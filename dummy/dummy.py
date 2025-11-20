import random
from datetime import datetime, timedelta

from faker import Faker

# Inisialisasi Faker
fake = Faker("id_ID")  # Pakai locale Indonesia
Faker.seed(42)  # Agar hasil randomnya konsisten tiap di-run

NUM_USERS = 50
NUM_ARTISTS = 20
NUM_GENRES = 10
NUM_COLLECTIONS = 40
NUM_SONGS = 150
NUM_PLAYLISTS = 30

OUTPUT_FILE = "../database/02_dml_seed.sql"


def escape_sql(text):
    """Mencegah error SQL jika ada tanda kutip satu (')"""
    if text is None:
        return "NULL"
    return "'" + str(text).replace("'", "''") + "'"


def generate_data():
    sql_statements = []
    sql_statements.append("/* --- GENERATED SEED DATA --- */")
    sql_statements.append("BEGIN;")  # Mulai Transaksi

    print("Generasi data dimulai...")

    # --- 1. USERS ---
    user_ids = []
    print(f"Membuat {NUM_USERS} Users...")
    for i in range(1, NUM_USERS + 1):
        username = fake.user_name()
        email = f"{username}_{i}@example.com"  # Unik
        pw_hash = fake.sha256()  # Panjang hash aman (>8 char)
        pfp = f"/uploads/users/{username}.jpg"

        sql = f"INSERT INTO USERS (USERNAME, USER_EMAIL, PW_HASH, USER_PFP) VALUES ({escape_sql(username)}, {escape_sql(email)}, {escape_sql(pw_hash)}, {escape_sql(pfp)});"
        sql_statements.append(sql)
        user_ids.append(i)

    # --- 2. ARTISTS ---
    artist_ids = []
    print(f"Membuat {NUM_ARTISTS} Artists...")
    for i in range(1, NUM_ARTISTS + 1):
        name = fake.name()
        bio = fake.text(max_nb_chars=200)
        pfp = f"/uploads/artists/artist_{i}.jpg"

        email = f"{name}_{i}@example.com"  # Unik
        sql = f"INSERT INTO ARTISTS (ARTIST_NAME, BIO, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES ({escape_sql(name)}, {escape_sql(bio)}, {escape_sql(pfp)}, {random.randint(0, 1000000)}, {escape_sql(email)});"
        sql_statements.append(sql)
        artist_ids.append(i)

    # --- 3. GENRES ---
    genre_ids = []
    genres_list = [
        "Pop",
        "Rock",
        "Jazz",
        "Dangdut",
        "Indie",
        "Hip Hop",
        "R&B",
        "Electronic",
        "Classical",
        "Metal",
    ]
    print("Membuat Genres...")
    for i, g_name in enumerate(genres_list, 1):
        sql = f"INSERT INTO GENRES (GENRE_NAME) VALUES ({escape_sql(g_name)});"
        sql_statements.append(sql)
        genre_ids.append(i)

    # --- 4. COLLECTIONS (ALBUMS) ---
    collection_ids = []
    print(f"Membuat {NUM_COLLECTIONS} Collections...")
    coll_types = ["Album", "EP", "Single", "Compilation"]

    # Kita butuh mapping siapa pemilik album ini untuk tabel RELEASES nanti
    collection_owners = {}

    for i in range(1, NUM_COLLECTIONS + 1):
        title = fake.sentence(nb_words=3).replace(".", "")
        ctype = random.choice(coll_types)
        date = fake.date_between(start_date="-5y", end_date="today")
        cover = f"/uploads/covers/coll_{i}.jpg"

        sql = f"INSERT INTO COLLECTIONS (COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER) VALUES ({escape_sql(title)}, {escape_sql(ctype)}, {escape_sql(date)}, {escape_sql(cover)});"
        sql_statements.append(sql)
        collection_ids.append(i)

        # Assign random artist as owner
        owner_id = random.choice(artist_ids)
        collection_owners[i] = owner_id

        # Isi tabel RELEASES (Artist merilis Collection)
        sql_rel = (
            f"INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES ({owner_id}, {i});"
        )
        sql_statements.append(sql_rel)

    # --- 5. SONGS ---
    song_ids = []
    print(f"Membuat {NUM_SONGS} Songs...")
    for i in range(1, NUM_SONGS + 1):
        title = fake.sentence(nb_words=4).replace(".", "")
        duration = random.randint(120, 300)  # detik
        file_path = f"/uploads/audio/song_{i}.mp3"

        # Metrics (0.0 - 1.0)
        valence = round(random.random(), 2)
        energy = round(random.random(), 2)
        dance = round(random.random(), 2)
        acoustic = round(random.random(), 2)
        popularity = random.randint(0, 100)
        release_date = fake.date_between(start_date="-20y", end_date="today")
        sql = f"INSERT INTO SONGS (SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ENERGY, DANCEABILITY, ACCOUSTICNESS, SONG_RELEASE_DATE) VALUES ({escape_sql(title)}, {duration}, {escape_sql(file_path)}, {popularity}, {valence}, {energy}, {dance}, {acoustic}, {escape_sql(release_date)});"
        sql_statements.append(sql)
        song_ids.append(i)

        # Link Song to Genre (SONGS_GENRES)
        g_id = random.choice(genre_ids)
        sql_sg = f"INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES ({i}, {g_id});"
        sql_statements.append(sql_sg)

    # --- 6. LINKING SONGS TO COLLECTIONS & ARTISTS ---
    print("Menghubungkan Lagu ke Album & Artis...")

    # Bagi lagu ke dalam collection secara merata
    # songs_per_coll = NUM_SONGS // NUM_COLLECTIONS
    current_song_idx = 0

    for c_id in collection_ids:
        # Tentukan berapa lagu di album ini (random dikit)
        num_tracks = random.randint(1, 12)
        disc_num = 1

        owner_artist = collection_owners[c_id]

        for track_num in range(1, num_tracks + 1):
            if current_song_idx >= len(song_ids):
                break

            s_id = song_ids[current_song_idx]

            # Masukkan ke COLLECTIONS_SONGS
            sql_cs = f"INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES ({c_id}, {s_id}, {disc_num}, {track_num});"
            sql_statements.append(sql_cs)

            # Masukkan ke CREATE_SONGS (Artist creates Song)
            # Artisnya harus sama dengan pemilik Album biar logis
            sql_cr = f"INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES ({owner_artist}, {s_id});"
            sql_statements.append(sql_cr)

            current_song_idx += 1

    # --- 7. PLAYLISTS ---
    playlist_ids = []
    playlist_titles = []
    playlist_owners = []
    print(f"Membuat {NUM_PLAYLISTS} Playlists...")
    for i in range(1, NUM_PLAYLISTS + 1):
        u_id = random.choice(user_ids)
        title = f"Playlist {fake.word()} {fake.color_name()}"
        is_collaborative = random.choice(["TRUE", "FALSE"])
        is_public = random.choice(["TRUE", "FALSE"])
        if is_collaborative:
            title += f" collab"
            is_public = "TRUE"
        is_onprofile = random.choice(["TRUE", "FALSE"])
        desc = "Playlist asik buat coding"

        created_date = fake.date_between(start_date="-7y", end_date="today")
        sql = f"INSERT INTO PLAYLISTS (USER_ID, PLAYLIST_TITLE, PLAYLIST_DESC, ISPUBLIC, ISONPROFILE, ISCOLLABORATIVE, PLAYLIST_DATE_CREATED) VALUES ({u_id}, {escape_sql(title)}, {escape_sql(desc)}, {is_public}, {is_onprofile}, {is_collaborative}, {escape_sql(created_date)});"
        sql_statements.append(sql)
        playlist_ids.append(i)
        playlist_titles.append(title)
        playlist_owners.append(u_id)

    # --- 8. INTERAKSI (ADD SONGS, LIKE, FOLLOW) ---
    print("Membuat Interaksi User...")

    # Add Songs to Playlist (ADD_SONGS_PLAYLISTS) - TERNARY RELATIONSHIP
    # Penting: User penambah harus Owner atau Collaborator.
    # Untuk simpelnya, kita anggap Owner yang nambahin.
    for p_id in playlist_ids:
        # Cari owner playlist ini (query logic simulasi)
        # Di sini kita random aja ambil user, asumsikan dia ownernya
        # (Idealnya kita track owner playlist di variable python di atas)

        # Ambil 5 lagu random
        random_songs = random.sample(song_ids, 5)
        for idx, s_id in enumerate(random_songs, 1):
            # Kita butuh user_id owner playlist sebenernya, tapi kita random user aja
            # Asumsi: constraint di DB tidak ngecek 'is_owner' di level insert data dummy
            if "collab" in playlist_titles[p_id - 1]:
                u_id = random.choice(user_ids)
            else:
                u_id = playlist_owners[p_id - 1]
            ts = fake.date_time_between(start_date="-2M", end_date="now")
            sql = f'INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, USER_ID, NO_URUT, "TIMESTAMP") VALUES ({p_id}, {s_id}, {u_id}, {idx}, {escape_sql(ts)});'
            sql_statements.append(sql)

    # Follow Artists
    for u_id in user_ids:
        # User follow 3 artis random
        targets = random.sample(artist_ids, 4)
        for a_id in targets:
            ts = fake.date_time_between(start_date="-6y", end_date="now")
            sql = f'INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID, "TIMESTAMP") VALUES ({u_id}, {a_id}, {escape_sql(ts)});'
            sql_statements.append(sql)

    # Listening History
    for u_id in user_ids:
        # User dengar 10 lagu random
        targets = random.sample(song_ids, 15)
        for s_id in targets:
            ts = fake.date_time_between(start_date="-1M", end_date="now")
            duration = random.randint(1, random.randint(300, 600))
            sql = f'INSERT INTO LISTENS (USER_ID, SONG_ID, "TIMESTAMP", DURATION_LISTENED) VALUES ({u_id}, {s_id}, {escape_sql(ts)}, {duration});'
            sql_statements.append(sql)

    sql_statements.append("COMMIT;")

    # Write to file
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_statements))

    print(f"Selesai! File '{OUTPUT_FILE}' berhasil dibuat.")


if __name__ == "__main__":
    generate_data()
