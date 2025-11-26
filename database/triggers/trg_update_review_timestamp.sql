-- FUNCTION untuk update timestamp saat review/rating berubah
CREATE OR REPLACE FUNCTION update_review_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika kolom review atau rating berubah
    IF NEW.review IS DISTINCT FROM OLD.review
       OR NEW.rating IS DISTINCT FROM OLD.rating THEN

        NEW."TIMESTAMP" = CURRENT_TIMESTAMP;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER
CREATE TRIGGER trg_update_review_timestamp
BEFORE UPDATE
ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_timestamp();

-- -- cek
-- -- tabel review
-- SELECT * FROM reviews;

-- -- update review timestamp
-- UPDATE reviews
-- SET review = 'Review baru test trigger'
-- WHERE review_id = 1;

-- -- update rating timestamp
-- UPDATE reviews
-- SET rating = rating + 1
-- WHERE review_id = 1;
