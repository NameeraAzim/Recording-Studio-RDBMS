-- Find the recording session that produced the greatest total number
-- of seconds of recording segments. Report the ID and name of everyone
-- who played at that session, whether as part of a band or in a solo capacity.
SET SEARCH_PATH TO recording;

DROP VIEW IF EXISTS total_recording_lengths CASCADE;
DROP VIEW IF EXISTS longest_total CASCADE;
DROP VIEW IF EXISTS longest_group CASCADE;

CREATE VIEW total_recording_lengths AS
SELECT session_id, SUM(segment_length) AS total_recording_length
FROM RecordingSegment
GROUP BY session_id;

CREATE VIEW longest_total AS
SELECT session_id
FROM total_recording_lengths
WHERE total_recording_length IN (
    SELECT MAX(total_recording_length)
    FROM total_recording_lengths
);

CREATE VIEW longest_group AS
SELECT group_id, session_id
FROM Playing
WHERE session_id IN (
    SELECT *
    FROM longest_total
);

SELECT DISTINCT Membership.performer_id AS performer_id,
RecordingUser.full_name AS name
FROM longest_group, Membership, RecordingUser
WHERE longest_group.group_id = Membership.group_id
AND Membership.performer_id = RecordingUser.user_id;
