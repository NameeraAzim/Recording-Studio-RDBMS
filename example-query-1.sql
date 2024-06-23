-- For each studio, report the ID and name of its current manager, 
-- and the number of albums it has contributed to. A studio contributed 
-- to an album iff at least one recording segment recorded there is 
-- part of that album.
SET SEARCH_PATH TO recording;

DROP VIEW IF EXISTS studio_manager CASCADE;
DROP VIEW IF EXISTS studio_album CASCADE;
DROP VIEW IF EXISTS most_recent_date CASCADE;
DROP VIEW IF EXISTS studio_manager_info CASCADE;

CREATE VIEW most_recent_date AS
SELECT MAX(start_date) AS max_date, studio_id
FROM Manages
GROUP BY studio_id;

CREATE VIEW studio_manager AS
SELECT Manages.studio_id AS studio_id, Manages.manager_id AS manager_id
FROM Manages, most_recent_date
WHERE Manages.studio_id = most_recent_date.studio_id
AND Manages.start_Date = max_date;

CREATE VIEW studio_manager_info AS 
SELECT studio_manager.studio_id AS studio_id, studio_manager.manager_id AS manager_id,
RecordingUser.full_name AS manager_name
FROM studio_manager, RecordingUser
WHERE studio_manager.manager_id = RecordingUser.user_id;

CREATE VIEW studio_album AS
SELECT RecordingSession.studio_id AS studio_id, COUNT(DISTINCT(OnAlbum.album_id)) AS album_num
FROM OnAlbum, OnTrack, RecordingSegment, RecordingSession
WHERE OnAlbum.track_id = OnTrack.track_id
AND OnTrack.recording_id = RecordingSegment.recording_id
AND RecordingSegment.session_id = RecordingSession.session_id
GROUP BY RecordingSession.studio_id;

SELECT studio_manager_info.studio_id AS studio_id, studio_manager_info.manager_id AS manager_id,
studio_manager_info.manager_name AS manager_name, 
    CASE 
        WHEN studio_album.album_num IS NULL THEN 0
        ELSE studio_album.album_num
    END AS number_of_albums
FROM studio_manager_info LEFT JOIN studio_album
ON studio_manager_info.studio_id = studio_album.studio_id;

