-- 1. Для вибірки всіх туристів
SELECT t.id,
       t.passport_number,
       t.full_name,
       t.birth_date,
       t.category,
       t.parent_id,
       v.document_number AS visa_number,
       v.status          AS visa_status,
       c.marks           AS cargo_marks,
       c.total_weight    AS cargo_weight
FROM tourists t
         LEFT JOIN visa_documents v ON t.id = v.tourist_id
         LEFT JOIN cargo c ON t.id = c.tourist_id
ORDER BY t.full_name;

-- 2. Для вибірки конкретної категорії (наприклад, 'cargo_tourist')
SELECT t.id,
       t.passport_number,
       t.full_name,
       t.birth_date,
       t.category,
       t.parent_id,
       v.document_number AS visa_number,
       v.status          AS visa_status,
       c.marks           AS cargo_marks,
       c.total_weight    AS cargo_weight
FROM tourists t
         LEFT JOIN visa_documents v ON t.id = v.tourist_id
         LEFT JOIN cargo c ON t.id = c.tourist_id
WHERE t.category = 'cargo_tourist'
ORDER BY t.full_name;


-- 3. Списки на розселення для всіх готелів
SELECT h.name                        AS hotel_name,
       hb.room_number,
       COUNT(thb.tourist_id)         AS tourists_count,
       STRING_AGG(t.full_name, ', ') AS tourists_names
FROM hotels h
         JOIN hotel_bookings hb ON h.id = hb.hotel_id
         JOIN tourists_hotel_bookings thb ON hb.id = thb.hotel_booking_id
         JOIN tourists t ON thb.tourist_id = t.id
GROUP BY h.name, hb.room_number
ORDER BY h.name, hb.room_number;

-- 4. Списки на розселення для конкретного готелю та категорії
SELECT h.name                        AS hotel_name,
       hb.room_number,
       COUNT(thb.tourist_id)         AS tourists_count,
       STRING_AGG(t.full_name, ', ') AS tourists_names
FROM hotels h
         JOIN hotel_bookings hb ON h.id = hb.hotel_id
         JOIN tourists_hotel_bookings thb ON hb.id = thb.hotel_booking_id
         JOIN tourists t ON thb.tourist_id = t.id
WHERE h.name = 'Le Meurice'
  AND t.category = 'cargo_tourist'
GROUP BY h.name, hb.room_number
ORDER BY h.name, hb.room_number;


-- 5. Загальна кількість
SELECT COUNT(DISTINCT cv.tourist_id) AS tourists_count
FROM country_visits cv
WHERE cv.entry_date BETWEEN '2023-01-01' AND '2023-12-31';

-- 6. Для конкретної категорії
SELECT COUNT(DISTINCT cv.tourist_id) AS tourists_count
FROM country_visits cv
         JOIN tourists t ON cv.tourist_id = t.id
WHERE cv.entry_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND t.category = 'vacationer';

-- 7. Відомості про конкретного туриста
SELECT t.full_name,
       t.passport_number,
       (SELECT COUNT(*) FROM country_visits WHERE tourist_id = 1) AS visits_count,
       (SELECT STRING_AGG(entry_date::text || ' - ' || exit_date::text, ', ')
        FROM country_visits
        WHERE tourist_id = 1)                                     AS visit_dates,
       (SELECT STRING_AGG(h.name || ' (кім. ' || hb.room_number || ')', ', ')
        FROM hotels h
                 JOIN hotel_bookings hb ON h.id = hb.hotel_id
                 JOIN tourists_hotel_bookings thb ON hb.id = thb.hotel_booking_id
        WHERE thb.tourist_id = 1)                                 AS hotels,
       (SELECT STRING_AGG(e.title || ' (' || e.agency_name || ')', ', ')
        FROM excursions e
                 JOIN excursion_participants ep ON e.id = ep.excursion_id
        WHERE ep.tourist_id = 1)                                  AS excursions,
       (SELECT STRING_AGG(c.marks::text, ', ')
        FROM cargo c
        WHERE c.tourist_id = 1)                                   AS cargo_marks
FROM tourists t
WHERE t.id = 1;


-- 8. Список готелів з кількістю номерів
SELECT h.name                         AS hotel_name,
       COUNT(DISTINCT hb.room_number) AS rooms_count,
       COUNT(thb.tourist_id)          AS tourists_count
FROM hotels h
         JOIN hotel_bookings hb ON h.id = hb.hotel_id
         JOIN tourists_hotel_bookings thb ON hb.id = thb.hotel_booking_id
WHERE hb.check_in_date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY h.name
ORDER BY tourists_count DESC;


-- 9. Кількість туристів, що замовили екскурсії
SELECT COUNT(DISTINCT ep.tourist_id) AS tourists_with_excursions
FROM excursion_participants ep
         JOIN excursions e ON ep.excursion_id = e.id
WHERE e.excursion_date BETWEEN '2023-01-01' AND '2023-12-31';


-- 10. Популярні екскурсії та агентства
SELECT e.title                AS excursion,
       e.agency_name          AS agency,
       COUNT(ep.tourist_id)   AS participants_count,
       ROUND(AVG(e.price), 2) AS avg_price
FROM excursions e
         JOIN excursion_participants ep ON e.id = ep.excursion_id
GROUP BY e.title, e.agency_name
ORDER BY participants_count DESC LIMIT 10;


-- 11. Завантаження рейсу
SELECT f.flight_number,
       f.departure_date,
       COUNT(DISTINCT fp.tourist_id)    AS passengers_count,
       COUNT(DISTINCT fc.cargo_id)      AS cargo_items_count,
       COALESCE(SUM(c.total_weight), 0) AS total_cargo_weight
FROM flights f
         LEFT JOIN flight_passengers fp ON f.id = fp.flight_id
         LEFT JOIN flight_cargo fc ON f.id = fc.flight_id
         LEFT JOIN cargo c ON fc.cargo_id = c.id
WHERE f.flight_number = 'AF5679'
  AND f.departure_date = '2024-01-05'
GROUP BY f.flight_number, f.departure_date;


-- 12. Статистика вантажообігу
SELECT COUNT(DISTINCT c.id)                                           AS cargo_items_count,
       SUM(c.total_weight)                                            AS total_weight,
       COUNT(DISTINCT fc.flight_id)                                   AS flights_count,
       COUNT(DISTINCT CASE WHEN f.price_per_ticket = 0 THEN f.id END) AS cargo_flights_count,
       COUNT(DISTINCT CASE WHEN f.price_per_ticket > 0 THEN f.id END) AS passenger_flights_count
FROM cargo c
         JOIN flight_cargo fc ON c.id = fc.cargo_id
         JOIN flights f ON fc.flight_id = f.id
WHERE c.tourist_id IN (SELECT id
                       FROM tourists
                       WHERE category = 'cargo_tourist')
  AND f.departure_date BETWEEN '2023-01-01' AND '2023-12-31';


-- 13. Фінансовий звіт для всієї групи
SELECT fr.report_date,
       tg.departure_date,
       tg.arrival_date,
       fr.hotel_expense,
       fr.flight_expense,
       fr.excursion_expense,
       fr.other_expense,
       fr.total_expense
FROM financial_reports fr
         JOIN tourist_groups tg ON fr.tourist_group = tg.id
WHERE fr.tourist_group = 2;

-- 14. Фінансовий звіт для конкретної категорії
SELECT fr.report_date,
       tg.departure_date,
       tg.arrival_date,
       fr.hotel_expense,
       fr.flight_expense,
       fr.excursion_expense,
       fr.other_expense,
       fr.total_expense
FROM financial_reports fr
         JOIN tourist_groups tg ON fr.tourist_group = tg.id
WHERE fr.tourist_group = 1
  AND fr.category = 'vacationer';


-- 15. Витрати та доходи за період
SELECT 'Готелі'                                                         AS category,
       SUM(hb.price_per_night * (hb.check_out_date - hb.check_in_date)) AS total
FROM hotel_bookings hb
WHERE hb.check_in_date BETWEEN '2023-01-01' AND '2023-12-31'
UNION ALL
SELECT 'Рейси',
       SUM(f.price_per_ticket)
FROM flights f
         JOIN flight_passengers fp ON f.id = fp.flight_id
WHERE f.departure_date BETWEEN '2023-01-01' AND '2023-12-31'
UNION ALL
SELECT 'Екскурсії',
       SUM(e.price)
FROM excursions e
         JOIN excursion_participants ep ON e.id = ep.excursion_id
WHERE e.excursion_date BETWEEN '2023-01-01' AND '2023-12-31'
UNION ALL
SELECT 'Вантаж',
       SUM(c.packaging_cost + c.insurance_cost)
FROM cargo c
WHERE EXISTS (SELECT 1
              FROM flight_cargo fc
                       JOIN flights f ON fc.flight_id = f.id
              WHERE fc.cargo_id = c.id
                AND f.departure_date BETWEEN '2023-01-01' AND '2023-12-31');


-- 16. Статистика за видами вантажу
SELECT UNNEST(c.marks)                                           AS cargo_type,
       COUNT(*)                                                  AS items_count,
       SUM(c.total_weight)                                       AS total_weight,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM cargo), 2) AS percentage_of_total
FROM cargo c
GROUP BY cargo_type
ORDER BY total_weight DESC;


-- 17. Відомості про туристів рейсу
SELECT t.id                                                           AS tourist_id,
       t.full_name,
       t.passport_number,
       t.category,
       fp.seat,
       STRING_AGG(h.name || ' (кім. ' || hb.room_number || ')', ', ') AS hotels,
       STRING_AGG(c.marks::text, ', ')                                AS cargo_marks
FROM flights f
         JOIN flight_passengers fp ON f.id = fp.flight_id
         JOIN tourists t ON fp.tourist_id = t.id
         LEFT JOIN tourists_hotel_bookings thb ON t.id = thb.tourist_id
         LEFT JOIN hotel_bookings hb ON thb.hotel_booking_id = hb.id
         LEFT JOIN hotels h ON hb.hotel_id = h.id
         LEFT JOIN cargo c ON t.id = c.tourist_id
WHERE f.flight_number = 'AF9012'
  AND f.departure_date = '2023-12-22'
GROUP BY t.id, t.full_name, t.passport_number, t.category, fp.seat;
