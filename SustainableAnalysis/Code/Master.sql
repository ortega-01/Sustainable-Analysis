CREATE TABLE article (
ArticleID SERIAL PRIMARY KEY,
Date timestamp,
Title varchar(100),
Author varchar(30),
Text varchar(1000),
totalviews int);

CREATE TABLE comment (
CommentID SERIAL PRIMARY KEY,
NumLikes int, 
SourceID int,
FOREIGN KEY (SourceID)
REFERENCES article (ArticleID), 
Text varchar(1000));

CREATE TABLE permissions (
PermissionID varchar(8) UNIQUE,
CanComment boolean,
CanEdit boolean, 
CanPostArticle boolean);

CREATE TABLE users (
UserID int PRIMARY KEY,
UserName varchar(50) NOT NULL,
UserPass varchar(30) NOT NULL,
PermissionSet varchar(8),
FOREIGN KEY (PermissionSet)
REFERENCES permissions(PermissionID),
Name varchar(50) NOT NULL);

CREATE TABLE tag (
TagID SERIAL PRIMARY KEY,
Name varchar(20) NOT NULL,
Descr varchar(100) NOT NULL,
TotalViews int NOT NULL CHECK (TotalViews > -1));

CREATE TABLE articletags (
ArticleID int NOT NULL, 
TagID int NOT NULL, 
FOREIGN KEY(ArticleID)
REFERENCES article(ArticleID),
FOREIGN KEY(TagID)
REFERENCES TAG(TagID));

CREATE TABLE usertags (
UserID int NOT NULL,
TagID int NOT NULL,
FOREIGN KEY (UserID)
REFERENCES users(UserID),
FOREIGN KEY(TagID)
REFERENCES tag(TagID));

INSERT INTO article (ArticleID, Date, Title, Author, Text, totalviews) Values
(1, '4/8/2020', 'Hello', 'Simon', 'This is a sample text for the body of an article.', 59),
(2, '4/7/2020', 'Darkness', 'Simon', 'This is a sample text for the body of an article.', 170),
(3, '4/8/2020', 'My', 'Garfunkle', 'This is a sample text for the body of an article.', 83),
(4, '4/8/2020', 'Old', 'Simon', 'This is a sample text for the body of an article.', 21),
(5, '4/8/2020', 'Friend', 'Simon', 'This is a sample text for the body of an article.', 72),
(6, '4/8/2020', 'Ive', 'Simon', 'This is a sample text for the body of an article.', 571),
(7, '4/8/2020', 'Come', 'Simon', 'This is a sample text for the body of an article.', 6),
(8, '4/8/2020', 'To', 'Simon', 'This is a sample text for the body of an article.', 15),
(9, '4/8/2020', 'Talk', 'Simon', 'This is a sample text for the body of an article.', 85),
(10, '4/8/2020', 'With', 'Simon', 'This is a sample text for the body of an article.', 96),
(11, '4/8/2020', 'You', 'Simon', 'This is a sample text for the body of an article.', 1);

INSERT INTO comment (CommentID, NumLikes, SourceID, Text) Values
(1, 15, 1, 'This is a sample text for the body of a comment'), 
(2, 15, 1, 'This is a sample text for the body of a comment'),
(3, 7, 2, 'This is a sample text for the body of a comment'),
(4, 2, 4, 'This is a sample text for the body of a comment');

INSERT INTO permissions (PermissionID, CanComment, CanEdit, CanPostArticle) Values
('User', true, false, false),
('Admin', true, true, false),
('Writer', true, true, true);

INSERT INTO users (UserID, UserName, UserPass, PermissionSet, Name) Values
(0001, 'Chicken', 'Nuggets', 'User', 'McDonalds Food'),
(0002, 'Pizza', 'Pasta', 'Admin', 'Italian'),
(0003, 'Video', 'Cassette', 'Writer', 'Player');

INSERT INTO tag (TagID, Name, Descr, TotalViews) Values
(001, 'Fantasy', 'This is a sample description for the tag of an article.',6431),
(002, 'Romance', 'This is a sample description for the tag of an article.',3241),
(003, 'Horror', 'This is a sample description for the tag of an article.',5213),
(004, 'Mystery', 'This is a sample description for the tag of an article.',3453),
(005, 'SciFi', 'This is a sample description for the tag of an article.',2342),
(006, 'History', 'This is a sample description for the tag of an article.',6436),
(007, 'Memoir', 'This is a sample description for the tag of an article.',9238),
(008, 'Thriller', 'This is a sample description for the tag of an article.',123),
(009, 'Poetry', 'This is a sample description for the tag of an article.',415),
(010, 'Biography', 'This is a sample description for the tag of an article.',4665),
(011, 'Cooking', 'This is a sample description for the tag of an article.',2),
(012, 'Art', 'This is a sample description for the tag of an article.',2455),
(013, 'Health', 'This is a sample description for the tag of an article.',8786);

INSERT INTO articletags (ArticleID, TagID) Values
(1,001),
(2,008),
(3,002),
(4,008),
(5,006),
(6,002),
(7,008),
(8,013),
(9,002),
(10,002),
(11,011),
(11,007);

INSERT INTO usertags (UserID, TagID) Values
(0001,001),
(0002,008),
(0003,002);


CREATE VIEW article_body AS
SELECT Title, Text
FROM article;

CREATE VIEW article_views AS
SELECT Title, TotalViews
FROM article, tag
ORDER BY TotalViews;

CREATE VIEW article_authors AS
SELECT Author, Title 
FROM article
ORDER BY Author;

CREATE VIEW user_permissions AS
SELECT UserName, CanComment, CanEdit, CanPostArticle
FROM users, permissions
WHERE PermissionSet = PermissionID;

CREATE VIEW article_tag AS
SELECT Name, Title
FROM article, tag
WHERE TagID = ArticleID;

CREATE VIEW tag_views AS
SELECT TotalViews, Name
FROM tag;
