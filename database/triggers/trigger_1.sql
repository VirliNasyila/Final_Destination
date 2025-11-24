-- Trigger review collection, akan mengubah collection_rating
CREATE OR REPLACE FUNCTION update_collection_rating()
RETURNS TRIGGER AS $$
DECLARE
    v_new_rating NUMERIC(5,2);
BEGIN
    -- Hitung ulang rating dari seluruh review untuk collection 
    SELECT AVG(rating)
    INTO v_new_rating
    FROM reviews
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    -- Update ke tabel collections
    UPDATE collections
    SET collection_rating = v_new_rating
    WHERE collection_id = COALESCE(NEW.collection_id, OLD.collection_id);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;




