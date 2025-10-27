import { useState, useEffect } from 'react';
import WelcomeScreen from './components/WelcomeScreen';
import GameRoom from './components/GameRoom';
import VictoryScreen from './components/VictoryScreen';
import Leaderboard from './components/Leaderboard';
import AdminPanel from './components/AdminPanel';
import { supabase, AdminSettings } from './lib/supabase';
import { GameState, Question } from './types/game';
import { Skull } from 'lucide-react';

type Screen = 'welcome' | 'game' | 'victory' | 'leaderboard' | 'admin';

function App() {
  const [screen, setScreen] = useState<Screen>('welcome');
  const [gameState, setGameState] = useState<GameState>({
    currentRoom: 1,
    score: 0,
    hintsUsed: 0,
    timeElapsed: 0,
    isPlaying: false,
    sessionId: null,
    playerId: null,
    playerNickname: null,
    selectedCategory: null,
    currentQuestions: [],
  });
  const [playerAvatar, setPlayerAvatar] = useState('👻');
  const [isProcessing, setIsProcessing] = useState(false);
  const [adminSettings, setAdminSettings] = useState<AdminSettings | null>(null);
  const [showNotification, setShowNotification] = useState(false);
  const [notificationMessage, setNotificationMessage] = useState('');
  const [notificationType, setNotificationType] = useState<'success' | 'error'>('success');

  useEffect(() => {
    loadAdminSettings();
  }, []);

  useEffect(() => {
    let timer: number;
    if (gameState.isPlaying) {
      timer = window.setInterval(() => {
        setGameState(prev => ({
          ...prev,
          timeElapsed: prev.timeElapsed + 1
        }));
      }, 1000);
    }
    return () => clearInterval(timer);
  }, [gameState.isPlaying]);

  const loadAdminSettings = async () => {
    try {
      const { data, error } = await supabase
        .from('admin_settings')
        .select('*')
        .maybeSingle();

      if (error) throw error;
      setAdminSettings(data);
    } catch (error) {
      console.error('Error loading admin settings:', error);
    }
  };

  const showNotif = (message: string, type: 'success' | 'error' = 'success') => {
    setNotificationMessage(message);
    setNotificationType(type);
    setShowNotification(true);
    setTimeout(() => setShowNotification(false), 3000);
  };

  const loadQuestions = async (category: string): Promise<Question[]> => {
    try {
      let query = supabase
        .from('questions')
        .select('*');

      if (category !== 'Mixto') {
        query = query.eq('category', category);
      }

      const { data, error } = await query;

      if (error) throw error;

      const questionsByDifficulty = {
        facil: data?.filter(q => q.difficulty === 'facil') || [],
        medio: data?.filter(q => q.difficulty === 'medio') || [],
        dificil: data?.filter(q => q.difficulty === 'dificil') || [],
      };

      const shuffle = (arr: Question[]) => arr.sort(() => Math.random() - 0.5);

      const selectedQuestions: Question[] = [
        ...shuffle(questionsByDifficulty.facil).slice(0, 2),
        ...shuffle(questionsByDifficulty.medio).slice(0, 2),
        ...shuffle(questionsByDifficulty.dificil).slice(0, 1),
      ];

      return shuffle(selectedQuestions).slice(0, 5);
    } catch (error) {
      console.error('Error loading questions:', error);
      return [];
    }
  };

  const handleGameStart = async (nickname: string, avatar: string, category: string) => {
    try {
      const questions = await loadQuestions(category);

      if (questions.length < 5) {
        showNotif('No hay suficientes preguntas en esta categoría', 'error');
        return;
      }

      const { data: existingPlayer } = await supabase
        .from('players')
        .select('*')
        .eq('nickname', nickname)
        .maybeSingle();

      let playerId: string;

      if (existingPlayer) {
        playerId = existingPlayer.id;
      } else {
        const { data: newPlayer, error: playerError } = await supabase
          .from('players')
          .insert([{ nickname, avatar_icon: avatar }])
          .select()
          .single();

        if (playerError) throw playerError;
        playerId = newPlayer.id;
      }

      const { data: session, error: sessionError } = await supabase
        .from('game_sessions')
        .insert([{
          player_id: playerId,
          current_room: 1,
          score: 0,
          hints_used: 0,
          time_elapsed: 0,
          is_completed: false,
          selected_category: category
        }])
        .select()
        .single();

      if (sessionError) throw sessionError;

      setGameState({
        currentRoom: 1,
        score: 0,
        hintsUsed: 0,
        timeElapsed: 0,
        isPlaying: true,
        sessionId: session.id,
        playerId,
        playerNickname: nickname,
        selectedCategory: category,
        currentQuestions: questions,
      });
      setPlayerAvatar(avatar);
      setScreen('game');
      showNotif('¡Bienvenido al test de Halloween! 👻');
    } catch (error) {
      console.error('Error starting game:', error);
      showNotif('Error al iniciar el juego', 'error');
    }
  };

  const handleAnswer = async (answer: string) => {
    if (!gameState.sessionId || isProcessing || gameState.currentQuestions.length === 0) return;

    setIsProcessing(true);
    const currentQuestion = gameState.currentQuestions[gameState.currentRoom - 1];
    const normalizedAnswer = answer.toLowerCase().trim();
    const normalizedCorrect = currentQuestion.correct_answer.toLowerCase().trim();

    const isCorrect = normalizedAnswer === normalizedCorrect ||
      currentQuestion.alternative_answers?.some(alt =>
        alt.toLowerCase().trim() === normalizedAnswer
      );

    if (isCorrect) {
      const newScore = gameState.score + currentQuestion.points;
      const newRoom = gameState.currentRoom + 1;

      try {
        await supabase
          .from('room_completions')
          .insert([{
            session_id: gameState.sessionId,
            room_number: gameState.currentRoom,
            time_taken: 30,
            attempts: 1,
            question_id: currentQuestion.id
          }]);

        if (newRoom > 5) {
          await supabase
            .from('game_sessions')
            .update({
              is_completed: true,
              completed_at: new Date().toISOString(),
              score: newScore,
              time_elapsed: gameState.timeElapsed,
              hints_used: gameState.hintsUsed
            })
            .eq('id', gameState.sessionId);

          const { data: player } = await supabase
            .from('players')
            .select('total_score, games_completed')
            .eq('id', gameState.playerId)
            .single();

          if (player) {
            await supabase
              .from('players')
              .update({
                total_score: player.total_score + newScore,
                games_completed: player.games_completed + 1
              })
              .eq('id', gameState.playerId);
          }

          setGameState(prev => ({
            ...prev,
            score: newScore,
            isPlaying: false
          }));
          setScreen('victory');
          showNotif('¡HAS COMPLETADO EL TEST! 🎉', 'success');
        } else {
          await supabase
            .from('game_sessions')
            .update({
              current_room: newRoom,
              score: newScore,
              time_elapsed: gameState.timeElapsed,
              hints_used: gameState.hintsUsed
            })
            .eq('id', gameState.sessionId);

          setGameState(prev => ({
            ...prev,
            currentRoom: newRoom,
            score: newScore
          }));
          showNotif('¡Correcto! Siguiente pregunta 👍', 'success');
        }
      } catch (error) {
        console.error('Error updating game state:', error);
        showNotif('Error al procesar respuesta', 'error');
      }
    } else {
      showNotif('❌ Respuesta incorrecta. ¡Intenta de nuevo!', 'error');
    }

    setIsProcessing(false);
  };

  const handleHint = async () => {
    if (!gameState.sessionId || !adminSettings) return;

    const newHintsUsed = gameState.hintsUsed + 1;

    try {
      await supabase
        .from('game_sessions')
        .update({
          hints_used: newHintsUsed,
          time_elapsed: gameState.timeElapsed
        })
        .eq('id', gameState.sessionId);

      setGameState(prev => ({
        ...prev,
        hintsUsed: newHintsUsed
      }));
      showNotif('💡 Pista revelada', 'success');
    } catch (error) {
      console.error('Error using hint:', error);
    }
  };

  const handlePlayAgain = () => {
    setGameState({
      currentRoom: 1,
      score: 0,
      hintsUsed: 0,
      timeElapsed: 0,
      isPlaying: false,
      sessionId: null,
      playerId: gameState.playerId,
      playerNickname: gameState.playerNickname,
      selectedCategory: null,
      currentQuestions: [],
    });
    setScreen('welcome');
  };

  const handleViewLeaderboard = () => {
    setScreen('leaderboard');
  };

  const handleCloseLeaderboard = () => {
    if (gameState.sessionId) {
      setScreen('victory');
    } else {
      setScreen('welcome');
    }
  };

  const handleOpenAdmin = () => {
    setScreen('admin');
  };

  const handleCloseAdmin = () => {
    loadAdminSettings();
    setScreen('welcome');
  };

  if (!adminSettings) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-gray-900 via-purple-900 to-black flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin text-6xl mb-4">👻</div>
          <p className="text-gray-400">Cargando...</p>
        </div>
      </div>
    );
  }

  if (!adminSettings.game_enabled && screen !== 'admin') {
    return (
      <div className="min-h-screen bg-gradient-to-b from-gray-900 via-red-900 to-black flex items-center justify-center p-4">
        <div className="bg-black/90 backdrop-blur-lg border-4 border-red-600 rounded-lg p-8 max-w-md w-full text-center">
          <Skull className="w-20 h-20 text-red-500 mx-auto mb-4" />
          <h2 className="text-3xl font-bold text-red-500 mb-4">
            Test Desactivado
          </h2>
          <p className="text-gray-300 mb-6">
            El test está temporalmente fuera de servicio.
            Por favor, vuelve más tarde.
          </p>
          <button
            onClick={handleOpenAdmin}
            className="px-6 py-3 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-500 transition-all"
          >
            Panel de Administración
          </button>
        </div>
      </div>
    );
  }

  return (
    <>
      {screen === 'welcome' && (
        <div className="relative">
          <WelcomeScreen
            onStart={handleGameStart}
            announcement={adminSettings.announcement}
          />
          <div className="fixed bottom-4 right-4 flex gap-2 z-50">
            <button
              onClick={handleViewLeaderboard}
              className="px-6 py-3 bg-purple-600 text-white font-bold rounded-lg hover:bg-purple-500 transition-all shadow-lg"
            >
              🏆 Clasificación
            </button>
            <button
              onClick={handleOpenAdmin}
              className="px-6 py-3 bg-blue-600 text-white font-bold rounded-lg hover:bg-blue-500 transition-all shadow-lg"
            >
              ⚙️ Admin
            </button>
          </div>
        </div>
      )}
      {screen === 'game' && gameState.currentQuestions.length > 0 && (
        <GameRoom
          roomNumber={gameState.currentRoom}
          score={gameState.score}
          hintsUsed={gameState.hintsUsed}
          maxHints={adminSettings.max_hints}
          timeElapsed={gameState.timeElapsed}
          currentQuestion={gameState.currentQuestions[gameState.currentRoom - 1]}
          onAnswer={handleAnswer}
          onHint={handleHint}
          isProcessing={isProcessing}
        />
      )}
      {screen === 'victory' && (
        <VictoryScreen
          score={gameState.score}
          timeElapsed={gameState.timeElapsed}
          hintsUsed={gameState.hintsUsed}
          playerNickname={gameState.playerNickname || 'Jugador'}
          playerAvatar={playerAvatar}
          onPlayAgain={handlePlayAgain}
          onViewLeaderboard={handleViewLeaderboard}
        />
      )}
      {screen === 'leaderboard' && (
        <Leaderboard
          onClose={handleCloseLeaderboard}
          currentPlayerId={gameState.playerId || undefined}
        />
      )}
      {screen === 'admin' && (
        <AdminPanel onClose={handleCloseAdmin} />
      )}

      {showNotification && (
        <div className="fixed top-4 right-4 z-50 animate-slideIn">
          <div className={`px-6 py-4 rounded-lg shadow-2xl border-2 ${
            notificationType === 'success'
              ? 'bg-green-900/90 border-green-500'
              : 'bg-red-900/90 border-red-500'
          } backdrop-blur-lg`}>
            <p className={`font-bold ${
              notificationType === 'success' ? 'text-green-300' : 'text-red-300'
            }`}>
              {notificationMessage}
            </p>
          </div>
        </div>
      )}
    </>
  );
}

export default App;
