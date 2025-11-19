
-- cek users
INSERT INTO USERS(username, user_email)
VALUES ('virli', 'virli@example.com');

      -- asjbf
      SELECT * FROM USERS;

      -- abadf
      SELECT conname, convalidated
      FROM pg_constraint
      WHERE convalidated = false;

      -- sabhdv
      INSERT INTO users(username, user_email)
      VALUES ('tes_sequence', 'test@example.com');

      SELECT * FROM users ORDER BY user_id DESC LIMIT 1;

      SELECT * FROM USERS;

      -- asjbd
      INSERT INTO users(username, user_email)
      VALUES ('nurahma', 'rahma@example.com');

      SELECT * FROM users ORDER BY user_id DESC LIMIT 1;

      SELECT * FROM USERS;

      -- asbdad
      INSERT INTO users(username, user_email)
      VALUES ('arkan', 'arkan@example.com');

      SELECT * FROM USERS;

      -- cek tours
      INSERT INTO tours(tour_name)
      VALUES ('Test Tour');

      SELECT * FROM tours ORDER BY tour_id DESC LIMIT 1;

      SELECT * FROM tours;

      --nsajk
      INSERT INTO tours(tour_name)
      VALUES ('tanak');

      SELECT * FROM tours;

      -- cek artists
      INSERT INTO artists(artist_name)
      VALUES ('Artist Test');

      SELECT * FROM artists ORDER BY artist_id DESC LIMIT 1;

      SELECT * FROM artists;

      INSERT INTO artists(artist_name)
      VALUES ('IKON');

      SELECT * FROM artists;

      -- cek song
      INSERT INTO songs(song_title)
      VALUES ('Song Test');

      SELECT * FROM songs ORDER BY song_id DESC LIMIT 1;

      INSERT INTO songs(song_title)
      VALUES ('Songing');
      SELECT * FROM songs ORDER BY song_id DESC LIMIT 1;
      SELECT * FROM songs;

      -- cek playlist
      INSERT INTO playlists(user_id, playlist_title)
      VALUES (1, 'Playlist Test');

      SELECT * FROM playlists ORDER BY playlist_id DESC LIMIT 1;

      INSERT INTO playlists(user_id, playlist_title)
      VALUES (1, 'Playlist 2');

      INSERT INTO playlists(user_id, playlist_title)
      VALUES (1, 'Playlist 3');

      SELECT * FROM playlists;

      -- cek genre
      INSERT INTO genres(genre_name)
      VALUES ('Genre Test');

      SELECT * FROM genres ORDER BY genre_id DESC LIMIT 1;

      INSERT INTO genres(genre_name)
      VALUES ('Genre 2');

      SELECT * FROM genres;

      -- cek collections
      INSERT INTO collections(collection_title)
      VALUES ('Collection Test');

      INSERT INTO collections(collection_title)
      VALUES ('Collection 2');

      SELECT * FROM collections ORDER BY collection_id DESC LIMIT 1;
      SELECT * FROM collections;

      -- cek reviews
      INSERT INTO reviews(user_id,collection_id, review)
      VALUES (1, 1, 'Review Test');

      INSERT INTO reviews(user_id,collection_id, review)
      VALUES (1, 1, 'Review Test 2');

      SELECT * FROM reviews ORDER BY review_id DESC LIMIT 1;
      SELECT * FROM reviews;
