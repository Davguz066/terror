import { Trophy, Clock, Award, Lightbulb, Star } from 'lucide-react';

interface VictoryScreenProps {
  score: number;
  timeElapsed: number;
  hintsUsed: number;
  playerNickname: string;
  playerAvatar: string;
  onPlayAgain: () => void;
  onViewLeaderboard: () => void;
}

export default function VictoryScreen({
  score,
  timeElapsed,
  hintsUsed,
  playerNickname,
  playerAvatar,
  onPlayAgain,
  onViewLeaderboard
}: VictoryScreenProps) {
  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const getPerformanceMessage = () => {
    if (score >= 1200) return '¡MAESTRO DEL DAW! 🏆';
    if (score >= 1000) return '¡Excelente trabajo! 🌟';
    if (score >= 800) return '¡Bien hecho! 👏';
    return '¡Lo lograste! 🎉';
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-green-900 to-black flex items-center justify-center p-4 relative overflow-hidden">
      <div className="absolute inset-0 opacity-20">
        <div className="absolute top-10 left-10 animate-float">
          <Star className="w-16 h-16 text-yellow-400" />
        </div>
        <div className="absolute top-20 right-20 animate-float-delayed">
          <Trophy className="w-20 h-20 text-yellow-500" />
        </div>
        <div className="absolute bottom-20 left-20 animate-float">
          <Star className="w-14 h-14 text-yellow-300" />
        </div>
        <div className="absolute bottom-20 right-20 animate-float-delayed">
          <Star className="w-12 h-12 text-yellow-400" />
        </div>
      </div>

      <div className="bg-black/90 backdrop-blur-lg border-4 border-green-600 rounded-lg p-8 max-w-2xl w-full shadow-2xl shadow-green-600/50 relative z-10">
        <div className="text-center mb-8">
          <div className="text-8xl mb-4 animate-bounce">
            {playerAvatar}
          </div>
          <h1 className="text-5xl font-bold text-green-500 mb-2 animate-pulse">
            ¡HAS ESCAPADO!
          </h1>
          <h2 className="text-3xl font-bold text-white mb-4">
            {getPerformanceMessage()}
          </h2>
          <p className="text-gray-300 text-lg">
            {playerNickname}, has demostrado tus habilidades como desarrollador web
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <div className="bg-gradient-to-br from-yellow-600 to-orange-600 rounded-lg p-6 text-center transform hover:scale-105 transition-transform">
            <Award className="w-12 h-12 text-white mx-auto mb-2" />
            <p className="text-white/80 text-sm mb-1">Puntuación Final</p>
            <p className="text-3xl font-bold text-white">{score}</p>
          </div>

          <div className="bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg p-6 text-center transform hover:scale-105 transition-transform">
            <Clock className="w-12 h-12 text-white mx-auto mb-2" />
            <p className="text-white/80 text-sm mb-1">Tiempo Total</p>
            <p className="text-3xl font-bold text-white">{formatTime(timeElapsed)}</p>
          </div>

          <div className="bg-gradient-to-br from-purple-600 to-pink-600 rounded-lg p-6 text-center transform hover:scale-105 transition-transform">
            <Lightbulb className="w-12 h-12 text-white mx-auto mb-2" />
            <p className="text-white/80 text-sm mb-1">Pistas Usadas</p>
            <p className="text-3xl font-bold text-white">{hintsUsed}</p>
          </div>
        </div>

        <div className="bg-green-950/30 border-2 border-green-600 rounded-lg p-6 mb-8">
          <h3 className="text-green-400 font-bold text-xl mb-3 text-center">
            🎓 Has Completado el Desafío DAW 🎓
          </h3>
          <p className="text-gray-300 text-center">
            Has demostrado dominio en HTML, CSS, JavaScript y Git.
            ¡Sigue aprendiendo y mejorando tus habilidades!
          </p>
        </div>

        <div className="flex flex-col sm:flex-row gap-4">
          <button
            onClick={onPlayAgain}
            className="flex-1 py-4 bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold text-lg rounded-lg hover:from-green-500 hover:to-emerald-500 transition-all transform hover:scale-105 shadow-lg shadow-green-600/50 border-2 border-green-700"
          >
            🔄 Jugar de Nuevo
          </button>
          <button
            onClick={onViewLeaderboard}
            className="flex-1 py-4 bg-gradient-to-r from-yellow-600 to-orange-600 text-white font-bold text-lg rounded-lg hover:from-yellow-500 hover:to-orange-500 transition-all transform hover:scale-105 shadow-lg shadow-yellow-600/50 border-2 border-yellow-700"
          >
            🏆 Ver Clasificación
          </button>
        </div>
      </div>
    </div>
  );
}
