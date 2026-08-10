INSERT INTO pruebas (titulo, descripcion, tiempo_minutos)
VALUES ('Reading 1 - Incomplete Sentence', 'Read the sentence and choose the best answer', 15);
SET @id_prueba_reading1 = LAST_INSERT_ID();
 
INSERT INTO secciones (id_prueba, titulo, tipo, orden)
VALUES (@id_prueba_reading1, 'Part 1: Incomplete Sentences', 'reading', 1);
SET @id_seccion_r1 = LAST_INSERT_ID();
 
INSERT INTO recursos (id_seccion, tipo_recurso, archivo, orden)
VALUES (@id_seccion_r1, 'audio', 'wasa.mp3', 1);
SET @id_recurso_r1 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso_r1, 1, 'The manager ______ the report before the meeting.', 'A');
SET @q1 = LAST_INSERT_ID();
 
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@q1, 'A', 'reviewed'),
(@q1, 'B', 'review'),
(@q1, 'C', 'reviewing');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso_r1, 2, 'The new policy will ______ next month.', 'A');
SET @q2 = LAST_INSERT_ID();
 
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@q2, 'A', 'take effect'),
(@q2, 'B', 'takes effect'),
(@q2, 'C', 'took effect');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso_r1, 3, 'The company is known ______ its excellent customer service.', 'A');
SET @q3 = LAST_INSERT_ID();
 
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@q3, 'A', 'for'),
(@q3, 'B', 'to'),
(@q3, 'C', 'about');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso_r1, 4, 'Please submit your application ______ Friday.', 'A');
SET @q4 = LAST_INSERT_ID();
 
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@q4, 'A', 'by'),
(@q4, 'B', 'at'),
(@q4, 'C', 'on');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@id_recurso_r1, 5, 'The project was delayed ______ the lack of resources.', 'B');
SET @q5 = LAST_INSERT_ID();
 
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@q5, 'A', 'because'),
(@q5, 'B', 'due to'),
(@q5, 'C', 'although');

SELECT @id_prueba_reading1 AS id_prueba_reading1;