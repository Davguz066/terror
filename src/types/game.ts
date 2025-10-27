export interface Question {
  id: string;
  category: string;
  difficulty: string;
  question: string;
  correct_answer: string;
  alternative_answers: string[];
  hint1: string;
  hint2: string;
  hint3: string;
  points: number;
}

export interface GameState {
  currentRoom: number;
  score: number;
  hintsUsed: number;
  timeElapsed: number;
  isPlaying: boolean;
  sessionId: string | null;
  playerId: string | null;
  playerNickname: string | null;
  selectedCategory: string | null;
  currentQuestions: Question[];
}
