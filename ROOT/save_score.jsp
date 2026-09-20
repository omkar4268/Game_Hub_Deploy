<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.setStatus(405);
        out.print("{\"success\": false, \"message\": \"Method Not Allowed\"}");
        return;
    }

    HttpSession userSession = request.getSession(false);
    if (userSession == null || userSession.getAttribute("user_id") == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"message\": \"Guest player: Score cached locally only. Sign in to save to leaderboard!\"}");
        return;
    }

    int userId = (Integer) userSession.getAttribute("user_id");
    String gameName = request.getParameter("game");
    String scoreStr = request.getParameter("score");

    if (gameName == null || scoreStr == null) {
        response.setStatus(400);
        out.print("{\"success\": false, \"message\": \"Game name and score parameters required.\"}");
        return;
    }

    int score = 0;
    try {
        score = Integer.parseInt(scoreStr);
    } catch (NumberFormatException nfe) {
        response.setStatus(400);
        out.print("{\"success\": false, \"message\": \"Score must be an integer.\"}");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        conn = getDbConnection();
        // Atomic MySQL Upsert: updates high score only if current score is higher
        String sql = "INSERT INTO scores (user_id, game_name, score) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE score = GREATEST(score, VALUES(score)), recorded_at = CURRENT_TIMESTAMP";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userId);
        stmt.setString(2, gameName);
        stmt.setInt(3, score);
        stmt.executeUpdate();

        out.print("{\"success\": true, \"message\": \"High score synchronized to cloud!\", \"score\": " + score + "}");

    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\": false, \"message\": \"Database write error: " + e.getMessage().replace("\"", "'") + "\"}");
    } finally {
        if (stmt != null) try { stmt.close(); } catch(Exception ignored) {}
        if (conn != null) try { conn.close(); } catch(Exception ignored) {}
    }
%>
