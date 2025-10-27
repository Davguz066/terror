import { useEffect, useState } from 'react';
import { Trophy, Award, Clock, X } from 'lucide-react';
import { supabase, LeaderboardEntry } from '../lib/supabase';

interface LeaderboardProps {
  onClose: () => void;
  currentPlayerId?: string;
}

export default function Leaderboard({ onClose, currentPlayerId }: LeaderboardProps) {
  const [entries, setEntries] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadLeaderboard();
    const subscription = supabase
      .channel('leaderboard-changes')
      .on('postgres_changes', { event: '*', schema: 'public', table: 'players' }, () => {
        loadLeaderboard();
      })
      .subscribe();

    return () => {
      subscription.unsubscribe();
    };
  }, []);

  const loadLeaderboard = async () => {
    try {
      const { data, error } = await supabase
        .from('leaderboard')
        .select('*')
        .limit(20);

      if (error) throw error;
      setEntries(data || []);
    } catch (error) {
      console.error('Error loading leaderboard:', error);
    } finally {
      setLoading(false);
    }
  };

  const formatTime = (seconds: number | null) => {
    if (!seconds) return '--:--';
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  const getMedalColor = (position: number) => {
    if (position === 1) return 'from-yellow-400 to-yellow-600';
    if (position === 2) return 'from-gray-300 to-gray-500';
    if (position === 3) return 'from-orange-400 to-orange-600';
    return 'from-purple-500 to-purple-700';
  };

  const getMedalEmoji = (position: number) => {
    if (position === 1) return '🥇';
    if (position === 2) return '🥈';
    if (position === 3) return '🥉';
    return '🎃';
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-purple-900 to-black p-4 relative overflow-hidden">
      <div className="max-w-4xl mx-auto relative z-10">
        <div className="bg-black/90 backdrop-blur-lg border-4 border-purple-600 rounded-lg p-8 shadow-2xl shadow-purple-600/50">
          <div className="flex justify-between items-center mb-6">
            <div className="flex items-center gap-3">
              <Trophy className="w-10 h-10 text-yellow-400" />
              <h2 className="text-4xl font-bold text-purple-400">
                Clasificación
              </h2>
            </div>
            <button
              onClick={onClose}
              className="p-2 bg-red-600 hover:bg-red-500 rounded-lg transition-colors"
            >
              <X className="w-6 h-6 text-white" />
            </button>
          </div>

          {loading ? (
            <div className="text-center py-12">
              <div className="animate-spin text-6xl mb-4">👻</div>
              <p className="text-gray-400">Cargando clasificación...</p>
            </div>
          ) : entries.length === 0 ? (
            <div className="text-center py-12">
              <p className="text-gray-400 text-xl">
                No hay jugadores aún. ¡Sé el primero!
              </p>
            </div>
          ) : (
            <div className="space-y-3">
              {entries.map((entry, index) => {
                const position = index + 1;
                const isCurrentPlayer = entry.player_id === currentPlayerId;

                return (
                  <div
                    key={entry.player_id}
                    className={`bg-gradient-to-r ${getMedalColor(position)} p-1 rounded-lg transform transition-all ${
                      isCurrentPlayer ? 'scale-105 ring-4 ring-green-500' : 'hover:scale-102'
                    }`}
                  >
                    <div className="bg-gray-900 rounded-lg p-4">
                      <div className="flex items-center gap-4">
                        <div className="text-4xl font-bold w-12 text-center">
                          {getMedalEmoji(position)}
                        </div>
                        <div className="text-3xl">{entry.avatar_icon}</div>
                        <div className="flex-1">
                          <div className="flex items-center gap-2">
                            <p className="text-white font-bold text-lg">
                              {entry.nickname}
                            </p>
                            {isCurrentPlayer && (
                              <span className="text-xs bg-green-500 text-white px-2 py-1 rounded">
                                TÚ
                              </span>
                            )}
                          </div>
                          <div className="flex gap-4 mt-1 text-sm text-gray-400">
                            <div className="flex items-center gap-1">
                              <Award className="w-4 h-4" />
                              <span>{entry.total_score} pts</span>
                            </div>
                            <div className="flex items-center gap-1">
                              <Clock className="w-4 h-4" />
                              <span>{formatTime(entry.best_time)}</span>
                            </div>
                            <div>
                              <span>🎮 {entry.games_completed} juegos</span>
                            </div>
                          </div>
                        </div>
                        <div className="text-right">
                          <p className="text-2xl font-bold text-white">
                            #{position}
                          </p>
                        </div>
                      </div>
                    </div>
                  </div>
                );
              })}
            </div>
          )}

          <div className="mt-8 text-center">
            <button
              onClick={onClose}
              className="px-8 py-3 bg-gradient-to-r from-purple-600 to-pink-600 text-white font-bold rounded-lg hover:from-purple-500 hover:to-pink-500 transition-all transform hover:scale-105 shadow-lg"
            >
              Cerrar
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
