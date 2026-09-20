<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    HttpSession userSession = request.getSession(false);
    Integer currentUserId = (userSession != null) ? (Integer) userSession.getAttribute("user_id") : null;

    Connection conn = null;
    PreparedStatement userStmt = null;
    PreparedStatement topStmt = null;
    ResultSet rsUser = null;
    ResultSet rsTop = null;

    StringBuilder json = new StringBuilder("{");

    try {
        conn = getDbConnection();

        // 1. Get logged-in user's personal scores
        json.append("\"userScores\": {");
        if (currentUserId != null) {
            userStmt = conn.prepareStatement("SELECT game_name, score FROM scores WHERE user_id = ?");
            userStmt.setInt(1, currentUserId);
            rsUser = userStmt.executeQuery();
            boolean first = true;
            while (rsUser.next()) {
                if (!first) json.append(", ");
                json.append("\"").append(rsUser.getString("game_name")).append("\": ").append(rsUser.getInt("score"));
                first = false;
            }
        }
        json.append("}, ");

        // 2. Get global #1 high score leaders per game
        json.append("\"leaders\": {");
        String topSql = "SELECT s.game_name, s.score, u.username FROM scores s " +
                        "JOIN users u ON s.user_id = u.id " +
                        "WHERE (s.game_name, s.score) IN (SELECT game_name, MAX(score) FROM scores GROUP BY game_name)";
        topStmt = conn.prepareStatement(topSql);
        rsTop = topStmt.executeQuery();
        boolean firstLeader = true;
        while (rsTop.next()) {
            if (!firstLeader) json.append(", ");
            json.append("\"").append(rsTop.getString("game_name")).append("\": {")
                .append("\"username\": \"").append(rsTop.getString("username")).append("\", ")
                .append("\"score\": ").append(rsTop.getInt("score"))
                .append("}");
            firstLeader = false;
        }
        json.append("}}");

        out.print(json.toString());

    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"error\": \"" + e.getMessage().replace("\"", "'") + "\"}");
    } finally {
        if (rsUser != null) try { rsUser.close(); } catch(Exception ignored) {}
        if (rsTop != null) try { rsTop.close(); } catch(Exception ignored) {}
        if (userStmt != null) try { userStmt.close(); } catch(Exception ignored) {}
        if (topStmt != null) try { topStmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
