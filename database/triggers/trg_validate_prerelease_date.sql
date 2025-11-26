
CREATE OR REPLACE FUNCTION validate_prerelease_date()
RETURNS TRIGGER AS $$
BEGIN
    -- RULE 1: prerelease must be future
    IF NEW.isPrerelease = TRUE
       AND NEW.collection_release_date <= CURRENT_DATE THEN
        RAISE EXCEPTION
            'If isPrerelease = TRUE, then release_date (%s) must be in the future.',
            NEW.collection_release_date;
    END IF;

    -- RULE 2: NOT prerelease must be today or past
    IF NEW.isPrerelease = FALSE
       AND NEW.collection_release_date > CURRENT_DATE THEN
        RAISE EXCEPTION
            'If isPrerelease = FALSE, release_date (%s) cannot be in the future.',
            NEW.collection_release_date;
    END IF;

    -- RULE 3: If release date is today → force prerelease = FALSE
    IF NEW.collection_release_date = CURRENT_DATE THEN
        NEW.isPrerelease := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_prerelease_date
BEFORE INSERT OR UPDATE ON collections
FOR EACH ROW
EXECUTE FUNCTION validate_prerelease_date();
