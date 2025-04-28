-- Version: 1.0
-- Date: 2025-04-12


-- RESOURCES
-- Groups
CREATE TABLE groups
(
    uid            TEXT PRIMARY KEY,
    alphabet       TEXT NOT NULL,
    name           TEXT NOT NULL,
    kana_type      TEXT NOT NULL,
    version        TEXT NOT NULL,
    localized_name TEXT
);
-- Kana
CREATE TABLE kana
(
    uid           TEXT PRIMARY KEY,
    alphabet      TEXT    NOT NULL,
    group_uid     TEXT    NOT NULL,
    kana          TEXT    NOT NULL,
    romaji        TEXT    NOT NULL,
    version       TEXT    NOT NULL,
    position      INTEGER NOT NULL,
    FOREIGN KEY (group_uid) REFERENCES groups (uid)
);
-- Kanji
CREATE TABLE kanjis
(
    uid               TEXT PRIMARY KEY,
    kanji             TEXT    NOT NULL,
    jlpt_level        INTEGER NOT NULL,
    number_of_strokes INTEGER,
    grade             INTEGER,
    version           TEXT    NOT NULL,
    examples          TEXT    NOT NULL, -- Stored as JSON array
    jp_sort_syllables TEXT    NOT NULL, -- Stored as JSON array
    pronunciations    TEXT    NOT NULL, -- Stored as JSON array
    main_meaning      TEXT,
    meanings          TEXT,             -- Stored as JSON array, to be deprecated
    on_readings       TEXT,             -- Stored as JSON array, to be deprecated
    kun_readings      TEXT              -- Stored as JSON array, to be deprecated
);

--   Kanji Join tables
CREATE TABLE kanji_related_vocabulary
(
    kanji_uid      TEXT NOT NULL,
    vocabulary_uid TEXT NOT NULL,
    PRIMARY KEY (kanji_uid, vocabulary_uid),
    FOREIGN KEY (kanji_uid) REFERENCES kanjis (uid)
        ON DELETE CASCADE,
    FOREIGN KEY (vocabulary_uid) REFERENCES vocabulary (uid)
        ON DELETE CASCADE
);

CREATE TABLE kanji_groups
(
    kanji_uid TEXT NOT NULL,
    group_uid TEXT NOT NULL,
    PRIMARY KEY (kanji_uid, group_uid),
    FOREIGN KEY (kanji_uid) REFERENCES kanjis (uid)
        ON DELETE CASCADE,
    FOREIGN KEY (group_uid) REFERENCES groups (uid)
        ON DELETE CASCADE
);

-- Vocabulary
CREATE TABLE vocabulary
(
    uid            TEXT PRIMARY KEY,
    kanji          TEXT    NOT NULL,
    kana           TEXT    NOT NULL,
    jlpt_level     INTEGER NOT NULL,
    romaji         TEXT    NOT NULL,
    version        TEXT    NOT NULL,
    examples       TEXT    NOT NULL, -- Stored as JSON array
    kana_syllables TEXT    NOT NULL, -- Stored as JSON array
    meanings       TEXT    NOT NULL  -- Stored as JSON array
);

--  Vocabulary Join tables
CREATE TABLE vocabulary_related_kanjis
(
    vocabulary_uid TEXT NOT NULL,
    kanji_uid      TEXT NOT NULL,
    PRIMARY KEY (vocabulary_uid, kanji_uid),
    FOREIGN KEY (vocabulary_uid) REFERENCES vocabulary (uid)
        ON DELETE CASCADE,
    FOREIGN KEY (kanji_uid) REFERENCES kanjis (uid)
        ON DELETE CASCADE
);

CREATE TABLE vocabulary_kanji_readings
(
    vocabulary_uid TEXT NOT NULL,
    kanji_uid      TEXT NOT NULL,
    kanji          TEXT NOT NULL,
    reading        TEXT NOT NULL,
    FOREIGN KEY (vocabulary_uid) REFERENCES vocabulary (uid)
        ON DELETE CASCADE,
    FOREIGN KEY (kanji_uid) REFERENCES kanjis (uid)
        ON DELETE CASCADE
);

CREATE TABLE vocabulary_groups
(
    vocabulary_uid TEXT NOT NULL,
    group_uid      TEXT NOT NULL,
    PRIMARY KEY (vocabulary_uid, group_uid),
    FOREIGN KEY (vocabulary_uid) REFERENCES vocabulary (uid)
        ON DELETE CASCADE,
    FOREIGN KEY (group_uid) REFERENCES groups (uid)
        ON DELETE CASCADE
);
