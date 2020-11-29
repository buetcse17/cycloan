
CREATE TABLE OWNER
(
	OWNER_ID NUMBER NOT NULL,
	OWNER_NAME VARCHAR2(100) NOT NULL,
	PASSWORD VARCHAR2(100) NOT NULL,
	PHOTO_PATH VARCHAR2(100),
	OWNER_PHONE VARCHAR2(20) NOT NULL,
	LOCATION VARCHAR2(100),
	EMAIL_ADDRESS VARCHAR2(100) NOT NULL,
	RATING NUMBER,
	CONSTRAINT OWNER_PK PRIMARY KEY(OWNER_ID)
);

CREATE TABLE OWNER_EMAIL_VERIFICATION
(
	OWNER_ID NUMBER NOT NULL,
	IS_VERIFIED NUMBER NOT NULL,
	EMAIL_ADDRESS VARCHAR2(100) NOT NULL,
	TOKEN_VALUE VARCHAR2(300),
	TOKEN_CREATED DATE,
	TOKEN_EXPIRY DATE,
	CONSTRAINT OWNER_EMAIL_VER_PK PRIMARY KEY(OWNER_ID),
	CONSTRAINT OWNER_EMAIL_VER_FK FOREIGN KEY(OWNER_ID) REFERENCES OWNER(OWNER_ID)
);

CREATE TABLE CUSTOMER
(
	CUSTOMER_ID NUMBER NOT NULL,
	CUSTOMER_NAME VARCHAR2(100) NOT NULL,
	PASSWORD VARCHAR2(100) NOT NULL,
	PHOTO_PATH VARCHAR2(100),
	CUSTOMER_PHONE VARCHAR2(20) NOT NULL,
	EMAIL_ADDRESS VARCHAR2(100) NOT NULL,
	CONSTRAINT CUSTOMER_PK PRIMARY KEY(CUSTOMER_ID)
);

CREATE TABLE DOCUMENT
(
    CUSTOMER_ID NUMBER NOT NULL,
	TYPE_NAME VARCHAR2(20) NOT NULL,
	FILE_PATH VARCHAR2(100) NOT NULL,
	DESCRIPTION VARCHAR2(200) ,
	CONSTRAINT DOCUMENT_PK PRIMARY KEY(CUSTOMER_ID),
    CONSTRAINT CUSTOMER_DOCUMENT_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)
);

CREATE TABLE CUSTOMER_EMAIL_VERIFICATION
(
	CUSTOMER_ID NUMBER NOT NULL,
	IS_VERIFIED NUMBER NOT NULL,
	EMAIL_ADDRESS VARCHAR2(100) NOT NULL,
	TOKEN_VALUE VARCHAR2(50),
	TOKEN_CREATED DATE,
	TOKEN_EXPIRY DATE,
	CONSTRAINT CUSTOMER_EMAIL_VER_PK PRIMARY KEY(CUSTOMER_ID),
	CONSTRAINT CUSTOMER_EMAIL_VER_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)
);

CREATE TABLE CYCLE
(
	CYCLE_ID NUMBER NOT NULL,
	MODEL VARCHAR2(50),
	STATUS VARCHAR2(50) NOT NULL,
	RATING NUMBER,
	PHOTO_PATH VARCHAR2(100),
	OWNER_ID NUMBER NOT NULL,
	CONSTRAINT CYCLE_PK PRIMARY KEY(CYCLE_ID),
	CONSTRAINT CYCLE_OWNER_FK FOREIGN KEY(OWNER_ID) REFERENCES OWNER(OWNER_ID)
);

CREATE TABLE OWNS
(
	CYCLE_ID NUMBER NOT NULL,
	OWNER_ID NUMBER NOT NULL,
	CONSTRAINT OWNS_CYCLE_PK PRIMARY KEY(CYCLE_ID),
	CONSTRAINT OWNS_CYCLE_FK FOREIGN KEY(CYCLE_ID) REFERENCES CYCLE(CYCLE_ID),
	CONSTRAINT OWNS_OWNER_FK FOREIGN KEY(OWNER_ID) REFERENCES OWNER(OWNER_ID)
);

CREATE TABLE TRIP_DETAILS
(
	TRIP_ID NUMBER NOT NULL,
	START_DATE_TIME DATE NOT NULL,
	END_DATE_TIME DATE NOT NULL,
	FARE_PER_DAY NUMBER NOT NULL,
	PAYMENT_TYPE VARCHAR2(50) NOT NULL,
	CUSTOMER_ID NUMBER NOT NULL,
	CYCLE_ID NUMBER NOT NULL,
	CONSTRAINT TRIP_PK PRIMARY KEY(TRIP_ID),
	CONSTRAINT TRIP_CYCLE_FK FOREIGN KEY(CYCLE_ID) REFERENCES CYCLE(CYCLE_ID),
	CONSTRAINT TRIP_CUSTOMER_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)

);

CREATE TABLE CYCLE_REVIEW
(
	REVIEW_ID NUMBER NOT NULL,
	RATING NUMBER,
	COMMENT_TEXT VARCHAR2(500),
	CUSTOMER_ID NUMBER NOT NULL,
	CYCLE_ID NUMBER NOT NULL,
	CONSTRAINT CYCLE_REVIEW_PK PRIMARY KEY(REVIEW_ID),
	CONSTRAINT CYCLE_REVIEW_CYCLE_FK FOREIGN KEY(CYCLE_ID) REFERENCES CYCLE(CYCLE_ID),
	CONSTRAINT CYCLE_REVIEW_CUSTOMER_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)

);

CREATE TABLE PEER_REVIEW
(
	REVIEW_ID NUMBER NOT NULL,
	RATING NUMBER,
	COMMENT_TEXT VARCHAR2(500),
	CUSTOMER_ID NUMBER NOT NULL,
	OWNER_ID NUMBER NOT NULL,
	CONSTRAINT PEER_REVIEW_PK PRIMARY KEY(REVIEW_ID),
	CONSTRAINT PEER_REVIEW_OWNER_FK FOREIGN KEY(OWNER_ID) REFERENCES OWNER(OWNER_ID),
	CONSTRAINT PEER_REVIEW_CUSTOMER_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)

);

CREATE TABLE RESERVES
(
	TRIP_ID NUMBER NOT NULL,
	CYCLE_ID NUMBER NOT NULL,
	CUSTOMER_ID NUMBER NOT NULL,
	CONSTRAINT RESERVES_PK PRIMARY KEY(TRIP_ID),
	CONSTRAINT RESERVES_TRIP_FK FOREIGN KEY(TRIP_ID) REFERENCES TRIP_DETAILS(TRIP_ID),
	CONSTRAINT RESERVES_CYCLE_FK FOREIGN KEY(CYCLE_ID) REFERENCES CYCLE(CYCLE_ID),
	CONSTRAINT RESERVES_CUSTOMER_FK FOREIGN KEY(CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID)

);

 CREATE TABLE ADMIN
 (
	ADMIN_ID NUMBER NOT NULL,
	ADMIN_EMAIL VARCHAR2(100) NOT NULL,
	ADMIN_PASSWORD VARCHAR2(100) NOT NULL,
	CONSTRAINT ADM_PK PRIMARY KEY(ADMIN_ID)
 );