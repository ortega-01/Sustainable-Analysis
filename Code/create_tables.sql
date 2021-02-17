CREATE TABLE article (
ArticleID SERIAL PRIMARY KEY,
Date timestamp,
Title varchar(100),
Author varchar(30),
Text varchar(1000));

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
