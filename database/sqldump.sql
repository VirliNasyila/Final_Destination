
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
ARTIST_EMAIL         VARCHAR(320)         not null unique,
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
USERNAME             VARCHAR(50)          not null unique,
USER_PFP              VARCHAR(2048)        null,
PW_HASH              VARCHAR(255)         not null,
USER_EMAIL           VARCHAR(320)         not null unique,
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


    ALTER TABLE REVIEWS
    ADD CONSTRAINT UQ_USER_COLLECTION_REVIEW UNIQUE (user_id, collection_id);

commit;

/* Script Generated by Python Faker (Full 27 Tables) */
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
TRUNCATE TABLE
        USERS, ARTISTS, GENRES, COLLECTIONS, SONGS, PLAYLISTS,
        RELEASES, COLLECTIONS_SONGS, CREATE_SONGS, SONGS_GENRES,
        FOLLOW_ARTISTS, FOLLOW_USERS, LISTENS, LIKE_SONGS, REVIEWS,
        RATE_SONGS, TOURS, ARTISTS_TOURS, SOCIALS, COLLECTION_LIBRARY,
        PL_LIBRARY, BLOCK_USERS, BLOCKLIST_ARTISTS, LIKE_REVIEWS,
        ADD_SONGS_PLAYLISTS, COLLECTION_TOP_3_GENRES, ARTIST_PROMOTION
        RESTART IDENTITY CASCADE;
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (1, 'jmangunsong', 'jmangunsong_1@example.com', crypt('$&d_x5KqhkeS', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jmangunsong&background=random', 'Padangpanjang', 'Niger');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (2, 'purwantiqueen', 'purwantiqueen_2@example.com', crypt('KL)1OTvT1^d1', gen_salt('bf')), 'https://ui-avatars.com/api/?name=purwantiqueen&background=random', 'Kotamobagu', 'Burkina Faso');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (3, 'widodointan', 'widodointan_3@example.com', crypt('x4+Au(itDT0J', gen_salt('bf')), 'https://ui-avatars.com/api/?name=widodointan&background=random', 'Cimahi', 'Brunei');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (4, 'ikaanggriawan', 'ikaanggriawan_4@example.com', crypt('h*se1jXzs+!O', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ikaanggriawan&background=random', 'Palembang', 'Nauru');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (5, 'palastrimelinda', 'palastrimelinda_5@example.com', crypt('i!N1ADsKKjpq', gen_salt('bf')), 'https://ui-avatars.com/api/?name=palastrimelinda&background=random', 'Parepare', 'Portugal');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (6, 'titiwijayanti', 'titiwijayanti_6@example.com', crypt('#&1Q5)dv(dC8', gen_salt('bf')), 'https://ui-avatars.com/api/?name=titiwijayanti&background=random', 'Bekasi', 'Fiji');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (7, 'iharyanto', 'iharyanto_7@example.com', crypt('X$MxA8iJ4d92', gen_salt('bf')), 'https://ui-avatars.com/api/?name=iharyanto&background=random', 'Pontianak', 'Republik Dominika');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (8, 'timbul65', 'timbul65_8@example.com', crypt('CS83EH$n_7AR', gen_salt('bf')), 'https://ui-avatars.com/api/?name=timbul65&background=random', 'Banjarbaru', 'Peru');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (9, 'kasimsihombing', 'kasimsihombing_9@example.com', crypt(')F73WEdLk#$Y', gen_salt('bf')), 'https://ui-avatars.com/api/?name=kasimsihombing&background=random', 'Sungai Penuh', 'Ethiopia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (10, 'pradiptaozy', 'pradiptaozy_10@example.com', crypt('+H8KGggY#%F8', gen_salt('bf')), 'https://ui-avatars.com/api/?name=pradiptaozy&background=random', 'Kota Administrasi Jakarta Timur', 'Kolombia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (11, 'pranatapuspita', 'pranatapuspita_11@example.com', crypt('h%2(J3Fgl3w*', gen_salt('bf')), 'https://ui-avatars.com/api/?name=pranatapuspita&background=random', 'Banjarmasin', 'Bahrain');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (12, 'jumadinatsir', 'jumadinatsir_12@example.com', crypt('$5ludcvY45cW', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jumadinatsir&background=random', 'Surakarta', 'Botswana');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (13, 'cakrawala68', 'cakrawala68_13@example.com', crypt('_Q57EqUrT6jw', gen_salt('bf')), 'https://ui-avatars.com/api/?name=cakrawala68&background=random', 'Yogyakarta', 'Chili');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (14, 'estiono92', 'estiono92_14@example.com', crypt('LnB#WF$4t3Ic', gen_salt('bf')), 'https://ui-avatars.com/api/?name=estiono92&background=random', 'Metro', 'Rumania');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (15, 'dimaswahyudin', 'dimaswahyudin_15@example.com', crypt('()uhZnfDvaJ0', gen_salt('bf')), 'https://ui-avatars.com/api/?name=dimaswahyudin&background=random', 'Kota Administrasi Jakarta Barat', 'Zambia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (16, 'saptonosalwa', 'saptonosalwa_16@example.com', crypt('@S257Fbvl1xX', gen_salt('bf')), 'https://ui-avatars.com/api/?name=saptonosalwa&background=random', 'Pasuruan', 'Swedia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (17, 'setiawanfarhunnisa', 'setiawanfarhunnisa_17@example.com', crypt('+qi1Zpna3x5r', gen_salt('bf')), 'https://ui-avatars.com/api/?name=setiawanfarhunnisa&background=random', 'Pekalongan', 'Jepang');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (18, 'ratna18', 'ratna18_18@example.com', crypt('wYK8&!SrB!xl', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ratna18&background=random', 'Madiun', 'Maroko');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (19, 'adikaprasasta', 'adikaprasasta_19@example.com', crypt('_6IyN0KCFwfz', gen_salt('bf')), 'https://ui-avatars.com/api/?name=adikaprasasta&background=random', 'Bandung', 'Venezuela');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (20, 'bwijayanti', 'bwijayanti_20@example.com', crypt('raV)N4Kq+f4a', gen_salt('bf')), 'https://ui-avatars.com/api/?name=bwijayanti&background=random', 'Lhokseumawe', 'Austria');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (21, 'permatalukman', 'permatalukman_21@example.com', crypt('fm1g5JET+9hD', gen_salt('bf')), 'https://ui-avatars.com/api/?name=permatalukman&background=random', 'Denpasar', 'Pantai Gading');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (22, 'isimbolon', 'isimbolon_22@example.com', crypt('%6Ef#7Ax@kTx', gen_salt('bf')), 'https://ui-avatars.com/api/?name=isimbolon&background=random', 'Langsa', 'Tunisia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (23, 'tugimandamanik', 'tugimandamanik_23@example.com', crypt(')oNMJCK8Y8XP', gen_salt('bf')), 'https://ui-avatars.com/api/?name=tugimandamanik&background=random', 'Pangkalpinang', 'Venezuela');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (24, 'osalahudin', 'osalahudin_24@example.com', crypt('*j5UUhcg0+r@', gen_salt('bf')), 'https://ui-avatars.com/api/?name=osalahudin&background=random', 'Jambi', 'Ukraina');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (25, 'dacinpradipta', 'dacinpradipta_25@example.com', crypt('*O5RNSFgV*(c', gen_salt('bf')), 'https://ui-avatars.com/api/?name=dacinpradipta&background=random', 'Palu', 'Bulgaria');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (26, 'kasiranhidayat', 'kasiranhidayat_26@example.com', crypt('Z^HPaXE$xK8P', gen_salt('bf')), 'https://ui-avatars.com/api/?name=kasiranhidayat&background=random', 'Padang Sidempuan', 'Ghana');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (27, 'wahyudincagak', 'wahyudincagak_27@example.com', crypt('lA#l+KdPEqK9', gen_salt('bf')), 'https://ui-avatars.com/api/?name=wahyudincagak&background=random', 'Sawahlunto', 'Ukraina');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (28, 'jayadi15', 'jayadi15_28@example.com', crypt('&4#iNU@o0q6Y', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jayadi15&background=random', 'Manado', 'Afrika Selatan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (29, 'butama', 'butama_29@example.com', crypt('%wEg6G!)P^o)', gen_salt('bf')), 'https://ui-avatars.com/api/?name=butama&background=random', 'Tangerang', 'Pantai Gading');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (30, 'jwasita', 'jwasita_30@example.com', crypt('Jhe)Q7WvDwY9', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jwasita&background=random', 'Bontang', 'Jepang');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (31, 'dalima74', 'dalima74_31@example.com', crypt('T)62LaRHko0X', gen_salt('bf')), 'https://ui-avatars.com/api/?name=dalima74&background=random', 'Jayapura', 'Malaysia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (32, 'gangsarmardhiyah', 'gangsarmardhiyah_32@example.com', crypt('$4RBi67eTTOY', gen_salt('bf')), 'https://ui-avatars.com/api/?name=gangsarmardhiyah&background=random', 'Pasuruan', 'Pakistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (33, 'humaira14', 'humaira14_33@example.com', crypt('R!#_RzHsAOV6', gen_salt('bf')), 'https://ui-avatars.com/api/?name=humaira14&background=random', 'Bukittinggi', 'Peru');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (34, 'nadiasitorus', 'nadiasitorus_34@example.com', crypt('+50wMSl$3$gQ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=nadiasitorus&background=random', 'Kotamobagu', 'Vanuatu');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (35, 'ekaprayoga', 'ekaprayoga_35@example.com', crypt('Ik%%8NmoOL_3', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ekaprayoga&background=random', 'Samarinda', 'Montenegro');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (36, 'tsaptono', 'tsaptono_36@example.com', crypt('t&!aCoebkO16', gen_salt('bf')), 'https://ui-avatars.com/api/?name=tsaptono&background=random', 'Cilegon', 'Makedonia Utara');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (37, 'luthfi39', 'luthfi39_37@example.com', crypt('!k84IiTNE0K!', gen_salt('bf')), 'https://ui-avatars.com/api/?name=luthfi39&background=random', 'Ambon', 'Ukraina');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (38, 'balangga09', 'balangga09_38@example.com', crypt('d8WX8iKt1&W8', gen_salt('bf')), 'https://ui-avatars.com/api/?name=balangga09&background=random', 'Semarang', 'Uni Emirat Arab');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (39, 'wyolanda', 'wyolanda_39@example.com', crypt('9$NTdi9p_X2n', gen_salt('bf')), 'https://ui-avatars.com/api/?name=wyolanda&background=random', 'Padang', 'Finlandia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (40, 'jsuwarno', 'jsuwarno_40@example.com', crypt('4v7*WPJa@HQr', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jsuwarno&background=random', 'Batu', 'Portugal');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (41, 'melanifitria', 'melanifitria_41@example.com', crypt('_w3oRLHaoz2i', gen_salt('bf')), 'https://ui-avatars.com/api/?name=melanifitria&background=random', 'Pematangsiantar', 'Irak');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (42, 'whutasoit', 'whutasoit_42@example.com', crypt('%0ye2XMqu#$!', gen_salt('bf')), 'https://ui-avatars.com/api/?name=whutasoit&background=random', 'Tegal', 'Polandia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (43, 'putrasatya', 'putrasatya_43@example.com', crypt('8wY&1SrmEepw', gen_salt('bf')), 'https://ui-avatars.com/api/?name=putrasatya&background=random', 'Sibolga', 'Zimbabwe');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (44, 'ikinagustina', 'ikinagustina_44@example.com', crypt('3^(#B0rBpx8S', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ikinagustina&background=random', 'Pagaralam', 'Brasil');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (45, 'fyuniar', 'fyuniar_45@example.com', crypt('_9NC)0vyE87Y', gen_salt('bf')), 'https://ui-avatars.com/api/?name=fyuniar&background=random', 'Bau-Bau', 'Armenia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (46, 'galihwaluyo', 'galihwaluyo_46@example.com', crypt('5uXYtJ##_ig9', gen_salt('bf')), 'https://ui-avatars.com/api/?name=galihwaluyo&background=random', 'Dumai', 'Jepang');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (47, 'gunawandadap', 'gunawandadap_47@example.com', crypt('+O$H4H%t(a3L', gen_salt('bf')), 'https://ui-avatars.com/api/?name=gunawandadap&background=random', 'Ambon', 'Portugal');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (48, 'evasantoso', 'evasantoso_48@example.com', crypt('(5$@d*8s$(Rw', gen_salt('bf')), 'https://ui-avatars.com/api/?name=evasantoso&background=random', 'Ambon', 'Belize');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (49, 'ardiantokasusra', 'ardiantokasusra_49@example.com', crypt('5(KpTZe)pT7v', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ardiantokasusra&background=random', 'Banjar', 'Palau');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (50, 'elestari', 'elestari_50@example.com', crypt('8jt%vQCe)nyJ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=elestari&background=random', 'Bekasi', 'Swiss');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (51, 'enteng20', 'enteng20_51@example.com', crypt(')OegZh2zT465', gen_salt('bf')), 'https://ui-avatars.com/api/?name=enteng20&background=random', 'Pontianak', 'Mozambik');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (52, 'hasan09', 'hasan09_52@example.com', crypt('tY4^X0v2+CgP', gen_salt('bf')), 'https://ui-avatars.com/api/?name=hasan09&background=random', 'Dumai', 'Nepal');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (53, 'jprayoga', 'jprayoga_53@example.com', crypt('H$$1Qiai6QZG', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jprayoga&background=random', 'Banda Aceh', 'Tuvalu');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (54, 'dimasmandasari', 'dimasmandasari_54@example.com', crypt('@yWAQOHBv@4u', gen_salt('bf')), 'https://ui-avatars.com/api/?name=dimasmandasari&background=random', 'Bukittinggi', 'Madagaskar');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (55, 'agustinaheru', 'agustinaheru_55@example.com', crypt('6k9r43@6z+2V', gen_salt('bf')), 'https://ui-avatars.com/api/?name=agustinaheru&background=random', 'Palangkaraya', 'Serbia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (56, 'langgeng75', 'langgeng75_56@example.com', crypt('JuHOK(wt+3rt', gen_salt('bf')), 'https://ui-avatars.com/api/?name=langgeng75&background=random', 'Padang Sidempuan', 'Kuwait');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (57, 'harja13', 'harja13_57@example.com', crypt(')rLPwnky$01i', gen_salt('bf')), 'https://ui-avatars.com/api/?name=harja13&background=random', 'Bogor', 'Brasil');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (58, 'hartakapradipta', 'hartakapradipta_58@example.com', crypt('0Q7ZgJ2Wa+*6', gen_salt('bf')), 'https://ui-avatars.com/api/?name=hartakapradipta&background=random', 'Tangerang', 'Korea Utara');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (59, 'tasdiksantoso', 'tasdiksantoso_59@example.com', crypt('!$3DxeLTrY$E', gen_salt('bf')), 'https://ui-avatars.com/api/?name=tasdiksantoso&background=random', 'Pekalongan', 'Namibia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (60, 'unuraini', 'unuraini_60@example.com', crypt('*jCp$tM131TQ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=unuraini&background=random', 'Binjai', 'Estonia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (61, 'asudiati', 'asudiati_61@example.com', crypt('gVe+mO%zk&5e', gen_salt('bf')), 'https://ui-avatars.com/api/?name=asudiati&background=random', 'Subulussalam', 'Amerika Serikat');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (62, 'artanto06', 'artanto06_62@example.com', crypt('5)&UXwpH+9NR', gen_salt('bf')), 'https://ui-avatars.com/api/?name=artanto06&background=random', 'Bima', 'Vatikan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (63, 'adikaramandasari', 'adikaramandasari_63@example.com', crypt('*&_uCAxH5*8S', gen_salt('bf')), 'https://ui-avatars.com/api/?name=adikaramandasari&background=random', 'Gorontalo', 'Yordania');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (64, 'ubudiman', 'ubudiman_64@example.com', crypt('^rsbYNCh^6qA', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ubudiman&background=random', 'Tanjungpinang', 'Turkmenistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (65, 'vharyanto', 'vharyanto_65@example.com', crypt('(K3Bk*cGvRKl', gen_salt('bf')), 'https://ui-avatars.com/api/?name=vharyanto&background=random', 'Ambon', 'Turkmenistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (66, 'ismailwijaya', 'ismailwijaya_66@example.com', crypt('*7Oc8&j#1nWj', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ismailwijaya&background=random', 'Cimahi', 'Sierra Leone');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (67, 'darimin21', 'darimin21_67@example.com', crypt('q!NL0&cB2E7o', gen_salt('bf')), 'https://ui-avatars.com/api/?name=darimin21&background=random', 'Blitar', 'Finlandia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (68, 'marbunusman', 'marbunusman_68@example.com', crypt('%$25T_PxdNO&', gen_salt('bf')), 'https://ui-avatars.com/api/?name=marbunusman&background=random', 'Madiun', 'Montenegro');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (69, 'jmandasari', 'jmandasari_69@example.com', crypt('N$2XM7Owkg4a', gen_salt('bf')), 'https://ui-avatars.com/api/?name=jmandasari&background=random', 'Blitar', 'Singapura');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (70, 'gara70', 'gara70_70@example.com', crypt('W4jBGWv#^zTZ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=gara70&background=random', 'Surabaya', 'Paraguay');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (71, 'hasan83', 'hasan83_71@example.com', crypt('V!r$!TLxV4&6', gen_salt('bf')), 'https://ui-avatars.com/api/?name=hasan83&background=random', 'Sibolga', 'Sri Lanka');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (72, 'uwaisoni', 'uwaisoni_72@example.com', crypt('Rr2f)hNo_5Pp', gen_salt('bf')), 'https://ui-avatars.com/api/?name=uwaisoni&background=random', 'Semarang', 'Samoa');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (73, 'oman35', 'oman35_73@example.com', crypt('+dFD9F@pSVAy', gen_salt('bf')), 'https://ui-avatars.com/api/?name=oman35&background=random', 'Palangkaraya', 'Belize');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (74, 'hmarpaung', 'hmarpaung_74@example.com', crypt('L_4mNV8#3li9', gen_salt('bf')), 'https://ui-avatars.com/api/?name=hmarpaung&background=random', 'Kota Administrasi Jakarta Selatan', 'Samoa');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (75, 'ohidayat', 'ohidayat_75@example.com', crypt(')C1uFeds&LSP', gen_salt('bf')), 'https://ui-avatars.com/api/?name=ohidayat&background=random', 'Lhokseumawe', 'Serbia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (76, 'omaheswara', 'omaheswara_76@example.com', crypt('!6NeRveza2Xq', gen_salt('bf')), 'https://ui-avatars.com/api/?name=omaheswara&background=random', 'Jayapura', 'Ethiopia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (77, 'marpaungjessica', 'marpaungjessica_77@example.com', crypt(')QE&loa9A7wJ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=marpaungjessica&background=random', 'Balikpapan', 'Jamaika');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (78, 'siregaraditya', 'siregaraditya_78@example.com', crypt('NDHlcHYa%#u3', gen_salt('bf')), 'https://ui-avatars.com/api/?name=siregaraditya&background=random', 'Medan', 'Maroko');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (79, 'taswirmaryati', 'taswirmaryati_79@example.com', crypt('C2J7ziX2^xLA', gen_salt('bf')), 'https://ui-avatars.com/api/?name=taswirmaryati&background=random', 'Lhokseumawe', 'Hongaria');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (80, 'imarbun', 'imarbun_80@example.com', crypt('D7oEcjw$#KKa', gen_salt('bf')), 'https://ui-avatars.com/api/?name=imarbun&background=random', 'Bontang', 'Federasi Mikronesia');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (81, 'usyirahayu', 'usyirahayu_81@example.com', crypt('8S12Fwq%@GXR', gen_salt('bf')), 'https://ui-avatars.com/api/?name=usyirahayu&background=random', 'Lubuklinggau', 'Malta');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (82, 'nababanrizki', 'nababanrizki_82@example.com', crypt('wN2TiI(F!cW+', gen_salt('bf')), 'https://ui-avatars.com/api/?name=nababanrizki&background=random', 'Parepare', 'Afrika Tengah');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (83, 'nadriansyah', 'nadriansyah_83@example.com', crypt('B6L(Sq4d#3J@', gen_salt('bf')), 'https://ui-avatars.com/api/?name=nadriansyah&background=random', 'Blitar', 'Bahama');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (84, 'xnurdiyanti', 'xnurdiyanti_84@example.com', crypt('(55Um21#F!X6', gen_salt('bf')), 'https://ui-avatars.com/api/?name=xnurdiyanti&background=random', 'Bukittinggi', 'Mauritius');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (85, 'yolandakairav', 'yolandakairav_85@example.com', crypt('t73QEultoww_', gen_salt('bf')), 'https://ui-avatars.com/api/?name=yolandakairav&background=random', 'Cirebon', 'Bulgaria');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (86, 'lanjarmaryadi', 'lanjarmaryadi_86@example.com', crypt('n919f5Jg))BQ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=lanjarmaryadi&background=random', 'Cilegon', 'Arab Saudi');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (87, 'kuswandarisetya', 'kuswandarisetya_87@example.com', crypt('s74NK_vv)11J', gen_salt('bf')), 'https://ui-avatars.com/api/?name=kuswandarisetya&background=random', 'Ambon', 'Trinidad dan Tobago');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (88, 'sakti53', 'sakti53_88@example.com', crypt('d*i64LZqC_$q', gen_salt('bf')), 'https://ui-avatars.com/api/?name=sakti53&background=random', 'Banjar', 'Turkmenistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (89, 'wibisonomaryadi', 'wibisonomaryadi_89@example.com', crypt('Zd6MLh0(+@62', gen_salt('bf')), 'https://ui-avatars.com/api/?name=wibisonomaryadi&background=random', 'Bandung', 'Tonga');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (90, 'padmasaricatur', 'padmasaricatur_90@example.com', crypt('8n(7TyhBGr8(', gen_salt('bf')), 'https://ui-avatars.com/api/?name=padmasaricatur&background=random', 'Metro', 'Kosta Rika');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (91, 'primasaptono', 'primasaptono_91@example.com', crypt('K*CR#4PpcnD8', gen_salt('bf')), 'https://ui-avatars.com/api/?name=primasaptono&background=random', 'Gorontalo', 'Tajikistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (92, 'wahyudineman', 'wahyudineman_92@example.com', crypt('#drc9Ugqp2C7', gen_salt('bf')), 'https://ui-avatars.com/api/?name=wahyudineman&background=random', 'Pontianak', 'Grenada');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (93, 'novitasariestiono', 'novitasariestiono_93@example.com', crypt('qq8GxFjs+I%L', gen_salt('bf')), 'https://ui-avatars.com/api/?name=novitasariestiono&background=random', 'Medan', 'Kanada');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (94, 'natsirkezia', 'natsirkezia_94@example.com', crypt('&+X*@_osSw1E', gen_salt('bf')), 'https://ui-avatars.com/api/?name=natsirkezia&background=random', 'Ternate', 'Timor Leste');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (95, 'gpertiwi', 'gpertiwi_95@example.com', crypt('!U5@eoskowZJ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=gpertiwi&background=random', 'Sawahlunto', 'Chili');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (96, 'rachel97', 'rachel97_96@example.com', crypt('%FuF4SPp_4Pj', gen_salt('bf')), 'https://ui-avatars.com/api/?name=rachel97&background=random', 'Tomohon', 'Eritrea');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (97, 'nardi40', 'nardi40_97@example.com', crypt('tA$CWrbIy17@', gen_salt('bf')), 'https://ui-avatars.com/api/?name=nardi40&background=random', 'Banjarbaru', 'Spanyol');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (98, 'suartiniharsanto', 'suartiniharsanto_98@example.com', crypt('gh8+OVUuy)L*', gen_salt('bf')), 'https://ui-avatars.com/api/?name=suartiniharsanto&background=random', 'Medan', 'Nikaragua');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (99, 'tusamah', 'tusamah_99@example.com', crypt('c%J3K3$MxfT7', gen_salt('bf')), 'https://ui-avatars.com/api/?name=tusamah&background=random', 'Binjai', 'Tajikistan');
INSERT INTO USERS (USER_ID, USERNAME, USER_EMAIL, PW_HASH, USER_PFP, REGION, COUNTRY) VALUES (100, 'yancezulkarnain', 'yancezulkarnain_100@example.com', crypt('+2Puds+mvzVZ', gen_salt('bf')), 'https://ui-avatars.com/api/?name=yancezulkarnain&background=random', 'Yogyakarta', 'El Salvador');
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (1, 'Laufey', 'https://i.scdn.co/image/ab6761610000e5eb98c2527b85500f68f53084f2', 8703092, 'contact.1@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (1, 'Lover Girl', 'Single', '2025-06-25', 'https://i.scdn.co/image/ab67616d0000b273be1e41eda793059fb9129bff', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (1, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (1, 'Lover Girl', 164, '/stream/audio_default.mp3', 78, 0.607, 0.664, 0.433, 0.52, '2025-06-25') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (1, 1, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (1, 1) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (2, 'IU', 'https://i.scdn.co/image/ab6761610000e5eb789f38042e5ef8911fc3826b', 9453595, 'contact.2@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (1, 'k-pop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (2, 'k-ballad') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (2, 'Love wins all', 'Single', '2024-01-24', 'https://i.scdn.co/image/ab67616d0000b273b79a12d47af18d1d83a5caf9', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (2, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (2, 'Love wins all', 271, '/stream/audio_default.mp3', 68, 0.146, 0.788, 0.916, 0.802, '2024-01-24') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (2, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (2, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (2, 2, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (2, 2) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (3, 'Kristen Bell', 'https://i.scdn.co/image/4696b636f6be50265a1226814629eea4ed48a8e6', 165183, 'contact.3@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (3, 'Frozen (Original Motion Picture Soundtrack / Deluxe Edition)', 'Compilation', '2013-01-01', 'https://i.scdn.co/image/ab67616d0000b273a985e1e7c6b095da213eaa7c', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (3, 3) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (3, 'Love Is an Open Door - From "Frozen"/Soundtrack Version', 124, '/stream/audio_default.mp3', 69, 0.647, 0.353, 0.693, 0.732, '2013-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (3, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (3, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (3, 3, 1, 4) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (3, 3) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (4, 'Jeff Buckley', 'https://i.scdn.co/image/67779606c7f151618a28f62b1d24fb514d39dacf', 2342147, 'contact.4@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (4, 'Grace', 'Album', '1994-01-01', 'https://i.scdn.co/image/ab67616d0000b273afc2d1d2c8703a10aeded0af', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (4, 4) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (4, 'Lover, You Should''ve Come Over', 404, '/stream/audio_default.mp3', 84, 0.414, 0.354, 0.369, 0.781, '1994-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (4, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (4, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (4, 4, 1, 7) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (4, 4) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (5, 'Ariana Grande', 'https://i.scdn.co/image/ab6761610000e5eb6725802588d7dc1aba076ca5', 107890555, 'contact.5@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (3, 'pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (5, 'My Everything (Deluxe)', 'Album', '2014-08-22', 'https://i.scdn.co/image/ab67616d0000b273deec12a28d1e336c5052e9aa', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (5, 5) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (5, 'Love Me Harder', 236, '/stream/audio_default.mp3', 84, 0.013, 0.089, 0.059, 0.643, '2014-08-22') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (5, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (5, 5, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (5, 5) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (6, 'BLACKPINK', 'https://i.scdn.co/image/ab6761610000e5eb9b57f5eccf180a0049be84b3', 56471290, 'contact.6@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (6, 'THE ALBUM', 'Album', '2020-10-02', 'https://i.scdn.co/image/ab67616d0000b2731895052324f123becdd0d53d', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (6, 6) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (6, 'Lovesick Girls', 192, '/stream/audio_default.mp3', 71, 0.164, 0.433, 0.685, 0.878, '2020-10-02') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (6, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (6, 6, 1, 5) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (6, 6) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (7, 'Rihanna', 'https://i.scdn.co/image/ab6761610000e5ebcb565a8e684e3be458d329ac', 69619520, 'contact.7@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (7, 'Unapologetic (Deluxe)', 'Album', '2012-12-11', 'https://i.scdn.co/image/ab67616d0000b2736dee21d6cd1823e4d6231d37', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (7, 7) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (7, 'Loveeeeeee Song', 256, '/stream/audio_default.mp3', 78, 0.57, 0.574, 0.535, 0.776, '2012-12-11') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (7, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (7, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (7, 7, 1, 5) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (7, 7) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (8, 'SECRET NUMBER', 'https://i.scdn.co/image/ab6761610000e5eb4a0c6368275d8c1886b6f553', 264376, 'contact.8@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (8, 'Love, Maybe (A Business Proposal OST Part.5)', 'Single', '2022-03-14', 'https://i.scdn.co/image/ab67616d0000b2739ba0f46373fe18f26c31bb55', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (8, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (8, 'Love, Maybe', 185, '/stream/audio_default.mp3', 59, 0.31, 0.465, 0.0, 0.258, '2022-03-14') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (8, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (8, 8, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (8, 8) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (9, 'Freddie Mercury', 'https://i.scdn.co/image/ab6761610000e5eb1052b77abd7f89485562d797', 7008639, 'contact.9@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (9, 'Mr Bad Guy (Special Edition)', 'Album', '2019-10-10', 'https://i.scdn.co/image/ab67616d0000b273eb9b9159e1ecb0614c2fc945', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (9, 9) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (9, 'Love Me Like There''s No Tomorrow - Special Edition', 225, '/stream/audio_default.mp3', 60, 0.974, 0.449, 0.701, 0.03, '2019-10-10') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (9, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (9, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (9, 9, 1, 11) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (9, 9) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (10, 'SLANDER', 'https://i.scdn.co/image/ab6761610000e5eb9b8109ae98ff2e165c89ba72', 596027, 'contact.10@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (4, 'melodic bass') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (5, 'dubstep') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (6, 'future bass') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (7, 'edm') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (10, 'Love Is Gone (Acoustic)', 'Single', '2019-11-13', 'https://i.scdn.co/image/ab67616d0000b2733892a2a2c261629f34bb5536', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (10, 10) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (10, 'Love Is Gone - Acoustic', 176, '/stream/audio_default.mp3', 75, 0.161, 0.935, 0.283, 0.092, '2019-11-13') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (10, 4) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (10, 6) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (10, 10, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (10, 10) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (11, 'Selena Gomez & The Scene', 'https://i.scdn.co/image/469b6a74f5ddca9560e9f5137842e3772c8576c0', 10416656, 'contact.11@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (11, 'When The Sun Goes Down', 'Album', '2011-01-01', 'https://i.scdn.co/image/ab67616d0000b2731c8193de8d62b2ffa49a09db', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (11, 11) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (11, 'Love You Like A Love Song', 188, '/stream/audio_default.mp3', 84, 0.08, 0.113, 0.531, 0.352, '2011-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (11, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (11, 6) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (11, 11, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (11, 11) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (12, 'Delaney Bailey', 'https://i.scdn.co/image/ab6761610000e5eb89415c6dbafb0a674deb07a5', 294480, 'contact.12@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (12, '(i would have followed you)', 'Album', '2022-12-16', 'https://i.scdn.co/image/ab67616d0000b27390cd5ef3c0d264115d0f32f0', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (12, 12) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (12, 'Love Letter From The Sea to The Shore', 191, '/stream/audio_default.mp3', 56, 0.856, 0.407, 0.616, 0.094, '2022-12-16') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (12, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (12, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (12, 12, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (12, 12) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (13, 'Reality Club', 'https://i.scdn.co/image/ab6761610000e5ebd9a9a4eb30f0a26c250e47e1', 645788, 'contact.13@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (8, 'indonesian indie') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (13, 'Reality Club Presents…', 'Album', '2023-05-26', 'https://i.scdn.co/image/ab67616d0000b273c607bcd8355681ab4fac2968', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (13, 13) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (13, 'Love Epiphany', 338, '/stream/audio_default.mp3', 58, 0.886, 0.549, 0.812, 0.357, '2023-05-26') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (13, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (13, 13, 1, 10) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (13, 13) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (14, 'Edison Lighthouse', 'https://i.scdn.co/image/ab6761610000e5ebd4463af78a41ea5b1bd481d7', 68513, 'contact.14@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (14, 'Love Grows (Where My Rosemary Goes) & Other Gems', 'Album', '1970-01-01', 'https://i.scdn.co/image/ab67616d0000b2739a0011cc9d31cf969b656905', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (14, 14) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (14, 'Love Grows (Where My Rosemary Goes)', 174, '/stream/audio_default.mp3', 72, 0.056, 0.637, 0.14, 0.941, '1970-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (14, 6) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (14, 5) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (14, 14, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (14, 14) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (15, 'Little Mix', 'https://i.scdn.co/image/ab6761610000e5eb08cd53940cbf5813ee5fe565', 12327089, 'contact.15@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (15, 'Get Weird (Expanded Edition)', 'Album', '2015-11-06', 'https://i.scdn.co/image/ab67616d0000b273c6e0126da7f7476dd752b926', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (15, 15) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (15, 'Love Me Like You', 197, '/stream/audio_default.mp3', 74, 0.627, 0.506, 0.957, 0.113, '2015-11-06') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (15, 7) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (15, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (15, 15, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (15, 15) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (16, 'Beyoncé', 'https://i.scdn.co/image/ab6761610000e5eb7eaa373538359164b843f7c0', 41384984, 'contact.16@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (16, '4', 'Album', '2011-06-24', 'https://i.scdn.co/image/ab67616d0000b273ff5429125128b43572dbdccd', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (16, 16) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (16, 'Love On Top', 267, '/stream/audio_default.mp3', 74, 0.377, 0.776, 0.082, 0.903, '2011-06-24') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (16, 3) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (16, 6) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (16, 16, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (16, 16) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (17, 'CKay', 'https://i.scdn.co/image/ab6761610000e5eb0c09347b3eb8879406da7dca', 1730684, 'contact.17@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (9, 'afrobeats') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (10, 'afrobeat') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (11, 'afro r&b') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (12, 'afropop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (17, 'CKay The First', 'Album', '2019-08-30', 'https://i.scdn.co/image/ab67616d0000b273405fdad252857e01dbced96a', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (17, 17) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (17, 'love nwantiti (ah ah ah)', 145, '/stream/audio_default.mp3', 76, 0.856, 0.049, 0.66, 0.831, '2019-08-30') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (17, 10) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (17, 9) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (17, 17, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (17, 17) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (18, 'Billie Eilish', 'https://i.scdn.co/image/ab6761610000e5eb4a21b4760d2ecb7b0dcdc8da', 119716727, 'contact.18@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (18, 'Giving you all you want and more', 'Compilation', '2021-10-05', 'https://i.scdn.co/image/ab67616d0000b27314dcfb7581bf14f6ce8e6d67', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (18, 18) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (18, 'lovely', 200, '/stream/audio_default.mp3', 61, 0.342, 0.064, 0.724, 0.476, '2021-10-05') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (18, 2) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (18, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (18, 18, 1, 15) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (18, 18) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (19, 'The Cardigans', 'https://i.scdn.co/image/ab6761610000e5eb4458cf04006a95a1afa067f0', 1690913, 'contact.19@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (13, 'swedish pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (19, 'First Band On The Moon (Remastered)', 'Album', '1996-01-01', 'https://i.scdn.co/image/ab67616d0000b2730aac8ca880151fda470e91af', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (19, 19) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (19, 'Lovefool', 193, '/stream/audio_default.mp3', 83, 0.304, 0.996, 0.354, 0.468, '1996-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (19, 13) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (19, 19, 1, 7) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (19, 19) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (20, 'BJ Lips', 'https://i.scdn.co/image/ab6761610000e5eb84848d263662f164b2d3d37c', 169951, 'contact.20@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (20, 'Cum n Cocaine', 'Single', '2021-08-02', 'https://i.scdn.co/image/ab67616d0000b273afe31aa89995bd44ba17457d', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (20, 20) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (20, 'Love Potions', 173, '/stream/audio_default.mp3', 78, 0.869, 0.277, 0.337, 0.778, '2021-08-02') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (20, 12) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (20, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (20, 20, 1, 5) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (20, 20) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (21, 'LOVELI LORI', 'https://i.scdn.co/image/ab6761610000e5ebae07056ccd6afb4cb53deef4', 213521, 'contact.21@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (21, 'Love For You', 'Single', '2022-05-21', 'https://i.scdn.co/image/ab67616d0000b27374a94c8c0c6b1e9f38ff7cfe', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (21, 21) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (21, 'Love For You', 170, '/stream/audio_default.mp3', 76, 0.503, 0.347, 0.199, 0.106, '2022-05-21') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (21, 4) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (21, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (21, 21, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (21, 21) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (22, 'Woza Logan', 'https://i.scdn.co/image/ab6761610000e5ebd9038398713e24bcbdb4602c', 697, 'contact.22@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (14, 'gqom') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (15, 'amapiano') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (22, 'Love - Amapiano Remix', 'Single', '2025-01-06', 'https://i.scdn.co/image/ab67616d0000b273d55bd2fde9c2a40387347326', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (22, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (22, 'Love - Amapiano Remix', 347, '/stream/audio_default.mp3', 50, 0.167, 0.75, 0.727, 0.589, '2025-01-06') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (22, 14) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (22, 15) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (22, 22, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (22, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (23, 'love nwantiti (feat. Dj Yo! & AX''EL) [Remix]', 'Single', '2021-09-09', 'https://i.scdn.co/image/ab67616d0000b27339bb326b58346f99b8692745', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (17, 23) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (23, 'love nwantiti (feat. Dj Yo! & AX''EL) - Remix', 188, '/stream/audio_default.mp3', 73, 0.263, 0.322, 0.19, 0.069, '2021-09-09') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (23, 11) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (23, 12) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (23, 23, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (17, 23) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (23, 'MeloMance', 'https://i.scdn.co/image/ab6761610000e5eba0e601a6151cf62e4ff2ced2', 397198, 'contact.23@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (24, 'Love, Maybe (A Business Proposal OST Special Track)', 'Single', '2022-02-18', 'https://i.scdn.co/image/ab67616d0000b27347d4fcf597d9aee2d5a34e8e', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (23, 24) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (24, 'Love, Maybe', 185, '/stream/audio_default.mp3', 68, 0.296, 0.488, 0.53, 0.674, '2022-02-18') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (24, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (24, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (24, 24, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (23, 24) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (24, 'Queen', 'https://i.scdn.co/image/b040846ceba13c3e9c125d68389491094e7f2982', 55453661, 'contact.24@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (16, 'classic rock') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (17, 'rock') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (18, 'glam rock') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (25, 'In Love', 'Compilation', '2017-02-10', 'https://i.scdn.co/image/ab67616d0000b2730bbcf6b2907196b95a3d0c38', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (24, 25) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (25, 'Love Of My Life', 217, '/stream/audio_default.mp3', 50, 0.898, 0.036, 0.62, 0.804, '2017-02-10') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (25, 17) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (25, 18) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (25, 25, 2, 11) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (24, 25) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (25, 'Lexz', 'https://i.scdn.co/image/ab6761610000e5ebd043eac149a5f3e13f18e742', 17057, 'contact.25@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (26, 'Love Story (Slowed & Reverb)', 'Single', '2022-11-10', 'https://i.scdn.co/image/ab67616d0000b273eb5476754e53fda9feb40458', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (25, 26) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (26, 'Love Story - Slowed & Reverb', 295, '/stream/audio_default.mp3', 58, 0.652, 0.464, 0.383, 0.762, '2022-11-10') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (26, 9) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (26, 17) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (26, 26, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (25, 26) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (26, 'Ellie Goulding', 'https://i.scdn.co/image/ab6761610000e5eb69266d088d2ab5c74e028863', 13272083, 'contact.26@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (27, 'Delirium (Deluxe)', 'Album', '2015-11-06', 'https://i.scdn.co/image/ab67616d0000b2736bdee14242f244d9d6ddf2fd', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (26, 27) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (27, 'Love Me Like You Do - From "Fifty Shades Of Grey"', 252, '/stream/audio_default.mp3', 78, 0.281, 0.127, 0.377, 0.875, '2015-11-06') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (27, 17) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (27, 18) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (27, 27, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (26, 27) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (27, 'Taylor Swift', 'https://i.scdn.co/image/ab6761610000e5ebe2e8e7ff002a4afda1c7147e', 146900170, 'contact.27@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (28, 'Fearless (Big Machine Radio Release Special)', 'Album', '2008-11-11', 'https://i.scdn.co/image/ab67616d0000b27360cb9332e8c8c7d8e50854b3', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (27, 28) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (28, 'Love Story', 236, '/stream/audio_default.mp3', 76, 0.942, 0.226, 0.336, 0.388, '2008-11-11') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (28, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (28, 13) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (28, 28, 1, 6) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (27, 28) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (28, 'TV Girl', 'https://i.scdn.co/image/ab6761610000e5ebd80695211689a9c8c3fee3b0', 12789946, 'contact.28@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (29, 'French Exit', 'Album', '2014-06-05', 'https://i.scdn.co/image/ab67616d0000b273e1bc1af856b42dd7fdba9f84', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (28, 29) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (29, 'Lovers Rock', 213, '/stream/audio_default.mp3', 87, 0.437, 0.796, 0.638, 0.627, '2014-06-05') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (29, 5) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (29, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (29, 29, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (28, 29) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (29, 'Kendrick Lamar', 'https://i.scdn.co/image/ab6761610000e5eb39ba6dcd4355c03de0b50918', 45023550, 'contact.29@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (19, 'hip hop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (20, 'west coast hip hop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (30, 'DAMN.', 'Album', '2017-04-14', 'https://i.scdn.co/image/ab67616d0000b2738b52c6b9bc4e43d873869699', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (29, 30) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (30, 'LOVE. FEAT. ZACARI.', 213, '/stream/audio_default.mp3', 83, 0.819, 0.361, 0.08, 0.761, '2017-04-14') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (30, 19) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (30, 20) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (30, 30, 1, 10) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (29, 30) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (30, 'Justin Bieber', 'https://i.scdn.co/image/ab6761610000e5ebaf20f7db5288bce9beede034', 85439022, 'contact.30@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (31, 'My World', 'Album', '2009-01-01', 'https://i.scdn.co/image/ab67616d0000b2737c3bb9f74a98f60bdda6c9a7', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (30, 31) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (31, 'Love Me', 191, '/stream/audio_default.mp3', 69, 0.443, 0.977, 0.215, 0.805, '2009-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (31, 13) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (31, 7) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (31, 31, 1, 7) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (30, 31) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (31, 'iKON', 'https://i.scdn.co/image/ab6761610000e5eb8eb5e57e526ceb14f06ea203', 3592128, 'contact.31@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (32, 'Return', 'Album', '2018-01-25', 'https://i.scdn.co/image/ab67616d0000b27348f4704427189fe1957d2871', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (31, 32) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (32, 'LOVE SCENARIO', 209, '/stream/audio_default.mp3', 70, 0.478, 0.619, 0.548, 0.969, '2018-01-25') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (32, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (32, 32, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (31, 32) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (32, 'Indila', 'https://i.scdn.co/image/ab6761610000e5eb6cd07d169e7e2ec94193a1d2', 2579892, 'contact.32@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (21, 'french pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (33, 'Mini World (Deluxe)', 'Album', '2014-11-17', 'https://i.scdn.co/image/ab67616d0000b273eb5b8d192f9b4dfc67e4834d', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (32, 33) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (33, 'Love Story - Version Orchestrale', 297, '/stream/audio_default.mp3', 66, 0.695, 0.716, 0.873, 0.557, '2014-11-17') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (33, 21) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (33, 33, 1, 14) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (32, 33) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (34, 'Fearless (Taylor''s Version)', 'Album', '2021-04-09', 'https://i.scdn.co/image/ab67616d0000b273a48964b5d9a3d6968ae3e0de', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (27, 34) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (34, 'Love Story (Taylor’s Version)', 235, '/stream/audio_default.mp3', 75, 0.395, 0.5, 0.103, 0.104, '2021-04-09') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (34, 7) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (34, 21) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (34, 34, 1, 3) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (27, 34) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (33, 'The Walters', 'https://i.scdn.co/image/ab6761610000e5ebb63c6c447c9c484c6e87d509', 1062601, 'contact.33@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (35, 'I Love You So', 'Single', '2014-11-28', 'https://i.scdn.co/image/ab67616d0000b2739214ff0109a0e062f8a6cf0f', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (33, 35) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (35, 'I Love You So', 160, '/stream/audio_default.mp3', 87, 0.811, 0.229, 0.067, 0.334, '2014-11-28') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (35, 4) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (35, 20) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (35, 35, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (33, 35) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (34, 'Mitski', 'https://i.scdn.co/image/ab6761610000e5eb4bdb3888818637acb71c4a13', 11124491, 'contact.34@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (36, 'The Land Is Inhospitable and So Are We', 'Album', '2023-09-15', 'https://i.scdn.co/image/ab67616d0000b27334f21d3047d85440dfa37f10', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (34, 36) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (36, 'My Love Mine All Mine', 137, '/stream/audio_default.mp3', 87, 0.887, 0.573, 0.793, 0.543, '2023-09-15') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (36, 10) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (36, 16) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (36, 36, 1, 7) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (34, 36) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (35, 'Vierra', 'https://i.scdn.co/image/ab6761610000e5ebce05aec92bc5b3e81205ff73', 2488673, 'contact.35@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (22, 'indonesian pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (37, 'Love, Love & Love', 'Album', '2011-02-01', 'https://i.scdn.co/image/ab67616d0000b27318c5ae00eb3bee52e169d232', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (35, 37) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (37, 'Terlalu Lama', 247, '/stream/audio_default.mp3', 76, 0.66, 0.264, 0.017, 0.186, '2011-02-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (37, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (37, 37, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (35, 37) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (36, 'Monotone Gift', 'https://i.scdn.co/image/ab6742d3000053b7fa659bc7be038134fc2be2b3', 7, 'contact.36@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (38, 'รักคือ...', 'Single', '2004-01-01', 'https://i.scdn.co/image/ab6742d3000053b7fa659bc7be038134fc2be2b3', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (36, 38) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (38, 'รักคือ...', 220, '/stream/audio_default.mp3', 21, 0.601, 0.587, 0.603, 0.279, '2004-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (38, 6) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (38, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (38, 38, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (36, 38) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (37, 'Imagine Dragons', 'https://i.scdn.co/image/ab6761610000e5ebab47d8dae2b24f5afe7f9d38', 58554322, 'contact.37@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (39, 'Love Of Mine', 'Single', '2022-09-01', 'https://i.scdn.co/image/ab6742d3000053b7b241b2f69a9086e1764cfc64', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (37, 39) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (39, 'Love Of Mine', 250, '/stream/audio_default.mp3', 19, 0.06, 0.719, 0.645, 0.008, '2022-09-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (39, 3) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (39, 21) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (39, 39, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (37, 39) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (38, 'Céline Dion', 'https://i.scdn.co/image/ab6761610000e5ebc3b380448158e7b6e5863cde', 10412991, 'contact.38@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (23, 'variété française') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (40, 'Loved Me Back to Life (Live in Quebec City)', 'Single', '2013-09-17', 'https://i.scdn.co/image/ab6742d3000053b74eedab8aa8b8c6ffc2fb8e32', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (38, 40) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (40, 'Loved Me Back to Life - Live in Quebec City', 235, '/stream/audio_default.mp3', 5, 0.895, 0.788, 0.124, 0.831, '2013-09-17') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (40, 23) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (40, 40, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (38, 40) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (39, 'Sody', 'https://i.scdn.co/image/ab6761610000e5eb0a6460f02b3e357370501916', 175902, 'contact.39@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (41, 'Love''s a Waste (feat. James Smith) [Live at Metropolis, London, 2020]', 'Single', '2020-02-14', 'https://i.scdn.co/image/ab6742d3000053b76a19e49e9db09896ab125a07', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (39, 41) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (41, 'Love''s a Waste (feat. James Smith) - Live at Metropolis, London, 2020', 232, '/stream/audio_default.mp3', 3, 0.264, 0.669, 0.802, 0.682, '2020-02-14') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (41, 10) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (41, 5) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (41, 41, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (39, 41) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (42, 'Love Me Like You (Live from The Get Weird Tour: Wembley Arena, 2016)', 'Single', '2016-01-01', 'https://i.scdn.co/image/ab67616d0000b27354ae9131dca8aa2e14bc4309', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (15, 42) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (42, 'Love Me Like You - Live from The Get Weird Tour: Wembley Arena, 2016', 295, '/stream/audio_default.mp3', 4, 0.796, 0.03, 0.688, 0.087, '2016-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (42, 19) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (42, 13) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (42, 42, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (15, 42) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (40, 'Nirvana', 'https://i.scdn.co/image/84282c28d851a700132356381fcfbadc67ff498b', 23618098, 'contact.40@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (24, 'grunge') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (43, 'Love Buzz (1992/Live at Reading)', 'Single', '2009-01-01', 'https://i.scdn.co/image/ab6742d3000053b73999ef916f6bb61b2a94bb33', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (40, 43) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (43, 'Love Buzz - Live At Reading, 1992', 231, '/stream/audio_default.mp3', 11, 0.62, 0.16, 0.905, 0.27, '2009-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (43, 24) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (43, 17) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (43, 43, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (40, 43) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (41, 'SEU Worship', 'https://i.scdn.co/image/ab6761610000e5ebec3b45dab30f22021ec19f51', 199035, 'contact.41@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (25, 'worship') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (26, 'christian') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (27, 'christian pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (44, 'Love Like You (feat. Kenzie Walker) [Live]', 'Single', '2020-07-31', 'https://i.scdn.co/image/ab6742d3000053b787d17907544797de345be1c5', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (41, 44) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (44, 'Love Like You (feat. Kenzie Walker) - Live', 282, '/stream/audio_default.mp3', 0, 0.017, 0.578, 0.321, 0.827, '2020-07-31') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (44, 26) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (44, 25) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (44, 44, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (41, 44) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (42, 'Ravyn Lenae', 'https://i.scdn.co/image/ab6761610000e5eb138d70fe372dedacdca53b61', 875307, 'contact.42@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (28, 'alternative r&b') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (29, 'indie soul') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (45, 'Bird''s Eye', 'Album', '2024-08-09', 'https://i.scdn.co/image/ab67616d0000b273ef985ba96e76a9574cc68a30', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (42, 45) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (45, 'Love Me Not', 213, '/stream/audio_default.mp3', 89, 0.832, 0.226, 0.646, 0.636, '2024-08-09') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (45, 29) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (45, 28) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (45, 45, 1, 7) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (42, 45) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (43, 'Bibio', 'https://i.scdn.co/image/ab6761610000e5ebc6f8c3e1e5db20e02a26bcf2', 276061, 'contact.43@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (30, 'ambient folk') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (31, 'downtempo') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (46, 'lovers'' carvings (Live Acoustic)', 'Single', '2009-06-22', 'https://i.scdn.co/image/ab6742d3000053b71f35755543c12c138cf742a2', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (43, 46) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (46, 'lovers’ carvings - Live Acoustic', 170, '/stream/audio_default.mp3', 7, 0.185, 0.327, 0.116, 0.261, '2009-06-22') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (46, 30) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (46, 31) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (46, 46, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (43, 46) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (44, 'Jamiroquai', 'https://i.scdn.co/image/ab6761610000e5eb7e6dca959714339b69e9718d', 2779061, 'contact.44@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (32, 'acid jazz') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (47, 'Love Foolosophy (Live in Verona)', 'Single', '2002-01-01', 'https://i.scdn.co/image/ab6742d3000053b7e1cddc4aaa85f30ea2a134f1', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (44, 47) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (47, 'Love Foolosophy - Live in Verona', 462, '/stream/audio_default.mp3', 17, 0.25, 0.362, 0.384, 0.553, '2002-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (47, 32) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (47, 47, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (44, 47) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (45, 'Tungevaag', 'https://i.scdn.co/image/ab6761610000e5eb234623bc1c596eb2f3d94180', 176031, 'contact.45@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (33, 'big room') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (48, 'Love Me Anyway', 'Single', '2022-07-22', 'https://i.scdn.co/image/ab6742d3000053b7ac0427bdec757e1e00ba5775', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (45, 48) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (48, 'Love Me Anyway', 163, '/stream/audio_default.mp3', 2, 0.793, 0.215, 0.713, 0.675, '2022-07-22') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (48, 33) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (48, 48, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (45, 48) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (46, 'The Corrs', 'https://i.scdn.co/image/ab6761610000e5ebde0ef21e54809a4c88a81ab6', 1271944, 'contact.46@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (34, 'celtic rock') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (49, 'Love to Love You (Live at Royal Albert Hall)', 'Single', '2000-01-01', 'https://i.scdn.co/image/ab6742d3000053b7677908f7deca10b5e20d29bf', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (46, 49) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (49, 'Love to Love You - Live at Royal Albert Hall', 241, '/stream/audio_default.mp3', 6, 0.804, 0.898, 0.654, 0.764, '2000-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (49, 34) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (49, 49, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (46, 49) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (47, 'Elvis Presley', 'https://i.scdn.co/image/ab6761610000e5eb9a93e273380982dff84c0d7c', 11071673, 'contact.47@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (35, 'rockabilly') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (36, 'rock and roll') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (50, 'Love Me (Live On The Ed Sullivan Show, October 28, 1956)', 'Single', '1956-10-28', 'https://i.scdn.co/image/ab6742d3000053b71d183a42e910f224ece8566f', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (47, 50) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (50, 'Love Me - Live On The Ed Sullivan Show, October 28, 1956', 188, '/stream/audio_default.mp3', 6, 0.536, 0.83, 0.283, 0.515, '1956-10-28') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (50, 36) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (50, 35) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (50, 50, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (47, 50) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (51, 'Fearless (Taylor’s Version)', 241, '/stream/audio_default.mp3', 73, 0.545, 0.07, 0.082, 0.397, '2021-04-09') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (51, 5) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (51, 6) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (34, 51, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (27, 51) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (48, 'Nujabes', 'https://i.scdn.co/image/ab6761610000e5eb57f19d2f179b00207bfb3155', 1555885, 'contact.48@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (37, 'jazz rap') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (51, 'Modal Soul', 'Album', '2005-11-11', 'https://i.scdn.co/image/ab67616d0000b273912cc8fe2e9a53d328757a41', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (48, 51) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (52, 'Feather (feat. Cise Starr & Akin from CYNE)', 175, '/stream/audio_default.mp3', 68, 0.933, 0.782, 0.392, 0.727, '2005-11-11') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (52, 37) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (51, 52, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (48, 52) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (49, '.Feast', 'https://i.scdn.co/image/ab6761610000e5eb16f030ca05d4d917cdc2eb5e', 5100085, 'contact.49@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (38, 'indonesian rock') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (39, 'indorock') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (52, 'Membangun & Menghancurkan', 'Album', '2024-08-30', 'https://i.scdn.co/image/ab67616d0000b273c800b90e2092a5328f699117', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (49, 52) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (53, 'Arteri', 270, '/stream/audio_default.mp3', 67, 0.024, 0.482, 0.175, 0.363, '2024-08-30') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (53, 38) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (53, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (52, 53, 1, 4) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 53) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (50, 'Nicky Jam', 'https://i.scdn.co/image/ab6761610000e5eb45780f160ed896e42b6d17b0', 20708998, 'contact.50@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (40, 'reggaeton') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (41, 'latin') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (53, 'X (feat. Maluma & Ozuna) [Remix]', 'Single', '2018-06-29', 'https://i.scdn.co/image/ab67616d0000b2734b1734e4d48786063992ce04', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (50, 53) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (54, 'X (feat. Maluma & Ozuna) - Remix', 236, '/stream/audio_default.mp3', 80, 0.853, 0.813, 0.756, 0.155, '2018-06-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (54, 40) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (54, 41) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (53, 54, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (50, 54) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (51, 'Hindia', 'https://i.scdn.co/image/ab6761610000e5eb8022c4a018990cd93a9ddfe0', 11551080, 'contact.51@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (54, 'Lagipula Hidup Akan Berakhir', 'Album', '2023-07-21', 'https://i.scdn.co/image/ab67616d0000b27349bdf0e981cbba25d48b44e0', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (51, 54) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (55, 'Berdansalah, Karir Ini Tak Ada Artinya', 224, '/stream/audio_default.mp3', 75, 0.651, 0.45, 0.112, 0.669, '2023-07-21') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (55, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (55, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (54, 55, 2, 12) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 55) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (55, 'Tarian Penghancur Raya', 'Single', '2019-11-08', 'https://i.scdn.co/image/ab67616d0000b273bf3e3b7cec2030618845107b', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (49, 55) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (56, 'Tarian Penghancur Raya', 240, '/stream/audio_default.mp3', 63, 0.954, 0.766, 0.357, 0.758, '2019-11-08') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (56, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (56, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (55, 56, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 56) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (52, 'Sabrina Carpenter', 'https://i.scdn.co/image/ab6761610000e5eb78e45cfa4697ce3c437cb455', 27207975, 'contact.52@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (56, 'Manchild', 'Single', '2025-06-05', 'https://i.scdn.co/image/ab67616d0000b273062c6573009fdebd43de443b', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 56) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (57, 'Manchild', 213, '/stream/audio_default.mp3', 86, 0.229, 0.359, 0.001, 0.434, '2025-06-05') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (57, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (56, 57, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 57) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (57, 'emails i can''t send', 'Album', '2022-07-15', 'https://i.scdn.co/image/ab67616d0000b273700f7bf79c9f063ad0362bdf', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 57) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (58, 'Nonsense', 163, '/stream/audio_default.mp3', 84, 0.832, 0.157, 0.594, 0.237, '2022-07-15') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (58, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (57, 58, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 58) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (58, 'Espresso', 'Single', '2024-04-12', 'https://i.scdn.co/image/ab67616d0000b273659cd4673230913b3918e0d5', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 58) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (59, 'Espresso', 175, '/stream/audio_default.mp3', 85, 0.122, 0.581, 0.599, 0.792, '2024-04-12') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (59, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (58, 59, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 59) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (59, 'Feather (Sped Up)', 'Single', '2023-08-04', 'https://i.scdn.co/image/ab67616d0000b27320bc45d92ee8e4e2097ed635', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 59) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (60, 'Feather - Sped Up', 153, '/stream/audio_default.mp3', 51, 0.403, 0.321, 0.243, 0.824, '2023-08-04') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (60, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (59, 60, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 60) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (60, 'Abdi Lara Insani', 'Album', '2022-04-22', 'https://i.scdn.co/image/ab67616d0000b273471f8a4822a3ca180612d006', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (49, 60) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (61, 'Gugatan Rakyat Semesta', 266, '/stream/audio_default.mp3', 62, 0.091, 0.259, 0.408, 0.256, '2022-04-22') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (61, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (61, 38) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (60, 61, 1, 5) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 61) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (61, 'Short n'' Sweet', 'Album', '2024-08-23', 'https://i.scdn.co/image/ab67616d0000b273fd8d7a8d96871e791cb1f626', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 61) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (62, 'Taste', 157, '/stream/audio_default.mp3', 87, 0.06, 0.636, 0.709, 0.759, '2024-08-23') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (62, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (61, 62, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 62) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (53, 'Lost Sky', 'https://i.scdn.co/image/ab6761610000e5ebc5a27c631d60a8b0c99eff59', 353718, 'contact.53@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (62, 'Fearless Pt. II', 'Single', '2017-12-23', 'https://i.scdn.co/image/ab67616d0000b273df7c14e866cf14a259563ca1', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (53, 62) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (63, 'Fearless Pt. II', 194, '/stream/audio_default.mp3', 68, 0.834, 0.771, 0.504, 0.864, '2017-12-23') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (63, 21) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (63, 2) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (62, 63, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (53, 63) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (63, 'Please Please Please', 'Single', '2024-06-06', 'https://i.scdn.co/image/ab67616d0000b273de84adf0e48248ea2d769c3e', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (52, 63) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (64, 'Please Please Please', 186, '/stream/audio_default.mp3', 79, 0.058, 0.27, 0.247, 0.001, '2024-06-06') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (64, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (63, 64, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 64) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (64, 'Peradaban', 'Single', '2018-07-13', 'https://i.scdn.co/image/ab67616d0000b273a8701a073f15323f29e39d56', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (49, 64) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (65, 'Peradaban', 339, '/stream/audio_default.mp3', 73, 0.729, 0.947, 0.831, 0.296, '2018-07-13') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (65, 39) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (65, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (64, 65, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 65) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (66, 'Bintang Massa Aksi', 214, '/stream/audio_default.mp3', 58, 0.746, 0.071, 0.744, 0.78, '2022-04-22') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (66, 39) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (66, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (60, 66, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 66) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (54, 'Wale', 'https://i.scdn.co/image/ab6761610000e5eb273bdadffd7138dcbd7b79c3', 4302565, 'contact.54@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (65, 'The Gifted', 'Album', '2013-06-25', 'https://i.scdn.co/image/ab67616d0000b273af4a0e9eaf7a6f4ecaed385f', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (54, 65) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (67, 'Bad (feat. Rihanna) - Remix', 238, '/stream/audio_default.mp3', 80, 0.407, 0.147, 0.428, 0.401, '2013-06-25') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (67, 34) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (67, 9) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (65, 67, 1, 10) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (54, 67) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (66, 'Berita Kehilangan', 'Single', '2018-08-10', 'https://i.scdn.co/image/ab67616d0000b2732692d77a74b0da1756009e98', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (49, 66) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (68, 'Berita Kehilangan', 259, '/stream/audio_default.mp3', 66, 0.767, 0.678, 0.038, 0.021, '2018-08-10') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (68, 38) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (68, 39) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (66, 68, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 68) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (67, 'Lagipula Hidup Akan Berakhir', 'Album', '2023-07-07', 'https://i.scdn.co/image/ab67616d0000b273d58121433ea3e6c4822ac494', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (51, 67) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (69, 'Cincin', 266, '/stream/audio_default.mp3', 83, 0.142, 0.182, 0.764, 0.923, '2023-07-07') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (69, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (69, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (67, 69, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 69) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (70, 'Kita Ke Sana', 282, '/stream/audio_default.mp3', 78, 0.684, 0.633, 0.244, 0.747, '2023-07-21') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (70, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (70, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (54, 70, 2, 11) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 70) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (71, 'Bed Chem', 171, '/stream/audio_default.mp3', 83, 0.124, 0.254, 0.29, 0.08, '2024-08-23') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (71, 3) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (61, 71, 1, 6) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (52, 71) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (68, 'Menari Dengan Bayangan', 'Album', '2019-11-29', 'https://i.scdn.co/image/ab67616d0000b273d623688488865906052ef96b', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (51, 68) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (72, 'Secukupnya', 205, '/stream/audio_default.mp3', 77, 0.647, 0.661, 0.153, 0.888, '2019-11-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (72, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (72, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (68, 72, 1, 8) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 72) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (73, 'Rumah Ke Rumah', 277, '/stream/audio_default.mp3', 82, 0.057, 0.905, 0.967, 0.931, '2019-11-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (73, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (73, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (68, 73, 1, 12) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 73) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (74, 'Cincin', 266, '/stream/audio_default.mp3', 57, 0.64, 0.119, 0.36, 0.15, '2023-07-21') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (74, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (74, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (54, 74, 1, 9) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 74) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (75, 'Evaluasi', 194, '/stream/audio_default.mp3', 79, 0.03, 0.398, 0.453, 0.208, '2019-11-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (75, 22) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (75, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (68, 75, 1, 15) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (51, 75) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (76, 'Nina', 277, '/stream/audio_default.mp3', 80, 0.673, 0.096, 0.593, 0.108, '2024-08-30') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (76, 8) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (76, 39) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (52, 76, 1, 8) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (49, 76) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (55, 'Bazzi', 'https://i.scdn.co/image/ab6761610000e5eb901476fdd0fd274362d445db', 5512461, 'contact.55@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (69, 'Beautiful (feat. Camila Cabello)', 'Single', '2018-08-02', 'https://i.scdn.co/image/ab67616d0000b27305559264ebef3889709826cf', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (55, 69) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (77, 'Beautiful (feat. Camila Cabello)', 180, '/stream/audio_default.mp3', 74, 0.853, 0.761, 0.133, 0.394, '2018-08-02') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (77, 1) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (77, 21) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (69, 77, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (55, 77) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (56, 'Melly Goeslaw', 'https://i.scdn.co/image/ab6761610000e5eb92e8b7d478b17586c9329a60', 1516832, 'contact.56@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (42, 'malay') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (43, 'malay pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (70, 'Melly', 'Album', '1999-11-26', 'https://i.scdn.co/image/ab67616d0000b273a6bce4cd942caea821e1ba76', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (56, 70) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (78, 'Jika (feat. Ari Lasso)', 324, '/stream/audio_default.mp3', 63, 0.184, 0.002, 0.888, 0.346, '1999-11-26') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (78, 42) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (78, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (70, 78, 1, 4) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (56, 78) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (57, 'Judika', 'https://i.scdn.co/image/ab6761610000e5eb182818f4b3724670f8c5e9f5', 7004398, 'contact.57@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (71, 'Judika Mencari Cinta', 'Album', '2013-05-13', 'https://i.scdn.co/image/ab67616d0000b273a37335873ed72dc558ec6889', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (57, 71) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (79, 'Sampai Akhir (feat. DuMa)', 205, '/stream/audio_default.mp3', 71, 0.47, 0.614, 0.509, 0.826, '2013-05-13') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (79, 42) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (79, 43) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (71, 79, 1, 14) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (57, 79) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (58, 'Jennifer Lopez', 'https://i.scdn.co/image/ab6761610000e5eb48e24f77a03f78a00cfda0bb', 13748794, 'contact.58@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (72, 'Love?', 'Album', '2011-04-29', 'https://i.scdn.co/image/ab67616d0000b273d7b2aa3834b82b1cbe899a48', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (58, 72) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (80, 'On The Floor', 284, '/stream/audio_default.mp3', 82, 0.536, 0.61, 0.583, 0.73, '2011-04-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (80, 36) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (80, 20) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (72, 80, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (58, 80) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (59, 'Al-Ghazali', 'https://i.scdn.co/image/ab67616d0000b273c2737e0f45f4cc433ba69b11', 68752, 'contact.59@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (73, 'Kesayanganku (feat. Chelsea Shania) [From "Samudra Cinta"]', 'Single', '2020-01-10', 'https://i.scdn.co/image/ab67616d0000b273c2737e0f45f4cc433ba69b11', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (59, 73) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (81, 'Kesayanganku (feat. Chelsea Shania) [From "Samudra Cinta"]', 242, '/stream/audio_default.mp3', 67, 0.923, 0.377, 0.777, 0.864, '2020-01-10') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (81, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (73, 81, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (59, 81) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (60, 'The Weeknd', 'https://i.scdn.co/image/ab6761610000e5eb9e528993a2820267b97f6aae', 114242793, 'contact.60@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (74, 'Hurry Up Tomorrow', 'Album', '2025-01-31', 'https://i.scdn.co/image/ab67616d0000b273982320da137d0de34410df61', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (60, 74) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (82, 'Timeless (feat Playboi Carti)', 256, '/stream/audio_default.mp3', 91, 0.597, 0.565, 0.583, 0.299, '2025-01-31') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (82, 10) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (82, 35) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (74, 82, 1, 13) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (60, 82) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (61, 'Kahitna', 'https://i.scdn.co/image/ab6761610000e5ebe8b3eb71335b453ac794067e', 1294721, 'contact.61@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (44, 'indonesian jazz') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (75, 'Titik Nadir', 'Single', '2025-06-24', 'https://i.scdn.co/image/ab67616d0000b2735cfcb24701901b0e53ce4fae', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (61, 75) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (83, 'Titik Nadir (feat. Monita Tahalea)', 245, '/stream/audio_default.mp3', 73, 0.647, 0.931, 0.833, 0.891, '2025-06-24') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (83, 44) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (83, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (75, 83, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (61, 83) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (62, 'Lana Del Rey', 'https://i.scdn.co/image/ab6761610000e5ebb99cacf8acd5378206767261', 52502926, 'contact.62@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (76, 'Did you know that there''s a tunnel under Ocean Blvd', 'Album', '2023-03-24', 'https://i.scdn.co/image/ab67616d0000b27359ae8cf65d498afdd5585634', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (62, 76) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (84, 'Margaret (feat. Bleachers)', 339, '/stream/audio_default.mp3', 81, 0.764, 0.278, 0.586, 0.179, '2023-03-24') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (84, 29) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (84, 26) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (76, 84, 1, 13) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (62, 84) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (63, 'Clean Bandit', 'https://i.scdn.co/image/ab6761610000e5eb70d80b8ab8e193aef64223ec', 6004496, 'contact.63@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (77, 'What Is Love? (Deluxe Edition)', 'Album', '2018-11-30', 'https://i.scdn.co/image/ab67616d0000b2735c66e925d8fe4c92ebfb49ed', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (63, 77) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (85, 'Rockabye (feat. Sean Paul & Anne-Marie)', 251, '/stream/audio_default.mp3', 79, 0.455, 0.404, 0.908, 0.942, '2018-11-30') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (85, 15) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (85, 30) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (77, 85, 1, 4) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (63, 85) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (64, 'Daniel Caesar', 'https://i.scdn.co/image/ab6761610000e5ebe4d94f7cbebb17504c25d419', 11472410, 'contact.64@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (78, 'Freudian', 'Album', '2017-08-25', 'https://i.scdn.co/image/ab67616d0000b27305ac3e026324594a31fad7fb', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (64, 78) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (86, 'Best Part (feat. H.E.R.)', 209, '/stream/audio_default.mp3', 86, 0.55, 0.965, 0.494, 0.149, '2017-08-25') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (86, 26) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (86, 19) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (78, 86, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (64, 86) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (65, 'Rombongan Bodonk Koplo', 'https://i.scdn.co/image/ab6761610000e5eb20ca1bfde697b09680fd7347', 39789, 'contact.65@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (45, 'hipdut') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (46, 'lagu timur') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (47, 'dangdut') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (48, 'koplo') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (49, 'funkot') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (79, 'Calon Mantu Idaman (feat. Ncum)', 'Single', '2025-05-16', 'https://i.scdn.co/image/ab67616d0000b2732120cd815e807ae193648e7e', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (65, 79) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (87, 'Calon Mantu Idaman (feat. Ncum)', 189, '/stream/audio_default.mp3', 77, 0.419, 0.791, 0.587, 0.701, '2025-05-16') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (87, 45) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (87, 49) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (79, 87, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (65, 87) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (80, 'BIRDS OF A FEATHER (ISOLATED VOCALS/Visualizer)', 'Single', '2024-09-25', 'https://i.scdn.co/image/ab6742d3000053b73caba4166f723ff8af50d77c', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (18, 80) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (88, 'BIRDS OF A FEATHER - ISOLATED VOCALS/Visualizer', 210, '/stream/audio_default.mp3', 32, 0.499, 0.879, 0.798, 0.54, '2024-09-25') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (88, 43) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (88, 42) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (80, 88, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (18, 88) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (81, 'Toss the Feathers (Live at Royal Albert Hall)', 'Single', '2000-01-01', 'https://i.scdn.co/image/ab6742d3000053b752720d68948bbe137e18bed8', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (46, 81) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (89, 'Toss the Feathers - Live at Royal Albert Hall', 198, '/stream/audio_default.mp3', 7, 0.673, 0.946, 0.903, 0.884, '2000-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (89, 34) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (81, 89, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (46, 89) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (82, 'To Love You More feat. Taro Hakase (Live in Memphis, 1997)', 'Single', '1998-01-01', 'https://i.scdn.co/image/ab6742d3000053b71b62d7d6dcc92bb6dd39efb5', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (38, 82) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (90, 'To Love You More feat. Taro Hakase (Live in Memphis, 1997)', 311, '/stream/audio_default.mp3', 18, 0.758, 0.484, 0.106, 0.197, '1998-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (90, 23) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (82, 90, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (38, 90) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (66, 'Elevation Worship', 'https://i.scdn.co/image/ab6761610000e5eb6fa137c74960a6a81f11ee70', 5163604, 'contact.66@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (50, 'ccm') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (51, 'gospel') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (52, 'pop worship') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (83, 'Dancing (feat. Joe L Barnes & Tiffany Hudson) [Live]', 'Single', '2022-03-04', 'https://i.scdn.co/image/ab6742d3000053b7f9d7a4f85a5d3eebc67e3a72', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (66, 83) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (91, 'Dancing (feat. Joe L Barnes & Tiffany Hudson) - Live', 304, '/stream/audio_default.mp3', 8, 0.979, 0.081, 0.348, 0.277, '2022-03-04') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (91, 50) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (91, 26) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (83, 91, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (66, 91) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (84, 'Easy (feat. Jonsal Barrientes) [Live]', 'Single', '2024-07-12', 'https://i.scdn.co/image/ab6742d3000053b7012dd917a0314e7b5e8d0dc6', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (66, 84) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (92, 'Easy (feat. Jonsal Barrientes) - Live', 317, '/stream/audio_default.mp3', 9, 0.323, 0.384, 0.951, 0.03, '2024-07-12') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (92, 51) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (92, 26) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (84, 92, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (66, 92) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (67, 'Bring Me The Horizon', 'https://i.scdn.co/image/ab6761610000e5ebe7c9399d0b5d813c20cbec65', 6671498, 'contact.67@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (53, 'metalcore') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (54, 'emo') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (55, 'screamo') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (56, 'post-hardcore') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (85, 'liMOusIne (feat. AURORA) [Live from Japan]', 'Single', '2024-09-27', 'https://i.scdn.co/image/ab6742d3000053b74049f1eb089da6e39e713780', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (67, 85) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (93, 'liMOusIne (feat. AURORA) - Live from Japan', 310, '/stream/audio_default.mp3', 21, 0.293, 0.837, 0.106, 0.635, '2024-09-27') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (93, 55) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (93, 56) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (85, 93, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (67, 93) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (68, 'Bad Bunny', 'https://i.scdn.co/image/ab6761610000e5eb81f47f44084e0a09b5f0fa13', 103722263, 'contact.68@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (57, 'trap latino') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (58, 'urbano latino') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (86, 'MIA (feat. Drake)', 'Single', '2020-01-01', 'https://i.scdn.co/image/ab6742d3000053b733af09e1cbe925d1c71adf24', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (68, 86) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (94, 'MIA (feat. Drake)', 217, '/stream/audio_default.mp3', 35, 0.833, 0.961, 0.42, 0.619, '2020-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (94, 41) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (94, 57) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (86, 94, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (68, 94) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (69, 'BTS', 'https://i.scdn.co/image/ab6761610000e5ebd642648235ebf3460d2d1f6a', 81487075, 'contact.69@label.com') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (87, 'IDOL (feat. Nicki Minaj)', 'Single', '2018-09-07', 'https://i.scdn.co/image/ab6742d3000053b79dbc80140da729e739e98acf', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (69, 87) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (95, 'IDOL (feat. Nicki Minaj)', 286, '/stream/audio_default.mp3', 24, 0.372, 0.285, 0.37, 0.81, '2018-09-07') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (95, 1) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (87, 95, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (69, 95) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (88, 'Runnin (feat. Brandon Lake) [Live]', 'Single', '2023-05-19', 'https://i.scdn.co/image/ab6742d3000053b75173ea02ba931154d48b2f13', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (66, 88) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (96, 'Runnin (feat. Brandon Lake) - Live', 376, '/stream/audio_default.mp3', 21, 0.966, 0.711, 0.966, 0.363, '2023-05-19') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (96, 52) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (96, 50) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (88, 96, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (66, 96) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (70, 'G.E.M.', 'https://i.scdn.co/image/ab6761610000e5eb8b385b6aa7b47570adbeff7b', 3537769, 'contact.70@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (59, 'mandopop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (60, 'c-pop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (61, 'cantopop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (62, 'taiwanese pop') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (63, 'gufeng') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (89, '别勉强 (feat. Eric 周兴哲)', 'Single', '2020-06-29', 'https://i.scdn.co/image/ab6742d3000053b7df2465199311a9818648a284', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (70, 89) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (97, '别勉强 (feat. Eric 周兴哲)', 278, '/stream/audio_default.mp3', 7, 0.22, 0.999, 0.039, 0.382, '2020-06-29') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (97, 59) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (97, 60) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (89, 97, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (70, 97) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (71, 'Illusion Hills', 'https://i.scdn.co/image/ab6761610000e5eb0f87226b7190eec016873fb6', 10274, 'contact.71@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (64, 'hyperpop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (90, 'illusion hills feat KAIRO - so bad (official music video)', 'Single', '2025-02-26', 'https://i.scdn.co/image/ab6742d3000053b79f163b0677aa13df4ea9896f', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (71, 90) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (98, 'illusion hills feat KAIRO - so bad (official music video)', 182, '/stream/audio_default.mp3', 1, 0.672, 0.321, 0.612, 0.055, '2025-02-26') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (98, 64) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (90, 98, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (71, 98) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (72, 'PSYCHIC FEVER from EXILE TRIBE', 'https://i.scdn.co/image/ab6761610000e5eb7e966497c8cfa0b2a0f71a73', 108656, 'contact.72@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (65, 'j-pop') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (91, 'SH♡TGUN feat. JIMMY, WEESA, ぺろぺろきゃんでー', 'Single', '2024-12-27', 'https://i.scdn.co/image/ab6742d3000053b75606a26f0dd447d668dbb5f8', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (72, 91) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (99, 'SH♡TGUN feat. JIMMY, WEESA, ぺろぺろきゃんでー', 184, '/stream/audio_default.mp3', 3, 0.178, 0.393, 0.502, 0.683, '2024-12-27') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (99, 65) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (91, 99, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (72, 99) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS (ARTIST_ID, ARTIST_NAME, ARTIST_PFP, MONTHLY_LISTENER_COUNT, ARTIST_EMAIL) VALUES (73, 'Snarky Puppy', 'https://i.scdn.co/image/ab6761610000e5eb7fcb79b9805f93d9cedb5346', 764233, 'contact.73@label.com') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (66, 'jazz fusion') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (67, 'jazz funk') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (68, 'jazz') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (69, 'funk rock') ON CONFLICT DO NOTHING;
INSERT INTO GENRES (GENRE_ID, GENRE_NAME) VALUES (70, 'nu jazz') ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS (COLLECTION_ID, COLLECTION_TITLE, COLLECTION_TYPE, COLLECTION_RELEASE_DATE, COLLECTION_COVER, ISPRERELEASE) VALUES (92, 'Snarky Puppy feat. KNOWER - One Hope', 'Single', '2016-01-01', 'https://i.scdn.co/image/ab6742d3000053b7b7342edecc85f4756061b05d', FALSE) ON CONFLICT DO NOTHING;
INSERT INTO RELEASES (ARTIST_ID, COLLECTION_ID) VALUES (73, 92) ON CONFLICT DO NOTHING;
INSERT INTO SONGS (SONG_ID, SONG_TITLE, SONG_DURATION, SONG_FILE, POPULARITY, VALENCE, ACCOUSTICNESS, DANCEABILITY, ENERGY, SONG_RELEASE_DATE)
                  VALUES (100, 'Snarky Puppy feat. KNOWER - One Hope', 201, '/stream/audio_default.mp3', 8, 0.732, 0.154, 0.066, 0.099, '2016-01-01') ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (100, 66) ON CONFLICT DO NOTHING;
INSERT INTO SONGS_GENRES (SONG_ID, GENRE_ID) VALUES (100, 70) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTIONS_SONGS (COLLECTION_ID, SONG_ID, NOMOR_DISC, NOMOR_TRACK) VALUES (92, 100, 1, 1) ON CONFLICT DO NOTHING;
INSERT INTO CREATE_SONGS (ARTIST_ID, SONG_ID) VALUES (73, 100) ON CONFLICT DO NOTHING;
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (1, 1, 'Vel quis', TRUE, FALSE, 'My playlist', TRUE, '2025-09-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 34, 1, 1);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 66, 2, 1);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 7, 3, 1);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 88, 4, 1);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 24, 5, 1);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (1, 92, 6, 1);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (2, 2, 'Ut quibusdam quae', TRUE, FALSE, 'My playlist', TRUE, '2025-09-19');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (2, 60, 1, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (2, 22, 2, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (2, 19, 3, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (2, 23, 4, 2);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (3, 2, 'Soluta quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-08-05');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (3, 92, 1, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (3, 59, 2, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (3, 33, 3, 2);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (3, 88, 4, 2);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (4, 3, 'Aliquam magnam', TRUE, FALSE, 'My playlist', TRUE, '2025-09-27');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (4, 55, 1, 3);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (4, 91, 2, 3);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (4, 6, 3, 3);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (4, 13, 4, 3);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (4, 64, 5, 3);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (5, 4, 'Fugit ducimus ratione', TRUE, FALSE, 'My playlist', TRUE, '2025-04-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 43, 1, 4);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 91, 2, 4);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 30, 3, 4);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 22, 4, 4);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 7, 5, 4);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (5, 38, 6, 4);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (6, 5, 'Dignissimos', TRUE, FALSE, 'My playlist', TRUE, '2025-02-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (6, 47, 1, 5);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (6, 44, 2, 5);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (6, 31, 3, 5);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (6, 49, 4, 5);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (7, 6, 'Sapiente tenetur', TRUE, FALSE, 'My playlist', TRUE, '2025-01-14');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (7, 85, 1, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (7, 96, 2, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (7, 74, 3, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (7, 63, 4, 6);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (8, 6, 'Vel maiores nesciunt', TRUE, FALSE, 'My playlist', TRUE, '2025-02-08');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 85, 1, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 97, 2, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 69, 3, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 58, 4, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 1, 5, 6);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (8, 49, 6, 6);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (9, 7, 'Amet odit ab', TRUE, FALSE, 'My playlist', TRUE, '2025-10-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (9, 69, 1, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (9, 39, 2, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (9, 9, 3, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (9, 49, 4, 7);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (10, 7, 'Maiores odio aliquam', TRUE, FALSE, 'My playlist', TRUE, '2025-06-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 68, 1, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 73, 2, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 94, 3, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 67, 4, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 35, 5, 7);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (10, 56, 6, 7);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (11, 8, 'Sequi facilis libero', TRUE, FALSE, 'My playlist', TRUE, '2025-11-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (11, 12, 1, 8);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (11, 39, 2, 8);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (11, 6, 3, 8);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (11, 52, 4, 8);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (12, 8, 'Nostrum nemo quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-06-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (12, 63, 1, 8);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (12, 10, 2, 8);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (12, 79, 3, 8);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (13, 9, 'Quos quas rem', TRUE, FALSE, 'My playlist', TRUE, '2025-05-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 61, 1, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 92, 2, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 53, 3, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 56, 4, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 89, 5, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 7, 6, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 41, 7, 9);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (13, 46, 8, 9);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (14, 10, 'Voluptatibus', TRUE, FALSE, 'My playlist', TRUE, '2025-04-15');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (14, 52, 1, 10);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (14, 13, 2, 10);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (14, 21, 3, 10);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (15, 11, 'Voluptatum nemo', TRUE, FALSE, 'My playlist', TRUE, '2025-06-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (15, 4, 1, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (15, 80, 2, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (15, 30, 3, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (15, 37, 4, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (15, 27, 5, 11);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (16, 11, 'Animi quae', TRUE, FALSE, 'My playlist', TRUE, '2025-03-03');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (16, 41, 1, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (16, 15, 2, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (16, 83, 3, 11);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (16, 13, 4, 11);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (17, 12, 'Amet eum', TRUE, FALSE, 'My playlist', TRUE, '2025-03-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 68, 1, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 82, 2, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 96, 3, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 46, 4, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 64, 5, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 7, 6, 12);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (17, 42, 7, 12);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (18, 13, 'Fuga ipsum', TRUE, FALSE, 'My playlist', TRUE, '2025-09-27');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (18, 6, 1, 13);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (18, 38, 2, 13);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (18, 62, 3, 13);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (18, 7, 4, 13);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (19, 14, 'Corporis repudiandae quasi', TRUE, FALSE, 'My playlist', TRUE, '2025-04-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (19, 79, 1, 14);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (19, 84, 2, 14);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (19, 35, 3, 14);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (19, 14, 4, 14);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (19, 85, 5, 14);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (20, 15, 'Ullam dignissimos voluptatum', TRUE, FALSE, 'My playlist', TRUE, '2025-01-15');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (20, 36, 1, 15);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (20, 49, 2, 15);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (20, 72, 3, 15);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (21, 16, 'Dignissimos voluptate excepturi', TRUE, FALSE, 'My playlist', TRUE, '2025-01-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (21, 41, 1, 16);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (21, 20, 2, 16);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (21, 89, 3, 16);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (22, 16, 'Nam voluptate', TRUE, FALSE, 'My playlist', TRUE, '2025-06-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (22, 2, 1, 16);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (22, 61, 2, 16);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (22, 62, 3, 16);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (22, 69, 4, 16);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (23, 17, 'Amet aliquam facere', TRUE, FALSE, 'My playlist', TRUE, '2025-01-12');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 74, 1, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 85, 2, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 14, 3, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 82, 4, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 41, 5, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (23, 24, 6, 17);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (24, 17, 'Quibusdam magni dolores', TRUE, FALSE, 'My playlist', TRUE, '2025-03-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (24, 44, 1, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (24, 14, 2, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (24, 52, 3, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (24, 50, 4, 17);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (24, 80, 5, 17);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (25, 18, 'Incidunt architecto commodi', TRUE, FALSE, 'My playlist', TRUE, '2025-04-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (25, 95, 1, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (25, 70, 2, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (25, 17, 3, 18);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (26, 18, 'Porro fuga illo', TRUE, FALSE, 'My playlist', TRUE, '2025-04-12');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 6, 1, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 53, 2, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 30, 3, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 66, 4, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 50, 5, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 85, 6, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 11, 7, 18);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (26, 48, 8, 18);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (27, 19, 'Earum eos harum', TRUE, FALSE, 'My playlist', TRUE, '2025-07-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 100, 1, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 51, 2, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 79, 3, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 77, 4, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 66, 5, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 45, 6, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 91, 7, 19);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (27, 60, 8, 19);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (28, 20, 'Deserunt ullam', TRUE, FALSE, 'My playlist', TRUE, '2025-05-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 14, 1, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 88, 2, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 91, 3, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 46, 4, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 25, 5, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 72, 6, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 70, 7, 20);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (28, 47, 8, 20);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (29, 21, 'Blanditiis quidem perferendis', TRUE, FALSE, 'My playlist', TRUE, '2025-01-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 81, 1, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 100, 2, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 57, 3, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 41, 4, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 16, 5, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 82, 6, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 65, 7, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (29, 51, 8, 21);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (30, 21, 'Autem', TRUE, FALSE, 'My playlist', TRUE, '2025-04-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 76, 1, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 78, 2, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 47, 3, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 19, 4, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 67, 5, 21);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (30, 2, 6, 21);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (31, 22, 'Quam fugit sint', TRUE, FALSE, 'My playlist', TRUE, '2025-09-03');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 77, 1, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 59, 2, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 35, 3, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 28, 4, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 23, 5, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 13, 6, 22);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (31, 98, 7, 22);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (32, 23, 'Magni quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-11-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 38, 1, 23);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 46, 2, 23);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 69, 3, 23);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 10, 4, 23);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 32, 5, 23);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (32, 67, 6, 23);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (33, 24, 'Odit unde nostrum', TRUE, FALSE, 'My playlist', TRUE, '2025-08-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (33, 65, 1, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (33, 28, 2, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (33, 34, 3, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (33, 83, 4, 24);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (34, 24, 'Culpa esse', TRUE, FALSE, 'My playlist', TRUE, '2025-07-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (34, 81, 1, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (34, 21, 2, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (34, 18, 3, 24);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (34, 100, 4, 24);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (35, 25, 'Quis alias', TRUE, FALSE, 'My playlist', TRUE, '2025-02-18');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (35, 60, 1, 25);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (35, 86, 2, 25);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (35, 63, 3, 25);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (35, 88, 4, 25);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (35, 87, 5, 25);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (36, 26, 'Cupiditate inventore', TRUE, FALSE, 'My playlist', TRUE, '2025-11-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (36, 23, 1, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (36, 77, 2, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (36, 2, 3, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (36, 67, 4, 26);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (37, 26, 'Excepturi pariatur dolorem', TRUE, FALSE, 'My playlist', TRUE, '2025-07-08');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (37, 49, 1, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (37, 35, 2, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (37, 88, 3, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (37, 94, 4, 26);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (37, 74, 5, 26);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (38, 27, 'Omnis repudiandae quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-01-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (38, 56, 1, 27);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (38, 57, 2, 27);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (38, 100, 3, 27);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (38, 82, 4, 27);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (38, 13, 5, 27);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (39, 28, 'Dignissimos atque', TRUE, FALSE, 'My playlist', TRUE, '2025-07-16');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (39, 37, 1, 28);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (39, 4, 2, 28);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (39, 26, 3, 28);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (40, 29, 'Provident fugiat', TRUE, FALSE, 'My playlist', TRUE, '2025-05-13');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (40, 77, 1, 29);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (40, 1, 2, 29);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (40, 42, 3, 29);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (41, 30, 'Perspiciatis at', TRUE, FALSE, 'My playlist', TRUE, '2025-05-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (41, 94, 1, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (41, 8, 2, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (41, 38, 3, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (41, 62, 4, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (41, 25, 5, 30);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (42, 30, 'Quis reiciendis', TRUE, FALSE, 'My playlist', TRUE, '2025-04-30');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (42, 100, 1, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (42, 92, 2, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (42, 82, 3, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (42, 3, 4, 30);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (42, 49, 5, 30);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (43, 31, 'Eaque perferendis dolorum', TRUE, FALSE, 'My playlist', TRUE, '2025-08-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 27, 1, 31);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 32, 2, 31);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 88, 3, 31);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 90, 4, 31);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 85, 5, 31);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (43, 66, 6, 31);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (44, 32, 'Vero itaque aliquid', TRUE, FALSE, 'My playlist', TRUE, '2025-02-05');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 84, 1, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 85, 2, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 35, 3, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 90, 4, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 86, 5, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 76, 6, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (44, 79, 7, 32);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (45, 32, 'Similique explicabo', TRUE, FALSE, 'My playlist', TRUE, '2025-10-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 55, 1, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 79, 2, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 29, 3, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 89, 4, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 92, 5, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 43, 6, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 73, 7, 32);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (45, 66, 8, 32);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (46, 33, 'Est ea reprehenderit', TRUE, FALSE, 'My playlist', TRUE, '2025-07-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (46, 3, 1, 33);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (46, 33, 2, 33);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (46, 50, 3, 33);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (47, 33, 'Voluptatibus fuga', TRUE, FALSE, 'My playlist', TRUE, '2025-10-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (47, 81, 1, 33);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (47, 8, 2, 33);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (47, 2, 3, 33);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (48, 34, 'Quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-10-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 19, 1, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 3, 2, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 40, 3, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 29, 4, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 34, 5, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 48, 6, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 61, 7, 34);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (48, 45, 8, 34);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (49, 35, 'Maxime tempora nulla', TRUE, FALSE, 'My playlist', TRUE, '2025-09-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 80, 1, 35);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 52, 2, 35);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 19, 3, 35);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 91, 4, 35);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 59, 5, 35);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (49, 42, 6, 35);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (50, 36, 'Mollitia eos', TRUE, FALSE, 'My playlist', TRUE, '2025-02-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 46, 1, 36);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 33, 2, 36);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 4, 3, 36);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 60, 4, 36);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 79, 5, 36);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (50, 61, 6, 36);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (51, 37, 'Incidunt debitis', TRUE, FALSE, 'My playlist', TRUE, '2025-09-29');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 13, 1, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 89, 2, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 56, 3, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 35, 4, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 20, 5, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 53, 6, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 91, 7, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (51, 92, 8, 37);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (52, 37, 'Fugiat voluptatum quos', TRUE, FALSE, 'My playlist', TRUE, '2025-04-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 58, 1, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 88, 2, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 79, 3, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 96, 4, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 73, 5, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 86, 6, 37);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (52, 56, 7, 37);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (53, 38, 'Vitae numquam quis', TRUE, FALSE, 'My playlist', TRUE, '2025-03-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (53, 43, 1, 38);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (53, 56, 2, 38);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (53, 36, 3, 38);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (53, 17, 4, 38);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (53, 75, 5, 38);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (54, 39, 'Deleniti nesciunt laboriosam', TRUE, FALSE, 'My playlist', TRUE, '2025-10-05');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (54, 68, 1, 39);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (54, 28, 2, 39);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (54, 49, 3, 39);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (54, 63, 4, 39);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (54, 23, 5, 39);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (55, 40, 'Officia enim commodi', TRUE, FALSE, 'My playlist', TRUE, '2025-05-16');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 21, 1, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 28, 2, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 49, 3, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 63, 4, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 34, 5, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 72, 6, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 70, 7, 40);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (55, 15, 8, 40);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (56, 41, 'Recusandae saepe deleniti', TRUE, FALSE, 'My playlist', TRUE, '2025-08-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 32, 1, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 41, 2, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 89, 3, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 50, 4, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 78, 5, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 84, 6, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (56, 51, 7, 41);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (57, 41, 'Veniam sed minima nam', TRUE, FALSE, 'My playlist', TRUE, '2025-05-22');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 58, 1, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 69, 2, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 27, 3, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 12, 4, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 78, 5, 41);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (57, 67, 6, 41);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (58, 42, 'Eveniet architecto', TRUE, FALSE, 'My playlist', TRUE, '2025-07-05');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 87, 1, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 46, 2, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 96, 3, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 79, 4, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 74, 5, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 56, 6, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (58, 77, 7, 42);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (59, 42, 'Harum provident architecto', TRUE, FALSE, 'My playlist', TRUE, '2025-09-29');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (59, 21, 1, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (59, 25, 2, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (59, 43, 3, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (59, 11, 4, 42);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (59, 32, 5, 42);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (60, 43, 'Expedita architecto', TRUE, FALSE, 'My playlist', TRUE, '2025-07-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (60, 9, 1, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (60, 77, 2, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (60, 81, 3, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (60, 33, 4, 43);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (61, 43, 'Beatae explicabo debitis', TRUE, FALSE, 'My playlist', TRUE, '2025-01-18');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 27, 1, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 43, 2, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 37, 3, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 60, 4, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 73, 5, 43);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (61, 69, 6, 43);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (62, 44, 'Aliquid sunt', TRUE, FALSE, 'My playlist', TRUE, '2025-10-23');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (62, 85, 1, 44);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (62, 15, 2, 44);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (62, 38, 3, 44);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (62, 16, 4, 44);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (62, 8, 5, 44);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (63, 45, 'Quaerat magnam', TRUE, FALSE, 'My playlist', TRUE, '2025-01-12');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 25, 1, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 56, 2, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 4, 3, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 86, 4, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 29, 5, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 49, 6, 45);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (63, 71, 7, 45);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (64, 46, 'Rerum illum adipisci', TRUE, FALSE, 'My playlist', TRUE, '2025-08-08');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (64, 72, 1, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (64, 16, 2, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (64, 67, 3, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (64, 3, 4, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (64, 43, 5, 46);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (65, 46, 'Dolorum error accusamus', TRUE, FALSE, 'My playlist', TRUE, '2025-04-11');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (65, 67, 1, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (65, 7, 2, 46);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (65, 97, 3, 46);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (66, 47, 'Vero', TRUE, FALSE, 'My playlist', TRUE, '2025-10-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 6, 1, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 56, 2, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 49, 3, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 61, 4, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 3, 5, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 98, 6, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 68, 7, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (66, 60, 8, 47);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (67, 47, 'Molestias rem', TRUE, FALSE, 'My playlist', TRUE, '2025-06-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 82, 1, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 2, 2, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 30, 3, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 67, 4, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 95, 5, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 92, 6, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 80, 7, 47);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (67, 15, 8, 47);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (68, 48, 'Quaerat voluptas autem deserunt', TRUE, FALSE, 'My playlist', TRUE, '2025-09-22');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (68, 49, 1, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (68, 74, 2, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (68, 93, 3, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (68, 42, 4, 48);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (69, 48, 'Cum possimus sint', TRUE, FALSE, 'My playlist', TRUE, '2025-11-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 99, 1, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 6, 2, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 24, 3, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 58, 4, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 93, 5, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 38, 6, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 69, 7, 48);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (69, 98, 8, 48);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (70, 49, 'Saepe laudantium', TRUE, FALSE, 'My playlist', TRUE, '2025-04-11');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (70, 83, 1, 49);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (70, 92, 2, 49);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (70, 60, 3, 49);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (71, 49, 'Natus esse quia', TRUE, FALSE, 'My playlist', TRUE, '2025-05-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (71, 22, 1, 49);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (71, 1, 2, 49);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (71, 20, 3, 49);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (71, 87, 4, 49);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (72, 50, 'Facilis nisi libero possimus', TRUE, FALSE, 'My playlist', TRUE, '2025-09-29');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 11, 1, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 91, 2, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 72, 3, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 49, 4, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 20, 5, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 30, 6, 50);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (72, 74, 7, 50);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (73, 51, 'Vero mollitia fugiat', TRUE, FALSE, 'My playlist', TRUE, '2025-08-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 53, 1, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 61, 2, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 56, 3, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 20, 4, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 85, 5, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (73, 30, 6, 51);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (74, 51, 'At necessitatibus saepe', TRUE, FALSE, 'My playlist', TRUE, '2025-11-19');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 66, 1, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 84, 2, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 50, 3, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 65, 4, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 13, 5, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 42, 6, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 21, 7, 51);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (74, 93, 8, 51);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (75, 52, 'Minus sed', TRUE, FALSE, 'My playlist', TRUE, '2025-04-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 10, 1, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 51, 2, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 84, 3, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 26, 4, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 5, 5, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 43, 6, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (75, 23, 7, 52);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (76, 52, 'Optio perferendis dicta', TRUE, FALSE, 'My playlist', TRUE, '2025-10-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 22, 1, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 63, 2, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 58, 3, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 65, 4, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 10, 5, 52);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (76, 51, 6, 52);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (77, 53, 'Dolor accusamus possimus', TRUE, FALSE, 'My playlist', TRUE, '2025-06-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 28, 1, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 87, 2, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 86, 3, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 47, 4, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 60, 5, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 3, 6, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (77, 41, 7, 53);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (78, 53, 'Mollitia ipsam', TRUE, FALSE, 'My playlist', TRUE, '2025-01-03');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (78, 44, 1, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (78, 98, 2, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (78, 87, 3, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (78, 32, 4, 53);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (78, 78, 5, 53);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (79, 54, 'Maiores consequatur repudiandae', TRUE, FALSE, 'My playlist', TRUE, '2025-03-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 77, 1, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 91, 2, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 65, 3, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 13, 4, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 66, 5, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 18, 6, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 81, 7, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (79, 16, 8, 54);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (80, 54, 'Officiis pariatur cum', TRUE, FALSE, 'My playlist', TRUE, '2025-10-19');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 7, 1, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 9, 2, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 80, 3, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 3, 4, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 47, 5, 54);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (80, 39, 6, 54);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (81, 55, 'Quas dolores', TRUE, FALSE, 'My playlist', TRUE, '2025-07-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 35, 1, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 97, 2, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 99, 3, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 43, 4, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 86, 5, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 59, 6, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (81, 39, 7, 55);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (82, 55, 'Debitis exercitationem', TRUE, FALSE, 'My playlist', TRUE, '2025-01-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (82, 35, 1, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (82, 31, 2, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (82, 46, 3, 55);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (82, 97, 4, 55);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (83, 56, 'Animi quo odit', TRUE, FALSE, 'My playlist', TRUE, '2025-01-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (83, 6, 1, 56);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (83, 27, 2, 56);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (83, 68, 3, 56);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (84, 57, 'Aliquam qui aliquid', TRUE, FALSE, 'My playlist', TRUE, '2025-07-29');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (84, 69, 1, 57);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (84, 49, 2, 57);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (84, 13, 3, 57);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (85, 58, 'Animi consequuntur quibusdam', TRUE, FALSE, 'My playlist', TRUE, '2025-04-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 50, 1, 58);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 74, 2, 58);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 47, 3, 58);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 99, 4, 58);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 60, 5, 58);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (85, 62, 6, 58);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (86, 59, 'Expedita possimus', TRUE, FALSE, 'My playlist', TRUE, '2025-06-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (86, 9, 1, 59);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (86, 80, 2, 59);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (86, 15, 3, 59);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (87, 59, 'Sequi delectus', TRUE, FALSE, 'My playlist', TRUE, '2025-02-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (87, 14, 1, 59);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (87, 70, 2, 59);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (87, 64, 3, 59);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (88, 60, 'Reprehenderit occaecati possimus quidem', TRUE, FALSE, 'My playlist', TRUE, '2025-11-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (88, 16, 1, 60);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (88, 65, 2, 60);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (88, 96, 3, 60);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (88, 74, 4, 60);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (89, 61, 'Saepe saepe id', TRUE, FALSE, 'My playlist', TRUE, '2025-02-13');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 94, 1, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 90, 2, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 41, 3, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 79, 4, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 60, 5, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 10, 6, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 68, 7, 61);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (89, 54, 8, 61);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (90, 62, 'Inventore aliquam magni', TRUE, FALSE, 'My playlist', TRUE, '2025-08-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (90, 2, 1, 62);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (90, 38, 2, 62);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (90, 94, 3, 62);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (90, 82, 4, 62);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (91, 62, 'Iusto minima accusamus ullam', TRUE, FALSE, 'My playlist', TRUE, '2025-05-22');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (91, 91, 1, 62);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (91, 57, 2, 62);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (91, 2, 3, 62);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (92, 63, 'Deserunt vero nihil', TRUE, FALSE, 'My playlist', TRUE, '2025-09-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 6, 1, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 11, 2, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 10, 3, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 44, 4, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 51, 5, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (92, 21, 6, 63);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (93, 63, 'Doloribus eos', TRUE, FALSE, 'My playlist', TRUE, '2025-11-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (93, 61, 1, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (93, 68, 2, 63);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (93, 6, 3, 63);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (94, 64, 'Enim quisquam ratione', TRUE, FALSE, 'My playlist', TRUE, '2025-11-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 48, 1, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 47, 2, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 59, 3, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 12, 4, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 39, 5, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 41, 6, 64);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (94, 63, 7, 64);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (95, 65, 'Atque tenetur fugiat', TRUE, FALSE, 'My playlist', TRUE, '2025-10-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (95, 6, 1, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (95, 63, 2, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (95, 77, 3, 65);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (96, 65, 'Quasi eos', TRUE, FALSE, 'My playlist', TRUE, '2025-02-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (96, 33, 1, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (96, 77, 2, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (96, 31, 3, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (96, 40, 4, 65);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (96, 70, 5, 65);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (97, 66, 'Suscipit pariatur', TRUE, FALSE, 'My playlist', TRUE, '2025-11-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (97, 70, 1, 66);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (97, 91, 2, 66);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (97, 81, 3, 66);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (98, 67, 'Sapiente corrupti', TRUE, FALSE, 'My playlist', TRUE, '2025-07-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (98, 83, 1, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (98, 64, 2, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (98, 92, 3, 67);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (99, 67, 'A nulla sed', TRUE, FALSE, 'My playlist', TRUE, '2025-11-11');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 44, 1, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 19, 2, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 70, 3, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 45, 4, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 77, 5, 67);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (99, 87, 6, 67);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (100, 68, 'Vel atque a', TRUE, FALSE, 'My playlist', TRUE, '2025-02-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 58, 1, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 75, 2, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 31, 3, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 27, 4, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 47, 5, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 6, 6, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 54, 7, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (100, 64, 8, 68);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (101, 68, 'Aperiam voluptate rem', TRUE, FALSE, 'My playlist', TRUE, '2025-08-25');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 24, 1, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 21, 2, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 43, 3, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 2, 4, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 68, 5, 68);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (101, 77, 6, 68);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (102, 69, 'Commodi temporibus', TRUE, FALSE, 'My playlist', TRUE, '2025-10-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (102, 83, 1, 69);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (102, 29, 2, 69);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (102, 33, 3, 69);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (102, 6, 4, 69);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (102, 93, 5, 69);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (103, 70, 'Accusantium perspiciatis sapiente', TRUE, FALSE, 'My playlist', TRUE, '2025-09-16');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 87, 1, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 22, 2, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 17, 3, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 18, 4, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 90, 5, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 35, 6, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (103, 78, 7, 70);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (104, 70, 'Vel voluptatibus maiores', TRUE, FALSE, 'My playlist', TRUE, '2025-11-15');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (104, 6, 1, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (104, 87, 2, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (104, 61, 3, 70);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (104, 10, 4, 70);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (105, 71, 'Culpa sequi explicabo', TRUE, FALSE, 'My playlist', TRUE, '2025-08-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 8, 1, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 36, 2, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 76, 3, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 74, 4, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 19, 5, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 30, 6, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (105, 6, 7, 71);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (106, 71, 'Non doloremque aspernatur', TRUE, FALSE, 'My playlist', TRUE, '2025-02-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 21, 1, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 67, 2, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 15, 3, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 27, 4, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 7, 5, 71);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (106, 45, 6, 71);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (107, 72, 'At provident', TRUE, FALSE, 'My playlist', TRUE, '2025-08-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (107, 46, 1, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (107, 71, 2, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (107, 98, 3, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (107, 7, 4, 72);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (108, 72, 'Consequatur saepe id', TRUE, FALSE, 'My playlist', TRUE, '2025-01-31');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 83, 1, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 22, 2, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 17, 3, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 51, 4, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 93, 5, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 38, 6, 72);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (108, 16, 7, 72);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (109, 73, 'Labore in', TRUE, FALSE, 'My playlist', TRUE, '2025-02-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (109, 55, 1, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (109, 6, 2, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (109, 44, 3, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (109, 18, 4, 73);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (110, 73, 'Neque ex ducimus', TRUE, FALSE, 'My playlist', TRUE, '2025-01-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (110, 95, 1, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (110, 34, 2, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (110, 92, 3, 73);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (110, 75, 4, 73);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (111, 74, 'Nulla nesciunt nemo', TRUE, FALSE, 'My playlist', TRUE, '2025-11-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 45, 1, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 92, 2, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 91, 3, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 66, 4, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 48, 5, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 33, 6, 74);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (111, 81, 7, 74);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (112, 75, 'Eius', TRUE, FALSE, 'My playlist', TRUE, '2025-04-27');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 39, 1, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 89, 2, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 98, 3, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 97, 4, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 3, 5, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 100, 6, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 10, 7, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (112, 38, 8, 75);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (113, 75, 'Nihil magni illum', TRUE, FALSE, 'My playlist', TRUE, '2025-07-02');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 72, 1, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 40, 2, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 70, 3, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 19, 4, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 23, 5, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 12, 6, 75);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (113, 22, 7, 75);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (114, 76, 'Unde minima', TRUE, FALSE, 'My playlist', TRUE, '2025-04-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 41, 1, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 11, 2, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 54, 3, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 50, 4, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 17, 5, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 60, 6, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (114, 93, 7, 76);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (115, 76, 'Nobis repudiandae facere', TRUE, FALSE, 'My playlist', TRUE, '2025-04-03');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (115, 97, 1, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (115, 12, 2, 76);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (115, 69, 3, 76);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (116, 77, 'Ducimus minima pariatur', TRUE, FALSE, 'My playlist', TRUE, '2025-02-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (116, 56, 1, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (116, 95, 2, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (116, 38, 3, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (116, 49, 4, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (116, 26, 5, 77);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (117, 77, 'Impedit cupiditate harum', TRUE, FALSE, 'My playlist', TRUE, '2025-02-27');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (117, 60, 1, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (117, 12, 2, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (117, 94, 3, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (117, 56, 4, 77);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (117, 5, 5, 77);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (118, 78, 'In at corrupti', TRUE, FALSE, 'My playlist', TRUE, '2025-01-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (118, 77, 1, 78);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (118, 55, 2, 78);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (118, 21, 3, 78);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (118, 14, 4, 78);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (118, 22, 5, 78);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (119, 79, 'Deleniti nemo eligendi laborum', TRUE, FALSE, 'My playlist', TRUE, '2025-06-17');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 20, 1, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 87, 2, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 62, 3, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 81, 4, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 51, 5, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 38, 6, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 71, 7, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (119, 43, 8, 79);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (120, 79, 'Eaque nesciunt ex', TRUE, FALSE, 'My playlist', TRUE, '2025-08-18');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (120, 57, 1, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (120, 23, 2, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (120, 20, 3, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (120, 72, 4, 79);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (120, 60, 5, 79);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (121, 80, 'Laudantium quaerat', TRUE, FALSE, 'My playlist', TRUE, '2025-05-19');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 42, 1, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 87, 2, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 38, 3, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 81, 4, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 79, 5, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 100, 6, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 17, 7, 80);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (121, 92, 8, 80);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (122, 81, 'Fugit commodi', TRUE, FALSE, 'My playlist', TRUE, '2025-02-08');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 71, 1, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 55, 2, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 65, 3, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 2, 4, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 13, 5, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 62, 6, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 29, 7, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (122, 41, 8, 81);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (123, 81, 'Esse quis', TRUE, FALSE, 'My playlist', TRUE, '2025-07-16');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 35, 1, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 67, 2, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 16, 3, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 66, 4, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 92, 5, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 36, 6, 81);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (123, 13, 7, 81);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (124, 82, 'Quis unde quas', TRUE, FALSE, 'My playlist', TRUE, '2025-03-01');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (124, 31, 1, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (124, 53, 2, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (124, 92, 3, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (124, 99, 4, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (124, 7, 5, 82);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (125, 82, 'Iusto delectus dolorum', TRUE, FALSE, 'My playlist', TRUE, '2025-11-15');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 2, 1, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 1, 2, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 29, 3, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 49, 4, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 66, 5, 82);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (125, 72, 6, 82);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (126, 83, 'Porro fugit', TRUE, FALSE, 'My playlist', TRUE, '2025-05-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (126, 77, 1, 83);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (126, 58, 2, 83);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (126, 22, 3, 83);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (127, 84, 'Repudiandae sint occaecati', TRUE, FALSE, 'My playlist', TRUE, '2025-01-07');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (127, 25, 1, 84);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (127, 83, 2, 84);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (127, 34, 3, 84);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (127, 89, 4, 84);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (127, 33, 5, 84);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (128, 85, 'Dolor distinctio minima', TRUE, FALSE, 'My playlist', TRUE, '2025-06-21');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (128, 56, 1, 85);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (128, 38, 2, 85);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (128, 58, 3, 85);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (129, 86, 'Voluptatum', TRUE, FALSE, 'My playlist', TRUE, '2025-01-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (129, 66, 1, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (129, 79, 2, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (129, 65, 3, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (129, 95, 4, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (129, 45, 5, 86);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (130, 86, 'Natus ipsa modi', TRUE, FALSE, 'My playlist', TRUE, '2025-07-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (130, 78, 1, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (130, 48, 2, 86);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (130, 89, 3, 86);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (131, 87, 'Beatae dolorum ullam', TRUE, FALSE, 'My playlist', TRUE, '2025-10-12');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (131, 39, 1, 87);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (131, 78, 2, 87);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (131, 27, 3, 87);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (131, 81, 4, 87);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (131, 8, 5, 87);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (132, 88, 'Deleniti explicabo', TRUE, FALSE, 'My playlist', TRUE, '2025-11-16');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (132, 15, 1, 88);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (132, 77, 2, 88);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (132, 64, 3, 88);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (132, 2, 4, 88);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (132, 59, 5, 88);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (133, 89, 'Iure quo', TRUE, FALSE, 'My playlist', TRUE, '2025-05-24');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 64, 1, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 32, 2, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 55, 3, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 93, 4, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 17, 5, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 5, 6, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (133, 99, 7, 89);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (134, 89, 'Enim ducimus soluta', TRUE, FALSE, 'My playlist', TRUE, '2025-03-26');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 62, 1, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 36, 2, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 56, 3, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 75, 4, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 44, 5, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 94, 6, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 30, 7, 89);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (134, 100, 8, 89);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (135, 90, 'Cupiditate eligendi ullam ipsa', TRUE, FALSE, 'My playlist', TRUE, '2025-07-10');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (135, 71, 1, 90);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (135, 87, 2, 90);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (135, 83, 3, 90);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (135, 2, 4, 90);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (135, 16, 5, 90);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (136, 91, 'Error quod expedita', TRUE, FALSE, 'My playlist', TRUE, '2025-11-05');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (136, 83, 1, 91);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (136, 63, 2, 91);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (136, 57, 3, 91);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (137, 91, 'Quam ducimus sapiente', TRUE, FALSE, 'My playlist', TRUE, '2025-03-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (137, 31, 1, 91);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (137, 45, 2, 91);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (137, 3, 3, 91);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (137, 60, 4, 91);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (138, 92, 'Incidunt reprehenderit possimus', TRUE, FALSE, 'My playlist', TRUE, '2025-05-19');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (138, 14, 1, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (138, 38, 2, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (138, 49, 3, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (138, 79, 4, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (138, 16, 5, 92);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (139, 92, 'Assumenda', TRUE, FALSE, 'My playlist', TRUE, '2025-02-15');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 91, 1, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 16, 2, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 4, 3, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 61, 4, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 41, 5, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 42, 6, 92);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (139, 72, 7, 92);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (140, 93, 'Eum necessitatibus', TRUE, FALSE, 'My playlist', TRUE, '2025-04-04');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (140, 53, 1, 93);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (140, 72, 2, 93);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (140, 94, 3, 93);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (140, 2, 4, 93);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (140, 24, 5, 93);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (141, 94, 'Voluptate praesentium tenetur', TRUE, FALSE, 'My playlist', TRUE, '2025-02-13');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (141, 4, 1, 94);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (141, 71, 2, 94);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (141, 42, 3, 94);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (141, 53, 4, 94);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (141, 27, 5, 94);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (142, 95, 'Ab asperiores', TRUE, FALSE, 'My playlist', TRUE, '2025-04-14');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 93, 1, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 75, 2, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 94, 3, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 2, 4, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 18, 5, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 36, 6, 95);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (142, 34, 7, 95);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (143, 96, 'Non blanditiis', TRUE, FALSE, 'My playlist', TRUE, '2025-09-20');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (143, 98, 1, 96);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (143, 83, 2, 96);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (143, 52, 3, 96);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (143, 18, 4, 96);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (144, 97, 'Molestiae enim blanditiis', TRUE, FALSE, 'My playlist', TRUE, '2025-05-06');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 5, 1, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 53, 2, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 24, 3, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 88, 4, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 86, 5, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 66, 6, 97);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (144, 40, 7, 97);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (145, 98, 'Animi eos labore', TRUE, FALSE, 'My playlist', TRUE, '2025-10-09');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 95, 1, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 44, 2, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 38, 3, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 54, 4, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 81, 5, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 82, 6, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (145, 93, 7, 98);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (146, 98, 'Molestiae pariatur labore', TRUE, FALSE, 'My playlist', TRUE, '2025-01-14');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (146, 2, 1, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (146, 67, 2, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (146, 63, 3, 98);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (146, 93, 4, 98);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (147, 99, 'Atque sed', TRUE, FALSE, 'My playlist', TRUE, '2025-09-08');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 87, 1, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 22, 2, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 3, 3, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 19, 4, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 58, 5, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 50, 6, 99);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (147, 6, 7, 99);
INSERT INTO PLAYLISTS (PLAYLIST_ID, USER_ID, PLAYLIST_TITLE, ISPUBLIC, ISCOLLABORATIVE, PLAYLIST_DESC, ISONPROFILE, PLAYLIST_DATE_CREATED) VALUES (148, 100, 'Placeat culpa sunt alias', TRUE, FALSE, 'My playlist', TRUE, '2025-08-13');
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (148, 19, 1, 100);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (148, 33, 2, 100);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (148, 26, 3, 100);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (148, 92, 4, 100);
INSERT INTO ADD_SONGS_PLAYLISTS (PLAYLIST_ID, SONG_ID, NO_URUT, USER_ID) VALUES (148, 65, 5, 100);
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 52, 241, '2025-11-27 21:48:11');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 33, 173, '2025-11-27 21:48:24');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (14, 6, 165, '2025-11-27 21:50:13');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (25, 83, 195, '2025-11-27 21:50:31');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (29, 26, 81, '2025-11-27 21:49:41');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (6, 25, 190, '2025-11-27 21:50:47');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (2, 86, 85, '2025-11-27 21:48:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (56, 61, 234, '2025-11-27 21:49:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (72, 63, 127, '2025-11-27 21:45:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (68, 63, 212, '2025-11-27 21:45:33');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (88, 24, 118, '2025-11-27 21:49:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (19, 53, 126, '2025-11-27 21:49:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 32, 53, '2025-11-27 21:48:01');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (42, 50, 26, '2025-11-27 21:49:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (26, 45, 72, '2025-11-27 21:47:06');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 55, 32, '2025-11-27 21:47:07');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (80, 1, 245, '2025-11-27 21:48:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (68, 15, 265, '2025-11-27 21:48:35');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (83, 84, 77, '2025-11-27 21:49:40');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (67, 13, 28, '2025-11-27 21:47:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (51, 15, 243, '2025-11-27 21:49:48');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (29, 98, 230, '2025-11-27 21:51:03');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 21, 145, '2025-11-27 21:51:13');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (45, 88, 211, '2025-11-27 21:46:41');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (36, 71, 111, '2025-11-27 21:46:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (64, 23, 219, '2025-11-27 21:49:29');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (69, 47, 118, '2025-11-27 21:46:12');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 87, 264, '2025-11-27 21:48:40');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (72, 6, 48, '2025-11-27 21:50:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (71, 41, 28, '2025-11-27 21:50:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (96, 94, 73, '2025-11-27 21:49:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (89, 20, 141, '2025-11-27 21:48:47');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 55, 170, '2025-11-27 21:48:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (86, 51, 27, '2025-11-27 21:47:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (87, 88, 134, '2025-11-27 21:49:34');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (41, 41, 271, '2025-11-27 21:46:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 90, 124, '2025-11-27 21:49:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (96, 72, 158, '2025-11-27 21:50:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (89, 95, 200, '2025-11-27 21:50:56');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (70, 11, 46, '2025-11-27 21:46:53');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (8, 84, 164, '2025-11-27 21:49:11');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (78, 10, 243, '2025-11-27 21:49:51');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (22, 12, 135, '2025-11-27 21:50:51');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (2, 98, 189, '2025-11-27 21:51:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (66, 39, 41, '2025-11-27 21:48:53');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (51, 25, 15, '2025-11-27 21:48:04');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 100, 229, '2025-11-27 21:48:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (88, 9, 134, '2025-11-27 21:50:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 72, 229, '2025-11-27 21:46:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (43, 46, 113, '2025-11-27 21:49:31');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (82, 85, 168, '2025-11-27 21:50:27');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (35, 19, 93, '2025-11-27 21:45:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (74, 67, 289, '2025-11-27 21:47:29');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (35, 63, 199, '2025-11-27 21:50:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (67, 23, 173, '2025-11-27 21:45:56');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (61, 47, 17, '2025-11-27 21:50:48');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (69, 12, 223, '2025-11-27 21:47:23');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (20, 78, 248, '2025-11-27 21:48:23');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (65, 72, 188, '2025-11-27 21:50:42');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (38, 71, 40, '2025-11-27 21:50:11');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (46, 89, 82, '2025-11-27 21:47:38');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (93, 63, 190, '2025-11-27 21:46:13');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (27, 4, 107, '2025-11-27 21:45:33');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (52, 98, 134, '2025-11-27 21:49:27');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 35, 275, '2025-11-27 21:46:27');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (9, 90, 88, '2025-11-27 21:50:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (66, 3, 137, '2025-11-27 21:50:17');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (99, 11, 108, '2025-11-27 21:50:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (82, 100, 125, '2025-11-27 21:51:08');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (88, 89, 238, '2025-11-27 21:49:53');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (84, 31, 151, '2025-11-27 21:49:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (97, 33, 191, '2025-11-27 21:48:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (16, 52, 19, '2025-11-27 21:46:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 90, 201, '2025-11-27 21:46:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (53, 57, 101, '2025-11-27 21:46:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 61, 202, '2025-11-27 21:48:09');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (31, 100, 216, '2025-11-27 21:45:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (42, 39, 128, '2025-11-27 21:45:25');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (48, 14, 135, '2025-11-27 21:45:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 27, 84, '2025-11-27 21:45:24');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (54, 38, 163, '2025-11-27 21:49:50');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (58, 77, 146, '2025-11-27 21:46:03');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (43, 30, 116, '2025-11-27 21:45:37');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (64, 26, 162, '2025-11-27 21:46:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 28, 119, '2025-11-27 21:47:19');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (61, 55, 124, '2025-11-27 21:48:04');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (65, 53, 59, '2025-11-27 21:49:16');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (25, 82, 214, '2025-11-27 21:50:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (81, 92, 96, '2025-11-27 21:45:42');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (98, 28, 267, '2025-11-27 21:47:09');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (15, 59, 87, '2025-11-27 21:48:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (69, 47, 25, '2025-11-27 21:49:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (78, 29, 14, '2025-11-27 21:50:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (33, 91, 287, '2025-11-27 21:50:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 29, 227, '2025-11-27 21:50:25');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (49, 70, 126, '2025-11-27 21:48:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (49, 38, 221, '2025-11-27 21:49:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (51, 43, 214, '2025-11-27 21:47:20');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (1, 88, 181, '2025-11-27 21:49:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (80, 18, 196, '2025-11-27 21:48:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (4, 50, 34, '2025-11-27 21:48:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (56, 46, 164, '2025-11-27 21:45:53');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (82, 52, 12, '2025-11-27 21:50:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (25, 100, 27, '2025-11-27 21:46:31');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (47, 51, 260, '2025-11-27 21:50:52');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (4, 35, 50, '2025-11-27 21:50:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (38, 48, 52, '2025-11-27 21:49:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (55, 85, 286, '2025-11-27 21:49:13');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 16, 178, '2025-11-27 21:49:06');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (6, 69, 253, '2025-11-27 21:48:40');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (33, 42, 143, '2025-11-27 21:49:00');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (16, 19, 185, '2025-11-27 21:49:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 53, 163, '2025-11-27 21:50:38');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (71, 94, 246, '2025-11-27 21:51:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (51, 45, 116, '2025-11-27 21:50:25');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (49, 76, 123, '2025-11-27 21:48:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (19, 1, 123, '2025-11-27 21:46:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 58, 119, '2025-11-27 21:45:25');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (14, 63, 158, '2025-11-27 21:47:19');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (44, 55, 13, '2025-11-27 21:50:57');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (21, 45, 274, '2025-11-27 21:45:22');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (72, 31, 272, '2025-11-27 21:48:56');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (34, 77, 235, '2025-11-27 21:49:57');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (2, 82, 134, '2025-11-27 21:50:32');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (37, 64, 43, '2025-11-27 21:49:12');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (82, 9, 74, '2025-11-27 21:46:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (22, 20, 16, '2025-11-27 21:47:36');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (78, 46, 297, '2025-11-27 21:50:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (5, 72, 230, '2025-11-27 21:46:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (87, 84, 195, '2025-11-27 21:50:00');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (15, 93, 91, '2025-11-27 21:48:19');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (45, 45, 27, '2025-11-27 21:45:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (16, 93, 114, '2025-11-27 21:47:31');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (42, 72, 194, '2025-11-27 21:47:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (7, 29, 54, '2025-11-27 21:50:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (7, 11, 75, '2025-11-27 21:50:47');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (19, 73, 279, '2025-11-27 21:50:42');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (39, 6, 193, '2025-11-27 21:48:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 10, 187, '2025-11-27 21:49:17');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (26, 53, 97, '2025-11-27 21:51:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (54, 77, 184, '2025-11-27 21:49:19');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (3, 77, 21, '2025-11-27 21:46:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (43, 29, 234, '2025-11-27 21:46:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (41, 92, 100, '2025-11-27 21:47:24');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 78, 203, '2025-11-27 21:47:28');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (50, 86, 25, '2025-11-27 21:46:36');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (46, 24, 113, '2025-11-27 21:45:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (80, 58, 257, '2025-11-27 21:47:14');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (76, 92, 134, '2025-11-27 21:46:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (28, 35, 160, '2025-11-27 21:51:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (10, 74, 50, '2025-11-27 21:45:37');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (28, 59, 258, '2025-11-27 21:50:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 57, 181, '2025-11-27 21:50:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (85, 3, 275, '2025-11-27 21:46:57');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 2, 22, '2025-11-27 21:49:27');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (27, 1, 237, '2025-11-27 21:50:20');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (97, 73, 174, '2025-11-27 21:46:31');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (22, 66, 256, '2025-11-27 21:48:41');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (47, 95, 93, '2025-11-27 21:46:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (60, 47, 213, '2025-11-27 21:46:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (18, 39, 167, '2025-11-27 21:47:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (5, 84, 118, '2025-11-27 21:46:40');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 42, 295, '2025-11-27 21:47:48');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (81, 6, 59, '2025-11-27 21:46:35');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (27, 83, 76, '2025-11-27 21:50:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (67, 73, 241, '2025-11-27 21:50:32');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (62, 43, 253, '2025-11-27 21:49:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (28, 25, 85, '2025-11-27 21:50:50');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (92, 87, 204, '2025-11-27 21:49:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (29, 78, 118, '2025-11-27 21:45:30');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (43, 81, 115, '2025-11-27 21:48:16');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (96, 89, 268, '2025-11-27 21:46:27');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (53, 95, 183, '2025-11-27 21:49:41');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (50, 78, 218, '2025-11-27 21:50:47');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (58, 18, 45, '2025-11-27 21:47:20');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (89, 8, 211, '2025-11-27 21:45:22');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (61, 22, 197, '2025-11-27 21:47:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (11, 8, 51, '2025-11-27 21:45:45');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 63, 222, '2025-11-27 21:47:34');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (45, 8, 119, '2025-11-27 21:48:42');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 53, 264, '2025-11-27 21:49:21');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (74, 45, 30, '2025-11-27 21:50:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (44, 94, 63, '2025-11-27 21:49:59');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (83, 15, 137, '2025-11-27 21:46:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 28, 166, '2025-11-27 21:47:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (93, 12, 32, '2025-11-27 21:49:14');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (54, 93, 283, '2025-11-27 21:47:22');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (77, 51, 177, '2025-11-27 21:48:54');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (26, 15, 98, '2025-11-27 21:46:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (66, 40, 281, '2025-11-27 21:47:57');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (2, 84, 39, '2025-11-27 21:46:30');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (77, 15, 209, '2025-11-27 21:47:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (56, 92, 218, '2025-11-27 21:47:23');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (41, 21, 217, '2025-11-27 21:46:41');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (35, 83, 139, '2025-11-27 21:49:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (80, 71, 293, '2025-11-27 21:46:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (100, 70, 104, '2025-11-27 21:46:01');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (21, 96, 139, '2025-11-27 21:50:22');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (52, 39, 231, '2025-11-27 21:47:48');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (7, 60, 50, '2025-11-27 21:48:28');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (29, 5, 199, '2025-11-27 21:47:10');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (29, 73, 250, '2025-11-27 21:50:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (66, 35, 154, '2025-11-27 21:47:11');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (99, 73, 116, '2025-11-27 21:49:00');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (54, 87, 214, '2025-11-27 21:48:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 43, 296, '2025-11-27 21:47:20');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 70, 56, '2025-11-27 21:47:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 38, 176, '2025-11-27 21:50:33');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (73, 42, 261, '2025-11-27 21:48:08');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (18, 56, 71, '2025-11-27 21:47:15');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (19, 20, 54, '2025-11-27 21:48:52');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (96, 71, 77, '2025-11-27 21:46:29');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (39, 15, 38, '2025-11-27 21:46:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 80, 280, '2025-11-27 21:49:53');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (75, 82, 205, '2025-11-27 21:47:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (91, 45, 158, '2025-11-27 21:46:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (93, 71, 203, '2025-11-27 21:49:28');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 37, 82, '2025-11-27 21:45:39');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (20, 85, 33, '2025-11-27 21:50:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (81, 75, 208, '2025-11-27 21:47:24');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (11, 32, 205, '2025-11-27 21:46:43');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (66, 41, 39, '2025-11-27 21:50:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (27, 22, 107, '2025-11-27 21:49:07');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 34, 67, '2025-11-27 21:46:30');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (16, 49, 151, '2025-11-27 21:49:30');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (76, 89, 17, '2025-11-27 21:50:17');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (9, 53, 115, '2025-11-27 21:50:17');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (7, 41, 47, '2025-11-27 21:49:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (24, 60, 67, '2025-11-27 21:47:18');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (32, 23, 10, '2025-11-27 21:45:47');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (38, 97, 242, '2025-11-27 21:47:52');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (89, 99, 162, '2025-11-27 21:49:49');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (60, 25, 108, '2025-11-27 21:49:45');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (59, 86, 42, '2025-11-27 21:46:46');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (43, 13, 23, '2025-11-27 21:49:06');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (58, 57, 13, '2025-11-27 21:49:28');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (79, 36, 87, '2025-11-27 21:47:26');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (61, 49, 161, '2025-11-27 21:47:55');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (12, 4, 225, '2025-11-27 21:46:02');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (64, 69, 118, '2025-11-27 21:47:33');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (4, 34, 97, '2025-11-27 21:46:14');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (97, 41, 216, '2025-11-27 21:49:12');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (77, 93, 38, '2025-11-27 21:51:03');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (63, 14, 122, '2025-11-27 21:50:57');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (17, 26, 156, '2025-11-27 21:48:58');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (85, 17, 215, '2025-11-27 21:49:05');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (27, 24, 239, '2025-11-27 21:48:30');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (58, 91, 102, '2025-11-27 21:49:52');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (40, 56, 22, '2025-11-27 21:49:44');
INSERT INTO LISTENS (USER_ID, SONG_ID, DURATION_LISTENED, "TIMESTAMP") VALUES (100, 24, 129, '2025-11-27 21:48:02');
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (1, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (1, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (1, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (1, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (1, 99) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (2, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (2, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (2, 24) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (2, 53) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (2, 61) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (3, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (3, 74) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (3, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (3, 23) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (3, 77) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (4, 14) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (4, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (4, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (4, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (4, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (5, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (5, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (5, 38) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (5, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (5, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (6, 15) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (6, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (6, 95) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (6, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (6, 73) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (7, 34) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (7, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (7, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (7, 64) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (7, 27) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (8, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (8, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (8, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (8, 14) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (8, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (9, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (9, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (9, 95) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (9, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (9, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (10, 34) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (10, 75) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (10, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (10, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (10, 50) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (11, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (11, 61) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (11, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (11, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (11, 30) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (12, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (12, 20) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (12, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (12, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (12, 34) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (13, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (13, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (13, 48) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (13, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (13, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (14, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (14, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (14, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (14, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (14, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (15, 18) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (15, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (15, 2) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (15, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (15, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (16, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (16, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (16, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (16, 16) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (16, 63) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (17, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (17, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (17, 77) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (17, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (17, 95) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (18, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (18, 25) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (18, 7) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (18, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (18, 62) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (19, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (19, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (19, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (19, 100) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (19, 48) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (20, 99) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (20, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (20, 47) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (20, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (20, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (21, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (21, 89) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (21, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (21, 38) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (21, 77) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (22, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (22, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (22, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (22, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (22, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (23, 58) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (23, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (23, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (23, 63) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (23, 49) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (24, 47) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (24, 7) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (24, 62) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (24, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (24, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (25, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (25, 90) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (25, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (25, 75) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (25, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (26, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (26, 18) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (26, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (26, 24) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (26, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (27, 20) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (27, 30) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (27, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (27, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (27, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (28, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (28, 28) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (28, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (28, 72) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (28, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (29, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (29, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (29, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (29, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (29, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (30, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (30, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (30, 44) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (30, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (30, 16) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (31, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (31, 15) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (31, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (31, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (31, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (32, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (32, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (32, 26) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (32, 81) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (32, 42) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (33, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (33, 47) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (33, 30) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (33, 79) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (33, 31) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (34, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (34, 53) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (34, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (34, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (34, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (35, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (35, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (35, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (35, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (35, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (36, 90) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (36, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (36, 57) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (36, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (36, 63) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (37, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (37, 53) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (37, 20) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (37, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (37, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (38, 15) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (38, 25) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (38, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (38, 99) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (38, 78) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (39, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (39, 16) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (39, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (39, 57) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (39, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (40, 50) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (40, 10) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (40, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (40, 31) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (40, 48) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (41, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (41, 93) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (41, 16) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (41, 24) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (41, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (42, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (42, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (42, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (42, 94) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (42, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (43, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (43, 56) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (43, 61) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (43, 75) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (43, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (44, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (44, 73) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (44, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (44, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (44, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (45, 13) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (45, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (45, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (45, 20) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (45, 64) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (46, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (46, 26) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (46, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (46, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (46, 10) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (47, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (47, 73) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (47, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (47, 94) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (47, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (48, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (48, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (48, 49) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (48, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (48, 27) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (49, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (49, 74) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (49, 38) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (49, 40) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (49, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (50, 42) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (50, 51) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (50, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (50, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (50, 77) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (51, 48) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (51, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (51, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (51, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (51, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (52, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (52, 99) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (52, 89) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (52, 24) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (52, 92) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (53, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (53, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (53, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (53, 59) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (53, 97) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (54, 94) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (54, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (54, 64) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (54, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (54, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (55, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (55, 78) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (55, 42) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (55, 14) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (55, 18) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (56, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (56, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (56, 93) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (56, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (56, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (57, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (57, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (57, 51) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (57, 23) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (57, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (58, 78) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (58, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (58, 87) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (58, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (58, 100) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (59, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (59, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (59, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (59, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (59, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (60, 7) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (60, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (60, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (60, 64) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (60, 31) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (61, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (61, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (61, 56) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (61, 100) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (61, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (62, 23) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (62, 66) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (62, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (62, 99) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (62, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (63, 72) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (63, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (63, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (63, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (63, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (64, 44) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (64, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (64, 70) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (64, 23) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (64, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (65, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (65, 13) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (65, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (65, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (65, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (66, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (66, 59) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (66, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (66, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (66, 47) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (67, 77) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (67, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (67, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (67, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (67, 79) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (68, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (68, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (68, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (68, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (68, 8) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (69, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (69, 94) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (69, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (69, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (69, 44) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (70, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (70, 76) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (70, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (70, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (70, 1) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (71, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (71, 44) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (71, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (71, 54) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (71, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (72, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (72, 28) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (72, 36) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (72, 97) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (72, 40) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (73, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (73, 44) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (73, 2) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (73, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (73, 59) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (74, 70) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (74, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (74, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (74, 79) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (74, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (75, 24) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (75, 51) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (75, 87) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (75, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (75, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (76, 61) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (76, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (76, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (76, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (76, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (77, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (77, 75) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (77, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (77, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (77, 56) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (78, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (78, 90) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (78, 13) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (78, 37) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (78, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (79, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (79, 69) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (79, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (79, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (79, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (80, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (80, 91) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (80, 88) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (80, 57) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (80, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (81, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (81, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (81, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (81, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (81, 26) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (82, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (82, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (82, 11) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (82, 30) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (82, 47) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (83, 72) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (83, 96) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (83, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (83, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (83, 19) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (84, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (84, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (84, 53) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (84, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (84, 26) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (85, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (85, 67) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (85, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (85, 28) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (85, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (86, 98) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (86, 87) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (86, 2) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (86, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (86, 27) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (87, 57) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (87, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (87, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (87, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (87, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (88, 100) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (88, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (88, 23) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (88, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (88, 74) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (89, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (89, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (89, 63) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (89, 22) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (89, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (90, 60) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (90, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (90, 70) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (90, 43) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (90, 63) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (91, 90) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (91, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (91, 5) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (91, 33) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (91, 86) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (92, 25) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (92, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (92, 18) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (92, 58) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (92, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (93, 9) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (93, 31) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (93, 100) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (93, 10) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (93, 93) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (94, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (94, 64) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (94, 65) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (94, 45) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (94, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (95, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (95, 29) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (95, 91) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (95, 7) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (95, 4) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (96, 84) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (96, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (96, 40) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (96, 48) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (96, 46) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (97, 15) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (97, 10) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (97, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (97, 26) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (97, 35) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (98, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (98, 80) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (98, 52) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (98, 59) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (98, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (99, 85) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (99, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (99, 59) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (99, 68) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (99, 17) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (100, 62) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (100, 95) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (100, 65) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (100, 55) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_SONGS (USER_ID, SONG_ID) VALUES (100, 14) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (1, 64, 33) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (1, 82, 59) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (1, 39, 65) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (2, 65, 36) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (2, 58, 68) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (2, 82, 43) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (3, 61, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (3, 76, 49) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (3, 19, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (4, 65, 14) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (4, 74, 78) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (4, 29, 63) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (5, 73, 11) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (5, 40, 23) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (5, 75, 67) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (6, 62, 41) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (6, 53, 22) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (6, 20, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (7, 11, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (7, 73, 30) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (7, 8, 44) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (8, 52, 67) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (8, 43, 36) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (8, 41, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (9, 52, 38) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (9, 96, 87) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (9, 51, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (10, 3, 43) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (10, 59, 34) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (10, 27, 10) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (11, 53, 96) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (11, 60, 19) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (11, 30, 88) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (12, 58, 70) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (12, 17, 4) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (12, 95, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (13, 81, 65) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (13, 20, 89) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (13, 73, 58) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (14, 64, 38) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (14, 69, 91) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (14, 42, 49) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (15, 75, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (15, 70, 65) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (15, 36, 75) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (16, 55, 4) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (16, 42, 8) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (16, 14, 54) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (17, 18, 91) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (17, 42, 83) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (17, 19, 19) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (18, 81, 88) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (18, 32, 89) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (18, 49, 9) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (19, 61, 24) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (19, 60, 91) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (19, 27, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (20, 59, 3) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (20, 11, 13) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (20, 23, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (21, 16, 80) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (21, 99, 5) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (21, 23, 10) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (22, 49, 29) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (22, 4, 68) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (22, 85, 55) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (23, 84, 61) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (23, 97, 33) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (23, 10, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (24, 45, 68) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (24, 46, 48) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (24, 6, 76) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (25, 98, 66) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (25, 57, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (25, 17, 96) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (26, 3, 100) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (26, 23, 60) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (26, 92, 67) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (27, 50, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (27, 24, 7) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (27, 75, 20) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (28, 8, 72) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (28, 41, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (28, 38, 64) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (29, 59, 56) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (29, 30, 22) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (29, 19, 34) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (30, 2, 55) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (30, 91, 23) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (30, 99, 27) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (31, 39, 41) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (31, 27, 15) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (31, 62, 9) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (32, 49, 55) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (32, 37, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (32, 28, 61) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (33, 3, 100) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (33, 7, 11) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (33, 100, 39) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (34, 38, 43) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (34, 13, 81) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (34, 35, 38) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (35, 56, 81) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (35, 16, 15) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (35, 3, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (36, 89, 90) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (36, 36, 44) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (36, 90, 97) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (37, 54, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (37, 17, 95) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (37, 77, 59) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (38, 23, 12) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (38, 1, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (38, 47, 13) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (39, 40, 9) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (39, 23, 40) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (39, 17, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (40, 1, 94) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (40, 45, 16) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (40, 44, 83) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (41, 65, 76) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (41, 80, 44) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (41, 14, 10) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (42, 94, 52) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (42, 46, 29) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (42, 43, 60) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (43, 10, 63) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (43, 66, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (43, 30, 6) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (44, 32, 2) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (44, 23, 77) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (44, 66, 4) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (45, 87, 96) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (45, 73, 62) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (45, 19, 70) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (46, 92, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (46, 91, 63) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (46, 51, 42) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (47, 78, 52) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (47, 80, 44) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (47, 51, 92) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (48, 51, 94) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (48, 57, 27) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (48, 64, 39) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (49, 30, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (49, 39, 17) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (49, 70, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (50, 26, 48) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (50, 72, 19) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (50, 14, 50) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (51, 38, 19) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (51, 10, 29) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (51, 35, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (52, 8, 52) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (52, 94, 69) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (52, 72, 83) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (53, 100, 45) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (53, 76, 43) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (53, 27, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (54, 2, 81) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (54, 42, 24) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (54, 96, 52) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (55, 51, 41) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (55, 8, 89) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (55, 2, 30) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (56, 45, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (56, 15, 90) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (56, 6, 3) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (57, 93, 6) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (57, 19, 34) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (57, 47, 19) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (58, 84, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (58, 71, 32) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (58, 96, 62) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (59, 55, 99) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (59, 59, 22) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (59, 90, 87) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (60, 65, 64) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (60, 49, 72) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (60, 58, 72) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (61, 99, 25) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (61, 17, 23) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (61, 27, 40) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (62, 48, 6) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (62, 75, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (62, 34, 71) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (63, 12, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (63, 30, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (63, 42, 31) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (64, 54, 82) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (64, 51, 72) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (64, 63, 37) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (65, 79, 5) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (65, 52, 2) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (65, 99, 64) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (66, 36, 23) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (66, 1, 98) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (66, 74, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (67, 18, 50) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (67, 63, 22) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (67, 35, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (68, 28, 27) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (68, 32, 69) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (68, 61, 67) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (69, 28, 37) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (69, 72, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (69, 44, 56) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (70, 79, 46) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (70, 36, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (70, 54, 34) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (71, 14, 41) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (71, 36, 33) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (71, 29, 56) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (72, 81, 21) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (72, 87, 7) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (72, 61, 13) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (73, 100, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (73, 61, 47) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (73, 43, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (74, 6, 40) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (74, 22, 33) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (74, 72, 48) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (75, 14, 8) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (75, 33, 27) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (75, 45, 42) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (76, 6, 37) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (76, 16, 9) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (76, 97, 60) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (77, 21, 21) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (77, 78, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (77, 69, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (78, 100, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (78, 51, 16) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (78, 25, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (79, 78, 14) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (79, 53, 99) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (79, 95, 69) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (80, 41, 68) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (80, 50, 86) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (80, 77, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (81, 22, 99) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (81, 67, 85) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (81, 32, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (82, 2, 46) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (82, 36, 52) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (82, 5, 91) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (83, 82, 77) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (83, 93, 26) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (83, 80, 75) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (84, 6, 41) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (84, 67, 20) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (84, 80, 68) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (85, 32, 74) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (85, 27, 16) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (85, 30, 21) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (86, 95, 29) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (86, 15, 76) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (86, 53, 36) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (87, 15, 90) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (87, 81, 82) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (87, 44, 87) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (88, 68, 98) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (88, 97, 66) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (88, 96, 22) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (89, 32, 56) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (89, 94, 59) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (89, 9, 44) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (90, 15, 87) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (90, 23, 88) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (90, 35, 9) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (91, 51, 20) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (91, 94, 89) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (91, 31, 70) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (92, 67, 28) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (92, 24, 67) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (92, 27, 43) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (93, 64, 17) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (93, 83, 50) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (93, 96, 13) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (94, 71, 27) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (94, 79, 69) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (94, 3, 97) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (95, 43, 76) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (95, 57, 75) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (95, 53, 12) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (96, 7, 1) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (96, 65, 90) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (96, 25, 66) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (97, 12, 84) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (97, 84, 93) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (97, 85, 69) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (98, 28, 51) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (98, 89, 83) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (98, 74, 13) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (99, 46, 53) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (99, 50, 47) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (99, 4, 80) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (100, 42, 10) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (100, 95, 82) ON CONFLICT DO NOTHING;
INSERT INTO RATE_SONGS (USER_ID, SONG_ID, SONG_RATING) VALUES (100, 57, 84) ON CONFLICT DO NOTHING;
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (1, 10, 39, 'Sint expedita repudiandae distinctio.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (2, 46, 28, 'Ducimus aliquid itaque porro.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (2, 57, 100, 'Nisi pariatur deleniti iusto debitis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (3, 1, 90, 'Numquam sapiente voluptates hic recusandae.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (4, 43, 26, 'Nihil beatae libero consequatur incidunt corporis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (4, 46, 83, 'Soluta dolorum placeat officiis assumenda.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (5, 29, 24, 'Consequatur omnis perferendis quaerat.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (5, 86, 46, 'Minus vitae officia repellat ab.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (6, 53, 57, 'Assumenda voluptates ea laboriosam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (7, 25, 47, 'Est nam non occaecati commodi vero.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (8, 76, 75, 'Vel adipisci quasi molestias.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (9, 59, 44, 'Molestiae necessitatibus cupiditate nostrum pariatur esse praesentium fugit.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (10, 12, 74, 'Asperiores eligendi laboriosam nemo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (10, 41, 65, 'Corporis facilis dignissimos vitae reiciendis aut.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (11, 56, 94, 'Aspernatur qui perspiciatis aliquid minima fugiat cupiditate.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (11, 92, 53, 'Sapiente veritatis id.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (12, 38, 100, 'Quasi maxime cum sint iusto voluptate tempora.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (13, 32, 77, 'Quaerat cupiditate a tenetur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (13, 26, 22, 'Temporibus magnam ipsam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (14, 51, 93, 'Ipsam minus harum quis dolorem facere.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (14, 89, 93, 'Ipsa tempora similique minima eos.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (15, 30, 76, 'Iusto in ut.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (16, 86, 20, 'Enim quo deserunt mollitia enim sint.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (16, 14, 99, 'Deleniti veniam esse atque aspernatur pariatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (17, 90, 52, 'Minima molestiae fugit veniam nam placeat cumque.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (18, 63, 92, 'Quas cupiditate tempore nostrum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (18, 70, 27, 'Debitis beatae debitis necessitatibus illo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (19, 39, 67, 'Odio vel ullam perferendis repudiandae magni.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (19, 21, 57, 'Rem dolorum sunt voluptatem.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (20, 82, 40, 'Blanditiis voluptas nostrum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (20, 69, 50, 'Expedita nostrum totam qui.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (21, 91, 60, 'Itaque adipisci ex eum magni reprehenderit.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (21, 10, 24, 'Eius esse vero harum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (22, 41, 45, 'Fugit dolorum adipisci ducimus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (23, 11, 85, 'Cupiditate nulla voluptatem vero impedit ad necessitatibus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (24, 26, 46, 'Facere asperiores quod quam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (25, 55, 80, 'Neque veritatis amet sunt aperiam aspernatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (25, 19, 33, 'Placeat quod quis vel fugiat incidunt.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (26, 75, 50, 'Unde omnis debitis error libero.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (27, 33, 82, 'Alias nihil cupiditate impedit minima laborum vitae.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (27, 45, 82, 'Quae repudiandae molestiae voluptatem tenetur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (28, 26, 48, 'Voluptates id dolorem fugiat ex.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (29, 67, 66, 'Deleniti aliquid id ea quisquam aspernatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (30, 36, 73, 'Ea dicta repellendus unde quaerat porro eligendi.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (30, 23, 42, 'Odio culpa consequuntur neque nostrum cupiditate in explicabo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (31, 48, 24, 'Enim at ex officia dolorem sint.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (32, 49, 95, 'Ab soluta maxime aspernatur deleniti.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (33, 10, 96, 'Eaque soluta odio vel quasi ea nemo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (33, 76, 70, 'Nostrum earum cum nesciunt tempore optio.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (34, 43, 84, 'Voluptatem occaecati et dolorum inventore possimus eligendi cumque.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (34, 24, 100, 'Expedita ad error.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (35, 74, 52, 'Explicabo eveniet deleniti beatae error veniam magni.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (36, 17, 99, 'Atque in impedit provident corrupti perspiciatis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (36, 8, 39, 'A suscipit quisquam laborum odio soluta architecto.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (37, 22, 82, 'Doloremque doloremque numquam atque.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (37, 64, 98, 'Et sapiente temporibus eum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (38, 5, 23, 'Voluptatem culpa commodi delectus accusantium consectetur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (39, 31, 84, 'Cupiditate recusandae asperiores facere optio autem soluta.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (39, 61, 43, 'Accusantium temporibus totam voluptate corporis quas rem.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (40, 67, 83, 'Illo voluptatum quia excepturi asperiores est voluptate debitis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (41, 5, 41, 'Amet repellendus veritatis minima perspiciatis unde accusantium sit.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (41, 65, 59, 'Dolore quo dolorem id sunt rerum accusantium.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (42, 3, 41, 'Reiciendis magni aspernatur suscipit minima.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (42, 47, 47, 'Illo consequuntur enim quas porro.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (43, 45, 86, 'Eligendi occaecati commodi ducimus aspernatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (44, 10, 45, 'Numquam occaecati incidunt in quasi quod.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (45, 22, 62, 'Explicabo eaque doloremque sit fugit.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (46, 53, 73, 'Dolor dicta cumque eum dolor.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (47, 24, 26, 'Sapiente quibusdam aperiam inventore.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (48, 59, 100, 'Repellendus omnis necessitatibus voluptas libero placeat.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (49, 56, 86, 'Eius illum corrupti fuga impedit dolores.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (50, 76, 91, 'Perspiciatis architecto sed qui aperiam nesciunt distinctio.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (51, 67, 70, 'Sit corporis rem dicta ullam consequuntur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (52, 6, 75, 'Dolorum nihil quia consequuntur excepturi.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (53, 59, 90, 'Et tenetur quis dicta suscipit iusto quasi.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (53, 92, 58, 'Sequi expedita recusandae et libero veniam quo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (54, 73, 63, 'Facere quam earum modi dolores cupiditate.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (55, 6, 66, 'Cumque autem magni voluptatibus voluptatum culpa culpa.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (55, 78, 41, 'Consectetur molestias non aut nihil.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (56, 32, 54, 'A alias fugiat dolorum temporibus alias quis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (56, 8, 28, 'Laboriosam eaque explicabo ex reiciendis tempora.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (57, 71, 21, 'Dolorem nobis perspiciatis voluptas sequi magni consectetur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (57, 72, 61, 'Soluta quo repudiandae ad repudiandae.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (58, 10, 52, 'Quas a facilis non.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (58, 38, 51, 'Officia ut consequuntur maiores numquam assumenda a.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (59, 4, 58, 'Quidem esse ut laboriosam quisquam quidem facilis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (60, 54, 52, 'Adipisci similique in voluptates.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (61, 67, 41, 'Cum ea soluta nesciunt.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (61, 70, 73, 'Provident vero maiores.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (62, 48, 31, 'Blanditiis esse totam iste vitae consequuntur reprehenderit.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (62, 14, 72, 'Consectetur excepturi voluptas quaerat ullam veritatis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (63, 45, 26, 'Laudantium nostrum saepe libero mollitia praesentium sint.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (64, 31, 67, 'Minima ullam magni animi ducimus veniam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (65, 88, 77, 'Sapiente deleniti architecto magni quam placeat.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (65, 15, 51, 'Iure veniam molestias consectetur recusandae id adipisci ratione.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (66, 57, 26, 'Mollitia minima voluptatum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (67, 44, 48, 'Perspiciatis sequi repellendus aperiam ducimus minus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (68, 20, 49, 'At hic provident quia doloremque.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (69, 39, 59, 'Nulla aspernatur dolor minus reprehenderit dolorum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (70, 90, 56, 'Voluptatibus delectus facilis ducimus est.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (71, 55, 30, 'Natus et corporis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (71, 47, 61, 'Necessitatibus accusamus ullam voluptatem cupiditate.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (72, 55, 68, 'Accusamus ea veniam dignissimos sunt.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (72, 49, 24, 'Deleniti blanditiis provident.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (73, 77, 94, 'Praesentium autem nihil impedit magni officiis id quia.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (73, 41, 25, 'Reiciendis quaerat perferendis perspiciatis quam mollitia illum eum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (74, 13, 44, 'A debitis magni aspernatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (74, 4, 62, 'Exercitationem sit ea dolor rerum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (75, 25, 63, 'Facere nisi nihil rem veniam a quidem.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (75, 24, 71, 'Nesciunt laboriosam quo.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (76, 46, 97, 'Facilis earum pariatur facilis pariatur quidem.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (77, 6, 54, 'Modi libero est.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (77, 32, 38, 'Nulla consectetur nam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (78, 6, 50, 'Perferendis ex omnis dolor.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (78, 60, 87, 'Mollitia iusto eius.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (79, 82, 42, 'Soluta labore cupiditate optio nulla impedit doloribus repudiandae.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (79, 33, 81, 'Autem blanditiis officiis aspernatur aperiam perspiciatis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (80, 84, 58, 'Vero deleniti nesciunt fuga culpa explicabo natus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (81, 18, 65, 'Ipsum similique quae magnam libero.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (82, 88, 41, 'Quia quas atque temporibus a cumque error.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (83, 51, 78, 'Occaecati eos architecto ratione repellat occaecati animi.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (84, 19, 78, 'Voluptas ut sequi sapiente nesciunt.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (85, 28, 51, 'Corporis exercitationem veniam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (86, 84, 76, 'Quaerat nihil distinctio in excepturi rerum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (86, 9, 37, 'Aspernatur porro inventore repellat deserunt.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (87, 64, 43, 'Facilis delectus odit nostrum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (88, 40, 90, 'Maiores id veritatis laborum suscipit sed ipsam.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (89, 76, 26, 'Provident culpa molestias quasi adipisci inventore facilis consequuntur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (90, 90, 96, 'Incidunt optio id expedita ullam ea ut.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (90, 9, 35, 'Culpa alias fugit aliquid.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (91, 36, 31, 'Nulla illum expedita.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (91, 80, 54, 'Impedit placeat maiores sed cum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (92, 30, 68, 'Quo sunt placeat culpa.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (93, 12, 61, 'Architecto quia aut maiores blanditiis.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (94, 43, 69, 'Deleniti accusamus necessitatibus saepe dolor officiis autem error.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (94, 15, 57, 'Quod laudantium sit repudiandae inventore.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (95, 57, 29, 'Ullam consequatur impedit qui modi.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (96, 54, 44, 'Amet ullam nulla alias hic delectus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (97, 15, 71, 'Eaque dolor laudantium in quos atque.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (97, 69, 71, 'Consequuntur distinctio ipsa.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (98, 48, 99, 'Eveniet adipisci sapiente porro perferendis repellendus.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (98, 8, 25, 'Est aspernatur aspernatur.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (99, 62, 96, 'Quibusdam ea explicabo praesentium saepe dolores soluta repellat.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (100, 43, 73, 'Porro possimus sint quidem quae voluptatum.');
INSERT INTO REVIEWS (USER_ID, COLLECTION_ID, RATING, REVIEW) VALUES (100, 53, 84, 'Ab numquam accusamus aliquam perferendis ratione.');
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (137, 82) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (15, 42) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (51, 6) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (129, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (27, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (11, 49) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (66, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (119, 89) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (115, 90) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (139, 32) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (89, 21) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (74, 28) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (28, 79) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (71, 71) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (78, 25) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (7, 15) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (38, 3) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (109, 30) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (5, 83) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (128, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (98, 81) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (105, 12) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (69, 39) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (135, 58) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (36, 41) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (76, 97) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (57, 7) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (26, 93) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (136, 49) ON CONFLICT DO NOTHING;
INSERT INTO LIKE_REVIEWS (REVIEW_ID, USER_ID) VALUES (56, 73) ON CONFLICT DO NOTHING;
INSERT INTO TOURS (TOUR_ID, TOUR_DATE, TOUR_NAME, VENUE) VALUES (1, '2026-01-22', 'Banjar Tour', 'Perum Prabowo Arena');
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (1, 58) ON CONFLICT DO NOTHING;
INSERT INTO TOURS (TOUR_ID, TOUR_DATE, TOUR_NAME, VENUE) VALUES (2, '2026-07-16', 'Banjar Tour', 'CV Sitompul (Persero) Tbk Arena');
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (2, 39) ON CONFLICT DO NOTHING;
INSERT INTO TOURS (TOUR_ID, TOUR_DATE, TOUR_NAME, VENUE) VALUES (3, '2026-04-15', 'Dumai Tour', 'PT Sudiati (Persero) Tbk Arena');
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (3, 39) ON CONFLICT DO NOTHING;
INSERT INTO TOURS (TOUR_ID, TOUR_DATE, TOUR_NAME, VENUE) VALUES (4, '2026-01-02', 'Kupang Tour', 'PD Wasita Arena');
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (4, 32) ON CONFLICT DO NOTHING;
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (4, 19) ON CONFLICT DO NOTHING;
INSERT INTO TOURS (TOUR_ID, TOUR_DATE, TOUR_NAME, VENUE) VALUES (5, '2025-12-14', 'Bontang Tour', 'CV Wibisono Mayasari Tbk Arena');
INSERT INTO ARTISTS_TOURS (TOUR_ID, ARTIST_ID) VALUES (5, 50) ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (1, 1, 'https://instagram.com/artist_1') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (2, 2, 'https://instagram.com/artist_2') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (3, 3, 'https://instagram.com/artist_3') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (4, 4, 'https://instagram.com/artist_4') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (5, 5, 'https://instagram.com/artist_5') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (6, 6, 'https://instagram.com/artist_6') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (7, 7, 'https://instagram.com/artist_7') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (8, 8, 'https://instagram.com/artist_8') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (9, 9, 'https://instagram.com/artist_9') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (10, 10, 'https://instagram.com/artist_10') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (11, 11, 'https://instagram.com/artist_11') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (12, 12, 'https://instagram.com/artist_12') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (13, 13, 'https://instagram.com/artist_13') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (14, 14, 'https://instagram.com/artist_14') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (15, 15, 'https://instagram.com/artist_15') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (16, 16, 'https://instagram.com/artist_16') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (17, 17, 'https://instagram.com/artist_17') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (18, 18, 'https://instagram.com/artist_18') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (19, 19, 'https://instagram.com/artist_19') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (20, 20, 'https://instagram.com/artist_20') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (21, 21, 'https://instagram.com/artist_21') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (22, 22, 'https://instagram.com/artist_22') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (23, 23, 'https://instagram.com/artist_23') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (24, 24, 'https://instagram.com/artist_24') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (25, 25, 'https://instagram.com/artist_25') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (26, 26, 'https://instagram.com/artist_26') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (27, 27, 'https://instagram.com/artist_27') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (28, 28, 'https://instagram.com/artist_28') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (29, 29, 'https://instagram.com/artist_29') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (30, 30, 'https://instagram.com/artist_30') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (31, 31, 'https://instagram.com/artist_31') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (32, 32, 'https://instagram.com/artist_32') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (33, 33, 'https://instagram.com/artist_33') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (34, 34, 'https://instagram.com/artist_34') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (35, 35, 'https://instagram.com/artist_35') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (36, 36, 'https://instagram.com/artist_36') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (37, 37, 'https://instagram.com/artist_37') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (38, 38, 'https://instagram.com/artist_38') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (39, 39, 'https://instagram.com/artist_39') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (40, 40, 'https://instagram.com/artist_40') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (41, 41, 'https://instagram.com/artist_41') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (42, 42, 'https://instagram.com/artist_42') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (43, 43, 'https://instagram.com/artist_43') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (44, 44, 'https://instagram.com/artist_44') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (45, 45, 'https://instagram.com/artist_45') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (46, 46, 'https://instagram.com/artist_46') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (47, 47, 'https://instagram.com/artist_47') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (48, 48, 'https://instagram.com/artist_48') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (49, 49, 'https://instagram.com/artist_49') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (50, 50, 'https://instagram.com/artist_50') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (51, 51, 'https://instagram.com/artist_51') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (52, 52, 'https://instagram.com/artist_52') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (53, 53, 'https://instagram.com/artist_53') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (54, 54, 'https://instagram.com/artist_54') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (55, 55, 'https://instagram.com/artist_55') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (56, 56, 'https://instagram.com/artist_56') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (57, 57, 'https://instagram.com/artist_57') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (58, 58, 'https://instagram.com/artist_58') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (59, 59, 'https://instagram.com/artist_59') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (60, 60, 'https://instagram.com/artist_60') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (61, 61, 'https://instagram.com/artist_61') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (62, 62, 'https://instagram.com/artist_62') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (63, 63, 'https://instagram.com/artist_63') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (64, 64, 'https://instagram.com/artist_64') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (65, 65, 'https://instagram.com/artist_65') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (66, 66, 'https://instagram.com/artist_66') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (67, 67, 'https://instagram.com/artist_67') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (68, 68, 'https://instagram.com/artist_68') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (69, 69, 'https://instagram.com/artist_69') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (70, 70, 'https://instagram.com/artist_70') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (71, 71, 'https://instagram.com/artist_71') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (72, 72, 'https://instagram.com/artist_72') ON CONFLICT DO NOTHING;
INSERT INTO SOCIALS (SOCIAL_ID, ARTIST_ID, SOCIAL_MEDIA_LINK) VALUES (73, 73, 'https://instagram.com/artist_73') ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (1, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (1, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (1, 65) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (1, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (1, 89) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (2, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (2, 49) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (2, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (2, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (2, 92) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (3, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (3, 70) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (3, 26) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (3, 78) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (3, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (4, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (4, 42) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (4, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (4, 17) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (4, 19) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (5, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (5, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (5, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (5, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (5, 97) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (6, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (6, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (6, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (6, 20) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (6, 94) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (7, 64) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (7, 9) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (7, 4) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (7, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (7, 92) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (8, 37) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (8, 17) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (8, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (8, 67) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (8, 62) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (9, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (9, 21) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (9, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (9, 52) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (9, 88) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (10, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (10, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (10, 70) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (10, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (10, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (11, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (11, 52) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (11, 34) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (11, 9) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (11, 20) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (12, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (12, 26) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (12, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (12, 74) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (12, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (13, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (13, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (13, 17) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (13, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (13, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (14, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (14, 19) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (14, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (14, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (14, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (15, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (15, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (15, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (15, 80) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (15, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (16, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (16, 10) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (16, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (16, 99) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (16, 73) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (17, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (17, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (17, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (17, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (17, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (18, 65) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (18, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (18, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (18, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (18, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (19, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (19, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (19, 50) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (19, 89) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (19, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (20, 71) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (20, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (20, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (20, 67) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (20, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (21, 57) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (21, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (21, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (21, 97) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (21, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (22, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (22, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (22, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (22, 94) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (23, 22) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (23, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (23, 31) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (23, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (23, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (24, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (24, 38) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (24, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (24, 65) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (24, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (25, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (25, 24) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (25, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (25, 82) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (25, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (26, 65) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (26, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (26, 62) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (26, 24) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (26, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (27, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (27, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (27, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (27, 10) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (27, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (28, 21) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (28, 45) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (28, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (28, 97) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (28, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (29, 26) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (29, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (29, 24) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (29, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (29, 71) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (30, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (30, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (30, 49) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (30, 95) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (30, 73) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (31, 22) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (31, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (31, 70) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (31, 50) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (31, 19) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (32, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (32, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (32, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (32, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (32, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (33, 32) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (33, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (33, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (33, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (33, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (34, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (34, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (34, 37) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (34, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (34, 42) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (35, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (35, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (35, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (35, 64) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (35, 85) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (36, 20) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (36, 68) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (36, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (36, 31) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (36, 86) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (37, 38) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (37, 28) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (37, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (37, 42) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (37, 81) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (38, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (38, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (38, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (38, 32) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (38, 26) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (39, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (39, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (39, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (39, 58) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (39, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (40, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (40, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (40, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (40, 85) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (40, 49) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (41, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (41, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (41, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (41, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (41, 52) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (42, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (42, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (42, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (42, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (42, 68) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (43, 32) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (43, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (43, 28) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (43, 69) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (43, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (44, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (44, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (44, 34) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (44, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (44, 74) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (45, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (45, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (45, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (45, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (45, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (46, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (46, 70) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (46, 42) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (46, 20) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (46, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (47, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (47, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (47, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (47, 94) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (47, 74) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (48, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (48, 57) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (48, 37) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (48, 64) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (48, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (49, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (49, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (49, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (49, 10) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (49, 95) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (50, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (50, 28) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (50, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (50, 91) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (50, 20) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (51, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (51, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (51, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (51, 78) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (51, 94) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (52, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (52, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (52, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (52, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (52, 31) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (53, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (53, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (53, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (53, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (53, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (54, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (54, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (54, 4) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (54, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (54, 79) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (55, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (55, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (55, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (55, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (55, 28) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (56, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (56, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (56, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (56, 92) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (56, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (57, 67) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (57, 21) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (57, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (57, 78) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (57, 50) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (58, 42) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (58, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (58, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (58, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (58, 49) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (59, 34) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (59, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (59, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (59, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (59, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (60, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (60, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (60, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (60, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (60, 81) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (61, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (61, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (61, 68) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (61, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (61, 7) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (62, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (62, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (62, 52) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (62, 79) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (62, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (63, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (63, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (63, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (63, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (63, 88) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (64, 32) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (64, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (64, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (64, 99) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (64, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (65, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (65, 73) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (65, 5) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (65, 34) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (65, 99) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (66, 50) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (66, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (66, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (66, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (67, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (67, 69) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (67, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (67, 54) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (67, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (68, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (68, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (68, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (68, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (68, 94) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (69, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (69, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (69, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (69, 93) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (69, 99) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (70, 14) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (70, 57) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (70, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (70, 32) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (70, 73) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (71, 10) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (71, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (71, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (71, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (71, 45) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (72, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (72, 71) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (72, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (72, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (72, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (73, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (73, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (73, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (73, 79) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (73, 81) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (74, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (74, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (74, 21) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (74, 77) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (74, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (75, 34) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (75, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (75, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (75, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (75, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (76, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (76, 11) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (76, 52) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (76, 14) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (76, 50) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (77, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (77, 54) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (77, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (77, 38) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (78, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (78, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (78, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (78, 33) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (78, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (79, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (79, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (79, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (79, 43) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (79, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (80, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (80, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (80, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (80, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (80, 8) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (81, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (81, 54) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (81, 51) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (81, 84) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (81, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (82, 19) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (82, 31) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (82, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (82, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (82, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (83, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (83, 28) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (83, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (83, 93) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (83, 90) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (84, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (84, 26) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (84, 65) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (84, 98) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (84, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (85, 36) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (85, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (85, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (85, 4) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (85, 80) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (86, 9) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (86, 38) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (86, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (86, 24) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (86, 84) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (87, 59) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (87, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (87, 62) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (87, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (87, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (88, 69) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (88, 1) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (88, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (88, 27) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (88, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (89, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (89, 53) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (89, 6) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (89, 90) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (89, 70) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (90, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (90, 3) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (90, 41) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (90, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (90, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (91, 73) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (91, 60) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (91, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (91, 75) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (91, 58) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (92, 30) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (92, 16) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (92, 46) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (92, 40) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (92, 76) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (93, 15) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (93, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (93, 64) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (93, 19) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (93, 35) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (94, 12) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (94, 71) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (94, 44) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (94, 66) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (94, 25) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (95, 55) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (95, 56) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (95, 18) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (95, 47) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (95, 81) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (96, 61) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (96, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (96, 21) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (96, 37) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (96, 75) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (97, 38) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (97, 37) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (97, 2) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (97, 29) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (97, 90) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (98, 39) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (98, 72) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (98, 63) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (98, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (98, 87) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (99, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (99, 49) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (99, 48) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (99, 82) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (99, 10) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (100, 23) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (100, 64) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_ARTISTS (USER_ID, ARTIST_ID) VALUES (100, 13) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (100, 83) ON CONFLICT DO NOTHING;
INSERT INTO FOLLOW_USERS (FOLLOWER_ID, FOLLOWED_ID) VALUES (100, 64) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (1, 3) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (1, 143) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (2, 25) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (2, 11) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (3, 17) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (3, 143) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (4, 6) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (4, 105) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (5, 46) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (5, 82) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (6, 11) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (6, 93) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (7, 60) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (7, 135) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (8, 78) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (8, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (9, 4) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (9, 49) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (10, 70) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (10, 99) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (11, 68) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (11, 116) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (12, 74) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (12, 100) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (13, 16) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (13, 133) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (14, 73) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (14, 11) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (15, 73) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (15, 4) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (16, 81) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (16, 99) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (17, 91) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (17, 147) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (18, 57) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (18, 146) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (19, 26) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (19, 52) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (20, 75) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (20, 118) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (21, 6) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (21, 105) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (22, 77) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (22, 114) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (23, 87) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (23, 25) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (24, 38) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (24, 40) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (25, 67) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (25, 52) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (26, 60) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (26, 11) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (27, 68) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (27, 62) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (28, 68) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (28, 147) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (29, 61) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (29, 4) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (30, 2) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (30, 39) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (31, 64) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (31, 69) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (32, 37) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (32, 138) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (33, 24) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (33, 131) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (34, 10) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (34, 53) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (35, 47) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (35, 98) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (36, 35) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (36, 60) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (37, 65) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (37, 50) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (38, 77) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (38, 14) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (39, 58) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (39, 62) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (40, 44) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (40, 126) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (41, 3) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (41, 8) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (42, 64) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (42, 26) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (43, 35) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (43, 77) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (44, 11) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (44, 90) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (45, 29) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (45, 58) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (46, 71) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (46, 24) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (47, 12) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (47, 12) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (48, 88) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (48, 142) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (49, 11) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (49, 5) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (50, 65) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (50, 77) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (51, 88) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (51, 107) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (52, 13) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (52, 90) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (53, 36) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (53, 4) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (54, 16) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (54, 110) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (55, 55) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (55, 33) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (56, 87) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (56, 121) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (57, 27) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (57, 132) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (58, 48) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (58, 139) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (59, 24) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (59, 53) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (60, 13) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (60, 22) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (61, 63) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (61, 86) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (62, 26) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (62, 102) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (63, 71) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (63, 45) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (64, 53) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (64, 74) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (65, 49) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (65, 14) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (66, 51) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (66, 10) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (67, 14) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (67, 74) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (68, 22) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (68, 10) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (69, 13) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (69, 67) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (70, 2) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (70, 73) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (71, 43) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (71, 83) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (72, 61) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (72, 103) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (73, 29) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (73, 96) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (74, 87) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (74, 41) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (75, 24) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (75, 85) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (76, 81) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (76, 55) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (77, 81) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (77, 134) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (78, 61) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (78, 49) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (79, 17) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (79, 148) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (80, 75) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (80, 64) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (81, 4) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (81, 36) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (82, 22) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (82, 141) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (83, 59) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (83, 143) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (84, 76) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (84, 110) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (85, 32) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (85, 68) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (86, 64) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (86, 66) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (87, 92) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (87, 34) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (88, 41) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (88, 105) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (89, 43) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (89, 111) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (90, 5) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (90, 75) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (91, 47) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (91, 90) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (92, 39) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (92, 29) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (93, 41) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (93, 9) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (94, 25) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (94, 53) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (95, 64) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (95, 111) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (96, 48) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (96, 128) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (97, 51) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (97, 144) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (98, 44) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (98, 31) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (99, 85) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (99, 148) ON CONFLICT DO NOTHING;
INSERT INTO COLLECTION_LIBRARY (USER_ID, COLLECTION_ID) VALUES (100, 24) ON CONFLICT DO NOTHING;
INSERT INTO PL_LIBRARY (USER_ID, PLAYLIST_ID) VALUES (100, 106) ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (6, 6, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (8, 8, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (9, 9, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (12, 12, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (13, 13, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (14, 14, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (15, 15, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (16, 16, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (20, 20, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (22, 22, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (23, 24, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (24, 25, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (27, 34, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (28, 29, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (30, 31, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (33, 35, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (34, 36, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (35, 37, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (37, 39, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (42, 45, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (43, 46, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (44, 47, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (46, 81, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (47, 50, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (50, 53, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (55, 69, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (57, 71, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (62, 76, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (63, 77, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (67, 85, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (68, 86, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO ARTIST_PROMOTION (ARTIST_ID, COLLECTION_ID, KOMENTAR_PROMOSI) VALUES (70, 89, 'Check my new stuff!') ON CONFLICT DO NOTHING;
INSERT INTO BLOCK_USERS (BLOCKER_ID, BLOCKED_ID) VALUES (43, 100) ON CONFLICT DO NOTHING;
INSERT INTO BLOCK_USERS (BLOCKER_ID, BLOCKED_ID) VALUES (84, 67) ON CONFLICT DO NOTHING;
INSERT INTO BLOCK_USERS (BLOCKER_ID, BLOCKED_ID) VALUES (31, 84) ON CONFLICT DO NOTHING;
INSERT INTO BLOCK_USERS (BLOCKER_ID, BLOCKED_ID) VALUES (19, 74) ON CONFLICT DO NOTHING;
INSERT INTO BLOCK_USERS (BLOCKER_ID, BLOCKED_ID) VALUES (13, 51) ON CONFLICT DO NOTHING;
INSERT INTO BLOCKLIST_ARTISTS (ARTIST_ID, USER_ID) VALUES (56, 81) ON CONFLICT DO NOTHING;
INSERT INTO BLOCKLIST_ARTISTS (ARTIST_ID, USER_ID) VALUES (3, 61) ON CONFLICT DO NOTHING;
INSERT INTO BLOCKLIST_ARTISTS (ARTIST_ID, USER_ID) VALUES (13, 58) ON CONFLICT DO NOTHING;
INSERT INTO BLOCKLIST_ARTISTS (ARTIST_ID, USER_ID) VALUES (9, 54) ON CONFLICT DO NOTHING;
INSERT INTO BLOCKLIST_ARTISTS (ARTIST_ID, USER_ID) VALUES (64, 36) ON CONFLICT DO NOTHING;
SELECT setval('seq_users_id', (SELECT MAX(USER_ID) FROM USERS));
SELECT setval('seq_artists_id', (SELECT MAX(ARTIST_ID) FROM ARTISTS));
SELECT setval('seq_genres_id', (SELECT MAX(GENRE_ID) FROM GENRES));
SELECT setval('seq_collections_id', (SELECT MAX(COLLECTION_ID) FROM COLLECTIONS));
SELECT setval('seq_songs_id', (SELECT MAX(SONG_ID) FROM SONGS));
SELECT setval('seq_reviews_id', (SELECT MAX(REVIEW_ID) FROM REVIEWS));
SELECT setval('seq_playlists_id', (SELECT MAX(PLAYLIST_ID) FROM PLAYLISTS));
SELECT setval('seq_socials_id', (SELECT MAX(SOCIAL_ID) FROM SOCIALS));
SELECT setval('seq_tours_id', (SELECT MAX(TOUR_ID) FROM TOURS));
SELECT setval('seq_listens_id', (SELECT MAX(LISTEN_ID) FROM LISTENS));
SELECT setval('seq_add_songs_playlist_id', (SELECT MAX(ADD_SONG_PL_ID) FROM ADD_SONGS_PLAYLISTS));
COMMIT;


DROP VIEW IF EXISTS VIEW_ALBUM_TRACKLIST CASCADE;

CREATE OR REPLACE VIEW VIEW_ALBUM_TRACKLIST AS
WITH
-- 1) Aggregate Album Artists (because some albums have multiple artists)
ALBUM_ARTISTS AS (
    SELECT
        R.COLLECTION_ID,
        STRING_AGG(DISTINCT A.ARTIST_NAME, ', ' ORDER BY A.ARTIST_NAME) AS ALBUM_ARTISTS
    FROM RELEASES R
    JOIN ARTISTS A ON R.ARTIST_ID = A.ARTIST_ID
    GROUP BY R.COLLECTION_ID
),

-- 2) Aggregate Song Artists
SONG_ARTISTS AS (
    SELECT
        CRS.SONG_ID,
        STRING_AGG(DISTINCT A.ARTIST_NAME, ', ' ORDER BY A.ARTIST_NAME) AS SONG_ARTISTS
    FROM CREATE_SONGS CRS
    JOIN ARTISTS A ON CRS.ARTIST_ID = A.ARTIST_ID
    GROUP BY CRS.SONG_ID
)

SELECT
    C.COLLECTION_ID,
    C.COLLECTION_TITLE,
    AA.ALBUM_ARTISTS,

    CS.NOMOR_DISC,
    CS.NOMOR_TRACK,
    S.SONG_TITLE,

    SA.SONG_ARTISTS,

    TO_CHAR((S.SONG_DURATION || ' second')::interval, 'MI:SS') AS DURATION

FROM COLLECTIONS C
JOIN ALBUM_ARTISTS AA ON C.COLLECTION_ID = AA.COLLECTION_ID

JOIN COLLECTIONS_SONGS CS ON C.COLLECTION_ID = CS.COLLECTION_ID
JOIN SONGS S ON CS.SONG_ID = S.SONG_ID
LEFT JOIN SONG_ARTISTS SA ON SA.SONG_ID = S.SONG_ID

ORDER BY
    C.COLLECTION_ID,
    CS.NOMOR_DISC,
    CS.NOMOR_TRACK;


    DROP VIEW IF EXISTS VIEW_ARTIST_PROFILE_HEADER CASCADE;

    CREATE OR REPLACE VIEW VIEW_ARTIST_PROFILE_HEADER AS
    WITH TOTAL_ALBUMS AS (
        SELECT ARTIST_ID, COUNT(*) AS TOTAL_ALBUMS
        FROM RELEASES
        GROUP BY ARTIST_ID
    ),
    TOTAL_TRACKS AS (
        SELECT ARTIST_ID, COUNT(*) AS TOTAL_TRACKS
        FROM CREATE_SONGS
        GROUP BY ARTIST_ID
    )
    SELECT
        A.ARTIST_ID,
        A.ARTIST_NAME,
        A.BIO,
        A.ARTIST_PFP,
        A.BANNER,
        A.ARTIST_EMAIL,

        A.MONTHLY_LISTENER_COUNT,
        A.FOLLOWER_COUNT,

        COALESCE(ALB.TOTAL_ALBUMS, 0) AS TOTAL_ALBUMS,
        COALESCE(TRK.TOTAL_TRACKS, 0) AS TOTAL_TRACKS

    FROM ARTISTS A
    LEFT JOIN TOTAL_ALBUMS ALB ON A.ARTIST_ID = ALB.ARTIST_ID
    LEFT JOIN TOTAL_TRACKS TRK ON A.ARTIST_ID = TRK.ARTIST_ID;


    DROP VIEW IF EXISTS VIEW_FULL_SONG_DETAILS CASCADE;

    CREATE OR REPLACE VIEW VIEW_FULL_SONG_DETAILS AS
    SELECT
        S.SONG_ID,
        S.SONG_TITLE,
        STRING_AGG(DISTINCT A.ARTIST_NAME, ', ') AS ARTISTS_NAME,
        C.COLLECTION_TITLE AS ALBUM_NAME,
        S.SONG_DURATION,
        S.POPULARITY,
        S.SONG_FILE,
        TO_CHAR((S.SONG_DURATION || ' second')::interval, 'MI:SS') AS DURATION_FORMATTED
    FROM SONGS S
    -- join ke artis
    JOIN CREATE_SONGS CS ON S.SONG_ID = CS.SONG_ID
    JOIN ARTISTS A ON CS.ARTIST_ID = A.ARTIST_ID
    -- join ke album
    LEFT JOIN COLLECTIONS_SONGS C_S ON S.SONG_ID = C_S.SONG_ID
    LEFT JOIN COLLECTIONS C ON C_S.COLLECTION_ID = C.COLLECTION_ID
    GROUP BY
        -- sisa kolom lain wajib di group-by
        S.SONG_ID,
        S.SONG_TITLE,
        C.COLLECTION_TITLE,
        S.SONG_DURATION,
        S.POPULARITY,
        S.SONG_FILE;



        DROP VIEW IF EXISTS VIEW_TOP_CHARTS CASCADE;

        CREATE OR REPLACE VIEW VIEW_TOP_CHARTS AS
        WITH SONG_ARTISTS AS (
            SELECT
                CRS.SONG_ID,
                STRING_AGG(DISTINCT A.ARTIST_NAME, ', ' ORDER BY A.ARTIST_NAME) AS ARTISTS
            FROM CREATE_SONGS CRS
            JOIN ARTISTS A ON A.ARTIST_ID = CRS.ARTIST_ID
            GROUP BY CRS.SONG_ID
        ),
        SONG_ALBUM AS (
            SELECT DISTINCT ON (CS.SONG_ID)
                CS.SONG_ID,
                C.COLLECTION_TITLE AS ALBUM
            FROM COLLECTIONS_SONGS CS
            LEFT JOIN COLLECTIONS C ON C.COLLECTION_ID = CS.COLLECTION_ID
            ORDER BY CS.SONG_ID, C.COLLECTION_TITLE
        )
        SELECT
            ROW_NUMBER() OVER (ORDER BY S.POPULARITY DESC) AS RANK,
            S.SONG_TITLE,
            SA.ARTISTS,
            AL.ALBUM,
            S.POPULARITY
        FROM SONGS S
        LEFT JOIN SONG_ARTISTS SA ON SA.SONG_ID = S.SONG_ID
        LEFT JOIN SONG_ALBUM AL ON AL.SONG_ID = S.SONG_ID
        WHERE S.POPULARITY IS NOT NULL
        ORDER BY S.POPULARITY DESC;



        DROP VIEW IF EXISTS VIEW_USER_LIBRARY_STATS CASCADE;

        CREATE OR REPLACE VIEW VIEW_USER_LIBRARY_STATS AS
        WITH PUB_PLAYLISTS AS (
            SELECT USER_ID, COUNT(*) AS PUBLIC_PLAYLISTS
            FROM PLAYLISTS
            WHERE ISPUBLIC = TRUE
            GROUP BY USER_ID
        ),
        FOLLOWING_USERS AS (
            SELECT FOLLOWER_ID AS USER_ID, COUNT(*) AS FOLLOW_USERS_COUNT
            FROM FOLLOW_USERS
            GROUP BY FOLLOWER_ID
        ),
        FOLLOWING_ARTISTS AS (
            SELECT USER_ID, COUNT(*) AS FOLLOW_ARTISTS_COUNT
            FROM FOLLOW_ARTISTS
            GROUP BY USER_ID
        ),
        FOLLOWERS AS (
            SELECT FOLLOWED_ID AS USER_ID, COUNT(*) AS FOLLOWERS_COUNT
            FROM FOLLOW_USERS
            GROUP BY FOLLOWED_ID
        )
        SELECT
            U.USER_ID,
            U.USERNAME,
            U.USER_PFP,

            COALESCE(PP.PUBLIC_PLAYLISTS, 0) AS PUBLIC_PLAYLISTS,

            COALESCE(FU.FOLLOW_USERS_COUNT, 0) +
            COALESCE(FA.FOLLOW_ARTISTS_COUNT, 0) AS FOLLOWING_COUNT,

            COALESCE(FR.FOLLOWERS_COUNT, 0) AS FOLLOWERS_COUNT

        FROM USERS U
        LEFT JOIN PUB_PLAYLISTS PP ON PP.USER_ID = U.USER_ID
        LEFT JOIN FOLLOWING_USERS FU ON FU.USER_ID = U.USER_ID
        LEFT JOIN FOLLOWING_ARTISTS FA ON FA.USER_ID = U.USER_ID
        LEFT JOIN FOLLOWERS FR ON FR.USER_ID = U.USER_ID;

        -- Function: Update user_id lagu ketika playlist tidak lagi collaborative
        CREATE OR REPLACE FUNCTION fix_playlist_collaborators()
        RETURNS TRIGGER AS $$
        BEGIN
            -- Jika sebelumnya collaborative dan sekarang tidak collaborative
            IF OLD.iscollaborative = TRUE AND NEW.iscollaborative = FALSE THEN

                -- Update semua lagu yang ditambahkan oleh user lain
                UPDATE add_songs_playlists
                SET user_id = NEW.user_id
                WHERE playlist_id = NEW.playlist_id
                AND user_id <> NEW.user_id;
            END IF;

            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        -- Trigger: berjalan ketika playlist di-update
        CREATE TRIGGER trg_fix_playlist_collaborators
        AFTER UPDATE OF iscollaborative
        ON playlists
        FOR EACH ROW
        EXECUTE FUNCTION fix_playlist_collaborators();

        CREATE OR REPLACE FUNCTION reorder_playlist_sequence()
        RETURNS TRIGGER AS $$
        BEGIN
            UPDATE add_songs_playlists
            SET no_urut = no_urut - 1
            WHERE playlist_id = OLD.playlist_id
            AND no_urut > OLD.no_urut;
            RETURN OLD;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER trg_reorder_playlist_delete
        AFTER DELETE ON add_songs_playlists
        FOR EACH ROW
        EXECUTE FUNCTION reorder_playlist_sequence();




        -- Trigger follow–unfollow artis
        CREATE OR REPLACE FUNCTION update_artist_follow_count()
        RETURNS TRIGGER AS $$
        BEGIN
            -- FOLLOW → INSERT
            IF TG_OP = 'INSERT' THEN
                UPDATE artists
                SET follower_count = COALESCE(follower_count, 0) + 1
                WHERE artist_id = NEW.artist_id;
            END IF;

            -- UNFOLLOW → DELETE
            IF TG_OP = 'DELETE' THEN
                UPDATE artists
                SET follower_count = COALESCE(follower_count, 0) - 1
                WHERE artist_id = OLD.artist_id;
            END IF;

            RETURN NULL;
        END;
        $$ LANGUAGE plpgsql;


        -- trigger
        CREATE TRIGGER trg_update_artist_follow_count
        AFTER INSERT OR DELETE
        ON follow_artists
        FOR EACH ROW
        EXECUTE FUNCTION update_artist_follow_count();


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

        CREATE TRIGGER trg_update_collection_rating
        AFTER INSERT OR UPDATE OR DELETE
        ON reviews
        FOR EACH ROW
        EXECUTE FUNCTION update_collection_rating();


        -- Update_collection_top3_genres
        CREATE OR REPLACE FUNCTION update_collection_top3_genres()
        RETURNS TRIGGER AS $$
        DECLARE
            top_genre RECORD;
        BEGIN
            -- Hapus data lama untuk collection ini
            DELETE FROM collection_top_3_genres
            WHERE collection_id = NEW.collection_id;

            -- Ambil 3 genre paling sering muncul dari lagu-lagu collection
            FOR top_genre IN
                SELECT sg.genre_id
                FROM songs_genres sg
                JOIN collections_songs cs ON sg.song_id = cs.song_id
                WHERE cs.collection_id = NEW.collection_id
                GROUP BY sg.genre_id
                ORDER BY COUNT(*) DESC
                LIMIT 3
            LOOP
                -- Insert ke COLLECTION_TOP_3_GENRES
                INSERT INTO collection_top_3_genres (collection_id, genre_id)
                VALUES (NEW.collection_id, top_genre.genre_id);
            END LOOP;

            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;


        -- trigger
        CREATE TRIGGER trg_update_collection_top3_genres
        AFTER INSERT OR UPDATE ON collections_songs
        FOR EACH ROW
        EXECUTE FUNCTION update_collection_top3_genres();


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


        -- Update song rating
        CREATE OR REPLACE FUNCTION update_song_rating()
        RETURNS TRIGGER AS $$
        DECLARE
            v_new_rating NUMERIC(5,2);
        BEGIN
            -- Hitung ulang rata-rata rating untuk song
            SELECT AVG(song_rating)
            INTO v_new_rating
            FROM rate_songs
            WHERE song_id = COALESCE(NEW.song_id, OLD.song_id);

            -- Update ke tabel songs
            UPDATE songs
            SET song_rating = v_new_rating
            WHERE song_id = COALESCE(NEW.song_id, OLD.song_id);

            RETURN NULL;
        END;
        $$ LANGUAGE plpgsql;


        -- Trigger
        CREATE TRIGGER trg_update_song_rating
        AFTER INSERT OR UPDATE OR DELETE
        ON rate_songs
        FOR EACH ROW
        EXECUTE FUNCTION update_song_rating();

        CREATE OR REPLACE FUNCTION enforce_block_logic()
        RETURNS TRIGGER AS $$
        BEGIN
            -- Hapus hubungan follow kedua arah
            DELETE FROM follow_users
            WHERE (follower_id = NEW.blocker_id AND followed_id = NEW.blocked_id)
               OR (follower_id = NEW.blocked_id AND followed_id = NEW.blocker_id);
            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER trg_block_cleanup
        AFTER INSERT ON block_users
        FOR EACH ROW
        EXECUTE FUNCTION enforce_block_logic();


        CREATE OR REPLACE FUNCTION validate_prerelease_date()
        RETURNS TRIGGER AS $$
        BEGIN
            -- RULE 1: prerelease must be future
            IF NEW.isPrerelease = TRUE  -- Jika isPrerelease = TRUE
               AND NEW.collection_release_date <= CURRENT_DATE THEN   -- Tetapi tanggal rilis tidak di masa depan
                RAISE EXCEPTION
                    'If isPrerelease = TRUE, then release_date (%s) must be in the future.',  -- Pesan error
                    NEW.collection_release_date;
            END IF;

            -- RULE 2: NOT prerelease must be today or past
            IF NEW.isPrerelease = FALSE  -- Jika isPrerelease = FALSE
               AND NEW.collection_release_date > CURRENT_DATE THEN -- Tetapi tanggal rilis berada di masa depan
                RAISE EXCEPTION
                    'If isPrerelease = FALSE, release_date (%s) cannot be in the future.',  -- Pesan error
                    NEW.collection_release_date;   -- Menampilkan tanggal yang salah
            END IF;

            -- RULE 3: If release date is today → force prerelease = FALSE
            IF NEW.collection_release_date = CURRENT_DATE THEN   -- Jika tanggal rilis sama dengan hari ini
                NEW.isPrerelease := FALSE;  -- isPrerelease menjadi FALSE
            END IF;

            RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER trg_validate_prerelease_date
        BEFORE INSERT OR UPDATE ON collections
        FOR EACH ROW
        EXECUTE FUNCTION validate_prerelease_date();

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

        /*==============================================================*/
        /* Function: GET_ARTIST_DETAIL                                  */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS get_artist_detail(INT);

        CREATE OR REPLACE FUNCTION get_artist_detail(p_artist_id INT)
        RETURNS TABLE (
            artist_id INT,
            artist_name VARCHAR(255),
            bio TEXT,
            artist_pfp VARCHAR(2048),
            banner VARCHAR(2048),
            artist_email VARCHAR(320),
            monthly_listener_count BIGINT,
            follower_count BIGINT,
            total_albums BIGINT,
            total_tracks BIGINT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT * FROM view_artist_profile_header v WHERE v.artist_id = p_artist_id;
        END;
        $$ LANGUAGE plpgsql STABLE;

        SELECT * FROM get_artist_detail(3)
        /*==============================================================*/
        /* Function: GET_ARTIST_CONTENT                                 */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS get_artist_content(INT, TEXT);

        CREATE OR REPLACE FUNCTION get_artist_content(p_artist_id INT, p_type TEXT)
        RETURNS TABLE (
            content_type TEXT,
            content_id INT,
            title TEXT,
            extra_info TEXT
        )
        AS $$
        BEGIN
            -- ========== SONGS ==========
            IF p_type = 'songs' THEN
                RETURN QUERY
                SELECT
                    'song',
                    v.song_id,
                    v.song_title ::TEXT,
                    'Album: ' || COALESCE(v.album_name, '-') || ' • Popularity: ' || v.popularity
                FROM view_full_song_details v
                WHERE v.artist_name ILIKE (
                    SELECT '%' || artist_name || '%'
                    FROM artists WHERE artist_id = p_artist_id
                )
                ORDER BY v.popularity DESC;

            -- ========== COLLECTIONS ==========
            ELSIF p_type = 'collections' THEN
                RETURN QUERY
                SELECT
                    'collection',
                    c.collection_id,
                    c.collection_title ::TEXT,
                    c.collection_type ::TEXT
                FROM releases r
                JOIN collections c ON c.collection_id = r.collection_id
                WHERE r.artist_id = p_artist_id;

            -- ========== TOURS ==========
            ELSIF p_type = 'tours' THEN
                RETURN QUERY
                SELECT
                    'tour',
                    t.tour_id,
                    t.tour_name ::TEXT,
                    t.venue || ' • ' || t.tour_date
                FROM artists_tours at
                JOIN tours t ON t.tour_id = at.tour_id
                WHERE at.artist_id = p_artist_id;

            -- ========== PROMOTIONS ==========
            ELSIF p_type = 'promotions' THEN
                RETURN QUERY
                SELECT
                    'promotion',
                    ap.collection_id,
                    c.collection_title ::TEXT,
                    ap.komentar_promosi
                FROM artist_promotion ap
                LEFT JOIN collections c ON c.collection_id = ap.collection_id
                WHERE ap.artist_id = p_artist_id;

            ELSE
                RAISE EXCEPTION 'Invalid type: %, valid types: songs, collections, tours, promotions', p_type;
            END IF;

        END;
        $$ LANGUAGE plpgsql STABLE;

        SELECT * FROM get_artist_content(2, 'songs')
        SELECT * FROM get_artist_content(2, 'collections')
        SELECT * FROM get_artist_content(2, 'tours')
        SELECT * FROM get_artist_content(2, 'promotions')
        SELECT * FROM get_artist_content(2, 'song')

        /*==============================================================*/
        /* Procedure: TOGGLE_FOLLOW_ARTIST                              */
        /*==============================================================*/
        CREATE OR REPLACE PROCEDURE toggle_follow_artist(p_user_id INT, p_artist_id INT)
        LANGUAGE plpgsql
        AS $$
        BEGIN
            -- cek user valid
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
                RAISE EXCEPTION 'User_id % not found', p_user_id;
            END IF;

            -- cek artist valid
            IF NOT EXISTS (SELECT 1 FROM artists WHERE artist_id = p_artist_id) THEN
                RAISE EXCEPTION 'Artist_id % not found', p_artist_id;
            END IF;

            -- jika sudah follow -> UNFOLLOW
            IF EXISTS (
                SELECT 1 FROM follow_artists
                WHERE user_id = p_user_id AND artist_id = p_artist_id
            ) THEN
                DELETE FROM follow_artists
                WHERE user_id = p_user_id AND artist_id = p_artist_id;

                RAISE NOTICE 'Unfollowed artist %', p_artist_id;
                RETURN;
            END IF;

            -- jika belum follow -> FOLLOW
            INSERT INTO follow_artists(user_id, artist_id)
            VALUES (p_user_id, p_artist_id);

            RAISE NOTICE 'Followed artist %', p_artist_id;

        END;
        $$;

        call toggle_follow_artist(1, 12)
        select * from follow_artists
        call toggle_follow_artist(9999, 12)
        call toggle_follow_artist(12, 9999)
        call toggle_follow_artist(1, 12)
        select * from follow_artists

        CREATE OR REPLACE FUNCTION get_song_average_rating(p_song_id INT)
        RETURNS NUMERIC AS $$
        DECLARE
            avg_rating NUMERIC;
        BEGIN
            SELECT AVG(r.song_rating)
            INTO avg_rating
            FROM rate_songs r
            WHERE r.song_id = p_song_id;

            RETURN avg_rating;
        END;
        $$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION get_playlist_duration_minutes(p_playlist_id INT)
        RETURNS INT AS $$
        DECLARE
            v_total_sec INT;
        BEGIN
            SELECT SUM(s.song_duration)
            INTO v_total_sec
            FROM songs s
            JOIN add_songs_playlists asp ON s.song_id = asp.song_id
            WHERE asp.playlist_id = p_playlist_id;

            RETURN COALESCE(v_total_sec / 60, 0);
        END;
        $$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION get_artist_total_plays(p_artist_id INT)
        RETURNS BIGINT AS $$
        DECLARE
            v_total_plays BIGINT;
        BEGIN
            SELECT COUNT(l.listen_id)
            INTO v_total_plays
            FROM create_songs cs
            JOIN listens l ON cs.song_id = l.song_id
            WHERE cs.artist_id = p_artist_id;

            RETURN COALESCE(v_total_plays, 0);
        END;
        $$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION get_album_total_duration(p_collection_id INT)
        RETURNS INT AS $$
        DECLARE
            v_total_seconds INT;
        BEGIN
            -- Aggregation: SUM (Menjumlahkan nilai durasi)
            SELECT SUM(s.song_duration)
            INTO v_total_seconds
            FROM collections_songs cs
            JOIN songs s ON cs.song_id = s.song_id
            WHERE cs.collection_id = p_collection_id;

            RETURN COALESCE(v_total_seconds, 0);
        END;
        $$ LANGUAGE plpgsql;

        CREATE OR REPLACE FUNCTION get_collection_genres(p_collection_id INT)
        RETURNS TABLE(genre_id INT, genre_name VARCHAR)
        LANGUAGE plpgsql
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                g.genre_id,
                g.genre_name
            FROM COLLECTION_TOP_3_GENRES ct3g
            JOIN GENRES g ON g.genre_id = ct3g.genre_id
            WHERE ct3g.collection_id = p_collection_id;
        END;
        $$;


        CREATE OR REPLACE FUNCTION get_collection_average_rating(p_collection_id INT)
        RETURNS NUMERIC AS
        $$
        DECLARE
            v_rating NUMERIC;
        BEGIN
            -- Mengambil nilai yang sudah dihitung oleh trigger
            SELECT COLLECTION_RATING
            INTO v_rating
            FROM COLLECTIONS
            WHERE COLLECTION_ID = p_collection_id;

            RETURN COALESCE(v_rating, 0);
        END;
        $$ LANGUAGE plpgsql;


        DROP FUNCTION IF EXISTS get_collection_detail(INT);
        CREATE OR REPLACE FUNCTION get_collection_detail(p_collection_id INT)
        RETURNS TABLE (
            collection_id INT,
            collection_title TEXT,
            collection_type TEXT,
            collection_cover TEXT,
            release_date DATE,
            rating NUMERIC(3,0),
            is_prerelease BOOL,
            total_tracks BIGINT,
            total_artists BIGINT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                c.collection_id,
                c.collection_title ::TEXT,
                c.collection_type ::TEXT,
                c.collection_cover ::TEXT,
                c.collection_release_date,
                c.collection_rating,
                c.isprerelease,
                (SELECT COUNT(*) FROM collections_songs cs
                 WHERE cs.collection_id = c.collection_id) AS total_tracks,
                (SELECT COUNT(DISTINCT r.artist_id)
                 FROM releases r
                 WHERE r.collection_id = c.collection_id) AS total_artists
            FROM collections c
            WHERE c.collection_id = p_collection_id;
        END;
        $$ LANGUAGE plpgsql STABLE;

        SELECT * FROM get_collection_detail(1);
        SELECT * FROM get_collection_detail(999);

        DROP FUNCTION IF EXISTS get_collection_tracks
        CREATE OR REPLACE FUNCTION get_collection_tracks(p_collection_id INT)
        RETURNS TABLE (
            track_number INT,
            song_id INT,
            song_title TEXT,
            artist_name TEXT,
            duration INT,
            popularity NUMERIC(3,0),
            song_file TEXT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                cs.nomor_track,
                v.song_id,
                v.song_title ::TEXT,
                v.artist_name ::TEXT,
                v.song_duration,
                v.popularity,
                v.song_file ::TEXT
            FROM collections_songs cs
            JOIN view_full_song_details v ON v.song_id = cs.song_id
            WHERE cs.collection_id = p_collection_id
            ORDER BY cs.nomor_disc, cs.nomor_track;
        END;
        $$ LANGUAGE plpgsql STABLE;

        SELECT * FROM get_collection_tracks(1);

        DROP FUNCTION IF EXISTS get_new_releases
        CREATE OR REPLACE FUNCTION get_new_releases(p_limit INT)
        RETURNS TABLE (
            collection_id INT,
            title TEXT,
            artist_name TEXT,
            release_date DATE,
            total_tracks BIGINT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                c.collection_id,
                c.collection_title ::TEXT,
                STRING_AGG(DISTINCT a.artist_name, ', ') AS artist_name,
                c.collection_release_date,
                COUNT(cs.song_id) AS total_tracks
            FROM collections c
            LEFT JOIN releases r ON r.collection_id = c.collection_id
            LEFT JOIN artists a ON a.artist_id = r.artist_id
            LEFT JOIN collections_songs cs ON cs.collection_id = c.collection_id
            GROUP BY
                c.collection_id,
                c.collection_title,
                c.collection_release_date
            ORDER BY c.collection_release_date DESC
            LIMIT p_limit;
        END;
        $$ LANGUAGE plpgsql STABLE;

        SELECT * FROM get_new_releases(5);
        SELECT * FROM get_new_releases(20);

        --  PROCEDURE log_listen
        CREATE OR REPLACE PROCEDURE log_listen(
            p_user_id INT,  -- Parameter input: ID user yang mendengarkan lagu, ID lagu yang didengarkan, durasi lagu yang didengarkan (dalam detik)
            p_song_id INT,
            p_duration INT
        )
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_exists_listen INT;  -- Variabel untuk menyimpan jumlah record listens yang sudah ada untuk user & song
        BEGIN
            -- VALIDASI USER
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
                RAISE EXCEPTION 'User % tidak ditemukan', p_user_id;
            END IF;

            -- VALIDASI SONG
            IF NOT EXISTS (SELECT 1 FROM songs WHERE song_id = p_song_id) THEN
                RAISE EXCEPTION 'Song % tidak ditemukan', p_song_id;
            END IF;

            -- VALIDASI DURASI
            IF p_duration <= 0 THEN
                RAISE EXCEPTION 'Duration harus > 0';
            END IF;

            -- CEK APAKAH USER SUDAH PERNAH MENDENGARKAN LAGU INI
            SELECT COUNT(*)  -- Hitung jumlah record listens untuk user & song
            INTO v_exists_listen   -- Simpan hasil hitungan ke variabel v_exists_listen
            FROM listens
            WHERE user_id = p_user_id
              AND song_id = p_song_id;

            -- INSERT LISTEN BARU  → listen_count + 1
            IF v_exists_listen = 0 THEN  -- Jika user belum pernah mendengarkan lagu ini

                INSERT INTO listens (listen_id, user_id, song_id, duration_listened)
                VALUES (
                    (SELECT COALESCE(MAX(listen_id), 0) + 1 FROM listens),  -- akan generate listen_id baru secara increment
                    p_user_id,
                    p_song_id,
                    p_duration
                );

                -- TAMBAH COUNTER LISTEN HANYA UNTUK INSERT
                UPDATE songs
                SET listen_count = COALESCE(listen_count, 0) + 1   -- Increment listen_count lagu
                WHERE song_id = p_song_id;

            -- UPDATE LISTEN LAMA → TIDAK MENAMBAH COUNTER
            ELSE

                UPDATE listens
                SET duration_listened = p_duration,  -- Update durasi terakhir mendengarkan
                    "TIMESTAMP" = CURRENT_TIMESTAMP  -- Update timestamp terakhir
                WHERE user_id = p_user_id
                  AND song_id = p_song_id;

            END IF;

        END;
        $$;


        -- Funtion get_recently_played
        CREATE OR REPLACE FUNCTION get_recently_played(
            p_user_id INT,    -- Parameter input ID user
            p_limit INT DEFAULT 10 -- Limit jumlah hasil yang ditampilkan
        )
        RETURNS TABLE (
            song_id INT,  -- Mengambil ID lagu dari tabel songs
            song_title VARCHAR,   -- Mengambil judul lagu dari tabel songs
            duration_listened INT,  -- Durasi mendengarkan dalam bentuk detik
            last_play TIMESTAMP  -- Timestamp kapan lagu diputar
        )
        LANGUAGE plpgsql
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                s.song_id,
                s.song_title,
                l.duration_listened, -- dalam detik
                l."TIMESTAMP" AS last_play
            FROM listens l
            JOIN songs s ON s.song_id = l.song_id  -- Join tabel listens dengan songs berdasarkan song_id
            WHERE l.user_id = p_user_id   -- Memfilter hanya record yang sesuai user yang diminta
            ORDER BY l."TIMESTAMP" DESC  -- Mengurutkan dari pemutaran terbaru
            LIMIT p_limit;  -- Membatasi jumlah record sesuai parameter p_limit
        END;
        $$;

        --  Procedure Create Playlist
        CREATE OR REPLACE PROCEDURE create_playlist(
            p_user_id INT,
            p_title VARCHAR,
            p_ispublic BOOLEAN,
            p_iscollaborative BOOLEAN,
            p_description TEXT,
            p_cover VARCHAR,
            p_isonprofile BOOLEAN
        )
        LANGUAGE plpgsql
        AS $$
        BEGIN
           INSERT INTO playlists (
               user_id,
               playlist_cover,
               playlist_title,
               ispublic,
               iscollaborative,
               playlist_desc,
               isonprofile,
               playlist_date_created
           )
           VALUES (
               p_user_id,
               p_cover,
               p_title,
               p_ispublic,
               p_iscollaborative,
               p_description,
               p_isonprofile,
               CURRENT_DATE
           );

           RAISE NOTICE 'Playlist created successfully.';
        END;
        $$;

        -- CALL user_id, playlist_title, ispublic, iscollaborative, playlist_desc, playlist_cover, isonprofile
        CALL create_playlist(5, 'cek procedure', true, false, 'Santai sore', 'cover.png', true);

        -- cek
        SELECT *
        FROM playlists;


        -- Procedure add_song_to_playlist
        CREATE OR REPLACE PROCEDURE add_song_to_playlist(
            p_user_id INT,  -- Parameter input: ID user yang ingin menambahkan lagu
            p_playlist_id INT,  -- Parameter input: ID playlist tujuan
            p_song_id INT  -- Parameter input: ID lagu yang ingin ditambahkan
        )
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_owner_id INT;  -- Variabel untuk menyimpan ID pemilik playlist
            v_is_collab BOOLEAN;
            v_exists INT;  -- Variabel untuk mengecek apakah lagu sudah ada di playlist
            v_last_no_urut INT; -- Variabel untuk menentukan nomor urut lagu terakhir
        BEGIN
            -- Cek apakah playlist ada
            SELECT user_id, isCollaborative
            INTO v_owner_id, v_is_collab
            FROM playlists
            WHERE playlist_id = p_playlist_id;

            IF NOT FOUND THEN
	-- Kalo playlist tidak ditemukan,
                RAISE EXCEPTION 'Playlist % tidak ditemukan.', p_playlist_id;
            END IF;

            -- Cek duplikasi lagu
            SELECT COUNT(*)
            INTO v_exists
            FROM add_songs_playlists
            WHERE playlist_id = p_playlist_id
              AND song_id = p_song_id;

            IF v_exists > 0 THEN
	-- Kalo lagu sudah ada di playlist,
                RAISE EXCEPTION 'Lagu % sudah ada di playlist %.', p_song_id, p_playlist_id;
            END IF;

            -- Cek kepemilikan playlist (non-collaborative)
            IF v_is_collab = FALSE AND p_user_id <> v_owner_id THEN
                RAISE EXCEPTION
                    'Playlist ini non-collaborative. Hanya pemilik (user_id = %) yang dapat menambahkan lagu.',
                    v_owner_id;
            END IF;

            -- Hitung nomor urut otomatis
            SELECT COALESCE(MAX(no_urut), 0)
            INTO v_last_no_urut
            FROM add_songs_playlists
            WHERE playlist_id = p_playlist_id;

            v_last_no_urut := v_last_no_urut + 1;  -- Tambah 1 untuk nomor urut lagu baru

            -- Insert lagu ke playlist
            INSERT INTO add_songs_playlists (
                user_id,
                playlist_id,
                song_id,
                no_urut
            ) VALUES (
                p_user_id,
                p_playlist_id,
                p_song_id,
                v_last_no_urut
            );

        END;
        $$;

        -- cek (user_id, playlist_id, song_id)
        CALL add_song_to_playlist(2, 10, 5);

        SELECT *
        FROM add_songs_playlists
        WHERE playlist_id = 10
        ORDER BY no_urut;


        -- PROCEDURE remove_song_from_playlist
        CREATE OR REPLACE PROCEDURE remove_song_from_playlist(
            p_playlist_id INT,  -- Parameter input: ID playlist yang ingin dihapus lagunya
            p_song_id INT  -- Parameter input: ID lagu yang ingin dihapus
        )
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_exists INT;  -- Variabel untuk mengecek apakah lagu ada di playlist
        BEGIN
            -- Cek apakah lagu ada di playlist
            SELECT COUNT(*)
            INTO v_exists
            FROM add_songs_playlists
            WHERE playlist_id = p_playlist_id
              AND song_id = p_song_id;

            IF v_exists = 0 THEN
		-- Kalo lagu tidak ditemukan di playlist,
                RAISE EXCEPTION 'Lagu % tidak ditemukan di playlist %.', p_song_id, p_playlist_id;
            END IF;

            -- Hapus lagu dari playlist
            DELETE FROM add_songs_playlists
            WHERE playlist_id = p_playlist_id
              AND song_id = p_song_id;

            -- Perbaiki nomor urut (re-order) supaya urutan lagu tetap berurutan
            WITH ordered AS (
                SELECT
                    add_song_pl_id,  -- Ambil ID record
                    ROW_NUMBER() OVER (ORDER BY no_urut) AS new_no  -- Hitung nomor urut baru
                FROM add_songs_playlists
                WHERE playlist_id = p_playlist_id  -- Hanya untuk playlist yang sama
            )
            UPDATE add_songs_playlists asp
            SET no_urut = o.new_no  -- Update no_urut sesuai urutan baru
            FROM ordered o
            WHERE asp.add_song_pl_id = o.add_song_pl_id;  -- Cocokin dengan ID record nya

        END;
        $$;

        -- hapus lagu (song_id 30) dari playlist 10
        CALL remove_song_from_playlist(10, 30);

        -- cek hasil
        SELECT *
        FROM add_songs_playlists
        WHERE playlist_id = 10
        ORDER BY no_urut;


        -- Function: get_playlist_detail
        CREATE OR REPLACE FUNCTION get_playlist_detail(p_playlist_id INT)
        RETURNS TABLE (
            playlist_id INT,
            playlist_title VARCHAR,
            playlist_cover VARCHAR,
            playlist_desc TEXT,
            song_no INT,
            song_id INT,
            song_title VARCHAR,
            song_duration INT,
            added_by_username VARCHAR
        )
        AS $$
        BEGIN
	-- Ambil data playlist + daftar lagu + siapa yang menambahkan lagu
            RETURN QUERY
            SELECT
                p.playlist_id,
                p.playlist_title,
                p.playlist_cover,
                p.playlist_desc,
                asp.no_urut AS song_no,  -- nomor urut lagu di playlist
                s.song_id,
                s.song_title,
                s.song_duration,
                u.username AS added_by_username -- username yang menambahkan lagu
            FROM PLAYLISTS p
	-- Join ke tabel add_songs_playlists untuk mendapatkan daftar lagu yang ada di playlist
            JOIN ADD_SONGS_PLAYLISTS asp ON p.playlist_id = asp.playlist_id
            JOIN SONGS s ON asp.song_id = s.song_id  -- Join ke tabel songs untuk mengambil detail lagu
            JOIN USERS u ON asp.user_id = u.user_id  -- Join ke tabel users untuk mengetahui siapa yang nambahin lagu
            WHERE p.playlist_id = p_playlist_id  -- Filter hanya playlist yang sesuai dengan parameter input
            ORDER BY asp.no_urut; -- urutkan lagu sesuai nomor urut
        END;
        $$ LANGUAGE plpgsql;

        -- cek detail playlist id 1
        SELECT * FROM get_playlist_detail(1);


        -- Function: get_playlist_tracks
        CREATE OR REPLACE FUNCTION get_playlist_tracks(p_playlist_id INT)
        RETURNS TABLE (
            song_no INT,
            song_id INT,
            song_title VARCHAR,
            song_duration INT,
            collection_id INT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                asp.no_urut AS song_no, -- nomor urut lagu di playlist
                s.song_id,
                s.song_title,
                s.song_duration,
                cs.collection_id   -- null jika lagu tidak ada di collection
            FROM ADD_SONGS_PLAYLISTS asp  -- Ambil tabel lagu yang ditambahkan ke playlist (alias asp)
            JOIN SONGS s ON asp.song_id = s.song_id
            LEFT JOIN COLLECTIONS_SONGS cs ON s.song_id = cs.song_id -- cek lagu di collection mana
            WHERE asp.playlist_id = p_playlist_id  -- ambil lagu dari playlist tertentu
            ORDER BY asp.no_urut;  -- Urut sesuai nomor urut di playlist
        END;
        $$ LANGUAGE plpgsql;

        -- cek lihat lagu-lagu di playlist dengan ID = 1
        SELECT *
        FROM get_playlist_tracks(1);



        CREATE OR REPLACE FUNCTION reorder_playlist_sequence()
        RETURNS TRIGGER AS $$
        BEGIN
            UPDATE add_songs_playlists
            SET no_urut = no_urut - 1
            WHERE playlist_id = OLD.playlist_id
            AND no_urut > OLD.no_urut;
            RETURN OLD;
        END;
        $$ LANGUAGE plpgsql;

        CREATE TRIGGER trg_reorder_playlist_delete
        AFTER DELETE ON add_songs_playlists
        FOR EACH ROW
        EXECUTE FUNCTION reorder_playlist_sequence();

        /*==============================================================*/
        /* Procedure: ADD_ARTIST_PROMOTION                              */
        /*==============================================================*/
        DROP PROCEDURE IF EXISTS add_artist_promotion(INT, INT, TEXT);
        CREATE OR REPLACE PROCEDURE add_artist_promotion(p_artist_id INT, p_collection_id INT, p_comment TEXT)
        LANGUAGE plpgsql
        AS $$
        BEGIN

            -- cek artist valid
            IF NOT EXISTS (SELECT 1 FROM artists WHERE artist_id = p_artist_id) THEN
                RAISE EXCEPTION 'Artist_id % not found', p_artist_id;
            END IF;

            -- cek collection ada
            IF NOT EXISTS (SELECT 1 FROM collections WHERE collection_id = p_collection_id) THEN
                RAISE EXCEPTION 'Collection_id % not found', p_collection_id;
            END IF;

            --validasi, apakah koleksi ini dirilis oleh artis tersebut?
            IF NOT EXISTS (SELECT 1 FROM releases WHERE artist_id = p_artist_id
                AND collection_id = p_collection_id
            ) THEN
                RAISE EXCEPTION 'Artist % cannot promote collection %, because it does not belong to them',
                    p_artist_id, p_collection_id;
            END IF;

            --jika sudah pernah promosi -> update komentar
            IF EXISTS (SELECT 1 FROM artist_promotion WHERE artist_id = p_artist_id
                AND collection_id = p_collection_id
            ) THEN
                UPDATE artist_promotion SET komentar_promosi = p_comment WHERE artist_id = p_artist_id
                AND collection_id = p_collection_id;

                RAISE NOTICE 'Promotion updated successfully';
                RETURN;
            END IF;

            --jika belum -> insert baru
            INSERT INTO artist_promotion(artist_id, collection_id, komentar_promosi)
            VALUES (p_artist_id, p_collection_id, p_comment);
            RAISE NOTICE 'Promotion added successfully';
        END;
        $$;

        select * from releases

        CALL add_artist_promotion(3, 3, 'Check out my new album!');
        select * from artist_promotion
        CALL add_artist_promotion(3, 3, 'Updated promo!');
        select * from artist_promotion
        CALL add_artist_promotion(10, 20, 'Invalid promotion');
        CALL add_artist_promotion(999, 5, 'hello');
        CALL add_artist_promotion(10, 999, 'promo');

        /*==============================================================*/
        /* Funtion:GET_ARTIST_TOURS                                     */
        /*==============================================================*/
        CREATE OR REPLACE FUNCTION get_artist_tours(p_artist_id INT)
        RETURNS TABLE (
            tour_id INT,
            tour_name TEXT,
            venue TEXT,
            tour_date DATE
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                t.tour_id,
                t.tour_name ::TEXT,
                t.venue ::TEXT,
                t.tour_date
            FROM artists_tours at
            JOIN tours t ON t.tour_id = at.tour_id
            WHERE at.artist_id = p_artist_id
            ORDER BY t.tour_date ASC;
        END;
        $$ LANGUAGE plpgsql STABLE;

        select * from artists_tours
        select * from tours

        --tambah tour
        INSERT INTO tours (tour_id, tour_name, venue, tour_date)
        VALUES (100, 'World Tour 2025', 'Jakarta Convention Center', '2025-12-20');

        -- relasikan artis ke tour
        INSERT INTO artists_tours (artist_id, tour_id)
        VALUES (3, 100);

        SELECT * FROM get_artist_tours(3);
        SELECT * FROM get_artist_tours(20);
        SELECT * FROM get_artist_tours(999);

        /*==============================================================*/
        /* Procedure: CREATE_REVIEW                               */
        /*==============================================================*/
        CREATE OR REPLACE PROCEDURE create_review(
            p_review_text TEXT,
	p_rating NUMERIC (3,0),
	p_user_id INT4,
            p_collection_id INT4
        )
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_review_id INT;
        BEGIN
            -- cek user
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
                RAISE EXCEPTION 'User_id % not found', p_user_id;
            END IF;

            -- cek collection
            IF NOT EXISTS (SELECT 1 FROM collections WHERE collection_id = p_collection_id) THEN
                RAISE EXCEPTION 'Collection_id % not found', p_collection_id;
            END IF;

            -- cek review kosong
            IF p_review_text IS NULL OR LENGTH(TRIM(p_review_text)) = 0 THEN
                RAISE EXCEPTION 'Review text cannot be empty';
            END IF;

            -- cek apakah user sudah review koleksi ini
            IF EXISTS (SELECT 1 FROM reviews WHERE user_id = p_user_id
		AND collection_id = p_collection_id
            ) THEN
                RAISE EXCEPTION 'User has already reviewed this collection';
            END IF;

            -- ambil review_id dari sequence
            SELECT NEXTVAL('seq_reviews_id')
            INTO v_review_id;

            -- insert review (trigger akan update timestamp jika review diganti)
            INSERT INTO reviews(review, rating, "TIMESTAMP", review_id, user_id, collection_id)
            VALUES (p_review_text, p_rating, CURRENT_TIMESTAMP, v_review_id, p_user_id, p_collection_id);

            RAISE NOTICE 'Review created with ID %', v_review_id;
        END;
        $$;

        select * from users
        select * from reviews
        CALL create_review('Album ini sangat keren!', 10, 1, 1);
        CALL create_review('Test review', 10, 9999, 1);
        CALL create_review('Test review', 10, 2, 9999);
        CALL create_review('', 10, 2, 3);
        CALL create_review('Review pertama', 10, 1, 10);
        CALL create_review('Review kedua', 10, 1, 10);

        /*==============================================================*/
        /* Procedure: TOGGLE_LIKE_REVIEW                               */
        /*==============================================================*/
        CREATE OR REPLACE PROCEDURE toggle_like_review(p_user_id INT, p_review_id INT)
        LANGUAGE plpgsql
        AS $$
        DECLARE
	v_exists BOOLEAN;
        BEGIN
            -- cek user
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
                RAISE EXCEPTION 'User_id % not found', p_user_id;
            END IF;

            -- cek review
            IF NOT EXISTS (SELECT 1 FROM reviews WHERE review_id = p_review_id) THEN
                RAISE EXCEPTION 'Review_id % not found', p_review_id;
            END IF;

            --cek toggle
            SELECT EXISTS (SELECT 1 FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id)
            INTO v_exists;

            --jika sudah like -> unlike
            IF v_exists THEN
                DELETE FROM like_reviews WHERE review_id = p_review_id AND user_id = p_user_id;
                RAISE NOTICE 'Review % unliked by user %', p_review_id, p_user_id;
                RETURN;
            END IF;

            -- jika belum like -> insert like
            INSERT INTO like_reviews VALUES (p_review_id, p_user_id);
            RAISE NOTICE 'Review % liked by user %', p_review_id, p_user_id;
        END;
        $$;

        select * from reviews
        CALL toggle_like_review(2, 1);
        select * from like_reviews
        CALL toggle_like_review(9999, 15);
        CALL toggle_like_review(2, 99999);



        /*search(keyword, type)
        type = 'song' | 'artist' | 'collection' | 'playlist' | 'user'*/

        DROP FUNCTION IF EXISTS search(TEXT, TEXT);

        CREATE OR REPLACE FUNCTION search(keyword TEXT, type TEXT)
        RETURNS TABLE (
            result_type TEXT,
            id INT,
            title TEXT,
            info TEXT,
            extra_info TEXT
        )
        AS $$
        BEGIN
            -- ============================
            -- TYPE: SONG
            -- ============================
            IF type = 'song' THEN
                RETURN QUERY
                SELECT
                    'song' AS result_type,
                    v.song_id AS id,
                    v.song_title ::TEXT AS title,
                    'Artist: ' || COALESCE(v.artists_name, '-') AS info,
                    'Album: ' || COALESCE(v.album_name, '-') ||
                    ' | Popularity: ' || COALESCE(v.popularity, 0) AS extra_info
                FROM view_full_song_details v
                WHERE v.song_title ILIKE '%' || keyword || '%'
                   OR v.artists_name ILIKE '%' || keyword || '%'
                   OR v.album_name ILIKE '%' || keyword || '%'
                ORDER BY v.popularity DESC NULLS LAST;

            -- ============================
            -- TYPE: COLLECTION (ALBUM)
            -- ============================
            ELSIF type = 'collection' THEN
                RETURN QUERY
                SELECT
                    'collection',
                    c.collection_id,
                    c.collection_title ::TEXT,
                    'Artist: ' || COALESCE(aa.album_artists,'-') AS info,
                    'Release: ' || COALESCE(c.collection_release_date::TEXT, '-') AS extra_info
                FROM collections c
                JOIN (
                    SELECT collection_id,
                        STRING_AGG(artist_name, ', ') AS album_artists
                    FROM releases r
                    JOIN artists a ON a.artist_id = r.artist_id
                    GROUP BY collection_id
                ) aa ON aa.collection_id = c.collection_id
                WHERE c.collection_title ILIKE '%' || keyword || '%'
                   OR aa.album_artists ILIKE '%' || keyword || '%';

            -- ============================
            -- TYPE: PLAYLIST
            -- ============================
            ELSIF type = 'playlist' THEN
                RETURN QUERY
                SELECT
                    'playlist',
                    p.playlist_id,
                    p.playlist_title ::TEXT,
                    COALESCE(p.playlist_desc, ''),
                    COUNT(asp.song_id)::TEXT AS extra
                FROM playlists p
                LEFT JOIN add_songs_playlists asp ON asp.playlist_id = p.playlist_id
                LEFT JOIN view_full_song_details v ON v.song_id = asp.song_id
                WHERE p.playlist_title ILIKE '%' || keyword || '%'
                   OR COALESCE(p.playlist_desc, '') ILIKE '%' || keyword || '%'
                   OR v.song_title ILIKE '%' || keyword || '%'
                   OR v.artists_name ILIKE '%' || keyword || '%'
                   OR v.album_name ILIKE '%' || keyword || '%'
                GROUP BY p.playlist_id, p.playlist_title, p.playlist_desc;

            -- ============================
            -- TYPE: ARTIST
            -- ============================
            ELSIF type = 'artist' THEN
                RETURN QUERY
                SELECT
                    'artist',
                    v.artist_id,
                    v.artist_name ::TEXT,
                    v.follower_count::TEXT || ' followers',
                    'Albums: ' || total_albums || ' | Tracks: ' || total_tracks AS extra
                FROM view_artist_profile_header v
                WHERE v.artist_name ILIKE '%' || keyword || '%';

            -- ============================
            -- TYPE: USER
            -- ============================
            ELSIF type = 'user' THEN
                RETURN QUERY
                SELECT
                    'user',
                    u.user_id,
                    u.username ::TEXT,
                    u.followers_count::TEXT || ' followers',
                    'Following: ' || u.following_count ||
                    ' | Public playlists: ' || u.public_playlists AS extra
                FROM view_user_library_stats u
                WHERE u.username ILIKE '%' || keyword || '%';

            ELSE
                RAISE EXCEPTION 'Invalid type: %, valid types = song | artist | collection | playlist | user', type;
            END IF;
        END;
        $$ LANGUAGE plpgsql STABLE;

        select * from search('nug', 'user')
        select * from search ('lil', 'artist')
        select * from search('story', 'song')
        select * from search('love', 'collection')
        select * from search('love', 'playlist')


        -- Function get_song_detail
        CREATE OR REPLACE FUNCTION get_song_detail(p_song_id INT)
        RETURNS TABLE (
            song_id INT,
            song_title VARCHAR,
            song_duration INT,
            song_release_date DATE,
            song_rating NUMERIC,
            artist_name VARCHAR,
            genre_name VARCHAR,
            collection_title VARCHAR,
            nomor_disc INT,
            nomor_track INT
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT
                -- Ambil ID lagu, judul lagu, durasi lagu, tanggal rilis lagu, rating lagu
                s.song_id,
                s.song_title,
                s.song_duration,
                s.song_release_date,
                s.song_rating,

                a.artist_name,                -- artis dari CREATE_SONGS)
                g.genre_name,                 -- genre lagu dari SONGS_GENRES)
                c.collection_title,           -- dari collection
                cs.nomor_disc,                -- nomor disc lagu dalam collection
                cs.nomor_track                -- nomor track lagu dalam collection

            FROM SONGS s

            -- ARTIST
            LEFT JOIN CREATE_SONGS cr ON s.song_id = cr.song_id  -- Join untuk dapat artist_id dari CREATE_SONGS
            LEFT JOIN ARTISTS a ON cr.artist_id = a.artist_id

            -- GENRE
            LEFT JOIN SONGS_GENRES sg ON s.song_id = sg.song_id
            LEFT JOIN GENRES g ON sg.genre_id = g.genre_id

            -- COLLECTION / ALBUM
            LEFT JOIN COLLECTIONS_SONGS cs ON s.song_id = cs.song_id
            LEFT JOIN COLLECTIONS c ON cs.collection_id = c.collection_id

            WHERE s.song_id = p_song_id;   -- Filter hanya lagu dengan ID sesuai parameter
        END;
        $$ LANGUAGE plpgsql;

        -- PROCEDURE toggle_like_song
        CREATE OR REPLACE PROCEDURE toggle_like_song(
            p_user_id INT, -- Parameter input: ID user yang ingin like/unlike lagu
            p_song_id INT  -- Parameter input: ID lagu yang ingin di like/unlike
        )
        LANGUAGE plpgsql
        AS $$
        DECLARE
            v_exists INT;  -- Variabel untuk mengecek record like_songs sudah ada apa belum
        BEGIN
            -- 1. Cek apakah user ada
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id) THEN
                RAISE EXCEPTION 'User dengan ID % tidak ditemukan', p_user_id;
            END IF;

            -- 2. Cek apakah lagu ada
            IF NOT EXISTS (SELECT 1 FROM songs WHERE song_id = p_song_id) THEN
                RAISE EXCEPTION 'Song dengan ID % tidak ditemukan', p_song_id;
            END IF;

            -- 3. Cek apakah sudah like
            SELECT COUNT(*) INTO v_exists
            FROM like_songs
            WHERE user_id = p_user_id
              AND song_id = p_song_id;
            -- 4. Jika sudah LIKE → UNLIKE
            IF v_exists > 0 THEN
                DELETE FROM like_songs  -- Hapus record like (unlike)
                WHERE user_id = p_user_id
                  AND song_id = p_song_id;
                RAISE NOTICE 'UNLIKE berhasil untuk song_id=% oleh user_id=%',
                    p_song_id, p_user_id;
            -- 5. Jika belum LIKE → LIKE
            ELSE
                INSERT INTO like_songs (song_id, user_id)  -- Tambah record like baru
                VALUES (p_song_id, p_user_id);
                RAISE NOTICE 'LIKE berhasil untuk song_id=% oleh user_id=%',
                    p_song_id, p_user_id;
            END IF;
        END;
        $$;

        -- cek like
        CALL toggle_like_song(1,10);

        -- cek hasil
        SELECT * FROM like_songs WHERE user_id = 1 AND song_id = 10;

        -- cek unlike
        CALL toggle_like_song(1,10);

        -- PROCEDURE rate_song
        CREATE OR REPLACE PROCEDURE rate_song(
            p_user_id INT,  -- Parameter input: ID user yang memberi rating
            p_song_id INT,  -- Parameter input: ID lagu yang dirating
            p_rating NUMERIC  -- Parameter input: nilai rating lagu
        )
        LANGUAGE plpgsql
        AS $$
        BEGIN
            -- Cek apakah user sudah pernah memberi rating
            IF EXISTS (
                SELECT 1 FROM rate_songs
                WHERE user_id = p_user_id
                  AND song_id = p_song_id
            ) THEN
                -- Kalo sudah ada rating → update rating lama dan timestamp
                UPDATE rate_songs
                SET song_rating = p_rating,  -- Set rating baru
                    "TIMESTAMP" = CURRENT_TIMESTAMP  -- Update waktu rating terakhir
                WHERE user_id = p_user_id
                  AND song_id = p_song_id;  -- update record user & lagu
            ELSE
                -- Jika belum ada rating → insert rating baru
                INSERT INTO rate_songs (user_id, song_id, song_rating)
                VALUES (p_user_id, p_song_id, p_rating);   -- Masukkan record baru
            END IF;
        END;
        $$;

        -- cek
        SELECT * FROM RATE_SONGS;

        -- Cek insert rating
        CALL rate_song(1,10,5);

        -- cek
        SELECT * FROM RATE_SONGS;

        -- update rating
        CALL rate_song(1, 10, 3);

        -- cek hasil
        SELECT * FROM RATE_SONGS WHERE song_id = 10;


        -- Function get_song_audio_features
        -- Deskripsi: Mengambil fitur audio dari sebuah lagu
        -- Input: p_song_id (INT) -> ID lagu yang ingin diambil fiturnya
        -- Output: Tabel berisi song_id, song_title, valence, accousticness, danceability, energy
        CREATE OR REPLACE FUNCTION get_song_audio_features(p_song_id INT)
        RETURNS TABLE (
            song_id INT,                -- ID lagu
            song_title VARCHAR,          -- Judul lagu
            valence DECIMAL(4,3),       -- Valence lagu
            acousticness DECIMAL(4,3),  -- Acousticness lagu
            danceability DECIMAL(4,3),  -- Danceability lagu
            energy DECIMAL(4,3)         -- Energy lagu
        ) AS $$
        BEGIN
            -- Mengambil data audio features dari tabel SONGS berdasarkan song_id
            RETURN QUERY
            SELECT
                s.song_id,
                s.song_title,
                s.valence,  -- seberapa “positif/ceria”
                s.accousticness,   -- seberapa akustik
                s.danceability, -- dance
                s.energy -- seberapa enejik
            FROM songs s
            WHERE s.song_id = p_song_id;

            -- Jika song_id tidak ada, hasilnya akan kosong
        END;
        $$ LANGUAGE plpgsql;

        -- cek
        -- coba panggil funciton dengan song_id
        SELECT * FROM get_song_audio_features(3);

        -- cek song_id nya yg gak ada di data
        SELECT * FROM get_song_audio_features(500);

        CREATE EXTENSION IF NOT EXISTS pgcrypto;
        /*==============================================================*/
        /* Function: REGISTER_USER
        insert data user baru ke table users dan mengembalikan user_id  */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS register_user(VARCHAR, VARCHAR, VARCHAR);

        CREATE OR REPLACE FUNCTION register_user(p_username VARCHAR, p_raw_pw VARCHAR, p_user_email VARCHAR)
        RETURNS TABLE (
            user_id INT4,
            message TEXT
        )
        AS $$
        DECLARE
	v_user_id INT4;
            v_pw_hash TEXT;
        BEGIN
            --cek apakah email sudah dipakai atau belum
            IF EXISTS (SELECT 1 FROM users WHERE user_email = p_user_email) THEN
                RETURN QUERY SELECT NULL::INT, 'Email already registered'::TEXT;
                RETURN;
            END IF;

            --cek apakah username sudah dipakai atau belum
            IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
                RETURN QUERY SELECT NULL::INT, 'Username already taken'::TEXT;
                RETURN;
            END IF;

            --hash password menggunakan bcrypt
            v_pw_hash := crypt(p_raw_pw, gen_salt('bf'));

	--generate user_id dari sequence
	SELECT nextval('seq_users_id') INTO v_user_id;

            --insert user baru, user_id dari sequence
            INSERT INTO users (user_id, username, pw_hash, user_email)
            VALUES (v_user_id, p_username, v_pw_hash, p_user_email);
            RETURN QUERY SELECT v_user_id, 'Registration successful'::TEXT;
	RETURN;
        END;
        $$ LANGUAGE plpgsql;

        SELECT * FROM register_user('nugrinti', 'password1234', 'nurahma@gmail.com');

        /*==============================================================*/
        /* Function: LOGIN_USER
        return user_id dan message login successful                     */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS login_user(VARCHAR);

        CREATE OR REPLACE FUNCTION login_user(p_user_email VARCHAR, p_raw_pw VARCHAR)
        RETURNS TABLE (
            user_id INT4,
            message TEXT
        )
        AS $$
        DECLARE
	v_user_id INT4;
            v_pw_hash VARCHAR(255);
        BEGIN
            --cek apakah username sudah terdaftar atau belum
            SELECT u.user_id, u.pw_hash
            INTO v_user_id, v_pw_hash
            FROM users u
            WHERE u.user_email = p_user_email;

            --jika email belum terdaftar
            IF v_user_id IS NULL THEN
                RETURN QUERY SELECT NULL::INT4, 'Email not registered'::TEXT;
                RETURN;
            END IF;

            --cek password
            IF crypt(p_raw_pw, v_pw_hash) <> v_pw_hash THEN
                RETURN QUERY SELECT NULL::INT4, 'Invalid password'::TEXT;
                RETURN;
            END IF;

            --else, berhasil login
            RETURN QUERY SELECT v_user_id, 'Login successful'::TEXT;
	RETURN;
        END;
        $$ LANGUAGE plpgsql;

        SELECT * FROM login_user('nurahma@gmail.com', 'password1234');

        /*==============================================================*/
        /* Procedure: TOGGLE_FOLLOW_USER
        toggle follow dan unfollow sesama user*/
        /*==============================================================*/
        CREATE OR REPLACE PROCEDURE toggle_follow_user(p_follower_id INT, p_followed_id INT)
        LANGUAGE PLPGSQL
        AS $$
        DECLARE
            v_exists BOOLEAN;
        BEGIN
            --tidak boleh follow/unfollow diri sendiri
            IF p_follower_id = p_followed_id THEN
                RAISE EXCEPTION 'User cannot follow/unfollow themselves';
            END IF;

            --cek apakah kedua user valid
            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_follower_id) THEN
                RAISE EXCEPTION 'Follower user_id % not found', p_follower_id;
            END IF;

            IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = p_followed_id) THEN
                RAISE EXCEPTION 'Followed user_id % not found', p_followed_id;
            END IF;

            --cek apakah sudah follow, jika sudah -> unfollow
            SELECT EXISTS (SELECT 1 FROM follow_users
                WHERE follower_id = p_follower_id AND followed_id = p_followed_id)
            INTO v_exists;

            IF v_exists THEN
                --delete relationship from follow_users
                DELETE from follow_users
                    WHERE follower_id = p_follower_id AND followed_id = p_followed_id;
                RAISE NOTICE 'Unfollow successful';
                RETURN;
            END IF;

            --jika belum follow -> follow
            --insert ke table follow_users
            INSERT INTO follow_users VALUES (p_follower_id, p_followed_id);
	RAISE NOTICE 'Follow successful';

        END;$$;

        CALL toggle_follow_user(12, 20);
        SELECT * FROM follow_users;

        /*==============================================================*/
        /* Function: GET_FOLLOWERS                                      */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS get_followers(INT);

        CREATE OR REPLACE FUNCTION get_followers(p_user_id INT)
        RETURNS TABLE (
            follower_id INT4,
            follower_username VARCHAR(50),
            follower_email VARCHAR(320)
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT u.user_id, u.username, u. user_email
            FROM follow_users
            JOIN users u ON fu.follower_id = u.user_id
            WHERE fu.followed_id = p_user_id
            ORDER BY u.username;
        END;
        $$ LANGUAGE plpgsql;

        CALL toggle_follow_user(11, 57);
        CALL toggle_follow_user(12, 57);
        CALL toggle_follow_user(20, 57);
        CALL toggle_follow_user(31, 57);

        SELECT * FROM get_followers(57);

        /*==============================================================*/
        /* Function: GET_FOLLOWING                                      */
        /*==============================================================*/
        DROP FUNCTION IF EXISTS get_following(INT);

        CREATE OR REPLACE FUNCTION get_following(p_user_id INT)
        RETURNS TABLE (
            following_id INT4,
            following_username VARCHAR(50),
            following_email VARCHAR(320)
        )
        AS $$
        BEGIN
            RETURN QUERY
            SELECT u.user_id, u.username, u. user_email
            FROM follow_users
            JOIN users u ON fu.followed_id = u.user_id
            WHERE fu.follower_id = p_user_id
            ORDER BY u.username;
        END;
        $$ LANGUAGE plpgsql;

        CALL toggle_follow_user(12, 40);
        CALL toggle_follow_user(12, 30);
        CALL toggle_follow_user(12, 53);

        SELECT * FROM get_following(12);


        CREATE OR REPLACE FUNCTION delete_expired_tours()
        RETURNS VOID AS $$
        BEGIN
            DELETE FROM tours
            WHERE tour_date < CURRENT_DATE;
        END;
        $$ LANGUAGE plpgsql;

        SELECT cron.schedule(
            'delete_expired_tours_daily',
            '5 0 * * *',
            $$SELECT delete_expired_tours();$$
        );

        CREATE OR REPLACE FUNCTION recalc_listen_count()
        RETURNS void AS $$
        BEGIN
            UPDATE songs s
            SET listen_count = sub.cnt
            FROM (
                SELECT song_id, COUNT(*) AS cnt
                FROM listens
                GROUP BY song_id
            ) sub
            WHERE s.song_id = sub.song_id;
        END;
        $$ LANGUAGE plpgsql;

        SELECT cron.schedule(
            'recalc_listen_count_daily',
            '20 0 * * *',
            $$SELECT recalc_listen_count();$$
        );


        CREATE OR REPLACE FUNCTION recalculate_all_song_popularity()
        RETURNS VOID AS $$
        BEGIN
            UPDATE songs s
            SET popularity = sub.pop
            FROM (
                SELECT
                    l.song_id,
                    CASE
                        WHEN COUNT(*) <= 1 THEN 0
                        ELSE LEAST(100, LOG(10, COUNT(*)) * 25)
                    END AS pop
                FROM listens l
                WHERE l."TIMESTAMP" >= CURRENT_DATE - INTERVAL '30 days'
                GROUP BY l.song_id
            ) sub
            WHERE s.song_id = sub.song_id;
        END;
        $$ LANGUAGE plpgsql;

        SELECT cron.schedule(
            'recalculate_song_popularity_daily',
            '15 0 * * *',
            $$SELECT recalculate_all_song_popularity();$$
        );



        CREATE OR REPLACE FUNCTION recalculate_monthly_listeners()
        RETURNS VOID AS $$
        BEGIN
            UPDATE artists a
            SET monthly_listener_count = sub.cnt
            FROM (
                SELECT
                    cs.artist_id,
                    COUNT(DISTINCT l.user_id) AS cnt
                FROM listens l
                JOIN create_songs cs ON cs.song_id = l.song_id
                WHERE DATE_TRUNC('month', l."TIMESTAMP") = DATE_TRUNC('month', CURRENT_DATE)
                GROUP BY cs.artist_id
            ) sub
            WHERE a.artist_id = sub.artist_id;
        END;
        $$ LANGUAGE plpgsql;

        SELECT cron.schedule(
            'recalculate_monthly_listeners_daily',
            '10 0 * * *',
            $$SELECT recalculate_monthly_listeners();$$
        );


        CREATE OR REPLACE FUNCTION update_prerelease_daily()
        RETURNS VOID AS $$
        BEGIN
            UPDATE collections
            SET isPrerelease = FALSE
            WHERE isPrerelease = TRUE
              AND collection_release_date <= CURRENT_DATE;
        END;
        $$ LANGUAGE plpgsql;

        SELECT cron.schedule(
            'update_prerelease_job_daily',
            '0 0 * * *',
            $$SELECT update_prerelease_daily();$$
        );
