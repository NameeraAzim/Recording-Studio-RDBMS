SET SEARCH_PATH TO recording;


INSERT INTO
    Studio(studio_id, name, address)
VALUES
    (1, 'Pawnee Recording Studio', '123 Valley spring lane, Pawnee, Indiana'),
    (2, 'Pawnee Sound', '353 Western Ave, Pawnee, Indiana'),
    (3, 'Eagleton Recording Studio', '829 Division, Eagleton, Indiana');

INSERT INTO
    RecordingUser(user_id, full_name, email, phone_number)
VALUES
    (1233, 'Donna Meagle', 'dmeagle@gmail.com', '+1-695-984-0987'),
    (1234, 'Tom Haverford', 'thaverford@gmail.com', '+1-342-453-2884'),
    (1231, 'April Ludgate', 'aludgate@gmail.com', '+1-773-992-9932'),
    (1232, 'Leslie Knope', 'lknope@gmail.com', '+1-020-733-8362'),
    (5678, 'Ben Wyatt', 'bwyatt@gmail.com', '+1-134-563-0013'),
    (9942, 'Ann Perkins', 'aperkins@gmail.com', '+1-223-987-3528'),
    (6521, 'Chris Traeger', 'ctraeger@gmail.com', '+1-992-446-2235'),
    (6754, 'Andy Dwyer', 'adwyer@gmail.com', '+1-222-222-2222'),
    (4523, 'Andrew Burlinson', 'aberlinson@gmail.com', '+1-333-333-3333'),
    (2224, 'Michael Chang', 'mchang@gmail.com', '+1-444-444-4444'),
    (7832, 'James Pierson', 'jpierson@gmail.com', '+150-555-555-5555'),
    (1000, 'Duke Silver', 'dsilver@gmail.com', '+1-666-666-6666');

INSERT INTO
    Manager(manager_id)
VALUES
    (1231),
    (1232),
    (1233),
    (1234);

INSERT INTO
    Manages(manager_id, studio_id, start_date)
VALUES
    -- Pawnee Recording Studio
    (1231, 1, '2008-03-21'),
    (1234, 1, '2017-01-13'),
    (1233, 1, '2018-12-02'),
    -- Pawnee Sound
    (1233, 2, '2011-05-07'),
    -- Eagleton Recording Studio
    (1232, 3, '2012-09-05'),
    (1234, 3, '2016-09-05'),
    (1232, 3, '2020-09-05');

INSERT INTO
    SoundEngineer(engineer_id)
VALUES
    (5678),
    (9942),
    (6521);

INSERT INTO
    Certified(engineer_id, certification)
VALUES
    (5678, 'ABCDEFGH-123I'),
    (5678, 'JKLMNOPQ-456R'),
    (9942, 'SOUND-123-AUDIO');

INSERT INTO
    Performer(performer_id)
VALUES
    (6754),
    (4523),
    (2224),
    (7832),
    (1000),
    (1234);

INSERT INTO
    PerformanceGroup(group_id, name, type)
VALUES
    (1, 'Mouse Rat', 'band'),
    (2, 'Duke Silver', 'solo artist'),
    (3, 'Andy Dwyer', 'solo artist'),
    (4, 'Tom Haverford', 'solo artist');

INSERT INTO
    Membership(performer_id, group_id)
VALUES
     -- Mouse Rat
     (6754, 1), -- Andy Dywer
     (4523, 1), -- Andrew Burlinson
     (2224, 1), -- Michael Chang
     (7832, 1), -- James Pierson
     -- Solo Artists
     (1000, 2), -- Duke Silver
     (6754, 3), -- Andy Dywer
     (1234, 4); -- Tom Haverford

INSERT INTO
    RecordingSession(session_id, start_datetime, end_datetime, fee, studio_id)
VALUES
    (01, '2023-01-08 10:00', '2023-01-08 15:00', 1500, 1),
    (02, '2023-01-10 13:00', '2023-01-11 14:00', 1500, 1),
    (03, '2023-01-12 18:00', '2023-01-13 20:00', 1500, 1),
    --
    (11, '2023-03-10 11:00', '2023-03-10 23:00', 2000, 1),
    (12, '2023-03-11 13:00', '2023-03-12 15:00', 2000, 1),
    --
    (21, '2023-03-13 10:00', '2023-03-13 20:00', 1000, 1),
    --
    (31, '2023-09-25 11:00', '2023-09-26 23:00', 1000, 3),
    (32, '2023-09-29 11:00', '2023-09-30 23:00', 1000, 3);

INSERT INTO
    Playing(group_id, session_id)
VALUES
    (1, 01),
    (2, 01),
    (1, 02),
    (2, 02),
    (1, 03),
    (2, 03),
    --
    (1, 11),
    (1, 12),
    --
    (3, 21),
    (4 ,21),
    --
    (3, 31),
    (3, 32);

INSERT INTO
    SessionEngineer(engineer_id, session_id)
VALUES
    (5678, 01),
    (9942, 01),
    (5678, 02),
    (9942, 02),
    (5678, 03),
    (9942, 03),
    --
    (5678, 11),
    (5678, 12),
    --
    (6521, 21),
    --
    (5678, 31),
    (5678, 32);

INSERT INTO
    RecordingSegment(recording_id, segment_length, format, session_id)
VALUES
    -- Mouse and Bob
    (1, 1, 'WAV', 01), (2, 1, 'WAV', 01), (3, 1, 'WAV', 01),
    (4, 1, 'WAV', 01), (5, 1, 'WAV', 01), (6, 1, 'WAV', 01),
    (7, 1, 'WAV', 01), (8, 1, 'WAV', 01), (9, 1, 'WAV', 01),

    (10, 1, 'WAV', 01), (11, 1, 'WAV', 02), (12, 1, 'WAV', 02),
    (13, 1, 'WAV', 02), (14, 1, 'WAV', 02), (15, 1, 'WAV', 02),

    (16, 1, 'WAV', 03), (17, 1, 'WAV', 03), (18, 1, 'WAV', 03),
    (19, 1, 'WAV', 03),
    -- Mouse
    (20, 2, 'WAV', 11), (21, 2, 'WAV', 11),
    -- Dywer and Tom
    (22, 1, 'WAV', 21), (23, 1, 'WAV', 21), (24, 1, 'WAV', 21),
    (25, 1, 'WAV', 21), (26, 1, 'WAV', 21),
    -- Dywer
    (27, 3, 'AIFF', 31), (28, 3, 'AIFF', 31), (29, 3, 'AIFF', 31),
    (30, 3, 'AIFF', 31), (31, 3, 'AIFF', 31), (32, 3, 'AIFF', 31),
    (33, 3, 'AIFF', 31), (34, 3, 'AIFF', 31), (35, 3, 'AIFF', 31),

    (36, 3, 'WAV', 32), (37, 3, 'WAV', 32), (38, 3, 'WAV', 32),
    (39, 3, 'WAV', 32), (40, 3, 'WAV', 32), (41, 3, 'WAV', 32);

INSERT INTO
    Track(track_id, name)
VALUES
    (02, '5,000 Candles in the Wind'),
    (03, 'Catch Your Dream'),
    (31, 'May Song'),
    (32, 'The Pit'),
    (33, 'Remember'),
    (34, 'The Way You Look Tonight'),
    (35, 'Another Song');

INSERT INTO
    Album(album_id, name, release_date)
VALUES
    (1, 'The Awesome Album', '2023-05-25'),
    (2, 'Another Awesome Album', '2023-10-29');

INSERT INTO
    OnTrack(recording_id, track_id)
VALUES
    (11, 02), (12, 02), (13, 02), (14, 02), (15, 02),
    (22, 02), (23, 02), (24, 02), (25, 02), (26, 02),

    (16, 03), (17, 03), (18, 03), (19, 03),
    (20, 03), (21, 03),
    (22, 03), (23, 03), (24, 03), (25, 03), (26, 03),

    (32, 31), (33, 31), (34, 32), (35, 32), (36, 33), (37, 33),
    (38, 34), (39, 34), (40, 35), (41, 35);

INSERT INTO
    OnAlbum(album_id, track_id)
VALUES
    -- The Awesome Album
    (1, 02),
    (1, 03),
    -- Another awesome Album
    (2, 31),
    (2, 32),
    (2, 33),
    (2, 34),
    (2, 35);
