/*
  # Replace All Questions with Halloween-Themed Content

  ## Overview
  This migration deletes all existing questions and replaces them with Halloween-themed
  trivia questions across all categories. Each category now focuses on Halloween-related
  content (horror movies, spooky music, dark history, etc.).

  ## Changes
  - Delete all existing questions
  - Insert 10 Halloween-themed questions per category
  - All categories maintain mixed content but with Halloween focus

  ## Categories with Halloween Theme
  - **Terror** - Horror movies and literature
  - **Musica** - Halloween/horror themed music (Thriller, spooky songs)
  - **Historia** - Dark historical events and Halloween history
  - **Ciencia** - Death, decay, and spooky science
  - **Arte** - Gothic and macabre art
  - **Geografia** - Spooky locations and haunted places
  - **Informatica** - Horror games and tech

  ## Distribution per Category
  Each category has 10 questions:
  - 3-4 easy questions (100 points each)
  - 3-4 medium questions (200 points each)
  - 2-3 hard questions (300 points each)
*/

-- Delete all existing questions
DELETE FROM questions;

-- Insert Terror (Horror Movies & Literature) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Terror', 'facil', '¿Quién escribió "It" (Eso)?', 'Stephen King', ARRAY['King', 'S. King'], 'El rey del terror', 'También escribió "El Resplandor"', 'Stephen _____', 100),
('Terror', 'facil', '¿Cómo se llama el payaso de "It"?', 'Pennywise', ARRAY['Penny wise', 'pennywise'], 'Vive en las alcantarillas', 'Su nombre significa "centavo sabio"', 'Penny_____', 100),
('Terror', 'facil', '¿Qué película de terror tiene una niña llamada Samara?', 'The Ring', ARRAY['El Aro', 'ring'], 'Sale de un pozo', 'Tiene una cinta maldita', 'The _____', 100),
('Terror', 'facil', '¿Quién es el asesino de la película "Halloween"?', 'Michael Myers', ARRAY['Myers', 'Michael'], 'Usa una máscara blanca', 'También se llama "La Forma"', 'Michael _____', 100),
('Terror', 'medio', '¿En qué hotel se desarrolla "El Resplandor"?', 'Overlook', ARRAY['Hotel Overlook', 'overlook'], 'Está en las montañas', 'Jack Torrance es el cuidador', 'Hotel _____', 200),
('Terror', 'medio', '¿Quién dirigió la película "Psicosis"?', 'Alfred Hitchcock', ARRAY['Hitchcock', 'Alfred'], 'Maestro del suspense', 'También dirigió "Los Pájaros"', 'Alfred _____', 200),
('Terror', 'medio', '¿Qué película tiene un muñeco llamado Chucky?', 'Childs Play', ARRAY['Child''s Play', 'Muñeco Diabólico', 'Chucky'], 'El muñeco está poseído', 'Es pelirrojo', 'Muñeco _____', 200),
('Terror', 'medio', '¿Quién escribió "Drácula"?', 'Bram Stoker', ARRAY['Stoker', 'Bram'], 'Autor irlandés', 'Publicado en 1897', 'Bram _____', 200),
('Terror', 'dificil', '¿En qué año se estrenó "El Exorcista"?', '1973', ARRAY['año 1973'], 'Década de los 70', 'Principios de los 70', 'Es 197_', 300),
('Terror', 'dificil', '¿Quién escribió "Frankenstein"?', 'Mary Shelley', ARRAY['Shelley', 'Mary'], 'Escritora británica', 'Lo escribió muy joven', 'Mary _____', 300);

-- Insert Musica (Halloween & Horror Music) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Musica', 'facil', '¿Quién canta "Thriller"?', 'Michael Jackson', ARRAY['Jackson', 'Michael'], 'El Rey del Pop', 'Video con zombies', 'Michael _____', 100),
('Musica', 'facil', '¿En qué mes se celebra Halloween?', 'Octubre', ARRAY['octubre'], 'Último mes del otoño', 'Mes 10 del año', 'Empieza con O', 100),
('Musica', 'facil', '¿Qué canción comienza con "I was working in the lab late one night"?', 'Monster Mash', ARRAY['The Monster Mash', 'monster mash'], 'Canción de Halloween clásica', 'Habla de un monstruo', 'Monster _____', 100),
('Musica', 'medio', '¿En qué año se lanzó el video de "Thriller"?', '1983', ARRAY['año 1983'], 'Década de 1980', 'Principios de los 80', 'Es 198_', 200),
('Musica', 'medio', '¿Qué banda canta "Highway to Hell"?', 'AC/DC', ARRAY['ACDC', 'AC DC'], 'Banda de rock australiana', 'Tienen un logo con rayo', 'AC/_____', 200),
('Musica', 'medio', '¿Quién compuso la banda sonora de "Halloween" (1978)?', 'John Carpenter', ARRAY['Carpenter', 'John'], 'También dirigió la película', 'Su apellido significa carpintero', 'John _____', 200),
('Musica', 'medio', '¿Qué banda de rock lanzó "Sympathy for the Devil"?', 'Rolling Stones', ARRAY['The Rolling Stones', 'Stones'], 'Banda británica legendaria', 'Su logo es una lengua', 'Rolling _____', 200),
('Musica', 'dificil', '¿En qué película aparece la canción "Tiptoe Through the Tulips"?', 'Insidious', ARRAY['insidious'], 'Película de terror moderna', 'James Wan la dirigió', 'Empieza con I', 300),
('Musica', 'dificil', '¿Quién canta "The Number of the Beast"?', 'Iron Maiden', ARRAY['iron maiden'], 'Banda de heavy metal', 'Su mascota es Eddie', 'Iron _____', 300),
('Musica', 'dificil', '¿En qué año murió Michael Jackson?', '2009', ARRAY['año 2009'], 'Siglo XXI', 'Finales de los 2000', 'Es 200_', 300);

-- Insert Historia (Dark History & Halloween Origins) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Historia', 'facil', '¿De qué cultura antigua proviene Halloween?', 'Celta', ARRAY['celta', 'celtas'], 'De Irlanda', 'Celebraban Samhain', 'Empieza con C', 100),
('Historia', 'facil', '¿Cómo se llamaba la celebración celta que originó Halloween?', 'Samhain', ARRAY['samhain'], 'Fin del verano', 'Se pronuncia "sou-in"', 'Empieza con S', 100),
('Historia', 'facil', '¿En qué país se originó la tradición de tallar calabazas?', 'Irlanda', ARRAY['irlanda'], 'País europeo', 'Isla verde', 'Empieza con I', 100),
('Historia', 'medio', '¿En qué siglo comenzaron las cazas de brujas en Europa?', '15', ARRAY['XV', 'siglo XV', 'siglo 15'], 'Edad Media tardía', 'Antes del siglo XVI', 'Es el siglo _____', 200),
('Historia', 'medio', '¿Qué ciudad fue escenario de los juicios de Salem?', 'Salem', ARRAY['salem', 'Salem Massachusetts'], 'En Massachusetts', 'Juicios de brujas famosos', 'Empieza con S', 200),
('Historia', 'medio', '¿En qué año ocurrieron los juicios de brujas de Salem?', '1692', ARRAY['año 1692'], 'Siglo XVII', 'Finales del siglo XVII', 'Es 169_', 200),
('Historia', 'medio', '¿Quién fue Vlad el Empalador?', 'Vlad Tepes', ARRAY['Vlad III', 'Drácula', 'Vlad'], 'Príncipe de Valaquia', 'Inspiró a Drácula', 'Vlad _____', 200),
('Historia', 'dificil', '¿Cuántas personas murieron en los juicios de Salem?', '20', ARRAY['veinte', '20 personas'], 'Menos de 25', 'Más de 15', 'Es 2_', 300),
('Historia', 'dificil', '¿En qué año nació Bram Stoker?', '1847', ARRAY['año 1847'], 'Siglo XIX', 'Mediados del siglo XIX', 'Es 184_', 300),
('Historia', 'dificil', '¿Qué emperador romano era conocido por su crueldad y locura?', 'Nerón', ARRAY['Nero', 'neron'], 'Quemó Roma', 'Del siglo I', 'Empieza con N', 300);

-- Insert Ciencia (Death, Biology & Spooky Science) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Ciencia', 'facil', '¿Cuántos huesos tiene un esqueleto humano adulto?', '206', ARRAY['206 huesos', 'doscientos seis'], 'Más de 200', 'Entre 200 y 210', 'Es 20_', 100),
('Ciencia', 'facil', '¿Qué animal es símbolo de Halloween?', 'Murciélago', ARRAY['murcielago', 'murciélagos'], 'Vuela de noche', 'Es un mamífero', 'Empieza con M', 100),
('Ciencia', 'facil', '¿Qué órgano humano pesa más?', 'Hígado', ARRAY['higado', 'el hígado'], 'Órgano interno', 'Procesa toxinas', 'Empieza con H', 100),
('Ciencia', 'facil', '¿Cuántas patas tiene una araña?', '8', ARRAY['ocho', '8 patas'], 'Más de 6', 'Es un número par', 'Es menos de 10', 100),
('Ciencia', 'medio', '¿Qué proceso convierte un cuerpo en esqueleto?', 'Descomposición', ARRAY['descomposicion', 'putrefacción'], 'Después de la muerte', 'Proceso natural', 'Empieza con D', 200),
('Ciencia', 'medio', '¿Qué estudio científico trata sobre venenos?', 'Toxicología', ARRAY['toxicologia'], 'Estudia sustancias tóxicas', 'Relacionado con toxinas', 'Toxico_____', 200),
('Ciencia', 'medio', '¿Cómo se llama el miedo a la oscuridad?', 'Nictofobia', ARRAY['nictofobia', 'nictalofobia'], 'Fobia específica', 'Del griego noche', 'Empieza con N', 200),
('Ciencia', 'dificil', '¿Cuánto tiempo puede sobrevivir el cerebro sin oxígeno?', '4', ARRAY['4 minutos', 'cuatro'], 'Menos de 5 minutos', 'Más de 3 minutos', 'Es _ minutos', 300),
('Ciencia', 'dificil', '¿Qué enfermedad convierte los músculos en hueso?', 'FOP', ARRAY['Fibrodisplasia Osificante Progresiva', 'fop'], 'Muy rara', 'Osificación progresiva', 'Son tres letras', 300),
('Ciencia', 'dificil', '¿Cuántas especies de murciélagos vampiro existen?', '3', ARRAY['tres', '3 especies'], 'Menos de 5', 'Más de 2', 'Es un número impar', 300);

-- Insert Arte (Gothic & Macabre Art) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Arte', 'facil', '¿Quién pintó "El grito"?', 'Edvard Munch', ARRAY['Munch', 'Edvard'], 'Pintor noruego', 'Expresionismo', 'Edvard _____', 100),
('Arte', 'facil', '¿Qué artista español pintó "Saturno devorando a su hijo"?', 'Goya', ARRAY['Francisco de Goya', 'Francisco Goya'], 'Pintor español', 'Pinturas negras', 'Empieza con G', 100),
('Arte', 'facil', '¿Qué color predomina en el período gótico?', 'Negro', ARRAY['negro'], 'Color oscuro', 'Ausencia de luz', 'Empieza con N', 100),
('Arte', 'medio', '¿Quién escribió "El cuervo"?', 'Edgar Allan Poe', ARRAY['Poe', 'Allan Poe', 'Edgar Poe'], 'Escritor estadounidense', 'Maestro del terror', 'Edgar Allan _____', 200),
('Arte', 'medio', '¿Qué arquitectura se caracteriza por arcos apuntados y gárgolas?', 'Gótica', ARRAY['gotica', 'arquitectura gótica'], 'De la Edad Media', 'Catedrales oscuras', 'Empieza con G', 200),
('Arte', 'medio', '¿Quién dirigió "El cadáver de la novia"?', 'Tim Burton', ARRAY['Burton', 'Tim'], 'Director gótico', 'También hizo "El extraño mundo de Jack"', 'Tim _____', 200),
('Arte', 'medio', '¿Qué pintor holandés se cortó una oreja?', 'Van Gogh', ARRAY['Vincent van Gogh', 'Vincent'], 'Postimpresionista', 'Pintó "La noche estrellada"', 'Van _____', 200),
('Arte', 'dificil', '¿En qué año pintó Goya "Saturno devorando a su hijo"?', '1823', ARRAY['año 1823'], 'Siglo XIX', 'Década de 1820', 'Es 182_', 300),
('Arte', 'dificil', '¿Qué artista creó "La metamorfosis" de Franz Kafka?', 'Franz Kafka', ARRAY['Kafka'], 'No es un cuadro, es literatura', 'Escritor checo', 'Franz _____', 300),
('Arte', 'dificil', '¿Quién escribió "Drácula" en 1897?', 'Bram Stoker', ARRAY['Stoker', 'Bram'], 'Autor irlandés', 'Vampiro famoso', 'Bram _____', 300);

-- Insert Geografia (Haunted Places & Spooky Locations) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Geografia', 'facil', '¿En qué país está Transilvania?', 'Rumania', ARRAY['rumania', 'Romania'], 'Europa del Este', 'Hogar de Drácula', 'Empieza con R', 100),
('Geografia', 'facil', '¿En qué ciudad está el Castillo de Bran (Castillo de Drácula)?', 'Brasov', ARRAY['brasov', 'Brașov'], 'En Transilvania', 'Rumania', 'Empieza con B', 100),
('Geografia', 'facil', '¿En qué país está Salem, famoso por los juicios de brujas?', 'Estados Unidos', ARRAY['USA', 'EEUU', 'EE.UU.'], 'Norteamérica', 'En Massachusetts', 'Estados _____', 100),
('Geografia', 'facil', '¿En qué país se originó Halloween?', 'Irlanda', ARRAY['irlanda'], 'Europa', 'Isla verde', 'Empieza con I', 100),
('Geografia', 'medio', '¿En qué ciudad está la Torre de Londres?', 'Londres', ARRAY['london'], 'Capital de Inglaterra', 'En el Támesis', 'Empieza con L', 200),
('Geografia', 'medio', '¿Dónde están las catacumbas más famosas?', 'París', ARRAY['paris', 'Francia'], 'Capital francesa', 'Ciudad de la luz', 'Empieza con P', 200),
('Geografia', 'medio', '¿En qué país está el Bosque de Aokigahara?', 'Japón', ARRAY['japon'], 'Asia', 'Monte Fuji', 'Empieza con J', 200),
('Geografia', 'dificil', '¿Cuántos kilómetros tienen las Catacumbas de París?', '300', ARRAY['300 km', 'trescientos'], 'Más de 200', 'Menos de 400', 'Es 3__', 300),
('Geografia', 'dificil', '¿En qué isla se encuentra el Castillo de Frankenstein?', 'Alemania', ARRAY['alemania'], 'No está en una isla', 'Europa Central', 'Empieza con A', 300),
('Geografia', 'dificil', '¿En qué ciudad murió Edgar Allan Poe?', 'Baltimore', ARRAY['baltimore'], 'En Maryland', 'Estados Unidos', 'Empieza con B', 300);

-- Insert Informatica (Horror Games & Tech) questions
INSERT INTO questions (category, difficulty, question, correct_answer, alternative_answers, hint1, hint2, hint3, points) VALUES
('Informatica', 'facil', '¿Qué juego de terror tiene un animatrónico llamado Freddy?', 'Five Nights at Freddys', ARRAY['FNAF', 'Five Nights', 'Freddys'], 'Juego de supervivencia', 'Pizzería embrujada', 'Five Nights _____', 100),
('Informatica', 'facil', '¿Qué juego de terror se desarrolla en Raccoon City?', 'Resident Evil', ARRAY['resident evil'], 'Zombies y virus', 'Capcom', 'Resident _____', 100),
('Informatica', 'facil', '¿Qué juego indie tiene un personaje llamado Slenderman?', 'Slender', ARRAY['slender', 'The Eight Pages'], 'Figura alta y delgada', 'Recolectar páginas', 'Empieza con S', 100),
('Informatica', 'facil', '¿Qué consola lanzó Nintendo en 2017?', 'Switch', ARRAY['Nintendo Switch', 'switch'], 'Híbrida', 'Portátil y sobremesa', 'Empieza con S', 100),
('Informatica', 'medio', '¿Quién desarrolló "Silent Hill"?', 'Konami', ARRAY['konami'], 'Empresa japonesa', 'También hizo Metal Gear', 'Empieza con K', 200),
('Informatica', 'medio', '¿En qué año se lanzó "Resident Evil"?', '1996', ARRAY['año 1996'], 'Década de 1990', 'Mediados de los 90', 'Es 199_', 200),
('Informatica', 'medio', '¿Qué juego tiene a Pyramid Head?', 'Silent Hill', ARRAY['silent hill', 'Silent Hill 2'], 'Terror psicológico', 'Niebla', 'Silent _____', 200),
('Informatica', 'dificil', '¿Quién creó "Five Nights at Freddy''s"?', 'Scott Cawthon', ARRAY['Cawthon', 'Scott'], 'Desarrollador indie', 'Estadounidense', 'Scott _____', 300),
('Informatica', 'dificil', '¿En qué año se lanzó "Dead Space"?', '2008', ARRAY['año 2008'], 'Siglo XXI', 'Finales de los 2000', 'Es 200_', 300),
('Informatica', 'dificil', '¿Qué motor gráfico usa "Outlast"?', 'Unreal Engine', ARRAY['Unreal', 'unreal'], 'Motor muy popular', 'De Epic Games', 'Unreal _____', 300);
