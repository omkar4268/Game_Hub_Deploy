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
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = getDbConnection();
        stmt = conn.prepareStatement("SELECT id, username, password_hash, salt FROM users WHERE username = ?");
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (rs.next()) {
            int userId = rs.getInt("id");
            String storedHash = rs.getString("password_hash");
            String salt = rs.getString("salt");

            String calculatedHash = hashPassword(password, salt);

            if (calculatedHash.equals(storedHash)) {
                // Initialize active HTTP session
                HttpSession userSession = request.getSession(true);
                userSession.setAttribute("user_session", rs.getString("username"));
                userSession.setAttribute("user", rs.getString("username"));
                userSession.setAttribute("user_id", userId);

                out.print("{\"status\": \"success\", \"success\": true, \"message\": \"Authentication successful! Access granted.\", \"username\": \"" + escapeJson(rs.getString("username")) + "\"}");
                return;
            }
        }

        // Generic error message for security
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"Invalid username or password.\"}");

    } catch (Throwable t) {
        String errMsg = (t.getMessage() != null) ? t.getMessage() : t.toString();
        out.print("{\"status\": \"error\", \"success\": false, \"message\": \"" + escapeJson(errMsg) + "\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
