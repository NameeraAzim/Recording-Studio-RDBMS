-- Find the album that required the greatest number of recording sessions.
-- Report the album ID and name, the number of recording sessions, and the
-- number of different people who played on the album. If a person played
-- both as part of a band and in a solo capacity, count them only once.
SET SEARCH_PATH TO recording;

DROP VIEW IF EXISTS Album_Sessions CASCADE;
DROP VIEW IF EXISTS Album_Session_Count CASCADE;
DROP VIEW IF EXISTS Max_Session CASCADE;
DROP VIEW IF EXISTS Max_Album CASCADE;
DROP VIEW IF EXISTS Wanted_Albums CASCADE;

CREATE VIEW Album_Sessions AS
SELECT DISTINCT session_id, album_id
FROM OnAlbum, OnTrack, RecordingSegment
WHERE OnAlbum.track_id = OnTrack.track_id AND
OnTrack.recording_id = RecordingSegment.recording_id;

CREATE VIEW Album_Session_Count AS
SELECT album_id, COUNT(session_id) AS num_sessions
FROM Album_Sessions
GROUP BY album_id;

CREATE VIEW Max_Session AS
SELECT MAX(num_sessions) AS max_num_session
FROM Album_Session_Count;

CREATE VIEW Max_Album AS
SELECT album_id, num_sessions
FROM Album_Session_Count
WHERE num_sessions IN (
    SELECT MAX(num_sessions)
    FROM Album_Session_Count NATURAL JOIN Max_Session
);

CREATE VIEW Wanted_Albums AS
SELECT Album.album_id AS album_id, Album.name AS name, num_sessions
FROM Album NATURAL JOIN Max_Album;

SELECT Wanted_Albums.album_id AS album_id, MAX(wanted_albums.name) AS name,
MAX(wanted_albums.num_sessions) AS session_count,
COUNT(DISTINCT(Membership.performer_id)) AS performer_count
FROM OnAlbum, OnTrack, RecordingSegment, Playing, Membership, wanted_albums
WHERE OnAlbum.track_id = OnTrack.track_id
AND OnTrack.recording_id = RecordingSegment.recording_id
AND RecordingSegment.session_id = Playing.session_id
AND Playing.group_id = Membership.group_id
AND OnAlbum.album_id = wanted_albums.album_id
GROUP BY wanted_albums.album_id;

