<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession userSession = request.getSession(false);
    if (userSession != null) {
        userSession.invalidate();
    }

    String acceptHeader = request.getHeader("Accept");
    if (acceptHeader != null && acceptHeader.contains("application/json")) {
        out.print("{\"success\": true, \"message\": \"Logged out successfully.\"}");
    } else {
        response.sendRedirect("index.jsp");
    }
%>
