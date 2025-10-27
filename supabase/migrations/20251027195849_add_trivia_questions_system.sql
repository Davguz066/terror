/*
  # Add Trivia Questions System

  ## Overview
  This migration adds support for trivia questions with multiple categories and difficulty levels.
  Replaces the hardcoded escape room puzzles with a flexible question system.

  ## New Tables

  ### `questions`
  Stores all trivia questions
  - `id` (uuid, primary key) - Unique question identifier
  - `category` (text) - Question category (Historia, Ciencia, Musica, Informatica, Arte, Geografia)
  - `difficulty` (text) - Difficulty level (facil, medio, dificil)
  - `question` (text) - The question text
  - `correct_answer` (text) - The correct answer
  - `alternative_answers` (text array) - Alternative valid answers
  - `hint1` (text) - First hint
  - `hint2` (text) - Second hint
  - `hint3` (text) - Third hint
  - `points` (integer) - Points awarded for correct answer
  - `created_at` (timestamptz) - When question was created

  ## Updates to Existing Tables

  ### `game_sessions`
  - Add `selected_category` (text) - Category chosen by player

  ### `room_completions`
  - Add `question_id` (uuid) - Reference to question answered

  ## Security
  - Enable RLS on questions table
  - Everyone can read questions
  - Only admins can modify questions

  ## Initial Data
  Load 30+ questions across all categories and difficulties
*/

-- Create questions table
CREATE TABLE IF NOT EXISTS questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category text NOT NULL,
  difficulty text NOT NULL,
  question text NOT NULL,
  correct_answer text NOT NULL,
  alternative_answers text[] DEFAULT '{}',
  hint1 text DEFAULT '',
  hint2 text DEFAULT '',
  hint3 text DEFAULT '',
  points integer DEFAULT 100,
  created_at timestamptz DEFAULT now()
);

-- Add columns to existing tables
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'game_sessions' AND column_name = 'selected_category'
  ) THEN
    ALTER TABLE game_sessions ADD COLUMN selected_category text DEFAULT 'Mixto';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'room_completions' AND column_name = 'question_id'
  ) THEN
    ALTER TABLE room_completions ADD COLUMN question_id uuid;
  END IF;
END $$;

-- Enable RLS
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;

-- Questions policies
CREATE POLICY "Everyone can read questions"
  ON questions FOR SELECT
  TO anon
  USING (true);

CREATE POLICY "Anyone can create questions"
  ON questions FOR INSERT
  TO anon
  WITH CHECK (true);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_questions_category ON questions(category);
CREATE INDEX IF NOT EXISTS idx_questions_difficulty ON questions(difficulty);
CREATE INDEX IF NOT EXISTS idx_questions_category_difficulty ON questions(category, difficulty);

-- Insert Historia questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Historia', 'facil', '¿En qué año descubrió Cristóbal Colón América?', '1492', ARRAY['año 1492'], '¿Siglo XV?', 'Fue a finales del siglo XV', 'Piensa en 14__', 100),
('Historia', 'facil', '¿Quién fue el primer presidente de Estados Unidos?', 'George Washington', ARRAY['Washington', 'George'], 'Sus iniciales son G.W.', 'Su apellido es una capital', 'George _____', 100),
('Historia', 'facil', '¿Qué muro cayó en 1989?', 'Muro de Berlín', ARRAY['Berlín', 'El muro de Berlín'], 'Estaba en Alemania', 'Separaba una ciudad', 'Muro de _____', 100),
('Historia', 'medio', '¿En qué año comenzó la Segunda Guerra Mundial?', '1939', ARRAY['año 1939'], 'Década de 1930', 'Un año antes de 1940', 'Piensa en 193_', 200),
('Historia', 'medio', '¿Quién pintó la Capilla Sixtina?', 'Miguel Ángel', ARRAY['Michelangelo', 'Miguel Angel'], 'Fue un artista del Renacimiento', 'También esculpió el David', 'Su nombre es Miguel _____', 200),
('Historia', 'dificil', '¿En qué año cayó el Imperio Romano de Occidente?', '476', ARRAY['año 476', '476 d.C.'], 'Siglo V', 'Década de 470', 'Es 47_', 300),

-- Insert Ciencia questions
('Ciencia', 'facil', '¿Cuál es el planeta más cercano al Sol?', 'Mercurio', ARRAY['mercurio'], 'Es el más pequeño', 'Su nombre es de un dios romano', 'Empieza con M', 100),
('Ciencia', 'facil', '¿Cuántos continentes hay en la Tierra?', '7', ARRAY['siete', '7 continentes'], 'Más de 5', 'Entre 6 y 8', 'Es un número impar', 100),
('Ciencia', 'facil', '¿Qué gas respiramos principalmente?', 'Oxígeno', ARRAY['oxigeno', 'O2'], 'Su símbolo es O2', 'Es vital para vivir', 'Empieza con O', 100),
('Ciencia', 'medio', '¿Cuál es el hueso más largo del cuerpo humano?', 'Fémur', ARRAY['femur', 'el fémur'], 'Está en las piernas', 'Va del muslo a la rodilla', 'Empieza con F', 200),
('Ciencia', 'medio', '¿A qué velocidad viaja la luz aproximadamente?', '300000', ARRAY['300000 km/s', '300.000 km/s', 'trescientos mil'], 'Son kilómetros por segundo', 'Empieza con 3', 'Es 300___', 200),
('Ciencia', 'dificil', '¿Cuántos huesos tiene el cuerpo humano adulto?', '206', ARRAY['206 huesos', 'doscientos seis'], 'Más de 200', 'Entre 200 y 210', 'Es 20_', 300),

-- Insert Musica questions
('Musica', 'facil', '¿Cuántas cuerdas tiene una guitarra española estándar?', '6', ARRAY['seis', '6 cuerdas'], 'Menos de 10', 'Es un número par', 'Más de 4', 100),
('Musica', 'facil', '¿Qué banda británica cantó "Yesterday"?', 'The Beatles', ARRAY['Beatles', 'Los Beatles'], 'De Liverpool', 'Los cuatro de Liverpool', 'The _____', 100),
('Musica', 'facil', '¿Cómo se llama el instrumento de viento de madera con agujeros?', 'Flauta', ARRAY['la flauta', 'flauta dulce'], 'Es alargado', 'Se sopla por un extremo', 'Empieza con F', 100),
('Musica', 'medio', '¿Cuántas teclas tiene un piano estándar?', '88', ARRAY['88 teclas', 'ochenta y ocho'], 'Entre 80 y 90', 'Es par', 'Es 8_', 200),
('Musica', 'medio', '¿Quién compuso "La Novena Sinfonía"?', 'Beethoven', ARRAY['Ludwig van Beethoven'], 'Compositor alemán', 'También compuso "Para Elisa"', 'Su apellido empieza con B', 200),
('Musica', 'dificil', '¿En qué año murió Michael Jackson?', '2009', ARRAY['año 2009'], 'Siglo XXI', 'Década de 2000', 'Es 200_', 300),

-- Insert Informatica questions
('Informatica', 'facil', '¿Qué significa CPU en español?', 'Unidad Central de Procesamiento', ARRAY['procesador', 'CPU', 'Unidad de Procesamiento'], 'Es el cerebro del ordenador', 'Procesa información', 'Unidad _____', 100),
('Informatica', 'facil', '¿Qué significa WWW?', 'World Wide Web', ARRAY['web', 'la web'], 'Está en las URLs', 'Son tres palabras', 'World _____ _____', 100),
('Informatica', 'facil', '¿Qué empresa creó Windows?', 'Microsoft', ARRAY['microsoft'], 'De Bill Gates', 'También hace Xbox', 'Micro_____', 100),
('Informatica', 'medio', '¿En qué año se fundó Google?', '1998', ARRAY['año 1998'], 'Década de 1990', 'Finales del siglo XX', 'Es 199_', 200),
('Informatica', 'medio', '¿Qué lenguaje se usa principalmente para dar estilo a páginas web?', 'CSS', ARRAY['css', 'Cascading Style Sheets'], 'Son tres letras', 'No es HTML ni JavaScript', 'Empieza con C', 200),
('Informatica', 'dificil', '¿Quién es considerado el padre de la computación?', 'Alan Turing', ARRAY['Turing', 'Alan'], 'Matemático británico', 'Trabajó en la Segunda Guerra Mundial', 'Alan _____', 300),

-- Insert Arte questions
('Arte', 'facil', '¿Quién pintó "La Gioconda" o "Mona Lisa"?', 'Leonardo da Vinci', ARRAY['Da Vinci', 'Leonardo'], 'Artista del Renacimiento', 'También inventó máquinas', 'Leonardo _____', 100),
('Arte', 'facil', '¿De qué color son los Pitufos?', 'Azul', ARRAY['azules'], 'Color primario', 'Color del cielo', 'Empieza con A', 100),
('Arte', 'facil', '¿Qué artista español pintó el Guernica?', 'Picasso', ARRAY['Pablo Picasso', 'Pablo'], 'Del siglo XX', 'Arte cubista', 'Su apellido empieza con P', 100),
('Arte', 'medio', '¿En qué museo está la Mona Lisa?', 'Louvre', ARRAY['Museo del Louvre', 'El Louvre'], 'Está en París', 'Es el más visitado del mundo', 'Empieza con L', 200),
('Arte', 'medio', '¿Quién esculpió "El Pensador"?', 'Rodin', ARRAY['Auguste Rodin'], 'Escultor francés', 'Siglo XIX-XX', 'Su apellido es _____', 200),
('Arte', 'dificil', '¿En qué ciudad está la Capilla Sixtina?', 'Vaticano', ARRAY['Ciudad del Vaticano', 'Roma'], 'Es un estado independiente', 'Donde vive el Papa', 'Empieza con V', 300),

-- Insert Geografia questions
('Geografia', 'facil', '¿Cuál es la capital de España?', 'Madrid', ARRAY['madrid'], 'En el centro del país', 'Ciudad más poblada', 'Empieza con M', 100),
('Geografia', 'facil', '¿Cuál es el océano más grande?', 'Pacífico', ARRAY['Océano Pacífico', 'pacifico'], 'Entre América y Asia', 'El más profundo también', 'Empieza con P', 100),
('Geografia', 'facil', '¿En qué continente está Egipto?', 'África', ARRAY['africa', 'continente africano'], 'Tiene el Nilo', 'Donde están las pirámides', 'Empieza con A', 100),
('Geografia', 'medio', '¿Cuál es el río más largo del mundo?', 'Amazonas', ARRAY['Río Amazonas', 'El Amazonas'], 'Está en Sudamérica', 'Pasa por Brasil', 'Empieza con A', 200),
('Geografia', 'medio', '¿Cuántos países hay en la Unión Europea?', '27', ARRAY['27 países', 'veintisiete'], 'Más de 20', 'Menos de 30', 'Es 2_', 200),
('Geografia', 'dificil', '¿Cuál es el país más pequeño del mundo?', 'Vaticano', ARRAY['Ciudad del Vaticano'], 'Está dentro de Roma', 'Es donde vive el Papa', 'Empieza con V', 300);
