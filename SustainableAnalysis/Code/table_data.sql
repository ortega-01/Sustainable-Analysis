INSERT INTO article (ArticleID, Date, Title, Author, Text) Values
(1, '4/8/2020', 'Hello', 'Simon', 'This is a sample text for the body of an article.'),
(2, '4/7/2020', 'Darkness', 'Simon', 'This is a sample text for the body of an article.'),
(3, '4/8/2020', 'My', 'Garfunkle', 'This is a sample text for the body of an article.'),
(4, '4/8/2020', 'Old', 'Simon', 'This is a sample text for the body of an article.'),
(5, '4/8/2020', 'Friend', 'Simon', 'This is a sample text for the body of an article.'),
(6, '4/8/2020', 'Ive', 'Simon', 'This is a sample text for the body of an article.'),
(7, '4/8/2020', 'Come', 'Simon', 'This is a sample text for the body of an article.'),
(8, '4/8/2020', 'To', 'Simon', 'This is a sample text for the body of an article.'),
(9, '4/8/2020', 'Talk', 'Simon', 'This is a sample text for the body of an article.'),
(10, '4/8/2020', 'With', 'Simon', 'This is a sample text for the body of an article.'),
(11, '4/8/2020', 'You', 'Simon', 'This is a sample text for the body of an article.');

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
