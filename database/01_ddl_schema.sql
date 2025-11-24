    
    /*==============================================================*/
    /* DBMS name:      PostgreSQL 9.x                               */
    /* Created on:     11/19/2025 8:39:55 PM                        */
    /*==============================================================*/
    begin;
    
    drop index if exists ADD_SONGS_PLAYLISTS_PK;
    
    drop index if exists MENAMBAHKAN_LAGU_FK;
    
    drop index if exists MENAMBAHKAN_KE_PLAYLIST_FK;
    
    drop index if exists USER_MENAMBAHKAN_FK;
    
    drop table if exists ADD_SONGS_PLAYLISTS;
    
    drop index if exists ARTISTS_PK;
    
    drop table if exists ARTISTS;
    
    drop index if exists MEMILIKI3_FK;
    
    drop index if exists MEMILIKI2_FK;
    
    drop index if exists ARTISTS_TOURS_PK;
    
    drop table if exists ARTISTS_TOURS;
    
    drop index if exists ARTIST_PROMOTION_PK;
    
    drop index if exists MEMPROMOSIKAN_FK;
    
    drop index if exists MEMPROMOSIKAN2_FK;
    
    drop table if exists ARTIST_PROMOTION;
    
    drop index if exists MEM_BLACKLIST_FK;
    
    drop index if exists MEM_BLACKLIST2_FK;
    
    drop index if exists BLOCKLIST_ARTISTS_PK;
    
    drop table if exists BLOCKLIST_ARTISTS;
    
    drop index if exists MEM_BLOCK_FK;
    
    drop index if exists MEM_BLOCK2_FK;
    
    drop index if exists BLOCK_USERS_PK;
    
    drop table if exists BLOCK_USERS;
    
    drop index if exists COLLECTIONS_PK;
    
    drop table if exists COLLECTIONS;
    
    drop index if exists MEMILIKI_FK;
    
    drop index if exists MEMILIKI4_FK;
    
    drop index if exists COLLECTIONS_SONGS_PK;
    
    drop table if exists COLLECTIONS_SONGS;
    
    drop index if exists RELATIONSHIP_41_FK;
    
    drop index if exists RELATIONSHIP_40_FK;
    
    drop index if exists COLLECTION_LIBRARY_PK;
    
    drop table if exists COLLECTION_LIBRARY;
    
    drop index if exists TOP_3_GENRE_FK;
    
    drop index if exists TOP_3_GENRE2_FK;
    
    drop index if exists COLLECTION_TOP_3_GENRES_PK;
    
    drop table if exists COLLECTION_TOP_3_GENRES;
    
    drop index if exists MEMBUAT_FK;
    
    drop index if exists MEMBUAT2_FK;
    
    drop index if exists CREATE_PLAYLISTS_PK;
    
    drop table if exists CREATE_SONGS;
    
    drop index if exists MENGIKUTI_FK;
    
    drop index if exists MENGIKUTI4_FK;
    
    drop index if exists FOLLOW_ARTISTS_PK;
    
    drop table if exists FOLLOW_ARTISTS;
    
    drop index if exists MENGIKUTI3_FK;
    
    drop index if exists MENGIKUTI2_FK;
    
    drop index if exists FOLLOW_USERS_PK;
    
    drop table if exists FOLLOW_USERS;
    
    drop index if exists GENRES_PK;
    
    drop table if exists GENRES;
    
    drop index if exists LIKE_REVIEW_FK;
    
    drop index if exists LIKE_REVIEW2_FK;
    
    drop index if exists LIKE_REVIEWS_PK;
    
    drop table if exists LIKE_REVIEWS;
    
    drop index if exists MENYUKAI_FK;
    
    drop index if exists MENYUKAI2_FK;
    
    drop index if exists LIKE_SONGS_PK;
    
    drop table if exists LIKE_SONGS;
    
    drop index if exists LISTENS_PK;
    
    drop index if exists MENDENGARKAN_FK;
    
    drop index if exists MENDENGARKAN2_FK;
    
    drop table if exists LISTENS;
    
    drop index if exists MEMBUAT_PLAYLIST_FK;
    
    drop index if exists PLAYLISTS_PK;
    
    drop table if exists PLAYLISTS;
    
    drop index if exists RELATIONSHIP_39_FK;
    
    drop index if exists RELATIONSHIP_38_FK;
    
    drop index if exists PL_LIBRARY_PK;
    
    drop table if exists PL_LIBRARY;
    
    drop index if exists RATE_FK;
    
    drop index if exists RATE2_FK;
    
    drop index if exists RATE_SONGS_PK;
    
    drop table if exists RATE_SONGS;
    
    drop index if exists MERILIS_FK;
    
    drop index if exists MERILIS2_FK;
    
    drop index if exists RELEASES_PK;
    
    drop table if exists RELEASES;
    
    drop index if exists COLLECTION_MANA_FK;
    
    drop index if exists MEMBUAT_REVIEW_FK;
    
    drop index if exists REVIEWS_PK;
    
    drop table if exists REVIEWS;
    
    drop index if exists HAS_FK;
    
    drop index if exists SOCIALS_PK;
    
    drop table if exists SOCIALS;
    
    drop index if exists SONGS_PK;
    
    drop table if exists SONGS;
    
    drop index if exists MEMPUNYAI_FK;
    
    drop index if exists MEMPUNYAI2_FK;
    
    drop index if exists SONGS_GENRES_PK;
    
    drop table if exists SONGS_GENRES;
    
    drop index if exists TOURS_PK;
    
    drop table if exists TOURS;
    
    drop index if exists USERS_PK;
    
    drop table if exists USERS;
    
    /*==============================================================*/
    /* Table: ADD_SONGS_PLAYLISTS                                   */
    /*==============================================================*/
    create table ADD_SONGS_PLAYLISTS (
    ADD_SONG_PL_ID       INT4                 not null,
    USER_ID              INT4                 not null,
    PLAYLIST_ID          INT4                 not null,
    SONG_ID              INT4                 not null,
    NO_URUT              INT4                 not null,
    "TIMESTAMP"          TIMESTAMP                 not null default current_timestamp,
    constraint PK_ADD_SONGS_PLAYLISTS primary key (ADD_SONG_PL_ID)
    );
    
    /*==============================================================*/
    /* Index: USER_MENAMBAHKAN_FK                                   */
    /*==============================================================*/
    create  index USER_MENAMBAHKAN_FK on ADD_SONGS_PLAYLISTS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MENAMBAHKAN_KE_PLAYLIST_FK                            */
    /*==============================================================*/
    create  index MENAMBAHKAN_KE_PLAYLIST_FK on ADD_SONGS_PLAYLISTS (
    PLAYLIST_ID
    );
    
    /*==============================================================*/
    /* Index: MENAMBAHKAN_LAGU_FK                                   */
    /*==============================================================*/
    create  index MENAMBAHKAN_LAGU_FK on ADD_SONGS_PLAYLISTS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: ADD_SONGS_PLAYLISTS_PK                                */
    /*==============================================================*/
    create unique index ADD_SONGS_PLAYLISTS_PK on ADD_SONGS_PLAYLISTS (
    ADD_SONG_PL_ID
    );
    
    /*==============================================================*/
    /* Table: ARTISTS                                               */
    /*==============================================================*/
    create table ARTISTS (
    ARTIST_ID            INT4                 not null,
    ARTIST_NAME          VARCHAR(255)         not null,
    BIO                  TEXT                 null,
    MONTHLY_LISTENER_COUNT INT8                 null default 0,
    ARTIST_PFP           VARCHAR(2048)        null,
    ARTIST_EMAIL         VARCHAR(320)         not null,
    BANNER               VARCHAR(2048)        null,
    FOLLOWER_COUNT       INT8                 null default 0,
    constraint PK_ARTISTS primary key (ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: ARTISTS_PK                                            */
    /*==============================================================*/
    create unique index ARTISTS_PK on ARTISTS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Table: ARTISTS_TOURS                                         */
    /*==============================================================*/
    create table ARTISTS_TOURS (
    TOUR_ID              INT4                 not null,
    ARTIST_ID            INT4                 not null,
    constraint PK_ARTISTS_TOURS primary key (TOUR_ID, ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: ARTISTS_TOURS_PK                                      */
    /*==============================================================*/
    create unique index ARTISTS_TOURS_PK on ARTISTS_TOURS (
    TOUR_ID,
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMILIKI2_FK                                          */
    /*==============================================================*/
    create  index MEMILIKI2_FK on ARTISTS_TOURS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMILIKI3_FK                                          */
    /*==============================================================*/
    create  index MEMILIKI3_FK on ARTISTS_TOURS (
    TOUR_ID
    );
    
    /*==============================================================*/
    /* Table: ARTIST_PROMOTION                                      */
    /*==============================================================*/
    create table ARTIST_PROMOTION (
    ARTIST_ID            INT4                 not null,
    COLLECTION_ID        INT4                 not null,
    KOMENTAR_PROMOSI     TEXT                 null,
    constraint PK_ARTIST_PROMOTION primary key (ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: MEMPROMOSIKAN2_FK                                     */
    /*==============================================================*/
    create  index MEMPROMOSIKAN2_FK on ARTIST_PROMOTION (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMPROMOSIKAN_FK                                      */
    /*==============================================================*/
    create  index MEMPROMOSIKAN_FK on ARTIST_PROMOTION (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Index: ARTIST_PROMOTION_PK                                   */
    /*==============================================================*/
    create unique index ARTIST_PROMOTION_PK on ARTIST_PROMOTION (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Table: BLOCKLIST_ARTISTS                                     */
    /*==============================================================*/
    create table BLOCKLIST_ARTISTS (
    ARTIST_ID            INT4                 not null,
    USER_ID              INT4                 not null,
    constraint PK_BLOCKLIST_ARTISTS primary key (ARTIST_ID, USER_ID)
    );
    
    /*==============================================================*/
    /* Index: BLOCKLIST_ARTISTS_PK                                  */
    /*==============================================================*/
    create unique index BLOCKLIST_ARTISTS_PK on BLOCKLIST_ARTISTS (
    ARTIST_ID,
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MEM_BLACKLIST2_FK                                     */
    /*==============================================================*/
    create  index MEM_BLACKLIST2_FK on BLOCKLIST_ARTISTS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MEM_BLACKLIST_FK                                      */
    /*==============================================================*/
    create  index MEM_BLACKLIST_FK on BLOCKLIST_ARTISTS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Table: BLOCK_USERS                                           */
    /*==============================================================*/
    create table BLOCK_USERS (
    BLOCKER_ID           INT4                 not null,
    BLOCKED_ID           INT4                 not null,
    constraint PK_BLOCK_USERS primary key (BLOCKER_ID, BLOCKED_ID)
    );
    
    /*==============================================================*/
    /* Index: BLOCK_USERS_PK                                        */
    /*==============================================================*/
    create unique index BLOCK_USERS_PK on BLOCK_USERS (
    BLOCKER_ID,
    BLOCKED_ID
    );
    
    /*==============================================================*/
    /* Index: MEM_BLOCK2_FK                                         */
    /*==============================================================*/
    create  index MEM_BLOCK2_FK on BLOCK_USERS (
    BLOCKED_ID
    );
    
    /*==============================================================*/
    /* Index: MEM_BLOCK_FK                                          */
    /*==============================================================*/
    create  index MEM_BLOCK_FK on BLOCK_USERS (
    BLOCKER_ID
    );
    
    /*==============================================================*/
    /* Table: COLLECTIONS                                           */
    /*==============================================================*/
    create table COLLECTIONS (
    COLLECTION_ID        INT4                 not null,
    COLLECTION_TITLE     VARCHAR(255)         not null,
    COLLECTION_TYPE      VARCHAR(50)          not null,
    COLLECTION_COVER     VARCHAR(2048)        null,
    COLLECTION_RELEASE_DATE DATE                 not null,
    COLLECTION_RATING    NUMERIC(3,0)         null,
    ISPRERELEASE         BOOL                 null,
    constraint PK_COLLECTIONS primary key (COLLECTION_ID)
    );
    
    /*==============================================================*/
    /* Index: COLLECTIONS_PK                                        */
    /*==============================================================*/
    create unique index COLLECTIONS_PK on COLLECTIONS (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: COLLECTIONS_SONGS                                     */
    /*==============================================================*/
    create table COLLECTIONS_SONGS (
    SONG_ID              INT4                 not null,
    COLLECTION_ID        INT4                 not null,
    NOMOR_DISC           INT4                 not null,
    NOMOR_TRACK          INT4                 not null,
    constraint PK_COLLECTIONS_SONGS primary key (SONG_ID, COLLECTION_ID)
    );
    
    /*==============================================================*/
    /* Index: COLLECTIONS_SONGS_PK                                  */
    /*==============================================================*/
    create unique index COLLECTIONS_SONGS_PK on COLLECTIONS_SONGS (
    SONG_ID,
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Index: MEMILIKI4_FK                                          */
    /*==============================================================*/
    create  index MEMILIKI4_FK on COLLECTIONS_SONGS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: MEMILIKI_FK                                           */
    /*==============================================================*/
    create  index MEMILIKI_FK on COLLECTIONS_SONGS (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: COLLECTION_LIBRARY                                    */
    /*==============================================================*/
    create table COLLECTION_LIBRARY (
    USER_ID              INT4                 not null,
    COLLECTION_ID        INT4                 not null,
    constraint PK_COLLECTION_LIBRARY primary key (USER_ID, COLLECTION_ID)
    );
    
    /*==============================================================*/
    /* Index: COLLECTION_LIBRARY_PK                                 */
    /*==============================================================*/
    create unique index COLLECTION_LIBRARY_PK on COLLECTION_LIBRARY (
    USER_ID,
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Index: RELATIONSHIP_40_FK                                    */
    /*==============================================================*/
    create  index RELATIONSHIP_40_FK on COLLECTION_LIBRARY (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: RELATIONSHIP_41_FK                                    */
    /*==============================================================*/
    create  index RELATIONSHIP_41_FK on COLLECTION_LIBRARY (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: COLLECTION_TOP_3_GENRES                               */
    /*==============================================================*/
    create table COLLECTION_TOP_3_GENRES (
    COLLECTION_ID        INT4                 not null,
    GENRE_ID             INT4                 not null,
    constraint PK_COLLECTION_TOP_3_GENRES primary key (COLLECTION_ID, GENRE_ID)
    );
    
    /*==============================================================*/
    /* Index: COLLECTION_TOP_3_GENRES_PK                            */
    /*==============================================================*/
    create unique index COLLECTION_TOP_3_GENRES_PK on COLLECTION_TOP_3_GENRES (
    COLLECTION_ID,
    GENRE_ID
    );
    
    /*==============================================================*/
    /* Index: TOP_3_GENRE2_FK                                       */
    /*==============================================================*/
    create  index TOP_3_GENRE2_FK on COLLECTION_TOP_3_GENRES (
    GENRE_ID
    );
    
    /*==============================================================*/
    /* Index: TOP_3_GENRE_FK                                        */
    /*==============================================================*/
    create  index TOP_3_GENRE_FK on COLLECTION_TOP_3_GENRES (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: CREATE_SONGS                                          */
    /*==============================================================*/
    create table CREATE_SONGS (
    SONG_ID              INT4                 not null,
    ARTIST_ID            INT4                 not null,
    constraint PK_CREATE_SONGS primary key (SONG_ID, ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: CREATE_PLAYLISTS_PK                                   */
    /*==============================================================*/
    create unique index CREATE_PLAYLISTS_PK on CREATE_SONGS (
    SONG_ID,
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMBUAT2_FK                                           */
    /*==============================================================*/
    create  index MEMBUAT2_FK on CREATE_SONGS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMBUAT_FK                                            */
    /*==============================================================*/
    create  index MEMBUAT_FK on CREATE_SONGS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Table: FOLLOW_ARTISTS                                        */
    /*==============================================================*/
    create table FOLLOW_ARTISTS (
    USER_ID              INT4                 not null,
    ARTIST_ID            INT4                 not null,
    "TIMESTAMP"          TIMESTAMP                 not null default current_timestamp,
    constraint PK_FOLLOW_ARTISTS primary key (USER_ID, ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: FOLLOW_ARTISTS_PK                                     */
    /*==============================================================*/
    create unique index FOLLOW_ARTISTS_PK on FOLLOW_ARTISTS (
    USER_ID,
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MENGIKUTI4_FK                                         */
    /*==============================================================*/
    create  index MENGIKUTI4_FK on FOLLOW_ARTISTS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MENGIKUTI_FK                                          */
    /*==============================================================*/
    create  index MENGIKUTI_FK on FOLLOW_ARTISTS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Table: FOLLOW_USERS                                          */
    /*==============================================================*/
    create table FOLLOW_USERS (
    FOLLOWER_ID          INT4                 not null,
    FOLLOWED_ID          INT4                 not null,
    constraint PK_FOLLOW_USERS primary key (FOLLOWER_ID, FOLLOWED_ID)
    );
    
    /*==============================================================*/
    /* Index: FOLLOW_USERS_PK                                       */
    /*==============================================================*/
    create unique index FOLLOW_USERS_PK on FOLLOW_USERS (
    FOLLOWER_ID,
    FOLLOWED_ID
    );
    
    /*==============================================================*/
    /* Index: MENGIKUTI2_FK                                         */
    /*==============================================================*/
    create  index MENGIKUTI2_FK on FOLLOW_USERS (
    FOLLOWED_ID
    );
    
    /*==============================================================*/
    /* Index: MENGIKUTI3_FK                                         */
    /*==============================================================*/
    create  index MENGIKUTI3_FK on FOLLOW_USERS (
    FOLLOWER_ID
    );
    
    /*==============================================================*/
    /* Table: GENRES                                                */
    /*==============================================================*/
    create table GENRES (
    GENRE_ID             INT4                 not null,
    GENRE_NAME           VARCHAR(255)         not null,
    constraint PK_GENRES primary key (GENRE_ID)
    );
    
    /*==============================================================*/
    /* Index: GENRES_PK                                             */
    /*==============================================================*/
    create unique index GENRES_PK on GENRES (
    GENRE_ID
    );
    
    /*==============================================================*/
    /* Table: LIKE_REVIEWS                                          */
    /*==============================================================*/
    create table LIKE_REVIEWS (
    REVIEW_ID            INT4                 not null,
    USER_ID              INT4                 not null,
    constraint PK_LIKE_REVIEWS primary key (REVIEW_ID, USER_ID)
    );
    
    /*==============================================================*/
    /* Index: LIKE_REVIEWS_PK                                       */
    /*==============================================================*/
    create unique index LIKE_REVIEWS_PK on LIKE_REVIEWS (
    REVIEW_ID,
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: LIKE_REVIEW2_FK                                       */
    /*==============================================================*/
    create  index LIKE_REVIEW2_FK on LIKE_REVIEWS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: LIKE_REVIEW_FK                                        */
    /*==============================================================*/
    create  index LIKE_REVIEW_FK on LIKE_REVIEWS (
    REVIEW_ID
    );
    
    /*==============================================================*/
    /* Table: LIKE_SONGS                                            */
    /*==============================================================*/
    create table LIKE_SONGS (
    SONG_ID              INT4                 not null,
    USER_ID              INT4                 not null,
    "TIMESTAMP"          TIMESTAMP                 not null default current_timestamp,
    constraint PK_LIKE_SONGS primary key (SONG_ID, USER_ID)
    );
    
    /*==============================================================*/
    /* Index: LIKE_SONGS_PK                                         */
    /*==============================================================*/
    create unique index LIKE_SONGS_PK on LIKE_SONGS (
    SONG_ID,
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MENYUKAI2_FK                                          */
    /*==============================================================*/
    create  index MENYUKAI2_FK on LIKE_SONGS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: MENYUKAI_FK                                           */
    /*==============================================================*/
    create  index MENYUKAI_FK on LIKE_SONGS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Table: LISTENS                                               */
    /*==============================================================*/
    create table LISTENS (
    LISTEN_ID            INT4                 not null,
    USER_ID              INT4                 not null,
    SONG_ID              INT4                 not null,
    DURATION_LISTENED    INT4                 not null,
    "TIMESTAMP"           TIMESTAMP                 not null DEFAULT current_timestamp,
    constraint PK_LISTENS primary key (LISTEN_ID)
    );
    
    /*==============================================================*/
    /* Index: MENDENGARKAN2_FK                                      */
    /*==============================================================*/
    create  index MENDENGARKAN2_FK on LISTENS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: MENDENGARKAN_FK                                       */
    /*==============================================================*/
    create  index MENDENGARKAN_FK on LISTENS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: LISTENS_PK                                            */
    /*==============================================================*/
    create unique index LISTENS_PK on LISTENS (
    LISTEN_ID
    );
    
    /*==============================================================*/
    /* Table: PLAYLISTS                                             */
    /*==============================================================*/
    create table PLAYLISTS (
    PLAYLIST_ID          INT4                 not null,
    USER_ID              INT4                 not null,
    PLAYLIST_COVER       VARCHAR(2048)        null,
    PLAYLIST_TITLE       VARCHAR(255)         not null,
    ISPUBLIC             BOOL                 not null,
    ISCOLLABORATIVE      BOOL                 not null,
    PLAYLIST_DESC        TEXT                 null,
    ISONPROFILE          BOOL                 not null,
    PLAYLIST_DATE_CREATED DATE                 not null,
    constraint PK_PLAYLISTS primary key (PLAYLIST_ID)
    );
    
    /*==============================================================*/
    /* Index: PLAYLISTS_PK                                          */
    /*==============================================================*/
    create unique index PLAYLISTS_PK on PLAYLISTS (
    PLAYLIST_ID
    );
    
    /*==============================================================*/
    /* Index: MEMBUAT_PLAYLIST_FK                                   */
    /*==============================================================*/
    create  index MEMBUAT_PLAYLIST_FK on PLAYLISTS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Table: PL_LIBRARY                                            */
    /*==============================================================*/
    create table PL_LIBRARY (
    USER_ID              INT4                 not null,
    PLAYLIST_ID          INT4                 not null,
    constraint PK_PL_LIBRARY primary key (USER_ID, PLAYLIST_ID)
    );
    
    /*==============================================================*/
    /* Index: PL_LIBRARY_PK                                         */
    /*==============================================================*/
    create unique index PL_LIBRARY_PK on PL_LIBRARY (
    USER_ID,
    PLAYLIST_ID
    );
    
    /*==============================================================*/
    /* Index: RELATIONSHIP_38_FK                                    */
    /*==============================================================*/
    create  index RELATIONSHIP_38_FK on PL_LIBRARY (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: RELATIONSHIP_39_FK                                    */
    /*==============================================================*/
    create  index RELATIONSHIP_39_FK on PL_LIBRARY (
    PLAYLIST_ID
    );
    
    /*==============================================================*/
    /* Table: RATE_SONGS                                            */
    /*==============================================================*/
    create table RATE_SONGS (
    USER_ID              INT4                 not null,
    SONG_ID              INT4                 not null,
    SONG_RATING          NUMERIC(3,0)         not null,
    "TIMESTAMP"           TIMESTAMP                 not null DEFAULT current_timestamp,
    constraint PK_RATE_SONGS primary key (USER_ID, SONG_ID)
    );
    
    /*==============================================================*/
    /* Index: RATE_SONGS_PK                                         */
    /*==============================================================*/
    create unique index RATE_SONGS_PK on RATE_SONGS (
    USER_ID,
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: RATE2_FK                                              */
    /*==============================================================*/
    create  index RATE2_FK on RATE_SONGS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: RATE_FK                                               */
    /*==============================================================*/
    create  index RATE_FK on RATE_SONGS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Table: RELEASES                                              */
    /*==============================================================*/
    create table RELEASES (
    COLLECTION_ID        INT4                 not null,
    ARTIST_ID            INT4                 not null,
    constraint PK_RELEASES primary key (COLLECTION_ID, ARTIST_ID)
    );
    
    /*==============================================================*/
    /* Index: RELEASES_PK                                           */
    /*==============================================================*/
    create unique index RELEASES_PK on RELEASES (
    COLLECTION_ID,
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MERILIS2_FK                                           */
    /*==============================================================*/
    create  index MERILIS2_FK on RELEASES (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Index: MERILIS_FK                                            */
    /*==============================================================*/
    create  index MERILIS_FK on RELEASES (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: REVIEWS                                               */
    /*==============================================================*/
    create table REVIEWS (
    REVIEW               TEXT                 null,
    RATING               NUMERIC(3,0)         not null,
    "TIMESTAMP"          TIMESTAMP                 not null DEFAULT current_timestamp,
    REVIEW_ID            INT4                 not null,
    USER_ID              INT4                 not null,
    COLLECTION_ID        INT4                 not null,
    constraint PK_REVIEWS primary key (REVIEW_ID)
    );
    
    /*==============================================================*/
    /* Index: REVIEWS_PK                                            */
    /*==============================================================*/
    create unique index REVIEWS_PK on REVIEWS (
    REVIEW_ID
    );
    
    /*==============================================================*/
    /* Index: MEMBUAT_REVIEW_FK                                     */
    /*==============================================================*/
    create  index MEMBUAT_REVIEW_FK on REVIEWS (
    USER_ID
    );
    
    /*==============================================================*/
    /* Index: COLLECTION_MANA_FK                                    */
    /*==============================================================*/
    create  index COLLECTION_MANA_FK on REVIEWS (
    COLLECTION_ID
    );
    
    /*==============================================================*/
    /* Table: SOCIALS                                               */
    /*==============================================================*/
    create table SOCIALS (
    SOCIAL_ID            INT4                 not null,
    ARTIST_ID            INT4                 not null,
    SOCIAL_MEDIA_LINK    VARCHAR(2048)        not null,
    constraint PK_SOCIALS primary key (SOCIAL_ID)
    );
    
    /*==============================================================*/
    /* Index: SOCIALS_PK                                            */
    /*==============================================================*/
    create unique index SOCIALS_PK on SOCIALS (
    SOCIAL_ID
    );
    
    /*==============================================================*/
    /* Index: HAS_FK                                                */
    /*==============================================================*/
    create  index HAS_FK on SOCIALS (
    ARTIST_ID
    );
    
    /*==============================================================*/
    /* Table: SONGS                                                 */
    /*==============================================================*/
    create table SONGS (
    SONG_ID              INT4                 not null,
    SONG_FILE            VARCHAR(320)         not null,
    SONG_TITLE           VARCHAR(255)         not null,
    LISTEN_COUNT         INT8                 null default 0,
    SONG_CREDITS         TEXT                 null,
    SONG_DURATION        INT4                 not null,
    VALENCE              DECIMAL(4,3)         null,
    ACCOUSTICNESS        DECIMAL(4,3)         null,
    DANCEABILITY         DECIMAL(4,3)         null,
    ENERGY               DECIMAL(4,3)         null,
    POPULARITY           NUMERIC(3,0)         null,
    SONG_RELEASE_DATE    DATE                 not null,
    SONG_RATING          NUMERIC(3,0)         null,
    constraint PK_SONGS primary key (SONG_ID)
    );
    
    /*==============================================================*/
    /* Index: SONGS_PK                                              */
    /*==============================================================*/
    create unique index SONGS_PK on SONGS (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Table: SONGS_GENRES                                          */
    /*==============================================================*/
    create table SONGS_GENRES (
    GENRE_ID             INT4                 not null,
    SONG_ID              INT4                 not null,
    constraint PK_SONGS_GENRES primary key (GENRE_ID, SONG_ID)
    );
    
    /*==============================================================*/
    /* Index: SONGS_GENRES_PK                                       */
    /*==============================================================*/
    create unique index SONGS_GENRES_PK on SONGS_GENRES (
    GENRE_ID,
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: MEMPUNYAI2_FK                                         */
    /*==============================================================*/
    create  index MEMPUNYAI2_FK on SONGS_GENRES (
    SONG_ID
    );
    
    /*==============================================================*/
    /* Index: MEMPUNYAI_FK                                          */
    /*==============================================================*/
    create  index MEMPUNYAI_FK on SONGS_GENRES (
    GENRE_ID
    );
    
    /*==============================================================*/
    /* Table: TOURS                                                 */
    /*==============================================================*/
    create table TOURS (
    TOUR_ID              INT4                 not null,
    TOUR_DATE            DATE                 not null,
    TOUR_NAME            VARCHAR(255)         not null,
    VENUE                VARCHAR(255)         not null,
    constraint PK_TOURS primary key (TOUR_ID)
    );
    
    /*==============================================================*/
    /* Index: TOURS_PK                                              */
    /*==============================================================*/
    create unique index TOURS_PK on TOURS (
    TOUR_ID
    );
    
    /*==============================================================*/
    /* Table: USERS                                                 */
    /*==============================================================*/
    create table USERS (
    USER_ID              INT4                 not null,
    USERNAME             VARCHAR(50)          not null,
    USER_PFP              VARCHAR(2048)        null,
    PW_HASH              VARCHAR(255)         not null,
    USER_EMAIL           VARCHAR(320)         not null,
    REGION               VARCHAR(50)          null,
    COUNTRY              VARCHAR(50)          null,
    constraint PK_USERS primary key (USER_ID)
    );
    
    /*==============================================================*/
    /* Index: USERS_PK                                              */
    /*==============================================================*/
    create unique index USERS_PK on USERS (
    USER_ID
    );
    
    alter table ADD_SONGS_PLAYLISTS
    add constraint FK_ADD_SONG_MENAMBAHK_PLAYLIST foreign key (PLAYLIST_ID)
        references PLAYLISTS (PLAYLIST_ID)
        on delete cascade on update cascade;
    
    alter table ADD_SONGS_PLAYLISTS
    add constraint FK_ADD_SONG_MENAMBAHK_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table ADD_SONGS_PLAYLISTS
    add constraint FK_ADD_SONG_USER_MENA_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table ARTISTS_TOURS
    add constraint FK_ARTISTS__MEMILIKI2_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete restrict on update cascade;
    
    alter table ARTISTS_TOURS
    add constraint FK_ARTISTS__MEMILIKI3_TOURS foreign key (TOUR_ID)
        references TOURS (TOUR_ID)
        on delete cascade on update cascade;
    
    alter table ARTIST_PROMOTION
    add constraint FK_ARTIST_P_MEMPROMOS_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table ARTIST_PROMOTION
    add constraint FK_ARTIST_P_MEMPROMOS_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete cascade on update cascade;
    
    alter table BLOCKLIST_ARTISTS
    add constraint FK_BLOCKLIS_MEM_BLACK_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete restrict on update cascade;
    
    alter table BLOCKLIST_ARTISTS
    add constraint FK_BLOCKLIS_MEM_BLACK_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table BLOCK_USERS
    add constraint FK_BLOCK_US_DI_BLOCK__USERS foreign key (BLOCKER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table BLOCK_USERS
    add constraint FK_BLOCK_US_MEM_BLOCK_USERS foreign key (BLOCKED_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTIONS_SONGS
    add constraint FK_COLLECTI_MEMILIKI_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTIONS_SONGS
    add constraint FK_COLLECTI_MEMILIKI4_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTION_LIBRARY
    add constraint FK_COLLECTI_COLLECTIO_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTION_LIBRARY
    add constraint FK_COLLECTI_USER_COLL_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTION_TOP_3_GENRES
    add constraint FK_COLLECTI_TOP_3_GEN_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table COLLECTION_TOP_3_GENRES
    add constraint FK_COLLECTI_TOP_3_GEN_GENRES foreign key (GENRE_ID)
        references GENRES (GENRE_ID)
        on delete restrict on update cascade;
    
    alter table CREATE_SONGS
    add constraint FK_CREATE_S_MEMBUAT_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table CREATE_SONGS
    add constraint FK_CREATE_S_MEMBUAT2_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete restrict on update cascade;
    
    alter table FOLLOW_ARTISTS
    add constraint FK_FOLLOW_A_MENGIKUTI_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete restrict on update cascade;
    
    alter table FOLLOW_ARTISTS
    add constraint FK_FOLLOW_A_MENGIKUTI_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table FOLLOW_USERS
    add constraint FK_FOLLOW_U_MENGIKUTI_USERS foreign key (FOLLOWED_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table FOLLOW_USERS
    add constraint FK_FOLLOW_U_USER_DIIK_USERS foreign key (FOLLOWER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table LIKE_REVIEWS
    add constraint FK_LIKE_REV_LIKE_REVI_REVIEWS foreign key (REVIEW_ID)
        references REVIEWS (REVIEW_ID)
        on delete cascade on update cascade;
    
    alter table LIKE_REVIEWS
    add constraint FK_LIKE_REV_LIKE_REVI_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table LIKE_SONGS
    add constraint FK_LIKE_SON_MENYUKAI_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table LIKE_SONGS
    add constraint FK_LIKE_SON_MENYUKAI2_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table LISTENS
    add constraint FK_LISTENS_MENDENGAR_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table LISTENS
    add constraint FK_LISTENS_MENDENGAR_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table PLAYLISTS
    add constraint FK_PLAYLIST_MEMBUAT_P_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table PL_LIBRARY
    add constraint FK_PL_LIBRA_PLAYLIST__PLAYLIST foreign key (PLAYLIST_ID)
        references PLAYLISTS (PLAYLIST_ID)
        on delete cascade on update cascade;
    
    alter table PL_LIBRARY
    add constraint FK_PL_LIBRA_USER_PLAY_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table RATE_SONGS
    add constraint FK_RATE_SON_RATE_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    alter table RATE_SONGS
    add constraint FK_RATE_SON_RATE2_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table RELEASES
    add constraint FK_RELEASES_MERILIS_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table RELEASES
    add constraint FK_RELEASES_MERILIS2_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete restrict on update cascade;
    
    alter table REVIEWS
    add constraint FK_REVIEWS_COLLECTIO_COLLECTI foreign key (COLLECTION_ID)
        references COLLECTIONS (COLLECTION_ID)
        on delete cascade on update cascade;
    
    alter table REVIEWS
    add constraint FK_REVIEWS_MEMBUAT_R_USERS foreign key (USER_ID)
        references USERS (USER_ID)
        on delete cascade on update cascade;
    
    alter table SOCIALS
    add constraint FK_SOCIALS_HAS_ARTISTS foreign key (ARTIST_ID)
        references ARTISTS (ARTIST_ID)
        on delete cascade on update cascade;
    
    alter table SONGS_GENRES
    add constraint FK_SONGS_GE_MEMPUNYAI_GENRES foreign key (GENRE_ID)
        references GENRES (GENRE_ID)
        on delete restrict on update cascade;
    
    alter table SONGS_GENRES
    add constraint FK_SONGS_GE_MEMPUNYAI_SONGS foreign key (SONG_ID)
        references SONGS (SONG_ID)
        on delete cascade on update cascade;
    
    
    
    -- Sequence untuk artists
    CREATE SEQUENCE seq_artists_id START 1;
    ALTER TABLE ARTISTS
    ALTER COLUMN ARTIST_ID SET DEFAULT nextval('seq_artists_id');
    ALTER SEQUENCE seq_artists_id OWNED BY ARTISTS.ARTIST_ID;
    
    -- Sequence untuk Songs
    CREATE SEQUENCE seq_songs_id START 1;
    ALTER TABLE SONGS
    ALTER COLUMN SONG_ID SET DEFAULT nextval('seq_songs_id');
    ALTER SEQUENCE seq_songs_id OWNED BY SONGS.SONG_ID;
    
    -- Sequence untuk Users
    CREATE SEQUENCE seq_users_id START 1;
    ALTER TABLE USERS
    ALTER COLUMN USER_ID SET DEFAULT nextval('seq_users_id');
    ALTER SEQUENCE seq_users_id OWNED BY USERS.USER_ID;
    
    -- Sequence untuk Playlists
    CREATE SEQUENCE seq_playlists_id START 1;
    ALTER TABLE PLAYLISTS
    ALTER COLUMN PLAYLIST_ID SET DEFAULT nextval('seq_playlists_id');
    ALTER SEQUENCE seq_playlists_id OWNED BY PLAYLISTS.PLAYLIST_ID;
    
    -- Sequence untuk Collections
    CREATE SEQUENCE seq_collections_id START 1;
    ALTER TABLE COLLECTIONS
    ALTER COLUMN COLLECTION_ID SET DEFAULT nextval('seq_collections_id');
    ALTER SEQUENCE seq_collections_id OWNED BY COLLECTIONS.COLLECTION_ID;
    
    -- Sequence untuk Genres
    CREATE SEQUENCE seq_genres_id START 1;
    ALTER TABLE GENRES
    ALTER COLUMN GENRE_ID SET DEFAULT nextval('seq_genres_id');
    ALTER SEQUENCE seq_genres_id OWNED BY GENRES.GENRE_ID;
    
    -- Sequence untuk Reviews
    CREATE SEQUENCE seq_reviews_id START 1;
    ALTER TABLE REVIEWS
    ALTER COLUMN REVIEW_ID SET DEFAULT nextval('seq_reviews_id');
    ALTER SEQUENCE seq_reviews_id OWNED BY REVIEWS.REVIEW_ID;
    
    -- Sequence untuk Tour
    CREATE SEQUENCE seq_tours_id START 1;
    ALTER TABLE TOURS
    ALTER COLUMN TOUR_ID SET DEFAULT nextval('seq_tours_id');
    ALTER SEQUENCE seq_tours_id OWNED BY TOURS.TOUR_ID;
    
    -- Sequence untuk Socials
    CREATE SEQUENCE seq_socials_id START 1;
    ALTER TABLE SOCIALS
    ALTER COLUMN SOCIAL_ID SET DEFAULT nextval('seq_socials_id');
    ALTER SEQUENCE seq_socials_id OWNED BY SOCIALS.SOCIAL_ID;
    -- Sequence untuk Listens
    CREATE SEQUENCE seq_listens_id START 1;
    ALTER TABLE LISTENS
    ALTER COLUMN LISTEN_ID SET DEFAULT nextval('seq_listens_id');
    ALTER SEQUENCE seq_listens_id OWNED BY LISTENS.LISTEN_ID;
    -- Sequence untuk ADD_SONGS_PLAYLISTS
    CREATE SEQUENCE seq_add_songs_playlist_id START 1;
    ALTER TABLE ADD_SONGS_PLAYLISTS
    ALTER COLUMN ADD_SONG_PL_ID SET DEFAULT nextval('seq_add_songs_playlist_id');
    ALTER SEQUENCE seq_add_songs_playlist_id OWNED BY ADD_SONGS_PLAYLISTS.ADD_SONG_PL_ID;
    
    
        -- cek socials
        /* --- VALIDASI LOGIKA BISNIS (ANGKA & RANGE) --- */
    
        ALTER TABLE SONGS ADD CONSTRAINT CHK_SONG_METRICS
        CHECK (
            (VALENCE >= 0 AND VALENCE <= 1) AND
            (DANCEABILITY >= 0 AND DANCEABILITY <= 1) AND
            (ENERGY >= 0 AND ENERGY <= 1) AND
            (ACCOUSTICNESS >= 0 AND ACCOUSTICNESS <= 1)
        );
    
        ALTER TABLE SONGS ADD CONSTRAINT CHK_SONG_DURATION_POSITIVE
        CHECK (SONG_DURATION > 0);
    
        ALTER TABLE SONGS ADD CONSTRAINT CHK_SONG_POPULARITY_RANGE
        CHECK (POPULARITY >= 0 AND POPULARITY <= 100);
    
        ALTER TABLE RATE_SONGS ADD CONSTRAINT CHK_RATE_SONG_RANGE
        CHECK (SONG_RATING >= 1 AND SONG_RATING <= 100);
    
        ALTER TABLE REVIEWS ADD CONSTRAINT CHK_REVIEW_RATING_RANGE
        CHECK (RATING >= 1 AND RATING <= 100);
    
        ALTER TABLE ARTISTS ADD CONSTRAINT CHK_LISTENER_POSITIVE
        CHECK (MONTHLY_LISTENER_COUNT >= 0);
    
        ALTER TABLE ADD_SONGS_PLAYLISTS ADD CONSTRAINT CHK_PLAYLIST_ORDER_POSITIVE
        CHECK (NO_URUT > 0);
    
        ALTER TABLE COLLECTIONS_SONGS ADD CONSTRAINT CHK_DISC_TRACK_POSITIVE
        CHECK (NOMOR_DISC > 0 AND NOMOR_TRACK > 0);
    
        ALTER TABLE USERS ADD CONSTRAINT CHK_PW_HASH_LENGTH
        CHECK (LENGTH(PW_HASH) >= 8);
    
        ALTER TABLE USERS ADD CONSTRAINT CHK_USERNAME_NO_WHITESPACE
        CHECK (LENGTH(TRIM(USERNAME)) > 0);
    
        ALTER TABLE ARTISTS ADD CONSTRAINT CHK_ARTISTNAME_NO_WHITESPACE
        CHECK (LENGTH(TRIM(ARTIST_NAME)) > 0);
    
        ALTER TABLE FOLLOW_USERS
        ADD CONSTRAINT CHK_NO_SELF_FOLLOW
        CHECK (FOLLOWER_ID <> FOLLOWED_ID);
    
        ALTER TABLE BLOCK_USERS
        ADD CONSTRAINT CHK_NO_SELF_BLOCK
        CHECK (BLOCKER_ID <> BLOCKED_ID);
        /* --- VALIDASI FORMAT TEKS & TIPE --- */
    
        ALTER TABLE USERS ADD CONSTRAINT CHK_EMAIL_FORMAT
        CHECK (USER_EMAIL LIKE '%_@__%.__%');
    
        ALTER TABLE COLLECTIONS ADD CONSTRAINT CHK_COLLECTION_TYPE_VALID
        CHECK (COLLECTION_TYPE IN ('Album', 'EP', 'Single', 'Compilation'));
    
        /* --- NILAI DEFAULT --- */
    
        -- 1. Playlist otomatis Private jika tidak diisi
        ALTER TABLE PLAYLISTS ALTER COLUMN ISPUBLIC SET DEFAULT FALSE;
    
        -- 2. Playlist otomatis Tidak Kolaboratif jika tidak diisi
        ALTER TABLE PLAYLISTS ALTER COLUMN ISCOLLABORATIVE SET DEFAULT FALSE;
    
    
        -- artist hanya bisa promosi rilisannya sendiri
        ALTER TABLE ARTIST_PROMOTION
            ADD CONSTRAINT FK_PROMO_OWN_RELEASE
            FOREIGN KEY (ARTIST_ID, COLLECTION_ID)
            REFERENCES RELEASES (ARTIST_ID, COLLECTION_ID)
            ON DELETE CASCADE ON UPDATE CASCADE;
    
    commit;
