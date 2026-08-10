INSERT INTO pruebas (titulo, descripcion, tiempo_minutos, activa)
VALUES ('Listening 2', 'Practice test: Question-Response', 15, TRUE);

SET @id_prueba = LAST_INSERT_ID();

INSERT INTO secciones (id_prueba, titulo, tipo, descripcion, orden)
VALUES (@id_prueba, 'Part 2: Questions', 'listening', 'Listen to the audio and respond to the question.', 1);

SET @id_seccion = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'audio', 'question.mp3', 'Audio for all Part 2 questions', 1);

SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso, 1, 'You were engaged when you bought the car, right?', 'A');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', "Yes, it's in the cage by the cart."),
(@id_pregunta, 'B', "No, my fiancé can't drive."),
(@id_pregunta, 'C', 'We bought the car in March.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso, 2, "Haven't you resolved that problem yet?", 'A');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', "We're working on it."),
(@id_pregunta, 'B', 'We have both letters.'),
(@id_pregunta, 'C', 'You have my assurance.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso, 3, "Aren't pop-up ads on the Internet just a fad?", 'A');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', "No, they're here to stay."),
(@id_pregunta, 'B', 'I put up with a lot.'),
(@id_pregunta, 'C', "She's not fat.");

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso, 4, 'Was the customer satisfied with our work?', 'B');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', 'Satisfaction is guaranteed.'),
(@id_pregunta, 'B', 'Very.'),
(@id_pregunta, 'C', 'I found a new customer today.');