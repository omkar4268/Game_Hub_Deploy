-- GameHub Database & Authentication Schema
CREATE DATABASE IF NOT EXISTS gamehub 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

USE gamehub;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Scores Table (Tracks high scores per user per game)
CREATE TABLE IF NOT EXISTS scores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    game_name VARCHAR(50) NOT NULL,
    score INT NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_scores_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_game UNIQUE (user_id, game_name)
) ENGINE=InnoDB;

-- 3. Leaderboard query index
CREATE INDEX idx_game_leaderboard ON scores(game_name, score DESC);
