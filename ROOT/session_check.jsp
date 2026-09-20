<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ include file="/WEB-INF/db_connect.jspf" %>
<%
    response.setContentType("application/json; charset=UTF-8");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

    HttpSession userSession = request.getSession(false);
    String user = null;
    if (userSession != null) {
        user = (String) userSession.getAttribute("user_session");
        if (user == null || user.trim().isEmpty()) {
            user = (String) userSession.getAttribute("user");
        }
    }

    if (user != null && !user.trim().isEmpty()) {
        out.print("{\"status\": \"success\", \"loggedIn\": true, \"username\": \"" + escapeJson(user) + "\", \"user_session\": \"" + escapeJson(user) + "\"}");
    } else {
        out.print("{\"status\": \"success\", \"loggedIn\": false}");
    }
%>
