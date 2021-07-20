-- Drop tables if exists
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "topics";
DROP TABLE IF EXISTS "posts";
DROP TABLE IF EXISTS "comments";
DROP TABLE IF EXISTS "post_votes";

-- Users table
CREATE TABLE "users" (
    "id" SERIAL PRIMARY KEY,
    "username" VARCHAR(50) UNIQUE NOT NULL,
    CONSTRAINT "check_users_length_not_zero" 
        CHECK (LENGTH(TRIM("username")) > 0),
    "login_timestamp" TIMESTAMP 
);

-- Index for a list of all users who haven’t logged in in the last year. WORK IN PROGRESS
CREATE INDEX "find_users_not_logged_in_last_year" 
    ON "users" ("username", YEAR("login_timestamp") != 
        date_part('year', (SELECT current_timestamp)));

-- Topics table
CREATE TABLE "topics" (
    "id" SERIAL PRIMARY KEY,
    "topic_name" VARCHAR(30) UNIQUE NOT NULL,
    "description" VARCHAR(500),
    "user_id" INTEGER,
    CONSTRAINT "check_topics_length_not_zero"
        CHECK (LENGTH(TRIM("topic_name")) > 0),
    CONSTRAINT "fk_user" 
        FOREIGN KEY ("user_id") REFERENCES "users" ("id")
);

-- Posts table
CREATE TABLE "posts" (
    "id" SERIAL PRIMARY KEY,
    "title" VARCHAR(100) NOT NULL,
    "URL" TEXT,
    "text_content" TEXT,
    "user_id" INTEGER,
    "topic_id" INTEGER,
    CONSTRAINT "check_posts_length_not_zero"
        CHECK (LENGTH(TRIM("title")) > 0),
    CONSTRAINT "fk_user" 
        FOREIGN KEY ("user_id") 
            REFERENCES "users" ("id") ON DELETE SET NULL,
    CONSTRAINT "fk_topic"
        FOREIGN KEY ("topic_id")
            REFERENCES "topics" ("id") ON DELETE CASCADE,
    CONSTRAINT "check_text_or_URL_isexist." 
        CHECK ((("URL") IS NULL AND 
            ("text_content") IS NOT NULL) OR
                (("URL") IS NOT NULL AND 
                    ("text_content") IS NULL)),
    "post_timestamp" TIMESTAMP 
);

-- Comments table
CREATE TABLE "comments" (
    "id" SERIAL PRIMARY KEY,
    "comment" TEXT NOT NULL,
    "user_id" INTEGER,
    "topic_id" INTEGER,
    "post_id" INTEGER,
    "parent_comment_id" INTEGER DEFAULT NULL, -- Look here for the i, j queries
    CONSTRAINT "check_posts_length_not_zero"
        CHECK (LENGTH(TRIM("comment")) > 0),
    CONSTRAINT "fk_user" 
        FOREIGN KEY ("user_id") 
            REFERENCES "users" ("id") ON DELETE SET NULL,
    CONSTRAINT "fk_topic"
        FOREIGN KEY ("topic_id")
            REFERENCES "topics" ("id") ON DELETE CASCADE,
    CONSTRAINT "fk_post"
        FOREIGN KEY ("post_id")
            REFERENCES "posts" ("id") ON DELETE CASCADE,
    CONSTRAINT "parent_child_comment_thread"
        FOREIGN KEY ("parent_comment_id")
            REFERENCES "comments" ("id") ON DELETE CASCADE
);

-- Votes on posts table
CREATE TABLE "post_votes" (
    "id" SERIAL PRIMARY KEY,
    "post_vote" INTEGER NOT NULL,
    "user_id" INTEGER,
    "post_id" INTEGER,
    CONSTRAINT "set_values_for_votes"
        CHECK ("post_vote" = 1 OR "post_vote" = -1),
    CONSTRAINT "fk_user" 
        FOREIGN KEY ("user_id") 
            REFERENCES "users" ("id") ON DELETE SET NULL,
    CONSTRAINT "fk_post"
        FOREIGN KEY ("post_id")
            REFERENCES "posts" ("id") ON DELETE CASCADE
);


