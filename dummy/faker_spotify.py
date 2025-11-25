import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from faker import Faker
import random
import os
from dotenv import load_dotenv 


load_dotenv()

# --- KONFIGURASI ---
CLIENT_ID = os.getenv("SPOTIFY_CLIENT_ID")
CLIENT_SECRET = os.getenv("SPOTIFY_CLIENT_SECRET")
OUTPUT_FILE = "../database/02_dml_spotify_random.sql"
TOTAL_SONGS_WANTED = 50

# --- INIT ---
sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET))
fake = Faker("id_ID")

def escape_sql(text):
    if text is None: return "NULL"
    # Potong text jika kepanjangan sesuai limit VARCHAR DDL
    text_str = str(text).replace("'", "''")
    return "'" + text_str + "'"

def get_safe_date(date_str):
    if not date_str: return "2020-01-01"
    parts = date_str.split("-")
    if len(parts) == 1: return f"{parts[0]}-01-01"
    if len(parts) == 2: return f"{parts[0]}-{parts[1]}-01"
    return date_str

def map_collection_type(spotify_type):
    # Mapping agar sesuai CONSTRAINT CHECK (Album, EP, Single, Compilation)
    st = spotify_type.lower()
    if 'album' in st: return 'Album'
    if 'single' in st: return 'Single'
    if 'compilation' in st: return 'Compilation'
    return 'Compilation' # Default aman untuk 'appears_on' dll

def generate_data_safe():
    sql_statements = []
    
    # --- PENTING: BEGIN DIMATIKAN DULU UTK DEBUGGING ---
    # Jika script ini sukses 100%, baru uncomment baris di bawah ini manual di file SQL nya
    sql_statements.append("-- BEGIN;  <-- Aktifkan manual jika sudah yakin tidak error") 
    
    # CLEANUP DATA LAMA (Opsional, hati-hati pakai ini)
    sql_statements.append("TRUNCATE TABLE USERS, ARTISTS, GENRES, COLLECTIONS, SONGS, PLAYLISTS, RELEASES, COLLECTIONS_SONGS, CREATE_SONGS, SONGS_GENRES RESTART IDENTITY CASCADE;")

    print("🔎 Mencari lagu random...")
    collected_tracks = []
    
    # Loop cari lagu sampai target tercapai
    while len(collected_tracks) < TOTAL_SONGS_WANTED:
        search_char = random.choice(['a', 'e', 'i', 'o', 'u', 'love', 'the'])
        offset_val = random.randint(0, 500)
        try:
            results = sp.search(q=search_char, type='track', limit=20, offset=offset_val)
            items = results['tracks']['items']
            if items: collected_tracks.extend(items)
        except:
            continue
            
    collected_tracks = collected_tracks[:TOTAL_SONGS_WANTED]
    
    # Cache ID
    artist_map = {} 
    album_map = {}
    genre_map = {}
    
    # Counter ID Manual (Untuk foreign key di script)
    # Nanti sequence DB di-update di akhir
    ids = {'users': 1, 'artists': 1, 'genres': 1, 'collections': 1, 'songs': 1}

    # 1. USERS
    print("Generating Users...")
    for _ in range(10):
        u_name = fake.user_name()
        email = f"{u_name}_{ids['users']}@example.com" # Format safe for regex
        # Insert user tanpa ID (biar sequence jalan) tapi kita butuh ID buat referensi playlist?
        # Sesuai DDL, USER_ID default nextval. Kita inject manual aja biar sinkron sama variabel python
        sql = f"INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH) VALUES ({ids['users']}, {escape_sql(u_name)}, {escape_sql(email)}, 'password123safe');"
        sql_statements.append(sql)
        ids['users'] += 1

    # 2. PROSES LAGU
    print("Processing Songs...")
    for track in collected_tracks:
        if not track: continue

        # --- ARTIST ---
        sp_artist = track['artists'][0]
        sp_artist_id = sp_artist['id']
        db_artist_id = artist_map.get(sp_artist_id)
        
        if not db_artist_id:
            try:
                full_artist = sp.artist(sp_artist_id)
            except: continue
            
            db_artist_id = ids['artists']
            artist_map[sp_artist_id] = db_artist_id
            
            name = full_artist['name'][:250] # Truncate jaga2
            pfp = full_artist['images'][0]['url'] if full_artist['images'] else ''
            # Email fake artist
            art_email = f"artist{db_artist_id}@label.com"
            
            sql = f"INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES ({db_artist_id}, {escape_sql(name)}, {escape_sql(pfp)}, {full_artist['followers']['total']}, {escape_sql(art_email)}) ON CONFLICT DO NOTHING;"
            sql_statements.append(sql)
            ids['artists'] += 1
            
            # Genre
            for g_name in full_artist['genres']:
                if g_name not in genre_map:
                    g_id = ids['genres']
                    genre_map[g_name] = g_id
                    sql_g = f"INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES ({g_id}, {escape_sql(g_name)}) ON CONFLICT DO NOTHING;"
                    sql_statements.append(sql_g)
                    ids['genres'] += 1

        # --- ALBUM / COLLECTION ---
        sp_album = track['album']
        sp_album_id = sp_album['id']
        db_album_id = album_map.get(sp_album_id)
        
        if not db_album_id:
            db_album_id = ids['collections']
            album_map[sp_album_id] = db_album_id
            
            title = sp_album['name'][:250]
            # Mapping Type agar lolos CONSTRAINT CHECK
            c_type = map_collection_type(sp_album['album_type'])
            date = get_safe_date(sp_album['release_date'])
            cover = sp_album['images'][0]['url'] if sp_album['images'] else ''
            
            sql = f"INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER) VALUES ({db_album_id}, {escape_sql(title)}, {escape_sql(c_type)}, {escape_sql(date)}, {escape_sql(cover)}) ON CONFLICT DO NOTHING;"
            sql_statements.append(sql)
            
            # Releases
            sql_rel = f"INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES ({db_artist_id}, {db_album_id}) ON CONFLICT DO NOTHING;"
            sql_statements.append(sql_rel)
            ids['collections'] += 1

        # --- SONG ---
        db_song_id = ids['songs']
        title = track['name'][:250]
        
        # FIX DURATION: Minimal 1 detik agar lolos CHECK(DURATION > 0)
        duration = int(track['duration_ms'] / 1000)
        if duration < 1: duration = 1
            
        file_path = track['preview_url'] if track['preview_url'] else '/default.mp3'
        pop = track['popularity']
        date = get_safe_date(track['album']['release_date'])
        
        # METRICS RANDOM (0.0 - 1.0)
        val = round(random.random(), 3)
        acoust = round(random.random(), 3)
        dance = round(random.random(), 3)
        energy = round(random.random(), 3)
        
        sql = f"""INSERT INTO SONGS 
        (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, 
         VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE) 
        VALUES 
        ({db_song_id}, {escape_sql(title)}, {duration}, {escape_sql(file_path)}, {pop}, 
         {val}, {acoust}, {dance}, {energy}, {escape_sql(date)}) ON CONFLICT DO NOTHING;"""
        sql_statements.append(sql)
        
        # RELASI SONG
        disc = track['disc_number']
        tr_no = track['track_number']
        sql_cs = f"INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES ({db_album_id}, {db_song_id}, {disc}, {tr_no}) ON CONFLICT DO NOTHING;"
        sql_statements.append(sql_cs)
        
        sql_cr = f"INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES ({db_artist_id}, {db_song_id}) ON CONFLICT DO NOTHING;"
        sql_statements.append(sql_cr)
        
        ids['songs'] += 1

    # --- 3. RESET SEQUENCES (WAJIB) ---
    # Karena kita insert manual ID, sequence DB harus dimajukan agar next insert gak duplicate
    seq_tables = ['USERS', 'ARTISTS', 'GENRES', 'COLLECTIONS', 'SONGS', 'REVIEWS', 'PLAYLISTS']
    for t in seq_tables:
        # Syntax postgres untuk sync sequence
        sql = f"SELECT setval('seq_{t.lower()}_id', (SELECT MAX({t[:-1]}_ID) FROM {t}));"
        sql_statements.append(sql)

    sql_statements.append("-- COMMIT; <-- Uncomment jika sudah oke")
    
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("\n".join(sql_statements))
    
    print(f"Selesai! File '{OUTPUT_FILE}' siap dijalankan.")

if __name__ == "__main__":
    generate_data_safe()