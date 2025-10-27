import { useState } from 'react';
import { Ghost, Skull, Flame, Moon, Sparkles } from 'lucide-react';

interface WelcomeScreenProps {
  onStart: (nickname: string, avatar: string, category: string) => void;
  announcement: string;
}

const avatars = ['👻', '🎃', '💀', '🧛', '🧟', '🕷️', '🦇', '🐺', '🔮', '⚰️'];

const categories = [
  { name: 'Mixto', emoji: '🎲', color: 'from-purple-600 to-pink-600' },
  { name: 'Terror', emoji: '🎬', color: 'from-red-600 to-orange-600' },
  { name: 'Musica', emoji: '🎵', color: 'from-blue-600 to-cyan-600' },
  { name: 'Historia', emoji: '🏛️', color: 'from-amber-600 to-orange-600' },
  { name: 'Ciencia', emoji: '🔬', color: 'from-green-600 to-emerald-600' },
  { name: 'Arte', emoji: '🎨', color: 'from-pink-600 to-rose-600' },
  { name: 'Geografia', emoji: '🌍', color: 'from-teal-600 to-green-600' },
  { name: 'Informatica', emoji: '💻', color: 'from-indigo-600 to-purple-600' },
];

export default function WelcomeScreen({ onStart, announcement }: WelcomeScreenProps) {
  const [nickname, setNickname] = useState('');
  const [selectedAvatar, setSelectedAvatar] = useState('👻');
  const [selectedCategory, setSelectedCategory] = useState('Mixto');
  const [shake, setShake] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (nickname.trim().length >= 3) {
      onStart(nickname.trim(), selectedAvatar, selectedCategory);
    } else {
      setShake(true);
      setTimeout(() => setShake(false), 500);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-purple-900 to-black flex items-center justify-center p-4 relative overflow-hidden">
      <div className="absolute inset-0 opacity-20">
        <div className="absolute top-10 left-10 animate-float">
          <Ghost className="w-16 h-16 text-white" />
        </div>
        <div className="absolute top-20 right-20 animate-float-delayed">
          <Skull className="w-12 h-12 text-orange-400" />
        </div>
        <div className="absolute bottom-20 left-20 animate-float">
          <Flame className="w-14 h-14 text-orange-500" />
        </div>
        <div className="absolute top-1/3 right-10 animate-float-delayed">
          <Moon className="w-20 h-20 text-yellow-200" />
        </div>
        <div className="absolute bottom-1/3 right-1/3 animate-pulse">
          <Sparkles className="w-10 h-10 text-purple-400" />
        </div>
      </div>

      <div className={`bg-black/80 backdrop-blur-lg border-4 border-orange-600 rounded-lg p-8 max-w-2xl w-full shadow-2xl shadow-orange-600/50 relative z-10 ${shake ? 'animate-shake' : ''}`}>
        <div className="text-center mb-6">
          <h1 className="text-5xl font-bold text-orange-500 mb-2 animate-pulse drop-shadow-glow">
            🎃 TRIVIA HALLOWEEN 🎃
          </h1>
          <h2 className="text-2xl font-bold text-white mb-4">
            Test de Cultura General
          </h2>
          {announcement && (
            <p className="text-orange-300 text-sm mb-4 italic">
              {announcement}
            </p>
          )}
          <p className="text-gray-300 text-sm">
            ¿Cuánto sabes sobre Halloween? Responde 5 preguntas escalofriantes...
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label className="block text-orange-400 font-bold mb-2">
              Tu Nombre:
            </label>
            <input
              type="text"
              value={nickname}
              onChange={(e) => setNickname(e.target.value)}
              placeholder="Mínimo 3 caracteres"
              className="w-full px-4 py-3 bg-gray-900 border-2 border-orange-600 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-orange-400 focus:ring-2 focus:ring-orange-400/50"
              maxLength={20}
            />
          </div>

          <div>
            <label className="block text-orange-400 font-bold mb-2">
              Elige tu Avatar:
            </label>
            <div className="grid grid-cols-5 gap-2">
              {avatars.map((avatar) => (
                <button
                  key={avatar}
                  type="button"
                  onClick={() => setSelectedAvatar(avatar)}
                  className={`text-4xl p-3 rounded-lg transition-all transform hover:scale-110 ${
                    selectedAvatar === avatar
                      ? 'bg-orange-600 scale-110 shadow-lg shadow-orange-600/50'
                      : 'bg-gray-800 hover:bg-gray-700'
                  }`}
                >
                  {avatar}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-orange-400 font-bold mb-3">
              Categoría:
            </label>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {categories.map((category) => (
                <button
                  key={category.name}
                  type="button"
                  onClick={() => setSelectedCategory(category.name)}
                  className={`p-4 rounded-lg transition-all transform hover:scale-105 ${
                    selectedCategory === category.name
                      ? `bg-gradient-to-r ${category.color} scale-105 shadow-lg`
                      : 'bg-gray-800 hover:bg-gray-700'
                  }`}
                >
                  <div className="text-3xl mb-1">{category.emoji}</div>
                  <div className="text-white font-bold text-sm">{category.name}</div>
                </button>
              ))}
            </div>
          </div>

          <button
            type="submit"
            className="w-full py-4 bg-gradient-to-r from-orange-600 to-red-600 text-white font-bold text-xl rounded-lg hover:from-orange-500 hover:to-red-500 transition-all transform hover:scale-105 shadow-lg shadow-red-600/50 border-2 border-red-700"
          >
            🕯️ COMENZAR TRIVIA 🕯️
          </button>
        </form>

        <div className="mt-6 text-center text-gray-400 text-xs">
          <p>⚠️ Pon a prueba tus conocimientos de terror y misterio ⚠️</p>
        </div>
      </div>
    </div>
  );
}
