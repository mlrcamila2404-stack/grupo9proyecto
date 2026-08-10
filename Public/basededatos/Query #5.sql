USE practify;

INSERT INTO pruebas (titulo, descripcion, tiempo_minutos, activa)
VALUES ('Listening 3', 'Part 3: Conversation', 10, TRUE);
SET @id_prueba_l3 = LAST_INSERT_ID();

INSERT INTO secciones (id_prueba, titulo, tipo, descripcion, orden)
VALUES (@id_prueba_l3, 'Part 3: Conversation', 'listening', 'Listen to the audio and respond to the questions about the conversation.', 1);
SET @id_seccion_l3 = LAST_INSERT_ID();

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_l3, 'audio', 'conversation.mp3', 'Conversation 1', 1);
SET @rec1 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 1, 'What problem do the speakers have with the computer company?', 'C');
SET @p1_1 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_1, 'A', 'It won''t renew the contract.'),
(@p1_1, 'B', 'It can''t repair the computer.'),
(@p1_1, 'C', 'It sends incorrect bills.'),
(@p1_1, 'D', 'It charges them for extra spare parts.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 2, 'When will the contract run out?', 'A');
SET @p1_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_2, 'A', 'In two months.'),
(@p1_2, 'B', 'In nine months.'),
(@p1_2, 'C', 'In one year.'),
(@p1_2, 'D', 'In four years.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec1, 3, 'What does the woman suggest doing?', 'D');
SET @p1_3 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p1_3, 'A', 'Asking the company to write a new contract.'),
(@p1_3, 'B', 'Canceling the contract.'),
(@p1_3, 'C', 'Renewing the contract.'),
(@p1_3, 'D', 'Waiting until the contract runs out.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 1, 'Why does the store need to be more competitive?', 'C');
SET @p2_1 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_1, 'A', 'There''s currently a recession.'),
(@p2_1, 'B', 'Productivity has dropped lately.'),
(@p2_1, 'C', 'There''s a new competitor nearby.'),
(@p2_1, 'D', 'New employees have little experience.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 2, 'How will the store attract more customers?', 'D');
SET @p2_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_2, 'A', 'By giving them trial products.'),
(@p2_2, 'B', 'By giving them discounts.'),
(@p2_2, 'C', 'By selling new products.'),
(@p2_2, 'D', 'By featuring happy customers in ads.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec2, 3, 'Who will the woman call?', 'A');
SET @p2_3 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p2_3, 'A', 'A photographer.'),
(@p2_3, 'B', 'A photocopy salesperson.'),
(@p2_3, 'C', 'A customer.'),
(@p2_3, 'D', 'A marketing executive.');


INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 1, 'How long is the basic warranty effective?', 'C');
SET @p3_1 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_1, 'A', 'Thirty days.'),
(@p3_1, 'B', 'Sixty days.'),
(@p3_1, 'C', 'One year.'),
(@p3_1, 'D', 'Two years.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 2, 'What will happen if the woman uses an unapproved mechanic?', 'B');
SET @p3_2 = LAST_INSERT_ID();
INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_2, 'A', 'There are no consequences.'),
(@p3_2, 'B', 'The warranty is no longer effective.'),
(@p3_2, 'C', 'Protection is decreased by 50%.'),
(@p3_2, 'D', 'She will have full coverage.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec3, 3, 'What does the woman decide to do?', 'A');
SET @p3_3 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p3_3, 'A', 'Take her car to an approved mechanic.'),
(@p3_3, 'B', 'Buy the extended warranty.'),
(@p3_3, 'C', 'Refuse the basic warranty.'),
(@p3_3, 'D', 'Buy a different car.');

INSERT INTO recursos (id_seccion, tipo_recurso, archivo, descripcion, orden)
VALUES (@id_seccion_l3, 'audio', 'conversation.mp3', 'Conversation 4', 4);
SET @rec4 = LAST_INSERT_ID();

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec4, 1, 'How do the speakers feel about Alexa''s business plan?', 'D');
SET @p4_1 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p4_1, 'A', 'She has gathered too much data.'),
(@p4_1, 'B', 'She has taken on too much risk.'),
(@p4_1, 'C', 'She has made many obvious mistakes.'),
(@p4_1, 'D', 'She is serious-minded and cautious.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec4, 2, 'How will the man help Alexa?', 'A');
SET @p4_2 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p4_2, 'A', 'By doing market research.'),
(@p4_2, 'B', 'By searching for an office.'),
(@p4_2, 'C', 'By pointing out her mistakes.'),
(@p4_2, 'D', 'By nominating her for an award.');

INSERT INTO preguntas (id_recurso, numero_pregunta, texto_pregunta, respuesta_correcta)
VALUES (@rec4, 3, 'According to the man, what is the most important strategy for success?', 'B');
SET @p4_3 = LAST_INSERT_ID();

INSERT INTO opciones_texto (id_pregunta, letra, texto_opcion) VALUES
(@p4_3, 'A', 'Investing in a good sound system.'),
(@p4_3, 'B', 'Having a good business plan.'),
(@p4_3, 'C', 'Eliminating all risk.'),
(@p4_3, 'D', 'Studying the market.');

SELECT @id_prueba_l3 AS id_prueba_listening3;