/* User Table Creation*/
CREATE TABLE User (
	UserId NVARCHAR(50) PRIMARY KEY, 
    Password NVARCHAR(50) NOT NULL);


/* News Table Creation*/
CREATE TABLE News 
(
	NewsId INT PRIMARY KEY, 
    Title NVARCHAR(255) NOT NULL,
    Content NVARCHAR(255) NOT NULL,
    PublishedAt DATETIME(6) NOT NULL, 
    CreatedBy NVARCHAR(50) NOT NULL,
    Url NVARCHAR(255),
    UrlToImage NVARCHAR(255)
);


/* Reminders Table Creation*/
CREATE TABLE Reminders 
(
	ReminderId INT PRIMARY KEY AUTO_INCREMENT,
	Schedule DATETIME(6) NOT NULL,
	NewsId INT NOT NULL
);

/*UserProfile Table Creation*/
CREATE TABLE UserProfile 
(
	UserId NVARCHAR(50) NOT NULL,
    FirstName NVARCHAR(255) NOT NULL,
    LastName NVARCHAR(255) NOT NULL,
    Contact  NVARCHAR(255),
    Email NVARCHAR(255),
    CreatedAt DATETIME(6) NOT NULL
);


/*Inserting data in News Table*/
INSERT INTO News VALUES (101,'IT industry in 2020','IT industry was facing disruptive changes in 2019, It is expected to have positive growth in 2020','2019-12-01 00:00:00','Jack',null,null);
INSERT INTO News VALUES (102,'2020 FIFA U 17 Women World Cup','the tournament will be held in india between 2 and 12 november 2020, it will mark the first time that India has hosted a FIFA womenfootball tournament ',
'2019-12-05 00:00:00','Jack',null,null);
INSERT INTO News VALUES(103,'chandrayan-2 spacecraft','The Lander of Chnadrayan-2 was named after Vikram after Dr Vikram Sarabhai,
the Father of the Indian Space Programme. It was designed for function to one lunar day','2019-12-05 00:00:00','John',null,null);
INSERT INTO News VALUES(104,'Neft transaction to be available 24x7','Bank Customer will able to transfer fund through NEFT around the clock on all days
including weekend and holidays from December 16','2019-12-07 00:00:00','John',null,null);


/*Inserting data in UserProfile Table*/
INSERT INTO UserProfile VALUES ('Jack','Jackson','James','8899776655','jack@ymail.com','2019-12-07 00:00:00');
INSERT INTO UserProfile VALUES ('John','Johnson','dsouza','786543210','john@gmail.com','2019-12-25 00:00:00');
INSERT INTO UserProfile VALUES ('Kevin','Kevin','Lloyd','9878685748','kevin@gmail.com','2019-12-01 00:00:00');


/*Inserting data in Reminders Table*/
INSERT INTO Reminders VALUES(ReminderId,'2019-04-12 00:00:00',101);
INSERT INTO Reminders VALUES(ReminderId,'2019-12-10 00:00:00',102);
INSERT INTO Reminders VALUES(ReminderId,'2019-12-10 00:00:00',104);


/*Inserting data in User Table*/
INSERT INTO User VALUES('Jack','pass@123');
INSERT INTO User VALUES('John','something#121');
INSERT INTO User VALUES('Kevin','test@123');

/*Retreive all the user profiles joined on or after 10-Dec-2019.*/
SELECT * FROM UserProfile WHERE CreatedAt >= '2019-12-10';


/*Retreive the details of user 'Jack' along with all the news created by him.*/
SELECT * FROM News news, UserProfile uProf WHERE 
news.CreatedBy = uProf.UserId AND uProf.UsedId = 'Jack';

/*Retreive all details of the user who created the News with newsId=103.*/
SELECT * FROM UserProfile WHERE UserId IN (SELECT CreatedBy FROM News WHERE NewsId = 103);

/*Retreive the details of all the users who have not added any news yet.*/
SELECT * FROM UserProfile WHERE UserId NOT IN (SELECT DISTINCT CreatedBy FROM News);

/*Retreive the newsid and title of all the news having some reminder.*/
SELECT NewsId,Title FROM News WHERE NewsId IN (SELECT DISTINCT NewsId From Reminders);

/*Retreive the total number of news added by each user.*/
SELECT COUNT(*), CreatedBy FROM  News GROUP BY CreatedBy;

/*Update the contact number of userId='John' to '9192939495'.*/
UPDATE UserProfile SET Contact = '9192939495' WHERE UserId = 'John';

/*Update the title of the newsId=101 to 'IT industry growth can be seen in 2020'.*/
UPDATE News SET Title = 'IT industry growth can be seen in 2020' WHERE NewsId = 101;

COMMIT;

/*Remove all the reminders belonging to the news created by Jack.*/
DELETE FROM Reminders WHERE NewsId IN (SELECT NewsId FROM News WHERE CreatedBy = 'Jack');

/*Write a query to set a reminder for a particular news (Use Reminder and News tables - insert statement)*/
INSERT INTO Reminders ( SCHEDULE, NewsId)
SELECT  NOW(),news.NewsId FROM Reminders rem , News news WHERE rem.NewsId=news.NewsId;

/*Create a trigger to delete all matching records from News,UserProfile,User and Reminder table when
			A particular news is deleted from news table (all the matching records from News,UserProfile,User
            and Reminder should be removed automatically)*/
DELIMITER $$
CREATE TRIGGER NEWS_BEFORE_DELETE
BEFORE DELETE
ON News FOR EACH ROW
BEGIN
DELETE FROM User WHERE User.UserId =OLD.CreatedBy;
    DELETE FROM UserProfile WHERE UserProfile.UserId =OLD.CreatedBy;
    DELETE FROM Reminders WHERE Reminders.NewsId =OLD.NewsId;
END $$


/*Create a trigger to delete all matching records from News,UserProfile,User and Reminder table when
			A particular user is deleted from User table (all the matching notes should be removed automatically)*/
DELIMITER $$
CREATE TRIGGER BEFORE_DELETE_USER
BEFORE DELETE
ON User FOR EACH ROW
BEGIN
	DELETE FROM Reminders WHERE Reminders.NewsId =
    (SELECT News.NewsId FROM News WHERE News.CreatedBy=OLD.UserId);
    Delete FROM UserProfile WHERE UserProfile.UserId =OLD.UserId;
    Delete FROM News WHERE News.CreatedBy =OLD.UserId;
END$$