<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Method Not Allowed\"}");
        return;
    }

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Callsign and Cipher are required.\"}");
        return;
    }

    username = username.trim();
    if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Callsign must be 3-20 alphanumeric characters.\"}");
        return;
    }

    if (password.length() < 6) {
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Cipher must be at least 6 characters.\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement checkStmt = null;
    PreparedStatement insertStmt = null;
    ResultSet rs = null;

    try {
        conn = getDbConnection();

        // 1. Check if username is already taken
        checkStmt = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
        checkStmt.setString(1, username);
        rs = checkStmt.executeQuery();
        if (rs.next()) {
            out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Username already taken. Please choose another callsign.\"}");
            return;
        }

        // 2. Hash password with cryptographic salt
        String salt = generateSalt();
        String passwordHash = hashPassword(password, salt);

        // 3. Insert new user record
        insertStmt = conn.prepareStatement("INSERT INTO users (username, password_hash, salt) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
        insertStmt.setString(1, username);
        insertStmt.setString(2, passwordHash);
        insertStmt.setString(3, salt);
        insertStmt.executeUpdate();

        ResultSet genKeys = insertStmt.getGeneratedKeys();
        int newUserId = -1;
        if (genKeys.next()) {
            newUserId = genKeys.getInt(1);
        }

        // 4. Session Persistence (both user_session and user attributes)
        HttpSession userSession = request.getSession(true);
        userSession.setAttribute("user_session", username);
        userSession.setAttribute("user", username);
        userSession.setAttribute("user_id", newUserId);

        out.print("{\"status\": \"success\", \"success\": true, \"message\": \"Enlistment complete. Identity verified!\", \"username\": \"" + escapeJson(username) + "\"}");

    } catch (Throwable t) {
        String errMsg = (t.getMessage() != null) ? t.getMessage() : t.toString();
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"" + escapeJson(errMsg) + "\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (checkStmt != null) try { checkStmt.close(); } catch(Exception ignored) {}
        if (insertStmt != null) try { insertStmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
