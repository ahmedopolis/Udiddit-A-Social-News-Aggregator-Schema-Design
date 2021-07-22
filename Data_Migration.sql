-- Query to fetch all unique usernames from both initial tables.
WITH union_usernames AS (
    SELECT username
    FROM "bad_posts" 
    UNION 
    SELECT username
    FROM "bad_comments"),
distinct_usernames AS (
    SELECT username
    FROM union_usernames
)
SELECT DISTINCT username
FROM distinct_usernames
ORDER BY 1 ASC
