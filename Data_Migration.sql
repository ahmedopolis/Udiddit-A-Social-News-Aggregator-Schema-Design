-- Insert all unique usernames from both initial tables.
INSERT INTO "users"
            ("username")
WITH union_usernames
     AS (SELECT username
         FROM   "bad_posts"
         UNION ALL
         SELECT username
         FROM   "bad_comments"),
     distinct_usernames
     AS (SELECT username
         FROM   union_usernames)
SELECT DISTINCT username
FROM   distinct_usernames
ORDER  BY 1 ASC;

-- Insert distinct topics from "bad_posts"
INSERT INTO "topics"
            ("topic_name")
SELECT DISTINCT topic
FROM   "bad_posts";

-- Insert fields from the "bad_posts", "users" and "topics".
INSERT INTO "posts"
            ("title",
             "url",
             "text_content",
             "user_id",
             "topic_id")
SELECT bp.title,
       bp.url,
       bp.text_content,
       uu.id AS user_id,
       tp.id AS topic_id
FROM   "bad_posts" bp
       join "users" uu
         ON bp.username = uu.username
       join "topics" tp
         ON bp.topic = tp.topic_name
WHERE  Length(Trim(title)) <= 100;

-- Insert comments and ids in "comments".
INSERT INTO "comments"
            ("comment",
             "user_id",
             "topic_id",
             "post_id")
SELECT bc.text_content AS COMMENT,
       po.user_id,
       po.topic_id,
       po.id           AS post_id
FROM   "bad_posts" bp
       join "posts" po
         ON bp.title = po.title
       join "users" uu
         ON po.user_id = uu.id
       join "bad_comments" bc
         ON uu.username = bc.username;

-- Insert upvotes & downvotes in "post_votes".
INSERT INTO "post_votes"
            ("post_vote",
             "voter_user_id",
             "post_id")
WITH "bad_posts_upvotes"
     AS (SELECT title,
                Regexp_split_to_table(bp.upvotes, ',') AS username_upvotes
         FROM   "bad_posts" bp),
     "bad_posts_downvotes"
     AS (SELECT title,
                Regexp_split_to_table(bp.downvotes, ',') AS username_downvotes
         FROM   "bad_posts" bp) SELECT 1     AS post_vote,
       uu.id AS voter_user_id,
       po.id AS post_id
FROM   "bad_posts_upvotes" bpu
       join "posts" po
         ON bpu.title = po.title
       join "users" uu
         ON bpu.username_upvotes = uu.username
UNION ALL
SELECT -1    AS post_vote,
       uu.id AS voter_user_id,
       po.id AS post_id
FROM   "bad_posts_downvotes" bpd
       join "posts" po
         ON bpd.title = po.title
       join "users" uu
         ON bpd.username_downvotes = uu.username; 