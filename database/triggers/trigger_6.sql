

-- TRIGGER
CREATE TRIGGER trg_update_review_timestamp
BEFORE UPDATE
ON reviews
FOR EACH ROW
EXECUTE FUNCTION update_review_timestamp();

-- cek
-- tabel review
SELECT * FROM reviews;

-- update review timestamp
UPDATE reviews
SET review = 'Review baru test trigger'
WHERE review_id = 1;

-- update rating timestamp
UPDATE reviews
SET rating = rating + 1
WHERE review_id = 1;



-- FUNCTION: otomatis matikan prerelease saat tanggal rilis tiba
CREATE OR REPLACE FUNCTION prerelease_check_logic()
RETURNS TRIGGER AS $$
BEGIN
    -- Jika ini prerelease dan hari ini sudah sama dengan tanggal rilis
    IF NEW.isPrerelease = TRUE
       AND CURRENT_DATE = NEW.collection_release_date THEN
        
        NEW.isPrerelease := FALSE; 
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;