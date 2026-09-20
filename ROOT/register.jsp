<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405);
        out.print("{\"success\": false, \"message\": \"Method Not Allowed\"}");
        return;
    }

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
        response.setStatus(400);
        out.print("{\"success\": false, \"message\": \"Username and password are required.\"}");
        return;
    }

    username = username.trim();
    if (!username.matches("^[a-zA-Z0-9_]{3,20}$")) {
        response.setStatus(400);
        out.print("{\"success\": false, \"message\": \"Username must be 3-20 alphanumeric characters.\"}");
        return;
    }

    if (password.length() < 6) {
        response.setStatus(400);
        out.print("{\"success\": false, \"message\": \"Password must be at least 6 characters.\"}");
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
            response.setStatus(409);
            out.print("{\"success\": false, \"message\": \"Username is already registered.\"}");
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

        // 4. Automatically authenticate the user session
        HttpSession userSession = request.getSession(true);
        userSession.setAttribute("user_id", newUserId);
        userSession.setAttribute("user", username);

        out.print("{\"success\": true, \"message\": \"Account created successfully!\", \"username\": \"" + username + "\"}");

    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"message\": \"Server error: " + e.getMessage().replace("\"", "'") + "\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (checkStmt != null) try { checkStmt.close(); } catch(Exception ignored) {}
        if (insertStmt != null) try { insertStmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
