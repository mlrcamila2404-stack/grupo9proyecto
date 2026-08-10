CREATE DATABASE practify;

USE practify;

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(100)
);


CREATE TABLE pruebas (
    id_prueba INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT NULL,
    tiempo_minutos INT NOT NULL,
    activa BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE secciones (
    id_seccion INT AUTO_INCREMENT PRIMARY KEY,
    id_prueba INT NOT NULL,
    titulo VARCHAR(150),
    tipo ENUM('listening', 'reading') NOT NULL,
    descripcion TEXT NULL,
    orden INT NOT NULL,

    FOREIGN KEY (id_prueba)
        REFERENCES pruebas(id_prueba)
);


CREATE TABLE recursos (
    id_recurso INT AUTO_INCREMENT PRIMARY KEY,
    id_seccion INT NOT NULL,
    tipo_recurso ENUM('audio', 'imagen') NOT NULL,
    archivo VARCHAR(255) NOT NULL,
    descripcion TEXT NULL,
    orden INT NOT NULL,

    FOREIGN KEY (id_seccion)
        REFERENCES secciones(id_seccion)
);


CREATE TABLE preguntas (
    id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
    id_recurso INT NOT NULL,
    numero_pregunta INT NOT NULL,
    texto_pregunta VARCHAR(225) NULL,
    respuesta_correcta ENUM('A', 'B', 'C', 'D') NOT NULL,
    retroalimentacion TEXT NULL,

    FOREIGN KEY (id_recurso)
        REFERENCES recursos(id_recurso)
);


CREATE TABLE intentos (
    id_intento INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_prueba INT NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NULL,
    puntaje DECIMAL(5,2),
    porcentaje DECIMAL(5,2),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_prueba)
        REFERENCES pruebas(id_prueba)
);


CREATE TABLE opciones_texto (
    id_opcion INT AUTO_INCREMENT PRIMARY KEY,
    id_pregunta INT NOT NULL,
    letra ENUM('A', 'B', 'C', 'D') NOT NULL,
    texto_opcion VARCHAR(255) NOT NULL,

    FOREIGN KEY (id_pregunta)
        REFERENCES preguntas(id_pregunta)
);


CREATE TABLE respuestas_usuario (
    id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
    id_intento INT NOT NULL,
    id_pregunta INT NOT NULL,
    respuesta_usuario ENUM('A', 'B', 'C', 'D') NOT NULL,
    es_correcta BOOLEAN NOT NULL,

    FOREIGN KEY (id_intento)
        REFERENCES intentos(id_intento),

    FOREIGN KEY (id_pregunta)
        REFERENCES preguntas(id_pregunta)
);

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