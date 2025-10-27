import { useState, useEffect } from 'react';
import { Skull, Lightbulb, Clock, Award, Ghost } from 'lucide-react';
import { Question } from '../types/game';

interface GameRoomProps {
  roomNumber: number;
  score: number;
  hintsUsed: number;
  maxHints: number;
  timeElapsed: number;
  currentQuestion: Question;
  onAnswer: (answer: string) => void;
  onHint: () => void;
  isProcessing: boolean;
}

const categoryEmojis: { [key: string]: string } = {
  'Historia': '🏛️',
  'Ciencia': '🔬',
  'Musica': '🎵',
  'Informatica': '💻',
  'Arte': '🎨',
  'Geografia': '🌍',
};

const difficultyColors: { [key: string]: string } = {
  'facil': 'text-green-400',
  'medio': 'text-yellow-400',
  'dificil': 'text-red-400',
};

export default function GameRoom({
  roomNumber,
  score,
  hintsUsed,
  maxHints,
  timeElapsed,
  currentQuestion,
  onAnswer,
  onHint,
  isProcessing
}: GameRoomProps) {
  const [answer, setAnswer] = useState('');
  const [showHint, setShowHint] = useState(false);
  const [shake, setShake] = useState(false);

  useEffect(() => {
    setAnswer('');
    setShowHint(false);
  }, [roomNumber]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (answer.trim()) {
      onAnswer(answer.trim());
    } else {
      setShake(true);
      setTimeout(() => setShake(false), 500);
    }
  };

  const handleHint = () => {
    if (hintsUsed < maxHints) {
      setShowHint(true);
      onHint();
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const getCurrentHint = () => {
    if (hintsUsed === 1) return currentQuestion.hint1;
    if (hintsUsed === 2) return currentQuestion.hint2;
    if (hintsUsed === 3) return currentQuestion.hint3;
    return '';
  };

  const getDifficultyStars = () => {
    if (currentQuestion.difficulty === 'facil') return '⭐';
    if (currentQuestion.difficulty === 'medio') return '⭐⭐';
    return '⭐⭐⭐';
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-red-950 to-black p-4 relative overflow-hidden">
      <div className="absolute inset-0 opacity-10">
        <div className="absolute animate-float" style={{ top: '10%', left: '5%' }}>
          <Ghost className="w-12 h-12 text-white" />
        </div>
        <div className="absolute animate-float-delayed" style={{ top: '20%', right: '10%' }}>
          <Skull className="w-10 h-10 text-red-500" />
        </div>
        <div className="absolute animate-float" style={{ bottom: '15%', left: '15%' }}>
          <Ghost className="w-14 h-14 text-white" />
        </div>
      </div>

      <div className="max-w-4xl mx-auto relative z-10">
        <div className="bg-black/80 backdrop-blur-lg border-4 border-red-600 rounded-lg p-4 mb-4 shadow-2xl shadow-red-600/30">
          <div className="flex justify-between items-center flex-wrap gap-4">
            <div className="flex items-center gap-2 text-orange-400">
              <Skull className="w-6 h-6" />
              <span className="font-bold">Pregunta {roomNumber}/5</span>
            </div>
            <div className="flex items-center gap-2 text-yellow-400">
              <Award className="w-6 h-6" />
              <span className="font-bold">{score} puntos</span>
            </div>
            <div className="flex items-center gap-2 text-blue-400">
              <Clock className="w-6 h-6" />
              <span className="font-bold">{formatTime(timeElapsed)}</span>
            </div>
            <div className="flex items-center gap-2 text-purple-400">
              <Lightbulb className="w-6 h-6" />
              <span className="font-bold">{maxHints - hintsUsed} pistas</span>
            </div>
          </div>
        </div>

        <div className={`bg-black/90 backdrop-blur-lg border-4 border-orange-600 rounded-lg p-8 shadow-2xl shadow-orange-600/50 ${shake ? 'animate-shake' : ''}`}>
          <div className="mb-6">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <span className="text-5xl">
                  {categoryEmojis[currentQuestion.category] || '📚'}
                </span>
                <div>
                  <h3 className="text-xl font-bold text-purple-400">
                    {currentQuestion.category}
                  </h3>
                  <p className={`text-sm font-bold ${difficultyColors[currentQuestion.difficulty]}`}>
                    {getDifficultyStars()} {currentQuestion.difficulty.toUpperCase()}
                  </p>
                </div>
              </div>
              <div className="text-right">
                <p className="text-3xl font-bold text-yellow-400">
                  {currentQuestion.points}
                </p>
                <p className="text-xs text-gray-400">puntos</p>
              </div>
            </div>

            <div className="bg-red-950/50 border-2 border-red-700 rounded-lg p-6">
              <p className="text-white text-xl leading-relaxed">
                {currentQuestion.question}
              </p>
            </div>
          </div>

          {showHint && getCurrentHint() && (
            <div className="mb-6 bg-yellow-950/30 border-2 border-yellow-600 rounded-lg p-4 animate-fadeIn">
              <div className="flex items-center gap-2 mb-2">
                <Lightbulb className="w-5 h-5 text-yellow-400" />
                <span className="text-yellow-400 font-bold">Pista {hintsUsed}:</span>
              </div>
              <p className="text-yellow-200">{getCurrentHint()}</p>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-orange-400 font-bold mb-2">
                Tu Respuesta:
              </label>
              <input
                type="text"
                value={answer}
                onChange={(e) => setAnswer(e.target.value)}
                placeholder="Escribe tu respuesta aquí..."
                className="w-full px-4 py-3 bg-gray-900 border-2 border-orange-600 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-orange-400 focus:ring-2 focus:ring-orange-400/50"
                disabled={isProcessing}
                autoFocus
              />
            </div>

            <div className="flex gap-4">
              <button
                type="submit"
                disabled={isProcessing}
                className="flex-1 py-3 bg-gradient-to-r from-orange-600 to-red-600 text-white font-bold text-lg rounded-lg hover:from-orange-500 hover:to-red-500 transition-all transform hover:scale-105 shadow-lg shadow-red-600/50 border-2 border-red-700 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {isProcessing ? '⏳ Verificando...' : '✓ Enviar Respuesta'}
              </button>
              <button
                type="button"
                onClick={handleHint}
                disabled={hintsUsed >= maxHints || isProcessing}
                className="px-6 py-3 bg-yellow-600 text-white font-bold rounded-lg hover:bg-yellow-500 transition-all transform hover:scale-105 shadow-lg disabled:opacity-30 disabled:cursor-not-allowed border-2 border-yellow-700"
              >
                💡 Pista
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
