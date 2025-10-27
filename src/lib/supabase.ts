import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

export interface Player {
  id: string;
  nickname: string;
  email?: string;
  avatar_icon: string;
  created_at: string;
  total_score: number;
  games_completed: number;
}

export interface GameSession {
  id: string;
  player_id: string;
  started_at: string;
  completed_at?: string;
  current_room: number;
  score: number;
  hints_used: number;
  time_elapsed: number;
  is_completed: boolean;
}

export interface RoomCompletion {
  id: string;
  session_id: string;
  room_number: number;
  completed_at: string;
  time_taken: number;
  attempts: number;
}

export interface AdminSettings {
  id: string;
  game_enabled: boolean;
  difficulty_level: string;
  max_hints: number;
  announcement: string;
  updated_at: string;
  updated_by: string;
}

export interface LeaderboardEntry {
  player_id: string;
  nickname: string;
  avatar_icon: string;
  total_score: number;
  games_completed: number;
  best_time: number;
  average_score: number;
}
