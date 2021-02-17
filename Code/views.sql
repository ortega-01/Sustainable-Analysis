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
