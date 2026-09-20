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
        out.print("{\"success\": false, \"message\": \"All fields are required.\"}");
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
                // Initialize session
                HttpSession userSession = request.getSession(true);
                userSession.setAttribute("user_id", userId);
                userSession.setAttribute("user", rs.getString("username"));

                out.print("{\"success\": true, \"message\": \"Authentication successful!\", \"username\": \"" + rs.getString("username") + "\"}");
                return;
            }
        }

        // Generic error message to prevent user enumeration
        response.setStatus(401);
        out.print("{\"success\": false, \"message\": \"Invalid username or password.\"}");

    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"message\": \"Server error: " + e.getMessage().replace("\"", "'") + "\"}");
    } finally {
        if (rs != null) try { rs.close(); } catch(Exception ignored) {}
        if (stmt != null) try { stmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
