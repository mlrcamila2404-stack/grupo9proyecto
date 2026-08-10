USE practify;

INSERT INTO pruebas (titulo, descripcion, tiempo_minutos, activa)
VALUES ('Reading 2', 'Part 2: Text Completion', 10, TRUE);
SET @id_prueba_r2 = LAST_INSERT_ID();

INSERT INTO secciones (id_prueba, titulo, tipo, descripcion, orden)
VALUES (@id_prueba_r2, 'Part 2: Text Completion', 'reading', 'Read the following texts and choose the word or phrase that best completes each blank.', 1);
SET @id_seccion_r2 = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r2, 'imagen', 'textcomplete1.jpg', 'Number 1', 1);
SET @rec1 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec1, 1, 'D');
SET @p1_1 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_1, 'A', 'agree'),
(@p1_1, 'B', 'agreed'),
(@p1_1, 'C', 'agreeable'),
(@p1_1, 'D', 'agreement');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec1, 2, 'B');
SET @p1_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_2, 'A', 'provision'),
(@p1_2, 'B', 'provisions'),
(@p1_2, 'C', 'provider'),
(@p1_2, 'D', 'providers');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec1, 3, 'D');
SET @p1_3 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_3, 'A', 'assure'),
(@p1_3, 'B', 'will assure'),
(@p1_3, 'C', 'are assuring'),
(@p1_3, 'D', 'are assured');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r2, 'imagen', 'textcomplete2.jpg', 'Number 2', 2);
SET @rec2 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec2, 4, 'C');
SET @p2_1 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_1, 'A', 'attract'),
(@p2_1, 'B', 'attractive'),
(@p2_1, 'C', 'attractively'),
(@p2_1, 'D', 'attraction');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec2, 5, 'A');
SET @p2_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_2, 'A', 'persuade'),
(@p2_2, 'B', 'persuades'),
(@p2_2, 'C', 'to persuade'),
(@p2_2, 'D', 'will persuade');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec2, 6, 'D');
SET @p2_3 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_3, 'A', 'satisfy'),
(@p2_3, 'B', 'satisfied'),
(@p2_3, 'C', 'will satisfy'),
(@p2_3, 'D', 'will be satisfied');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r2, 'imagen', 'textcomplete3.jpg', 'Number 3', 3);
SET @rec3 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec3, 7, 'A');
SET @p3_1 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_1, 'A', 'protects'),
(@p3_1, 'B', 'protectors'),
(@p3_1, 'C', 'protection'),
(@p3_1, 'D', 'protective');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec3, 8, 'B');
SET @p3_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_2, 'A', 'require'),
(@p3_2, 'B', 'requires'),
(@p3_2, 'C', 'is requiring'),
(@p3_2, 'D', 'has required');

INSERT INTO preguntas (id_recurso, numero_pregunta, respuesta_correcta)
VALUES (@rec3, 9, 'C');
SET @p3_3 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_3, 'A', 'should expire'),
(@p3_3, 'B', 'might expire'),
(@p3_3, 'C', 'will expire'),
(@p3_3, 'D', 'can expire');

SELECT @id_prueba_r2 AS id_prueba_reading2;