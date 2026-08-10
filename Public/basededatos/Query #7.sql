USE practify;

INSERT INTO pruebas (titulo, descripcion, tiempo_minutos, activa)
VALUES ('Reading 3', 'Part 3: Reading Comprehension', 15, TRUE);
SET @id_prueba_r3 = LAST_INSERT_ID();

INSERT INTO secciones (id_prueba, titulo, tipo, descripcion, orden)
VALUES (@id_prueba_r3, 'Part 3: Reading Comprehension', 'reading', 'Read the following paragraphs and select the best answer.', 1);
SET @id_seccion_r3 = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r3, 'imagen', 'textcompresion1.jpg', 'Number 1', 1);
SET @rec1 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 1, 'What is the purpose of the letter?', 'A');
SET @p1 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1, 'A', 'To find out why Mr. Harrison no longer wants this service.'),
(@p1, 'B', 'To ask Mr. Harrison to renew his contract.'),
(@p1, 'C', 'To advertise new services provided by the company.'),
(@p1, 'D', 'To offer the customer a better contract.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 2, 'What is Ms. Santos''s business?', 'B');
SET @p2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2, 'A', 'Customer relations.'),
(@p2, 'B', 'Cleaning service.'),
(@p2, 'C', 'Contract review.'),
(@p2, 'D', 'Conflict resolution.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 3, 'Why did this customer cancel the contract?', 'C');
SET @p3 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3, 'A', 'The company damaged something in his office.'),
(@p3, 'B', 'The employees provided unsatisfactory service.'),
(@p3, 'C', 'He had a disagreement about his bill.'),
(@p3, 'D', 'He doesn''t want this type of service anymore.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 4, 'The word "assure" in letter one, line 2, is closest in meaning to', 'A');
SET @p4 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p4, 'A', 'guarantee.'),
(@p4, 'B', 'discover.'),
(@p4, 'C', 'prove.'),
(@p4, 'D', 'advertise.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 5, 'The word "specific" in form two, line 15, is closest in meaning to', 'D');
SET @p5 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p5, 'A', 'personal.'),
(@p5, 'B', 'important.'),
(@p5, 'C', 'repeated.'),
(@p5, 'D', 'particular.');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r3, 'imagen', 'textcompresion2.jpg', 'Number 2', 2);
SET @rec2 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 6, 'When did the sales department have a meeting?', 'B');
SET @p6 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p6, 'A', 'At the beginning of the year.'),
(@p6, 'B', 'In March.'),
(@p6, 'C', 'A quarter of a year ago.'),
(@p6, 'D', 'At the end of last year.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 7, 'Which of the following might be part of the Catherine''s Curls line of products?', 'A');
SET @p7 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p7, 'A', 'Shampoo.'),
(@p7, 'B', 'Hand lotion.'),
(@p7, 'C', 'Nail polish.'),
(@p7, 'D', 'Lipstick.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 8, 'According to the report, why are fewer people buying Catherine''s Curls products?', 'C');
SET @p8 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p8, 'A', 'The prices are too high.'),
(@p8, 'B', 'The ingredients aren''t natural.'),
(@p8, 'C', 'The packages aren''t attractive.'),
(@p8, 'D', 'The type of product is not popular.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 9, 'The word "market" in line 5 is closest in meaning to', 'D');
SET @p9 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p9, 'A', 'product'),
(@p9, 'B', 'factory'),
(@p9, 'C', 'purchase'),
(@p9, 'D', 'demand');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 10, 'The word "fad" in line 8 is closest in meaning to', 'B');
SET @p10 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p10, 'A', 'need'),
(@p10, 'B', 'fashion'),
(@p10, 'C', 'event'),
(@p10, 'D', 'wish');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_r3, 'imagen', 'textcompresion3.jpg', 'Number 3', 3);
SET @rec3 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 11, 'Why did the customer return the toaster?', 'A');
SET @p11 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p11, 'A', 'It doesn''t work.'),
(@p11, 'B', 'It was too expensive.'),
(@p11, 'C', 'She wants a brand new one.'),
(@p11, 'D', 'She prefers a different model.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 12, 'When did she purchase the toaster?', 'D');
SET @p12 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p12, 'A', 'A month ago.'),
(@p12, 'B', 'Last October.'),
(@p12, 'C', 'Exactly one year ago.'),
(@p12, 'D', 'A little over a year ago.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 13, 'What will she get in place of the returned toaster?', 'D');
SET @p13 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p13, 'A', 'Nothing.'),
(@p13, 'B', 'A refund.'),
(@p13, 'C', 'A brand new toaster.'),
(@p13, 'D', 'A different, repaired toaster.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 14, 'The word "considering" in line 4 of the second letter is closest in meaning to', 'B');
SET @p14 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p14, 'A', 'reading about'),
(@p14, 'B', 'thinking about'),
(@p14, 'C', 'talking about'),
(@p14, 'D', 'worrying about');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 15, 'The word "frequently" in line 6 of the second letter is closest in meaning to', 'A');
SET @p15 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p15, 'A', 'often'),
(@p15, 'B', 'rarely'),
(@p15, 'C', 'never'),
(@p15, 'D', 'occasionally');

SELECT @id_prueba_r3 AS id_prueba_reading3;