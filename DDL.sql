-- Drop tables if exists
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "topics";
DROP TABLE IF EXISTS "posts";
DROP TABLE IF EXISTS "comments";
DROP TABLE IF EXISTS "votes";


-- Users table
CREATE TABLE "users" (
    "pk_user_id" SERIAL PRIMARY KEY,
    "username" VARCHAR(50) UNIQUE NOT NULL 
);

ALTER TABLE "users"
ADD CONSTRAINT "check_users_length_not_zero"
    CHECK (LENGTH(TRIM("username") > 0))

-- Topics table
CREATE TABLE "topics" (
    "pk_topic_id" SERIAL PRIMARY KEY,
    "topic" VARCHAR(30) UNIQUE NOT NULL,
    "description" VARCHAR(500)
);

ALTER TABLE "topics"
ADD CONSTRAINT "check_topics_length_not_zero"
    CHECK (LENGTH(TRIM("topic") > 0))
ADD CONSTRAINT "valid_user" 
    FOREIGN KEY ("fk_user") REFERENCES "users" ("pk_user_id");

-- Posts table
CREATE TABLE "posts" (
    "pk_post_id" SERIAL PRIMARY KEY,
    "title" VARCHAR(100) NOT NULL,
    "URL" TEXT,
    "text_content" TEXT
);

ALTER TABLE "posts"
ADD CONSTRAINT "check_posts_length_not_zero"
    CHECK (LENGTH(TRIM("title") > 0))
ADD CONSTRAINT "valid_topic" 
    FOREIGN KEY ("fk_topic") REFERENCES "topics" ("pk_topic_id")
ADD CONSTRAINT "check_text_or_URL_isexist." 
    CHECK ("URL" IS NULL OR "text_content" IS NULL)

