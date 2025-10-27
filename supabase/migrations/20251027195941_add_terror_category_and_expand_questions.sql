/*
  # Add Terror Category and Expand Questions to 10 per Category

  ## Overview
  This migration adds a mandatory Terror (Horror) category with movies and horror books,
  and expands all existing categories to have exactly 10 questions each with mixed content.

  ## Changes

  ### New Category
  - **Terror** - 10 questions covering horror movies and books (3 easy, 4 medium, 3 hard)

  ### Updated Categories
  Expand each existing category from 6 to 10 questions with mixed content:
  - **Historia** - Mixed historical content (4 additional questions)
  - **Ciencia** - Mixed science topics (4 additional questions)
  - **Musica** - Mixed music content (4 additional questions)
  - **Informatica** - Mixed computing content (4 additional questions)
  - **Arte** - Mixed art content (4 additional questions)
  - **Geografia** - Mixed geography content (4 additional questions)

  ## Distribution per Category
  Each category now has 10 questions:
  - 3-4 easy questions (100 points each)
  - 3-4 medium questions (200 points each)
  - 2-3 hard questions (300 points each)

  ## Notes
  - All categories include diverse, mixed content within their theme
  - Terror category includes both classic and modern horror references
  - Questions maintain the Spanish language format
  - Hints are progressive and helpful
*/

-- Insert Terror (Horror) category questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
-- Easy Terror questions
('Terror', 'facil', '¿Quién escribió "It" (Eso)?', 'Stephen King', ARRAY['King', 'S. King'], 'El rey del terror', 'También escribió "El Resplandor"', 'Stephen _____', 100),
('Terror', 'facil', '¿Cómo se llama el payaso de "It"?', 'Pennywise', ARRAY['Penny wise', 'pennywise'], 'Vive en las alcantarillas', 'Su nombre significa "centavo sabio"', 'Penny_____', 100),
('Terror', 'facil', '¿Qué película de terror tiene una niña llamada Samara?', 'The Ring', ARRAY['El Aro', 'ring'], 'Sale de un pozo', 'Tiene una cinta maldita', 'The _____', 100),
-- Medium Terror questions
('Terror', 'medio', '¿En qué hotel se desarrolla "El Resplandor"?', 'Overlook', ARRAY['Hotel Overlook', 'overlook'], 'Está en las montañas', 'Jack Torrance es el cuidador', 'Hotel _____', 200),
('Terror', 'medio', '¿Quién dirigió la película "Psicosis"?', 'Alfred Hitchcock', ARRAY['Hitchcock', 'Alfred'], 'Maestro del suspense', 'También dirigió "Los Pájaros"', 'Alfred _____', 200),
('Terror', 'medio', '¿Qué película tiene un muñeco llamado Chucky?', 'Childs Play', ARRAY['Child''s Play', 'Muñeco Diabólico', 'Chucky'], 'El muñeco está poseído', 'Es pelirrojo', 'Muñeco _____', 200),
('Terror', 'medio', '¿Quién escribió "Drácula"?', 'Bram Stoker', ARRAY['Stoker', 'Bram'], 'Autor irlandés', 'Publicado en 1897', 'Bram _____', 200),
-- Hard Terror questions
('Terror', 'dificil', '¿En qué año se estrenó "El Exorcista"?', '1973', ARRAY['año 1973'], 'Década de los 70', 'Principios de los 70', 'Es 197_', 300),
('Terror', 'dificil', '¿Quién escribió "Frankenstein"?', 'Mary Shelley', ARRAY['Shelley', 'Mary'], 'Escritora británica', 'Lo escribió muy joven', 'Mary _____', 300),
('Terror', 'dificil', '¿Cómo se llama el asesino en "Scream"?', 'Ghostface', ARRAY['Ghost face', 'ghostface'], 'Usa una máscara blanca', 'Su nombre significa "cara fantasma"', 'Ghost_____', 300);

-- Add 4 more Historia questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Historia', 'facil', '¿Quién fue Cleopatra?', 'Reina de Egipto', ARRAY['Reina egipcia', 'Faraona', 'Cleopatra VII'], 'Gobernante de la antigüedad', 'Relacionada con Julio César', 'Reina de _____', 100),
('Historia', 'medio', '¿En qué año llegó el hombre a la Luna?', '1969', ARRAY['año 1969'], 'Década de 1960', 'Finales de los 60', 'Es 196_', 200),
('Historia', 'dificil', '¿Cuánto duró la Guerra de los Cien Años?', '116', ARRAY['116 años', 'ciento dieciséis'], 'Más de 100 años', 'Entre 110 y 120', 'Es 11_', 300),
('Historia', 'dificil', '¿En qué año cayó el Muro de Berlín?', '1989', ARRAY['año 1989'], 'Década de 1980', 'Finales del siglo XX', 'Es 198_', 300);

-- Add 4 more Ciencia questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Ciencia', 'facil', '¿Cuál es el metal más abundante en la Tierra?', 'Hierro', ARRAY['hierro', 'Fe'], 'Su símbolo es Fe', 'Es magnético', 'Empieza con H', 100),
('Ciencia', 'medio', '¿Qué científico propuso la teoría de la relatividad?', 'Einstein', ARRAY['Albert Einstein', 'albert einstein'], 'Físico alemán', 'E=mc²', 'Su apellido empieza con E', 200),
('Ciencia', 'dificil', '¿Cuál es la constante de Avogadro aproximadamente?', '6.022', ARRAY['6.022 x 10^23', '6.022e23'], 'Es un número muy grande', 'Empieza con 6', 'Es 6.___', 300),
('Ciencia', 'dificil', '¿Cuántos elementos tiene la tabla periódica actualmente?', '118', ARRAY['118 elementos', 'ciento dieciocho'], 'Más de 100', 'Menos de 120', 'Es 11_', 300);

-- Add 4 more Musica questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Musica', 'facil', '¿Quién es conocido como el "Rey del Pop"?', 'Michael Jackson', ARRAY['Jackson', 'Michael'], 'Cantante estadounidense', 'Hizo el moonwalk', 'Michael _____', 100),
('Musica', 'medio', '¿Qué banda cantó "Bohemian Rhapsody"?', 'Queen', ARRAY['queen'], 'Banda británica', 'Su cantante era Freddie Mercury', 'Empieza con Q', 200),
('Musica', 'dificil', '¿En qué año murió Elvis Presley?', '1977', ARRAY['año 1977'], 'Década de 1970', 'Finales de los 70', 'Es 197_', 300),
('Musica', 'dificil', '¿Cuántas sinfonías compuso Beethoven?', '9', ARRAY['nueve', '9 sinfonías'], 'Menos de 10', 'Es un número impar', 'Es menos de 10', 300);

-- Add 4 more Informatica questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Informatica', 'facil', '¿Qué empresa creó el iPhone?', 'Apple', ARRAY['apple'], 'También hace Mac', 'Su logo es una manzana', 'Empieza con A', 100),
('Informatica', 'medio', '¿Qué significa HTML?', 'HyperText Markup Language', ARRAY['html', 'lenguaje de marcado'], 'Para crear páginas web', 'Son cuatro palabras', 'HyperText _____', 200),
('Informatica', 'dificil', '¿Quién fundó Facebook?', 'Mark Zuckerberg', ARRAY['Zuckerberg', 'Mark'], 'En Harvard', 'Creado en 2004', 'Mark _____', 300),
('Informatica', 'dificil', '¿En qué año se lanzó el primer iPhone?', '2007', ARRAY['año 2007'], 'Siglo XXI', 'Década de 2000', 'Es 200_', 300);

-- Add 4 more Arte questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Arte', 'facil', '¿Qué artista se cortó una oreja?', 'Van Gogh', ARRAY['Vincent van Gogh', 'Vincent'], 'Pintor holandés', 'Pintó "La noche estrellada"', 'Van _____', 100),
('Arte', 'medio', '¿Quién pintó "La última cena"?', 'Leonardo da Vinci', ARRAY['Da Vinci', 'Leonardo'], 'Mismo artista de la Mona Lisa', 'Artista del Renacimiento', 'Leonardo _____', 200),
('Arte', 'dificil', '¿En qué año nació Pablo Picasso?', '1881', ARRAY['año 1881'], 'Siglo XIX', 'Década de 1880', 'Es 188_', 300),
('Arte', 'dificil', '¿Quién pintó "El grito"?', 'Edvard Munch', ARRAY['Munch', 'Edvard'], 'Pintor noruego', 'Expresionismo', 'Edvard _____', 300);

-- Add 4 more Geografia questions for a total of 10
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Geografia', 'facil', '¿Cuál es el país más grande del mundo?', 'Rusia', ARRAY['rusia'], 'En Europa y Asia', 'Su capital es Moscú', 'Empieza con R', 100),
('Geografia', 'medio', '¿Cuál es la montaña más alta del mundo?', 'Everest', ARRAY['Monte Everest', 'El Everest'], 'Está en el Himalaya', 'Entre Nepal y Tíbet', 'Empieza con E', 200),
('Geografia', 'dificil', '¿Cuántos países tiene América del Sur?', '12', ARRAY['12 países', 'doce'], 'Más de 10', 'Menos de 15', 'Es 1_', 300),
('Geografia', 'dificil', '¿Cuál es la capital de Australia?', 'Canberra', ARRAY['canberra'], 'No es Sídney ni Melbourne', 'En el sureste del país', 'Empieza con C', 300);
