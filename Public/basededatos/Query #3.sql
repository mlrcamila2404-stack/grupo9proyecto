INSERT INTO pruebas (titulo, descripcion, tiempo_minutos, activa)
VALUES ('Listening 1 Photos ', 'Look at the images and choose the best answer.', 15, TRUE);

SET @id_prueba = LAST_INSERT_ID();

INSERT INTO secciones (id_prueba, titulo, tipo, descripcion, orden)
VALUES (@id_prueba, 'Part 1: Photos', 'listening', 'Look at the images and choose the best answer.', 1);

SET @id_seccion = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'audio', 'audios/wasa.mp3', 'Audio de práctica 1', 6);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'imagen', 'Track1.png', 'Photo question 1', 1);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@id_recurso, 1, 'B');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', 'The signers are having a party.'),
(@id_pregunta, 'B', 'The men are signing an agreement.'),
(@id_pregunta, 'C', 'The provisions are in the cabinet.'),
(@id_pregunta, 'D', 'The cancelled flight is on the tarmac.');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'imagen', 'Track2.png', 'Photo question 2', 2);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@id_recurso, 2, 'C');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', 'The clerk is competing with others.'),
(@id_pregunta, 'B', 'The shoppers are comparing prices.'),
(@id_pregunta, 'C', 'The man is not attracting a crowd.'),
(@id_pregunta, 'D', 'The consumer is convincing the sales person.');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'imagen', 'Track3.png', 'Photo question 3', 3);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@id_recurso, 3, 'C');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', "They're considering purchasing the bag."),
(@id_pregunta, 'B', "They're protecting their dog."),
(@id_pregunta, 'C', "They're covering the carpet."),
(@id_pregunta, 'D', "They're checking the expiration date.");

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'imagen', 'Track4.png', 'Photo question 4', 4);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@id_recurso, 4, 'A');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', 'The managers are planning a strategy.'),
(@id_pregunta, 'B', 'The president is dressing for dinner.'),
(@id_pregunta, 'C', 'The primary shape is round.'),
(@id_pregunta, 'D', 'The demonstrators are avoiding the meeting.');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion, 'imagen', 'Track5.png', 'Photo question 5', 5);
SET @id_recurso = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@id_recurso, 5, 'D');
SET @id_pregunta = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@id_pregunta, 'A', 'The attendees are registering at the desk.'),
(@id_pregunta, 'B', 'The organizers are selecting a podium.'),
(@id_pregunta, 'C', 'The banquet room is overcrowded.'),
(@id_pregunta, 'D', 'The participants are attending a session.');