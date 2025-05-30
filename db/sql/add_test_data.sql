-- Дорослі туристи (vacationer та cargo_tourist)
INSERT INTO tourists (passport_number, full_name, gender, birth_date, accommodation_preferences, category, parent_id)
VALUES ('FR00123456', 'Іваненко Петро Олексійович', 'male', '1985-07-15', 'одномісний номер, вид на місто',
        'vacationer', NULL),
       ('FR00234567', 'Петренко Марія Іванівна', 'female', '1990-03-22', 'двомісний номер, тихий район', 'vacationer',
        NULL),
       ('FR00345678', 'Сидоренко Олег Васильович', 'male', '1978-11-30', NULL, 'cargo_tourist', NULL),
       ('FR00456789', 'Коваленко Анна Сергіївна', 'female', '1995-05-18', 'апартаменти з кухнею', 'vacationer', NULL),
       ('FR00567890', 'Мельник Василь Петрович', 'male', '1982-09-10', 'хостел, бюджетний варіант', 'cargo_tourist',
        NULL),
       ('FR00678901', 'Шевченко Оксана Миколаївна', 'female', '1992-12-05', 'готель all inclusive', 'vacationer', NULL),
       ('FR00789012', 'Бондаренко Андрій Ігорович', 'male', '1988-04-20', NULL, 'cargo_tourist', NULL),
       ('FR00890123', 'Ткаченко Наталія Віталіївна', 'female', '1980-08-25', 'сімейний номер', 'vacationer', NULL),
       ('FR00901234', 'Кравченко Сергій Олегович', 'male', '1993-06-12', 'готель бізнес-класу', 'vacationer', NULL),
       ('FR00012345', 'Олійник Людмила Борисівна', 'female', '1975-02-28', 'готель з SPA', 'vacationer', NULL),
       ('FR01123456', 'Павленко Ірина Валеріївна', 'female', '1998-01-15', 'веганське харчування', 'vacationer', NULL),
       ('FR02234567', 'Гончаренко Денис Олександрович', 'male', '1987-07-07', 'близько до центру', 'vacationer', NULL),
       ('FR03345678', 'Савченко Юлія Дмитрівна', 'female', '1991-03-28', 'доступ для інвалідних візків', 'vacationer',
        NULL),
       ('FR04456789', 'Лисенко Максим Іванович', 'male', '1983-12-10', NULL, 'cargo_tourist', NULL);

-- Діти (child) з вказівкою батьків
INSERT INTO tourists (passport_number, full_name, gender, birth_date, accommodation_preferences, category, parent_id)
VALUES (NULL, 'Іваненко Софія Петрівна', 'female', '2015-09-10', 'додаткове ліжко в номері батьків', 'child', 1),
       (NULL, 'Іваненко Дмитро Петрович', 'male', '2018-04-15', 'додаткове ліжко в номері батьків', 'child', 1),
       (NULL, 'Петренко Артем Марійович', 'male', '2016-07-20', 'наявність дитячого клубу', 'child', 2),
       (NULL, 'Коваленко Микита Аннович', 'male', '2019-11-03', 'потрібне дитяче ліжечко', 'child', 4),
       (NULL, 'Ткаченко Вікторія Андріївна', 'female', '2014-05-30', 'потрібне дитяче меню', 'child', 8),
       (NULL, 'Ткаченко Олександр Андрійович', 'male', '2012-10-12', NULL, 'child', 8);

-- Тургрупи
INSERT INTO tourist_groups (departure_date, arrival_date)
VALUES ('2023-07-14', '2023-07-21'), -- 1 тиждень у Парижі
       ('2023-12-22', '2024-01-05');
-- 2 тижні на Різдво

-- Учасники груп
INSERT INTO group_members (group_id, tourist_id)
VALUES
-- Перша група
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
-- Друга група
(2, 1),
(2, 4),
(2, 8),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(2, 20);

-- Візи (Шенгенські)
INSERT INTO visa_documents (document_number, tourist_id, issue_date, expiry_date, visa_type, status)
VALUES
-- Перша група
('FRV001234', 1, '2023-06-01', '2023-08-31', 'Schengen', 'approved'),
('FRV002345', 2, '2023-06-05', '2023-09-15', 'Schengen', 'approved'),
('FRV003456', 3, '2023-06-10', '2023-09-30', 'Schengen', 'approved'),
('FRV004567', 4, '2023-06-15', '2023-09-30', 'Schengen', 'approved'),
('FRV005678', 5, '2023-06-20', '2023-10-31', 'Schengen', 'approved'),
('FRV006789', 6, '2023-06-25', '2023-10-31', 'Schengen', 'approved'),
('FRV007890', 7, '2023-06-28', '2023-11-30', 'Schengen', 'approved'),
('FRV008901', 8, '2023-07-01', '2023-11-30', 'Schengen', 'approved'),
('FRV009012', 9, '2023-07-05', '2023-12-31', 'Schengen', 'approved'),
('FRV000123', 10, '2023-07-10', '2024-01-31', 'Schengen', 'approved'),
-- Друга група
('FRV011234', 11, '2023-11-15', '2024-02-28', 'Schengen', 'approved'),
('FRV022345', 12, '2023-11-20', '2024-03-31', 'Schengen', 'approved'),
('FRV033456', 13, '2023-12-01', '2024-04-30', 'Schengen', 'approved'),
('FRV044567', 14, '2023-12-05', '2024-05-31', 'Schengen', 'approved');

-- Вантажі
INSERT INTO cargo (tourist_id, marks, items_count, total_weight, packaging_cost, insurance_cost)
VALUES
-- Cargo tourists
(3, '{"Fragile","Electronics"}', 2, 12.5, 200.00, 300.00),
(5, '{"Tools","Heavy"}', 1, 23.0, 150.00, 250.00),
(7, '{"Documents","Confidential"}', 3, 5.5, 100.00, 500.00),
(14, '{"Sports","Fragile"}', 2, 15.0, 180.00, 350.00),
-- Regular tourists
(1, '{"Gifts"}', 1, 5.0, 50.00, 100.00),
(8, '{"Baby","Food"}', 3, 8.0, 40.00, 80.00);

-- Рейси
INSERT INTO flights (flight_number, departure_date, arrival_date, departure_airport, arrival_airport, price_per_ticket)
VALUES
-- Перша група
('AF1234', '2023-07-14', '2023-07-14', 'Київ Бориспіль', 'Париж Шарль де Голль', 6500.00),
('AF1235', '2023-07-21', '2023-07-21', 'Париж Шарль де Голль', 'Київ Бориспіль', 6200.00),
-- Друга група
('AF5678', '2023-12-22', '2023-12-22', 'Київ Бориспіль', 'Париж Орлі', 7500.00),
('AF5679', '2024-01-05', '2024-01-05', 'Париж Орлі', 'Київ Бориспіль', 7200.00),
-- Бізнес клас
('AF9012', '2023-12-22', '2023-12-22', 'Київ Бориспіль', 'Париж Шарль де Голль', 18000.00);


-- Пасажири рейсів
INSERT INTO flight_passengers (flight_id, tourist_id, seat)
VALUES
-- Перший рейс (AF1234 Київ-Париж 2023-07-14)
(1, 1, '12A'),
(1, 2, '12B'),
(1, 3, '15C'),
(1, 4, '16D'),
(1, 5, '17E'),
(1, 6, '18F'),
(1, 7, '19G'),
(1, 8, '20H'),
(1, 9, '21J'),
(1, 10, '22K'),
(1, 11, '23L'),
(1, 12, '24M'),
(1, 13, '25N'),
(1, 14, '26P'),
(1, 15, '12C'),
(1, 16, '12D'),
(1, 17, '13A'),
(1, 18, '13B'),

-- Зворотний рейс (AF1235 Париж-Київ 2023-07-21)
(2, 1, '10A'),
(2, 2, '10B'),
(2, 3, '11C'),
(2, 4, '11D'),
(2, 5, '12E'),
(2, 6, '12F'),
(2, 7, '13G'),
(2, 8, '13H'),
(2, 9, '14J'),
(2, 10, '14K'),
(2, 11, '15L'),
(2, 12, '15M'),
(2, 13, '16N'),
(2, 14, '16P'),
(2, 15, '10C'),
(2, 16, '10D'),
(2, 17, '11A'),
(2, 18, '11B'),

-- Другий рейс (AF5678 Київ-Париж 2023-12-22)
(3, 1, '5A'),
(3, 4, '5B'),
(3, 8, '6C'),
(3, 11, '6D'),
(3, 12, '7E'),
(3, 13, '7F'),
(3, 14, '8G'),
(3, 15, '5C'),
(3, 16, '5D'),
(3, 17, '6A'),
(3, 18, '6B'),
(3, 19, '7C'),
(3, 20, '7D'),

-- Бізнес клас (AF9012 Київ-Париж 2023-12-22)
(5, 1, '1A'),
(5, 8, '1B'),
(5, 15, '1C'),
(5, 16, '1D'),

-- Зворотний рейс (AF5679 Париж-Київ 2024-01-05)
(4, 1, '3A'),
(4, 4, '3B'),
(4, 8, '4C'),
(4, 11, '4D'),
(4, 12, '5E'),
(4, 13, '5F'),
(4, 14, '6G'),
(4, 15, '3C'),
(4, 16, '3D'),
(4, 17, '4A'),
(4, 18, '4B'),
(4, 19, '5C'),
(4, 20, '5D');


-- Вантажі на рейси
INSERT INTO flight_cargo (flight_id, cargo_id)
VALUES
-- Перший рейс (AF1234 Київ-Париж 2023-07-14)
(1, 1),  -- Вантаж Сидоренка Олега (Electronics)
(1, 2),  -- Вантаж Мельника Василя (Tools)
(1, 5),  -- Вантаж Іваненка Петра (Gifts)
(1, 6),  -- Вантаж Ткаченко Наталії (Baby Food)

-- Зворотний рейс (AF1235 Париж-Київ 2023-07-21)
(2, 1),  -- Повернення вантажу Сидоренка
(2, 2),  -- Повернення вантажу Мельника
(2, 5),  -- Повернення вантажу Іваненка

-- Другий рейс (AF5678 Київ-Париж 2023-12-22)
(3, 3),  -- Вантаж Бондаренка Андрія (Documents)
(3, 4),  -- Вантаж Лисенка Максима (Sports)
(3, 6),  -- Вантаж Ткаченко Наталії (Baby Food)

-- Бізнес клас (AF9012 Київ-Париж 2023-12-22)
(5, 4),  -- Вантаж Лисенка Максима (Sports)

-- Зворотний рейс (AF5679 Париж-Київ 2024-01-05)
(4, 3),  -- Повернення вантажу Бондаренка
(4, 4);  -- Повернення вантажу Лисенка


-- Готелі
INSERT INTO hotels (name, address, phone)
VALUES ('Hôtel Plaza Athénée', '25 Avenue Montaigne, 75008 Paris', '+33 1 53 67 66 65'),
       ('Le Meurice', '228 Rue de Rivoli, 75001 Paris', '+33 1 44 58 10 10'),
       ('Hôtel du Louvre', 'Place André Malraux, 75001 Paris', '+33 1 44 58 38 38'),
       ('Hôtel de Crillon', '10 Place de la Concorde, 75008 Paris', '+33 1 44 71 15 00');

-- Бронювання готелів
INSERT INTO hotel_bookings (hotel_id, room_number, price_per_night, check_in_date, check_out_date)
VALUES (1, '501', 12000.00, '2023-07-14', '2023-07-21'),
       (2, '301', 8500.00, '2023-07-14', '2023-07-21'),
       (3, '201', 9500.00, '2023-12-22', '2024-01-05'),
       (4, '101', 15000.00, '2023-12-22', '2024-01-05');

-- Зв'язок туристів з бронюваннями
INSERT INTO tourists_hotel_bookings (tourist_id, hotel_booking_id)
VALUES (1, 1),
       (2, 1),
       (8, 1),
       (11, 1),
       (12, 1),
       (3, 2),
       (5, 2),
       (7, 2),
       (14, 2),
       (4, 3),
       (6, 3),
       (9, 3),
       (10, 3),
       (13, 3),
       (15, 4),
       (16, 4),
       (17, 4),
       (18, 4),
       (19, 4),
       (20, 4);

-- Екскурсії
INSERT INTO excursions (title, description, excursion_date, price, agency_name)
VALUES ('Ейфелева вежа', 'Оглядова екскурсія з підйомом на вежу', '2023-07-15', 1500.00, 'Paris Tours'),
       ('Лувр', 'Екскурсія основним залами музею', '2023-07-16', 1200.00, 'Art Explorers'),
       ('Версаль', 'Повноденна екскурсія до палацу', '2023-07-18', 2500.00, 'Royal Visits'),
       ('Монмартр', 'Прогулянка художнім кварталом', '2023-12-23', 800.00, 'Paris Walks'),
       ('Нормандія', 'Дводенна екскурсія до Другої світової', '2023-12-27', 5000.00, 'History Tours');

-- Учасники екскурсій
INSERT INTO excursion_participants (tourist_id, excursion_id)
VALUES (1, 1),
       (2, 1),
       (4, 1),
       (6, 1),
       (8, 1),
       (11, 1),
       (12, 1),
       (1, 2),
       (2, 2),
       (4, 2),
       (6, 2),
       (8, 2),
       (1, 3),
       (2, 3),
       (4, 3),
       (6, 3),
       (8, 3),
       (15, 4),
       (16, 4),
       (17, 4),
       (18, 4),
       (19, 4),
       (20, 4),
       (15, 5),
       (16, 5),
       (17, 5),
       (18, 5),
       (19, 5),
       (20, 5);

-- Витрати
INSERT INTO expenses (tourist_id, expense, description)
VALUES (1, 150.00, 'Трансфер з аеропорту'),
       (2, 200.00, 'Екскурсійний гід'),
       (3, 300.00, 'Вантажні послуги'),
       (4, 120.00, 'Міський транспорт'),
       (5, 180.00, 'Додатковий багаж'),
       (6, 250.00, 'SPA процедури'),
       (7, 220.00, 'Кур''єрські послуги'),
       (8, 150.00, 'Дитячий куточок'),
       (15, 100.00, 'Дитяче меню'),
       (16, 100.00, 'Дитяче меню');

-- Відвідування країни
INSERT INTO country_visits (tourist_id, entry_date, exit_date, visa_number)
VALUES
-- Перша група
(1, '2023-07-14', '2023-07-21', 'FRV001234'),
(2, '2023-07-14', '2023-07-21', 'FRV002345'),
(3, '2023-07-14', '2023-07-21', 'FRV003456'),
(4, '2023-07-14', '2023-07-21', 'FRV004567'),
(5, '2023-07-14', '2023-07-21', 'FRV005678'),
(6, '2023-07-14', '2023-07-21', 'FRV006789'),
(7, '2023-07-14', '2023-07-21', 'FRV007890'),
(8, '2023-07-14', '2023-07-21', 'FRV008901'),
(9, '2023-07-14', '2023-07-21', 'FRV009012'),
(10, '2023-07-14', '2023-07-21', 'FRV000123'),
-- Друга група
(11, '2023-12-22', '2024-01-05', 'FRV011234'),
(12, '2023-12-22', '2024-01-05', 'FRV022345'),
(13, '2023-12-22', '2024-01-05', 'FRV033456'),
(14, '2023-12-22', '2024-01-05', 'FRV044567'),
(15, '2023-12-22', '2024-01-05', 'FRV011234'),
(16, '2023-12-22', '2024-01-05', 'FRV011234'),
(17, '2023-12-22', '2024-01-05', 'FRV022345'),
(18, '2023-12-22', '2024-01-05', 'FRV033456'),
(19, '2023-12-22', '2024-01-05', 'FRV033456'),
(20, '2023-12-22', '2024-01-05', 'FRV044567');
