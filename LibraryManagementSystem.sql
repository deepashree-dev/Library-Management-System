CREATE DATABASE LibraryManagementDB;
GO

USE LibraryManagementDB;
GO

CREATE TABLE Books 
(
    BookID INT PRIMARY KEY,
    BookName VARCHAR(100),
    Author VARCHAR(100),
    Category VARCHAR(50),
    Quantity INT
);

SELECT * FROM Books;


CREATE TABLE Members 
(
    MemberID INT PRIMARY KEY,
    MemberName VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50)
);

SELECT * FROM Members;

CREATE TABLE IssueRecords (
    IssueID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    IssueDate DATE,
    ReturnDate DATE,

    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

SELECT * FROM IssueRecords;

USE LibraryManagementDB;
GO

SELECT name
FROM sys.tables;

SELECT * FROM Books;

SELECT * FROM Members;

SELECT * FROM IssueRecords;

INSERT INTO Books
(BookID, BookName, Author, Category, Quantity)
VALUES
(1, 'Wings of Fire', 'A.P.J. Abdul Kalam', 'Biography', 5),
(2, 'The Alchemist', 'Paulo Coelho', 'Fiction', 4),
(3, 'Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance', 3),
(4, 'Atomic Habits', 'James Clear', 'Self Help', 6),
(5, 'Introduction to SQL', 'Mark Smith', 'Technology', 2);

INSERT INTO Members
(MemberID, MemberName, Phone, City)
VALUES
(101, 'Anu', '9876543210', 'Bangalore'),
(102, 'Rahul', '9876543211', 'Mysore'),
(103, 'Priya', '9876543212', 'Chennai'),
(104, 'Kiran', '9876543213', 'Hyderabad'),
(105, 'Sneha', '9876543214', 'Bangalore');

SELECT * FROM Books;

SELECT * FROM Members;

INSERT INTO IssueRecords
(IssueID, BookID, MemberID, IssueDate, ReturnDate)
VALUES
(1, 1, 101, '2026-11-21', NULL);

SELECT * FROM IssueRecords;

USE LibraryManagementDB;
GO

CREATE TABLE IssueRecords 
(
    IssueID INT PRIMARY KEY,
    BookID INT,
    MemberID INT,
    IssueDate DATE,
    ReturnDate DATE,

    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

SELECT
    Books.BookName,
    IssueRecords.IssueDate
FROM Books
INNER JOIN IssueRecords
ON Books.BookID = IssueRecords.BookID;

SELECT
    Books.BookName,
    Members.MemberName,
    IssueRecords.IssueDate,
    IssueRecords.ReturnDate
FROM IssueRecords
INNER JOIN Books
ON IssueRecords.BookID = Books.BookID
INNER JOIN Members
ON IssueRecords.MemberID = Members.MemberID;

SELECT
    IssueID,
    BookID,
    MemberID,
    IssueDate,
    ReturnDate,
    DATEADD(DAY, 14, IssueDate) AS DueDate,
    CASE
        WHEN ReturnDate > DATEADD(DAY, 14, IssueDate)
        THEN DATEDIFF(
            DAY,
            DATEADD(DAY, 14, IssueDate),
            ReturnDate
        ) * 5
        ELSE 0
    END AS FineAmount
FROM IssueRecords
WHERE ReturnDate IS NOT NULL;

SELECT
    IssueID,
    BookID,
    MemberID,
    IssueDate,
    DATEADD(DAY, 14, IssueDate) AS DueDate,
    CASE
        WHEN GETDATE() > DATEADD(DAY, 14, IssueDate)
        THEN DATEDIFF(
            DAY,
            DATEADD(DAY, 14, IssueDate),
            CAST(GETDATE() AS DATE)
        ) * 5
        ELSE 0
    END AS CurrentFine
FROM IssueRecords
WHERE ReturnDate IS NULL;

SELECT
    M.MemberName,
    B.BookName,
    I.IssueDate,
    I.ReturnDate,
    CASE
        WHEN COALESCE(I.ReturnDate, CAST(GETDATE() AS DATE))
             > DATEADD(DAY, 14, I.IssueDate)
        THEN DATEDIFF(
            DAY,
            DATEADD(DAY, 14, I.IssueDate),
            COALESCE(I.ReturnDate, CAST(GETDATE() AS DATE))
        ) * 5
        ELSE 0
    END AS FineAmount
FROM IssueRecords I
INNER JOIN Members M
    ON I.MemberID = M.MemberID
INNER JOIN Books B
    ON I.BookID = B.BookID;