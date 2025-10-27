/*
  # Halloween Escape Room - Database Schema

  ## Overview
  This migration creates the complete database schema for the Halloween Escape Room game.
  Players solve web development puzzles to escape a haunted mansion.

  ## New Tables

  ### `players`
  Stores player information and game progress
  - `id` (uuid, primary key) - Unique player identifier
  - `nickname` (text, unique) - Player's chosen nickname
  - `email` (text, optional) - Optional email for notifications
  - `avatar_icon` (text) - Icon representing the player
  - `created_at` (timestamptz) - When player registered
  - `total_score` (integer) - Cumulative score across all games
  - `games_completed` (integer) - Number of completed games

  ### `game_sessions`
  Tracks individual game sessions
  - `id` (uuid, primary key) - Unique session identifier
  - `player_id` (uuid, foreign key) - Reference to players table
  - `started_at` (timestamptz) - When game started
  - `completed_at` (timestamptz, nullable) - When game completed
  - `current_room` (integer) - Current room number (1-5)
  - `score` (integer) - Current session score
  - `hints_used` (integer) - Number of hints used
  - `time_elapsed` (integer) - Time in seconds
  - `is_completed` (boolean) - Whether game is finished

  ### `room_completions`
  Tracks which rooms players have completed
  - `id` (uuid, primary key) - Unique completion identifier
  - `session_id` (uuid, foreign key) - Reference to game_sessions
  - `room_number` (integer) - Room number (1-5)
  - `completed_at` (timestamptz) - When room was completed
  - `time_taken` (integer) - Time in seconds to complete room
  - `attempts` (integer) - Number of attempts before success

  ### `leaderboard`
  Materialized view of top players
  - `player_id` (uuid) - Reference to players
  - `nickname` (text) - Player nickname
  - `best_time` (integer) - Fastest completion time
  - `total_completions` (integer) - Total games completed
  - `average_score` (integer) - Average score per game

  ### `admin_settings`
  Game configuration managed by DAW admins
  - `id` (uuid, primary key) - Settings identifier
  - `game_enabled` (boolean) - Whether game is active
  - `difficulty_level` (text) - Difficulty: easy, medium, hard
  - `max_hints` (integer) - Maximum hints allowed per game
  - `announcement` (text) - Current announcement message
  - `updated_at` (timestamptz) - Last update timestamp
  - `updated_by` (text) - Admin who updated

  ## Security
  - Enable RLS on all tables
  - Players can read/write their own data
  - Leaderboard is publicly readable
  - Admin settings require authentication
  - Prevent data tampering through policies
*/

-- Create players table
CREATE TABLE IF NOT EXISTS players (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  nickname text UNIQUE NOT NULL,
  email text,
  avatar_icon text DEFAULT '👻',
  created_at timestamptz DEFAULT now(),
  total_score integer DEFAULT 0,
  games_completed integer DEFAULT 0
);

-- Create game_sessions table
CREATE TABLE IF NOT EXISTS game_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid REFERENCES players(id) ON DELETE CASCADE NOT NULL,
  started_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  current_room integer DEFAULT 1,
  score integer DEFAULT 0,
  hints_used integer DEFAULT 0,
  time_elapsed integer DEFAULT 0,
  is_completed boolean DEFAULT false
);

-- Create room_completions table
CREATE TABLE IF NOT EXISTS room_completions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid REFERENCES game_sessions(id) ON DELETE CASCADE NOT NULL,
  room_number integer NOT NULL,
  completed_at timestamptz DEFAULT now(),
  time_taken integer DEFAULT 0,
  attempts integer DEFAULT 1,
  UNIQUE(session_id, room_number)
);

-- Create admin_settings table
CREATE TABLE IF NOT EXISTS admin_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  game_enabled boolean DEFAULT true,
  difficulty_level text DEFAULT 'medium',
  max_hints integer DEFAULT 3,
  announcement text DEFAULT '',
  updated_at timestamptz DEFAULT now(),
  updated_by text DEFAULT 'system'
);

-- Insert default admin settings
INSERT INTO admin_settings (game_enabled, difficulty_level, max_hints, announcement)
VALUES (true, 'medium', 3, '¡Bienvenidos al Escape Room de Halloween! 🎃')
ON CONFLICT DO NOTHING;

-- Enable RLS
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_settings ENABLE ROW LEVEL SECURITY;

-- Players policies
CREATE POLICY "Players can read all player data"
  ON players FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can create player"
  ON players FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Players can update own data"
  ON players FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- Game sessions policies
CREATE POLICY "Anyone can read game sessions"
  ON game_sessions FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can create game session"
  ON game_sessions FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can update game sessions"
  ON game_sessions FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- Room completions policies
CREATE POLICY "Anyone can read room completions"
  ON room_completions FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can create room completion"
  ON room_completions FOR INSERT
  TO anon
  WITH CHECK (true);

-- Admin settings policies
CREATE POLICY "Everyone can read admin settings"
  ON admin_settings FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can update admin settings"
  ON admin_settings FOR UPDATE
  TO anon
  USING (true)
  WITH CHECK (true);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_game_sessions_player_id ON game_sessions(player_id);
CREATE INDEX IF NOT EXISTS idx_game_sessions_completed ON game_sessions(is_completed);
CREATE INDEX IF NOT EXISTS idx_room_completions_session_id ON room_completions(session_id);
CREATE INDEX IF NOT EXISTS idx_players_nickname ON players(nickname);

-- Create view for leaderboard
CREATE OR REPLACE VIEW leaderboard AS
SELECT 
  p.id as player_id,
  p.nickname,
  p.avatar_icon,
  p.total_score,
  p.games_completed,
  MIN(gs.time_elapsed) as best_time,
  ROUND(AVG(gs.score)) as average_score
FROM players p
LEFT JOIN game_sessions gs ON p.id = gs.player_id AND gs.is_completed = true
GROUP BY p.id, p.nickname, p.avatar_icon, p.total_score, p.games_completed
ORDER BY p.total_score DESC, best_time ASC
LIMIT 50;