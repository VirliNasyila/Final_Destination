-- Update_collection_top3_genres
CREATE OR REPLACE FUNCTION update_collection_top3_genres()
RETURNS TRIGGER AS $$
DECLARE
    top_genre RECORD; -- Variabel RECORD untuk menampung hasil looping genre teratas
BEGIN
    -- Hapus data lama untuk collection ini (supaya bisa di isi ulang dari nol  )
    DELETE FROM collection_top_3_genres
    WHERE collection_id = NEW.collection_id;  -- Hanya untuk collection yang sama dengan row yang baru diubah/ditambah


    -- Ambil 3 genre paling sering muncul dari lagu-lagu collection
    FOR top_genre IN
        SELECT sg.genre_id  -- Mengambil genre_id
        FROM songs_genres sg  
        JOIN collections_songs cs ON sg.song_id = cs.song_id  -- Menghubungkan genre ke lagu dalam sebuah collection
        WHERE cs.collection_id = NEW.collection_id  -- Filter berdasarkan collection yang sedang di-update
        GROUP BY sg.genre_id  -- Mengelompokkan berdasarkan genre
        ORDER BY COUNT(*) DESC  -- Urutkan berdasarkan jumlah kemunculan genre terbanyak
        LIMIT 3  -- Ambil hanya 3 genre teratas
    LOOP
        -- Insert ke COLLECTION_TOP_3_GENRES
        INSERT INTO collection_top_3_genres (collection_id, genre_id)  -- Tambahkan satu per satu genre ke tabel top 3
        VALUES (NEW.collection_id, top_genre.genre_id);   -- Mengisi collection_id dan genre_id hasil loop
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- trigger
CREATE TRIGGER trg_update_collection_top3_genres
AFTER INSERT OR UPDATE ON collections_songs
FOR EACH ROW
EXECUTE FUNCTION update_collection_top3_genres();


SELECT * FROM collections_songs;
-- -- cek
-- -- Update supaya trigger jalan
UPDATE collections_songs
SET nomor_track = nomor_track
WHERE collection_id = 1;

UPDATE collections_songs
SET nomor_track = nomor_track
WHERE collection_id = 2;

-- -- Lihat hasil top 3 genre
SELECT * FROM collection_top_3_genres
WHERE collection_id = 1;


select * from collections_songs where collection_id = 1
SELECT * FROM collection_top_3_genres
WHERE collection_id = 2;

SELECT * FROM collection_top_3_genres;

-- insert 
INSERT INTO collections_songs (collection_id, song_id, nomor_disc, nomor_track) 
VALUES(1, 16, 1, 99);

SELECT * FROM genres
SELECT * FROM songs_genres
select * from genres
