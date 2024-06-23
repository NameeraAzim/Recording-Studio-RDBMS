----------------------------CHOICES AND ASSUMPTIONS----------------------------
-- Constraints that could not be enforced without triggers and assertions:
-- We did not think that any of constraints couldn't be enforced except with
-- triggers and assertions. There seemed to always be a creative way to enforce
-- the constraint, even when it was extremely costly to enforce it as such.

-- Constraints that would have been costly to enforce using SQL:
-- Every constraint listed here could have been enforced by one of a few design
-- choices including:
--    a. Defining one relation before the one we did (ex; Membership before
--    Performance group and having PerformanceGroup(group_id) reference
--    Membership(group_id)). This would have ensured all groups had at least
--    one member, but this would also have made deletions more risky as someone
--    could delete an attribute such as PerformanceGroup(group_id) and the
--    change would not cascade to the table it should. In this case Membership
--    making it possible for us to have situations like people being members of
--    bands which did not exist.
--    b. Combining tables so that we could use NOT NULL to ensure tables had
--    "at least one" of attributes (ex; Put performer_id in RecordingSession).
--    This would have added significant redundancy as for the example just given
--    this could lead to having an indefinite number of rows for one session,
--    repeating session information many times. This could be expanded to "at
--    least x" constraints by having x attributes set at NOT NULL as described.
--    c. Adding x number of attributes to ensure a table had "at most x _" (ex;
--    we could have added the attributes engineer1, engineer2, and engineer3 to
--    RecordingSession, keeping session_id as the primary key and adding NOT
--    NULL to only one of the aforementioned attributes). This would necessitate
--    us allowing for their to be null values in the table, a sacrifice which
--    we chose not to make.
-- Constraints
-- 1. Every band must have at least one member (a, b)
-- 2. Sessions have at least 1 and at most 3 recording engineer(s) (a, b, c)
-- 3. Sessions have at least 1 performer (a, b)
-- 4. Tracks appear on at least one album (a, b)
-- 5. Albums contain at least two tracks (b)

-- Constraints that we enforced that were not in the assignment document:
-- 1. Two managers cannot have the same start date at the same studio. So, a
--    manager can't quit the morning they started and have their replacement
--    start the same afternoon.
-- 2. A person can only have one phone number and email registered in the system


-- Assumptions we made:
-- 1. A person can be any combination of the types (manager, performer, sound
--    engineer) at the same time. For example, a bunch of sound engineers might
--    want to start a band together and they should be allowed to do so.
--    For this reason, we did not create a user type attribute as this would
--    lead to redundancy in the User table. Instead we created three tables (
--    Performer, Manager, and SoundEngineer) to record who is in which role.
--    This allows for a person to have multiple rolls at once.
-- 2. The current manager for studio x is the manager with the most recent
--    start date at studio x.
-- 3. A performer can be a member of an indefinite number of performance groups.


-------------------------------SETTING UP SCHEMA-------------------------------


DROP SCHEMA IF EXISTS recording CASCADE;
CREATE SCHEMA recording;
SET SEARCH_PATH TO recording;


---------------------------------BASIC USER INFO-------------------------------


-- A person in the system. Each has a unique number identifier <user_id>
-- <phone_number> is recommended to have the structure: '+i-aaa-xxx-xxxx'
CREATE TABLE RecordingUser (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(35) NOT NULL,
    email VARCHAR(40) NOT NULL,
    phone_number VARCHAR(25) NOT NULL
);

-- A user who is registered as a manager.
-- <manager_id> is the <user_id> of the manager.
CREATE TABLE Manager (
    manager_id SERIAL PRIMARY KEY,
    FOREIGN KEY (manager_id) REFERENCES RecordingUser(user_id) ON DELETE CASCADE
);

-- A user who is registered as a sound engineer.
-- <engineer_id> is the <user_id> of the sound engineer.
CREATE TABLE SoundEngineer (
    engineer_id SERIAL PRIMARY KEY,
    FOREIGN KEY (engineer_id) REFERENCES RecordingUser(user_id) ON DELETE CASCADE
);

-- A user who is registered as a performer.
-- <performer_id> is the <user_id> of the performer.
CREATE TABLE Performer (
    performer_id SERIAL PRIMARY KEY,
    FOREIGN KEY (performer_id) REFERENCES RecordingUser(user_id) ON DELETE CASCADE
);


---------------------------STUDIO AND MORE USER INFO---------------------------

-- The engineer with the id <engineer_id> has the certification <certification>.
-- An engineer can have zero or more certifications.
CREATE TABLE Certified (
    engineer_id SERIAL REFERENCES SoundEngineer ON DELETE CASCADE,
    certification VARCHAR(25) NOT NULL,
    PRIMARY KEY (engineer_id, certification)
);

-- The possible types of a Performance Group.
CREATE TYPE GROUPTYPE as ENUM ('solo artist', 'band');

-- Group <group_id> has be declared to perform together.
-- A group can be <type>='band' in which case it should have 1+ member(s), or
-- <type>='solo artist' in which case it should have only one member.
CREATE TABLE PerformanceGroup (
    group_id SERIAL PRIMARY KEY,
    name VARCHAR(35) NOT NULL,
    type GROUPTYPE NOT NULL
);

-- The performer <performer_id> is a member of performance group <group_id>.
-- A performer can be a member of multiple groups.
CREATE TABLE Membership (
    performer_id SERIAL REFERENCES Performer ON DELETE CASCADE,
    group_id SERIAL REFERENCES PerformanceGroup ON DELETE CASCADE,
    PRIMARY KEY (performer_id, group_id)
);

-- A recording studio.
-- A studio has a unique identifier <studio_id>, a <name>, and an <address>.
CREATE TABLE Studio (
    studio_id SERIAL PRIMARY KEY,
    name varchar(50) NOT NULL,
    address varchar(50) NOT NULL
);

-- Manager <manager_id> manages studio <studio_id>. The manager with the most
-- recent <start_date> for studio <studio_id> is the current manager.
CREATE TABLE Manages (
    manager_id SERIAL REFERENCES Manager ON DELETE CASCADE,
    studio_id SERIAL REFERENCES Studio ON DELETE CASCADE,
    start_date date NOT NULL,
    PRIMARY KEY (studio_id, start_date)
);


----------------------------RECORDING SESSION INFO-----------------------------

-- A recording session <session_id> which was held at studio <studio_id>.
-- Sessions at the same studio cannot start at the same time <start_datetime>.
-- For all sessions, a fee <fee> must be recorded.
CREATE TABLE RecordingSession (
    session_id SERIAL PRIMARY KEY,
    start_datetime TIMESTAMP NOT NULL,
    end_datetime TIMESTAMP NOT NULL,
    fee DECIMAL(10,2) NOT NULL,
    studio_id SERIAL REFERENCES Studio ON DELETE CASCADE,
    UNIQUE (start_datetime, studio_id)
);

-- The engineer <engineer_id> was the sound engineer for session <session_id>.
-- There should be between 1 and 3 engineers per session.
CREATE TABLE SessionEngineer (
    engineer_id SERIAL REFERENCES SoundEngineer ON DELETE CASCADE,
    session_id SERIAL REFERENCES RecordingSession ON DELETE CASCADE,
    PRIMARY KEY (engineer_id, session_id)
);

-- The performance group <group_id> played at the session <session_id>.
-- Each session should have at least 1 performance group.
CREATE TABLE Playing (
    group_id SERIAL REFERENCES PerformanceGroup ON DELETE CASCADE,
    session_id SERIAL REFERENCES RecordingSession ON DELETE CASCADE,
    PRIMARY KEY (group_id, session_id)
);

-- The recording segment <recording_id> was recorded during session <session_id>
-- in the format <format> and has a length in seconds <segment_length>.
CREATE TABLE RecordingSegment (
    recording_id SERIAL PRIMARY KEY,
    segment_length INTEGER NOT NULL,
    format varchar(25) NOT NULL,
    session_id SERIAL REFERENCES RecordingSession ON DELETE CASCADE
);


-----------------------------TRACK AND ALBUM INFO------------------------------

-- A track with the unique identifier <track_id> and the name <name>.
CREATE TABLE Track (
    track_id SERIAL PRIMARY KEY,
    name varchar(25) NOT NULL
);

-- The recording segment <recording_id> was used on track <track_id>.
CREATE TABLE OnTrack (
    recording_id SERIAL REFERENCES RecordingSegment ON DELETE CASCADE,
    track_id SERIAL REFERENCES Track ON DELETE CASCADE
);

-- An album <album> with the name <name> was released on <release_date>.
CREATE TABLE Album (
    album_id SERIAL PRIMARY KEY,
    name varchar(25) NOT NULL,
    release_date date NOT NULL
);

-- The track <track_id> was on the album <album_id>.
-- Each track should appear at least once on an album and each album should
-- contain at least 2 tracks.
CREATE TABLE OnAlbum (
    album_id SERIAL REFERENCES Album ON DELETE CASCADE,
    track_id SERIAL REFERENCES Track ON DELETE CASCADE
);
