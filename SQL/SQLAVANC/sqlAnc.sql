CREATE TABLE CUSTOMER(
   ID INTEGER,
   Name VARCHAR(50) ,
   EMAIL VARCHAR(50),
   GENDER VARCHAR(50) ,
   LANGUAGES VARCHAR(50) ,
   CREATIONDATE DATE,
   PRIMARY KEY(ID)
);

CREATE TABLE EMAILBOUNCES(
   ID INTEGER,
   BOUNCETYPE VARCHAR(50) ,
   BOUNCEDATE DATE,
   CUSTOMERID INTEGER NOT NULL,
   PRIMARY KEY(ID),
   FOREIGN KEY(CUSTOMERID) REFERENCES CUSTOMER(ID)
);

CREATE TABLE PRODUCT(
   ID INTEGER,
   MAINPRODUCTID INTEGER,
   LANGUAGES VARCHAR(50) ,
   NAME VARCHAR(50) ,
   PRICE_EUR NUMERIC(15,2)  ,
   PRIMARY KEY(ID)
);

CREATE TABLE TRANSACTION(
   ID VARCHAR(50) ,
   CREATIONDATE DATE,
   CUSTOMERID INTEGER NOT NULL,
   PRODUCTID INTEGER NOT NULL,
   PRIMARY KEY(ID),
   FOREIGN KEY(CUSTOMERID) REFERENCES CUSTOMER(ID),
   FOREIGN KEY(PRODUCTID) REFERENCES PRODUCT(ID)
);


//INSERT INTO 
INSERT INTO CUSTOMER (ID,NAME,EMAIL,GENDER,LANGUAGES,CREATIONDATE) VALUES (1,'Lorne Landyn','lorne.landyn@gmail.com','Male','FR','2014-01-07'),
(2,'Darren Sylvia','dsyvlia@gmail.com','Male','FR','2015-03-08'),
(3,'Geneva Avaline','null','Female','FR','2014-03-08'),
(4,'Sefton Jaydon','selfjaydon@gmail.com','Male','EN','2019-03-11'),
(5,'Essie Terri','essie.terrie@gmail.com','Female','EN','2018-03-08'),
(6,'Jaylee Charissa','jaylee.c@gmail.com','Female','FR','2016-03-09'),
(7,'Skyla Shirlee','','Female','EN','2015-09-09'),
(8,'Hadyn Tatum','hadyn.tatum@gmail.com','Male','FR','2014-10-09'),
(9,'Valary Imogen','valary.imogen@gmail.com','Male','EN','2017-07-28'),
(10,'Alphonso Oaklyn','alphonso.oaklyn@gmail.com','Male','FR','2019-07-01'),
(11,'Essie Doe','essie.terrie@gmail.com','Female','FR','2019-03-11');


INSERT INTO EMAILBOUNCES (ID,CUSTOMERID,BOUNCETYPE,BOUNCEDATE) VALUES (1,1,'Soft Bounce','2021-05-05'),
(2,10,'Hard Bounce','2021-04-28');

INSERT INTO PRODUCT (ID,MAINPRODUCTID,LANGUAGES,NAME,PRICE_EUR) VALUES (1,1,'EN','Bag',25),
(2,2,'EN','Necklace',50),
(3,3,'EN','Watch',100),
(4,1,'FR','Sac',25),
(5,2,'FR','Collier',50),
(6,3,'FR','Montre',100);

INSERT INTO TRANSACTION (ID,CUSTOMERID,PRODUCTID,CREATIONDATE) VALUES (1,1,1,'2014-01-07'),
(2,6,3,'2016-05-09'),
(3,2,2,'2015-03-08'),
(4,6,1,'2021-02-05'),
(5,3,3,'2014-05-08'),
(6,7,2,'2015-09-09'),
(7,4,1,'2019-03-11'),
(8,8,3,'2014-11-09'),
(9,5,2,'2018-05-08'),
(10,2,1,'2021-04-15');

//Exercice 1

SELECT GENDER, LANGUAGES, COUNT(*) AS NumberOfCustomers
FROM CUSTOMER
GROUP BY GENDER, LANGUAGES;

//Exercice 2

SELECT EXTRACT(YEAR FROM CREATIONDATE) AS Year, GENDER, LANGUAGES, COUNT(*) AS NumberOfCustomers
FROM CUSTOMER
WHERE ID IN (SELECT DISTINCT CUSTOMERID FROM EMAILBOUNCES) = FALSE
GROUP BY Year, GENDER, LANGUAGES
ORDER BY Year;

//Exercice 3

SELECT C.ID, COALESCE(COUNT(T.ID), 0) AS NumberOfTransactions
FROM CUSTOMER C
LEFT JOIN TRANSACTION T ON C.ID = T.CUSTOMERID
GROUP BY C.ID;


//Exercice 4

SELECT C.ID, C.Name, SUM(P.PRICE_EUR)
FROM CUSTOMER C
JOIN TRANSACTION T ON C.ID = T.CUSTOMERID
JOIN PRODUCT P ON T.PRODUCTID = P.ID
GROUP BY C.ID, C.Name
HAVING SUM(P.PRICE_EUR) >= 50;

//Exercice 5

SELECT DISTINCT C.ID, C.Name, C.GENDER, C.LANGUAGES, C.CREATIONDATE
FROM CUSTOMER C
WHERE C.ID NOT IN (SELECT CUSTOMERID FROM EMAILBOUNCES)
AND (C.GENDER = 'Mr' OR C.GENDER = 'Mrs' OR C.GENDER = 'Monsieur' OR C.GENDER = 'Madame')
AND (C.LANGUAGES = 'EN' OR C.LANGUAGES = 'FR')
AND C.CREATIONDATE = (SELECT MAX(CREATIONDATE) FROM CUSTOMER C2 WHERE C2.Name = C.Name);

