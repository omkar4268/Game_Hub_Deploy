<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession != null && userSession.getAttribute("user") != null) {
        String user = (String) userSession.getAttribute("user");
        out.print("{\"loggedIn\": true, \"username\": \"" + user + "\"}");
    } else {
        out.print("{\"loggedIn\": false}");
    }
%>
