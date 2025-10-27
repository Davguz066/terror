import { useState, useEffect } from 'react';
import { Settings, Save, AlertCircle, CheckCircle, X } from 'lucide-react';
import { supabase, AdminSettings } from '../lib/supabase';

interface AdminPanelProps {
  onClose: () => void;
}

export default function AdminPanel({ onClose }: AdminPanelProps) {
  const [settings, setSettings] = useState<AdminSettings | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState<{ type: 'success' | 'error', text: string } | null>(null);
  const [password, setPassword] = useState('');
  const [authenticated, setAuthenticated] = useState(false);

  const ADMIN_PASSWORD = 'daw2024';

  useEffect(() => {
    if (authenticated) {
      loadSettings();
    }
  }, [authenticated]);

  const loadSettings = async () => {
    try {
      const { data, error } = await supabase
        .from('admin_settings')
        .select('*')
        .maybeSingle();

      if (error) throw error;
      setSettings(data);
    } catch (error) {
      console.error('Error loading settings:', error);
      showMessage('error', 'Error al cargar configuración');
    } finally {
      setLoading(false);
    }
  };

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    if (password === ADMIN_PASSWORD) {
      setAuthenticated(true);
      showMessage('success', '¡Acceso concedido!');
    } else {
      showMessage('error', 'Contraseña incorrecta');
    }
  };

  const handleSave = async () => {
    if (!settings) return;

    setSaving(true);
    try {
      const { error } = await supabase
        .from('admin_settings')
        .update({
          game_enabled: settings.game_enabled,
          difficulty_level: settings.difficulty_level,
          max_hints: settings.max_hints,
          announcement: settings.announcement,
          updated_at: new Date().toISOString(),
          updated_by: 'DAW Admin'
        })
        .eq('id', settings.id);

      if (error) throw error;
      showMessage('success', '¡Configuración guardada!');
    } catch (error) {
      console.error('Error saving settings:', error);
      showMessage('error', 'Error al guardar');
    } finally {
      setSaving(false);
    }
  };

  const showMessage = (type: 'success' | 'error', text: string) => {
    setMessage({ type, text });
    setTimeout(() => setMessage(null), 3000);
  };

  if (!authenticated) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-gray-900 via-blue-900 to-black flex items-center justify-center p-4">
        <div className="bg-black/90 backdrop-blur-lg border-4 border-blue-600 rounded-lg p-8 max-w-md w-full shadow-2xl shadow-blue-600/50">
          <div className="text-center mb-6">
            <Settings className="w-16 h-16 text-blue-400 mx-auto mb-4" />
            <h2 className="text-3xl font-bold text-blue-400 mb-2">
              Panel de Administración DAW
            </h2>
            <p className="text-gray-400">Ingresa la contraseña para continuar</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-4">
            <div>
              <input
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Contraseña"
                className="w-full px-4 py-3 bg-gray-900 border-2 border-blue-600 rounded-lg text-white placeholder-gray-500 focus:outline-none focus:border-blue-400"
                autoFocus
              />
            </div>

            <button
              type="submit"
              className="w-full py-3 bg-gradient-to-r from-blue-600 to-purple-600 text-white font-bold rounded-lg hover:from-blue-500 hover:to-purple-500 transition-all"
            >
              Acceder
            </button>

            <button
              type="button"
              onClick={onClose}
              className="w-full py-3 bg-gray-700 text-white font-bold rounded-lg hover:bg-gray-600 transition-all"
            >
              Cancelar
            </button>
          </form>

          {message && (
            <div className={`mt-4 p-3 rounded-lg ${message.type === 'success' ? 'bg-green-900/50 border border-green-500' : 'bg-red-900/50 border border-red-500'}`}>
              <p className={message.type === 'success' ? 'text-green-400' : 'text-red-400'}>
                {message.text}
              </p>
            </div>
          )}
        </div>
      </div>
    );
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-gray-900 via-blue-900 to-black flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin text-6xl mb-4">⚙️</div>
          <p className="text-gray-400">Cargando configuración...</p>
        </div>
      </div>
    );
  }

  if (!settings) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-gray-900 via-blue-900 to-black flex items-center justify-center">
        <div className="text-center">
          <AlertCircle className="w-16 h-16 text-red-400 mx-auto mb-4" />
          <p className="text-red-400">Error al cargar configuración</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-blue-900 to-black p-4">
      <div className="max-w-4xl mx-auto">
        <div className="bg-black/90 backdrop-blur-lg border-4 border-blue-600 rounded-lg p-8 shadow-2xl shadow-blue-600/50">
          <div className="flex justify-between items-center mb-8">
            <div className="flex items-center gap-3">
              <Settings className="w-10 h-10 text-blue-400" />
              <h2 className="text-4xl font-bold text-blue-400">
                Panel de Control DAW
              </h2>
            </div>
            <button
              onClick={onClose}
              className="p-2 bg-red-600 hover:bg-red-500 rounded-lg transition-colors"
            >
              <X className="w-6 h-6 text-white" />
            </button>
          </div>

          {message && (
            <div className={`mb-6 p-4 rounded-lg flex items-center gap-3 ${message.type === 'success' ? 'bg-green-900/50 border-2 border-green-500' : 'bg-red-900/50 border-2 border-red-500'}`}>
              {message.type === 'success' ? (
                <CheckCircle className="w-6 h-6 text-green-400" />
              ) : (
                <AlertCircle className="w-6 h-6 text-red-400" />
              )}
              <p className={message.type === 'success' ? 'text-green-400' : 'text-red-400'}>
                {message.text}
              </p>
            </div>
          )}

          <div className="space-y-6">
            <div className="bg-gray-900/50 border-2 border-blue-500 rounded-lg p-6">
              <label className="flex items-center justify-between cursor-pointer">
                <span className="text-white font-bold text-lg">Estado del Juego</span>
                <div className="relative">
                  <input
                    type="checkbox"
                    checked={settings.game_enabled}
                    onChange={(e) => setSettings({ ...settings, game_enabled: e.target.checked })}
                    className="sr-only peer"
                  />
                  <div className="w-14 h-8 bg-gray-700 rounded-full peer peer-checked:bg-green-600 peer-focus:ring-4 peer-focus:ring-green-300 transition-all"></div>
                  <div className="absolute left-1 top-1 w-6 h-6 bg-white rounded-full transition-all peer-checked:translate-x-6"></div>
                </div>
              </label>
              <p className="text-gray-400 text-sm mt-2">
                {settings.game_enabled ? '✅ Juego activo' : '❌ Juego desactivado'}
              </p>
            </div>

            <div className="bg-gray-900/50 border-2 border-blue-500 rounded-lg p-6">
              <label className="block text-white font-bold text-lg mb-3">
                Nivel de Dificultad
              </label>
              <select
                value={settings.difficulty_level}
                onChange={(e) => setSettings({ ...settings, difficulty_level: e.target.value })}
                className="w-full px-4 py-3 bg-gray-800 border-2 border-blue-600 rounded-lg text-white focus:outline-none focus:border-blue-400"
              >
                <option value="easy">Fácil</option>
                <option value="medium">Medio</option>
                <option value="hard">Difícil</option>
              </select>
            </div>

            <div className="bg-gray-900/50 border-2 border-blue-500 rounded-lg p-6">
              <label className="block text-white font-bold text-lg mb-3">
                Pistas Máximas por Juego
              </label>
              <input
                type="number"
                min="0"
                max="10"
                value={settings.max_hints}
                onChange={(e) => setSettings({ ...settings, max_hints: parseInt(e.target.value) })}
                className="w-full px-4 py-3 bg-gray-800 border-2 border-blue-600 rounded-lg text-white focus:outline-none focus:border-blue-400"
              />
            </div>

            <div className="bg-gray-900/50 border-2 border-blue-500 rounded-lg p-6">
              <label className="block text-white font-bold text-lg mb-3">
                Anuncio de Bienvenida
              </label>
              <textarea
                value={settings.announcement}
                onChange={(e) => setSettings({ ...settings, announcement: e.target.value })}
                rows={3}
                className="w-full px-4 py-3 bg-gray-800 border-2 border-blue-600 rounded-lg text-white focus:outline-none focus:border-blue-400 resize-none"
                placeholder="Mensaje que verán los jugadores al iniciar..."
              />
            </div>
          </div>

          <div className="mt-8 flex gap-4">
            <button
              onClick={handleSave}
              disabled={saving}
              className="flex-1 py-4 bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold text-lg rounded-lg hover:from-green-500 hover:to-emerald-500 transition-all transform hover:scale-105 shadow-lg disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <Save className="w-6 h-6" />
              {saving ? 'Guardando...' : 'Guardar Cambios'}
            </button>
            <button
              onClick={onClose}
              className="px-8 py-4 bg-gray-700 text-white font-bold text-lg rounded-lg hover:bg-gray-600 transition-all"
            >
              Cerrar
            </button>
          </div>

          <div className="mt-6 text-center text-gray-500 text-sm">
            <p>Última actualización: {new Date(settings.updated_at).toLocaleString('es-ES')}</p>
          </div>
        </div>
      </div>
    </div>
  );
}
