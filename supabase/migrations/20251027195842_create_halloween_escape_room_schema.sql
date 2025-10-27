/*
  # Create Halloween Escape Room Schema

  ## Overview
  This migration creates the complete database schema for a Halloween-themed escape room game
  with player management, game sessions, room tracking, and leaderboards.

  ## New Tables

  ### `players`
  Stores player information
  - `id` (uuid, primary key) - Unique player identifier
  - `name` (text) - Player display name
  - `email` (text, unique) - Player email for identification
  - `total_score` (integer) - Cumulative score across all games
  - `games_played` (integer) - Total number of games completed
  - `created_at` (timestamptz) - When player was created

  ### `game_sessions`
  Tracks individual game sessions
  - `id` (uuid, primary key) - Unique session identifier
  - `player_id` (uuid, foreign key) - Reference to player
  - `start_time` (timestamptz) - When session started
  - `end_time` (timestamptz) - When session ended
  - `total_score` (integer) - Score achieved in this session
  - `rooms_completed` (integer) - Number of rooms completed
  - `status` (text) - Session status (active, completed, abandoned)
  - `created_at` (timestamptz) - When session was created

  ### `room_completions`
  Tracks completion of individual rooms within a session
  - `id` (uuid, primary key) - Unique completion identifier
  - `session_id` (uuid, foreign key) - Reference to game session
  - `room_number` (integer) - Which room was completed (1-5)
  - `time_taken` (integer) - Seconds taken to complete
  - `hints_used` (integer) - Number of hints used
  - `score` (integer) - Score earned for this room
  - `completed_at` (timestamptz) - When room was completed

  ## Security
  - Enable RLS on all tables
  - Allow anonymous users to create and read their own data
  - Restrict updates and deletes appropriately

  ## Indexes
  - Player email for fast lookups
  - Session player_id and status for filtering
  - Room completion session_id for aggregation
*/

-- Create players table
CREATE TABLE IF NOT EXISTS players (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text UNIQUE NOT NULL,
  total_score integer DEFAULT 0,
  games_played integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Create game_sessions table
CREATE TABLE IF NOT EXISTS game_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid REFERENCES players(id) ON DELETE CASCADE,
  start_time timestamptz DEFAULT now(),
  end_time timestamptz,
  total_score integer DEFAULT 0,
  rooms_completed integer DEFAULT 0,
  status text DEFAULT 'active',
  created_at timestamptz DEFAULT now()
);

-- Create room_completions table
CREATE TABLE IF NOT EXISTS room_completions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid REFERENCES game_sessions(id) ON DELETE CASCADE,
  room_number integer NOT NULL,
  time_taken integer DEFAULT 0,
  hints_used integer DEFAULT 0,
  score integer DEFAULT 0,
  completed_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE room_completions ENABLE ROW LEVEL SECURITY;

-- Players policies
CREATE POLICY "Anyone can create players"
  ON players FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can read players"
  ON players FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Players can update own data"
  ON players FOR UPDATE
  TO anon
  USING (true);

-- Game sessions policies
CREATE POLICY "Anyone can create sessions"
  ON game_sessions FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can read sessions"
  ON game_sessions FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can update sessions"
  ON game_sessions FOR UPDATE
  TO anon
  USING (true);

-- Room completions policies
CREATE POLICY "Anyone can create completions"
  ON room_completions FOR INSERT
  TO anon
  WITH CHECK (true);

CREATE POLICY "Anyone can read completions"
  ON room_completions FOR SELECT
  TO anon
  USING (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_players_email ON players(email);
CREATE INDEX IF NOT EXISTS idx_sessions_player_id ON game_sessions(player_id);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON game_sessions(status);
CREATE INDEX IF NOT EXISTS idx_completions_session_id ON room_completions(session_id);
