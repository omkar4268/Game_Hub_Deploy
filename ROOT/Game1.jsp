<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Random" %>
<%
    // Server-side Java logic runs on Tomcat
    HttpSession sess = request.getSession();
    String message = "Guess a number between 1 and 100!";
    String restart = request.getParameter("restart");

    // Initialize or reset game state
    if (restart != null || sess.getAttribute("target") == null) {
        int target = new Random().nextInt(100) + 1;
        sess.setAttribute("target", target);
        sess.setAttribute("attempts", 0);
        if (restart != null) {
            message = "New game started! Guess a number between 1 and 100.";
        }
    }

    // Process player's guess
    String guessParam = request.getParameter("guess");
    if (guessParam != null && !guessParam.trim().isEmpty()) {
        try {
            int guess = Integer.parseInt(guessParam.trim());
            Object targetObj = sess.getAttribute("target");
            Object attemptsObj = sess.getAttribute("attempts");
            int target = (targetObj != null) ? (Integer) targetObj : 50;
            int attempts = (attemptsObj != null) ? (Integer) attemptsObj + 1 : 1;
            sess.setAttribute("attempts", attempts);

            if (guess == target) {
                message = "🎉 Correct! You won in " + attempts + " attempts!";
                sess.removeAttribute("target"); // Reset game on win
            } else if (guess < target) {
                message = "Too low! Try a higher number. (Attempts: " + attempts + ")";
            } else {
                message = "Too high! Try a lower number. (Attempts: " + attempts + ")";
            }
        } catch (NumberFormatException e) {
            message = "Please enter a valid whole number!";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP Number Guessing Game</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1e1e2f;
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .game-card {
            background: #2b2b3d;
            padding: 35px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            width: 320px;
        }
        input[type="number"] {
            padding: 10px;
            width: 80%;
            margin-bottom: 15px;
            border-radius: 6px;
            border: 1px solid #444;
            font-size: 16px;
            text-align: center;
            box-sizing: border-box;
        }
        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            background: #007bff;
            color: white;
            font-size: 15px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 4px;
        }
        .btn:hover { background: #0056b3; }
        .btn-restart { background: #6c757d; }
        .btn-restart:hover { background: #565e64; }
        .msg { margin: 20px 0; font-size: 16px; color: #ffd166; min-height: 40px; }
    </style>
</head>
<body>

<div class="game-card">
    <h2>Number Guessing</h2>
    <p class="msg"><%= message %></p>

    <form method="POST" action="Game1.jsp">
        <input type="number" name="guess" min="1" max="100" placeholder="Enter 1 - 100" required autofocus>
        <br>
        <button type="submit" class="btn">Submit Guess</button>
        <a href="Game1.jsp?restart=true" class="btn btn-restart">Reset</a>
    </form>
</div>

</body>
</html>