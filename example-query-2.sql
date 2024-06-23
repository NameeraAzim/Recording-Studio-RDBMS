-- For each person in the database, report their ID and the number of 
-- recording sessions they have played at. Include everyone, even if they 
-- are a manager or engineer, and even if they never played at any sessions.
SET SEARCH_PATH TO recording;

DROP VIEW IF EXISTS performer_session CASCADE;

CREATE VIEW performer_session AS
SELECT Membership.performer_id AS u_id, COUNT(Playing.session_id) AS session_num
FROM Playing, Membership
WHERE Playing.group_id = Membership.group_id
GROUP BY Membership.performer_id;

SELECT RecordingUser.user_id AS user_id,
    CASE 
        WHEN session_num IS NULL THEN 0
        ELSE session_num
    END AS session_num
FROM RecordingUser LEFT JOIN performer_session
ON RecordingUser.user_id = performer_session.u_id;





