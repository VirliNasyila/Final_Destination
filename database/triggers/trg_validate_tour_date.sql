
CREATE OR REPLACE FUNCTION validate_tour_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.tour_date < CURRENT_DATE THEN
        RAISE EXCEPTION 'Tour date (%s) shouldnt be before today (%s)', NEW.tour_date, CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validate_tour_date
BEFORE INSERT OR UPDATE ON tours
FOR EACH ROW
EXECUTE FUNCTION validate_tour_date();
