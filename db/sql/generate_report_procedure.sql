CREATE OR REPLACE PROCEDURE generate_financial_reports()
LANGUAGE plpgsql
AS $$
DECLARE
    group_rec RECORD;
    report_exists BOOLEAN;
    categories TEXT[] := ARRAY['vacationer', 'cargo_tourist', 'child', 'total'];
    current_category TEXT;
    hotel_cost NUMERIC(10,2);
    flight_cost NUMERIC(10,2);
    excursion_cost NUMERIC(10,2);
    other_cost NUMERIC(10,2);
BEGIN
    -- Перебираємо групи, які вже завершили тур
    FOR group_rec IN
        SELECT id FROM tourist_groups
        WHERE arrival_date < CURRENT_DATE
    LOOP
        -- Перевіряємо, чи вже існує звіт для цієї групи (загальний)
        SELECT EXISTS(
            SELECT 1 FROM financial_reports
            WHERE tourist_group = group_rec.id AND category = 'total'
        ) INTO report_exists;

        -- Якщо звіту немає - генеруємо нові
        IF NOT report_exists THEN
            -- Генеруємо звіти для кожної категорії
            FOREACH current_category IN ARRAY categories
            LOOP
                -- Рахуємо витрати на готелі
                SELECT COALESCE(SUM(
                    CASE
                        WHEN current_category = 'total' THEN hb.price_per_night * (hb.check_out_date - hb.check_in_date)
                        WHEN t.category = current_category THEN hb.price_per_night * (hb.check_out_date - hb.check_in_date)
                        ELSE 0
                    END
                ), 0)
                INTO hotel_cost
                FROM hotel_bookings hb
                JOIN tourists_hotel_bookings thb ON hb.id = thb.hotel_booking_id
                JOIN tourists t ON thb.tourist_id = t.id
                JOIN group_members gm ON thb.tourist_id = gm.tourist_id
                WHERE gm.group_id = group_rec.id;

                -- Рахуємо витрати на перельоти
                SELECT COALESCE(SUM(
                    CASE
                        WHEN current_category = 'total' THEN f.price_per_ticket
                        WHEN t.category = current_category THEN f.price_per_ticket
                        ELSE 0
                    END
                ), 0)
                INTO flight_cost
                FROM flight_passengers fp
                JOIN flights f ON fp.flight_id = f.id
                JOIN tourists t ON fp.tourist_id = t.id
                JOIN group_members gm ON fp.tourist_id = gm.tourist_id
                WHERE gm.group_id = group_rec.id;

                -- Рахуємо витрати на екскурсії
                SELECT COALESCE(SUM(
                    CASE
                        WHEN current_category = 'total' THEN e.price
                        WHEN t.category = current_category THEN e.price
                        ELSE 0
                    END
                ), 0)
                INTO excursion_cost
                FROM excursion_participants ep
                JOIN excursions e ON ep.excursion_id = e.id
                JOIN tourists t ON ep.tourist_id = t.id
                JOIN group_members gm ON ep.tourist_id = gm.tourist_id
                WHERE gm.group_id = group_rec.id;

                -- Рахуємо інші витрати
                SELECT COALESCE(SUM(
                    CASE
                        WHEN current_category = 'total' THEN ex.expense
                        WHEN t.category = current_category THEN ex.expense
                        ELSE 0
                    END
                ), 0)
                INTO other_cost
                FROM expenses ex
                JOIN tourists t ON ex.tourist_id = t.id
                JOIN group_members gm ON ex.tourist_id = gm.tourist_id
                WHERE gm.group_id = group_rec.id;

                -- Додаємо вартість вантажних перевезень (тільки для cargo_tourist або total)
                IF current_category IN ('cargo_tourist', 'total') THEN
                    SELECT COALESCE(other_cost + SUM(
                        CASE
                            WHEN current_category = 'total' THEN c.packaging_cost + c.insurance_cost
                            WHEN t.category = 'cargo_tourist' THEN c.packaging_cost + c.insurance_cost
                            ELSE 0
                        END
                    ), other_cost)
                    INTO other_cost
                    FROM cargo c
                    JOIN tourists t ON c.tourist_id = t.id
                    JOIN group_members gm ON c.tourist_id = gm.tourist_id
                    WHERE gm.group_id = group_rec.id;
                END IF;

                -- Вставляємо новий запис звіту
                INSERT INTO financial_reports (
                    report_date,
                    tourist_group,
                    category,
                    hotel_expense,
                    flight_expense,
                    excursion_expense,
                    other_expense
                ) VALUES (
                    CURRENT_DATE,
                    group_rec.id,
                    current_category,
                    hotel_cost,
                    flight_cost,
                    excursion_cost,
                    other_cost
                );

                RAISE NOTICE 'Згенеровано фінансовий звіт для групи %, категорія %', group_rec.id, current_category;
            END LOOP;
        END IF;
    END LOOP;
END;
$$
