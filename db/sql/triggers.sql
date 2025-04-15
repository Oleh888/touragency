CREATE OR REPLACE FUNCTION validate_parent_category()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.category = 'child' AND NEW.parent_id IS NOT NULL THEN
        -- Перевірка, чи батько не належить до категорії 'child'
        IF EXISTS (SELECT 1 FROM tourists WHERE id = NEW.parent_id AND category = 'child') THEN
            RAISE EXCEPTION 'Батько (parent_id %) не може бути дитиною', NEW.parent_id;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Тригер спрацьовує перед додаванням або оновленням запису в tourists
CREATE TRIGGER check_parent_is_adult
BEFORE INSERT OR UPDATE ON tourists
FOR EACH ROW EXECUTE FUNCTION validate_parent_category();
