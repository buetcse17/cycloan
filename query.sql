--------------------searching for cycle in my location---------------------

location = request.POST.get('location')

cursor = connection.cursor()
sql = "SELECT DISTINCT CYCLE_ID FROM CYCLE C, OWNER O WHERE O.OWNER_ID=C.OWNER_ID AND UPPER(O.LOCATION) = %s"
cursor.execute(sql,location)
cycle_list = cursor.fetchall()
cursor.close()

for cyc in cycle_list:
	cycle_id = cyc[0]
	cursor = connection.cursor()
	sql = "SELECT PHOTO,MODEL,RATING FROM CYCLE WHERE CYCLE_ID = %s"
	cursor.execute(sql,cycle_id)
	cycle = cursor.fetchall()
	cursor.close()

----------------------OR-----------------------

location = request.POST.get('location')

cursor = connection.cursor()
sql = "SELECT OWNER_ID FROM OWNER WHERE UPPER(LOCATION) = %s"
cursor.execute(sql,location)
result = cursor.fetchall()
cursor.close()
cycle_list=[]
for r in result:
	own_id = r[0]
	cursor = connection.cursor()
	sql = "SELECT CYCLE_ID FROM CYCLE WHERE OWNER_ID = %s"
	cursor.execute(sql,own_id)
	cycle = cursor.fetchall()
	cursor.close()
	for cyc in cycle:
		cycle_list.append(cyc[0])

for cyc in cycle_list:
	cycle_id = cyc[0]
	cursor = connection.cursor()
	sql = "SELECT PHOTO,MODEL,RATING FROM CYCLE WHERE CYCLE_ID = %s"
	cursor.execute(sql,cycle_id)
	cycle = cursor.fetchall()
	cursor.close()


-----------------------------------------------------------------
-------------------------------SEQUENCE------------------------------------------

CREATE SEQUENCE OWNER_INCREMENT
INCREMENT BY 1
START WITH 10000
MAXVALUE 50000
NOCYCLE ;

--DROP SEQUENCE OWNER_INCREMENT

CREATE SEQUENCE CUSTOMER_INCREMENT
INCREMENT BY 1
START WITH 50000
MAXVALUE 90000
NOCYCLE ;

--DROP SEQUENCE CUSTOMER_INCREMENT

CREATE SEQUENCE CYCLE_INCREMENT
INCREMENT BY 1
START WITH 90000
MAXVALUE 130000
NOCYCLE ;

--DROP SEQUENCE CYCLE_INCREMENT

CREATE SEQUENCE TRIP_INCREMENT
INCREMENT BY 1
START WITH 10000
MAXVALUE 99999
NOCYCLE ;

--DROP SEQUENCE TRIP_INCREMENT

CREATE SEQUENCE CYCLE_REVIEW_INCREMENT
INCREMENT BY 1
START WITH 10000
MAXVALUE 99999
NOCYCLE ;

--DROP SEQUENCE CYCLE_REVIEW_INCREMENT

CREATE SEQUENCE PEER_REVIEW_INCREMENT
INCREMENT BY 1
START WITH 10000
MAXVALUE 99999
NOCYCLE ;

--DROP SEQUENCE PEER_REVIEW_INCREMENT

-------------------------------------------------------

--------------------------------------------------------
----------------------FINDING OWNER REVIEW---------------------------

SELECT P.CUSTOMER_ID, C.CUSTOMER_NAME, P.COMMENT_TEXT, P.RATING
FROM PEER_REVIEW P, CUSTOMER C
WHERE P.OWNER_ID = SOMETHING AND P.CUSTOMER_ID = C.CUSTOMER_ID

------------------------------------------

-----------------------------OWNS INSERTING TRIGGER--------------------

CREATE OR REPLACE TRIGGER INSERT_OWNS
AFTER INSERT
ON CYCLE
FOR EACH ROW
DECLARE
	OWNER NUMBER;
	CYCLE NUMBER;
BEGIN
	OWNER := :NEW.OWNER_ID;
	CYCLE := :NEW.CYCLE_ID;

	INSERT INTO OWNS(CYCLE_ID, OWNER_ID) VALUES(CYCLE,OWNER);

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

-------------------------------------------

--------------------------------OWNS DELETE TRIGGER------------------


CREATE OR REPLACE TRIGGER DELETE_OWNS
BEFORE DELETE
ON CYCLE
FOR EACH ROW
DECLARE
	CYCLE NUMBER;
BEGIN
	CYCLE := :OLD.CYCLE_ID;
	DELETE FROM OWNS WHERE CYCLE_ID=CYCLE;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

---------------------------------------------------------------

-------------------------PROCEDURE FOR INSERTING IN CUSTOMER-----------------------


CREATE OR REPLACE PROCEDURE INSERT_CUSTOMER( FNAME IN VARCHAR2, EMAIL IN VARCHAR2, PASS IN VARCHAR2, CONTACT IN VARCHAR2, PPATH IN VARCHAR2, DPATH IN VARCHAR2, DTYPE IN VARCHAR2, TOKCREATED IN VARCHAR2, TOKEXPIRY IN VARCHAR2, TOKEN IN VARCHAR2) IS
	CUS_ID NUMBER;
BEGIN

	INSERT INTO CUSTOMER(CUSTOMER_ID,CUSTOMER_NAME,PASSWORD,CUSTOMER_PHONE,PHOTO_PATH,EMAIL_ADDRESS) VALUES(CUSTOMER_INCREMENT.NEXTVAL,FNAME,PASS,CONTACT,PPATH,EMAIL);

	SELECT CUSTOMER_ID INTO CUS_ID FROM CUSTOMER WHERE EMAIL_ADDRESS=EMAIL;

	INSERT INTO CUSTOMER_EMAIL_VERIFICATION(CUSTOMER_ID, IS_VERIFIED, EMAIL_ADDRESS, TOKEN_CREATED, TOKEN_EXPIRY, TOKEN_VALUE) VALUES(CUS_ID,0,EMAIL,TOKCREATED,TOKEXPIRY,TOKEN);

	INSERT INTO DOCUMENT(CUSTOMER_ID,TYPE_NAME,FILE_PATH) VALUES(CUS_ID,DTYPE,DPATH);

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/
-----------------------------------------------------------------
------------------------------------PROCEDURE FOR INSERTING IN OWNER-------------------------

CREATE OR REPLACE PROCEDURE INSERT_OWNER(FNAME IN VARCHAR2, EMAIL IN VARCHAR2, PASS IN VARCHAR2, CONTACT IN VARCHAR2, PPATH IN VARCHAR2, LOC IN VARCHAR2, TOKCREATED IN VARCHAR2, TOKEXPIRY IN VARCHAR2, TOKEN IN VARCHAR2) IS
	OWN_ID NUMBER;
BEGIN

	INSERT INTO OWNER(OWNER_ID,OWNER_NAME,PASSWORD,OWNER_PHONE,LOCATION,PHOTO_PATH,EMAIL_ADDRESS) VALUES(OWNER_INCREMENT.NEXTVAL, FNAME, PASS, CONTACT, LOC, PPATH, EMAIL);

	SELECT OWNER_ID INTO OWN_ID FROM OWNER WHERE EMAIL_ADDRESS=EMAIL;

	INSERT INTO OWNER_EMAIL_VERIFICATION(OWNER_ID, IS_VERIFIED, EMAIL_ADDRESS, TOKEN_CREATED, TOKEN_EXPIRY, TOKEN_VALUE) VALUES(OWN_ID, 0, EMAIL, TOKCREATED, TOKEXPIRY, TOKEN);

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

---------------------------------------
--------------------------function for owner rating calculation---------------------

CREATE OR REPLACE FUNCTION OWNER_RATING( OWN_ID IN NUMBER )
RETURN NUMBER IS
	OWNER_RATING NUMBER;
BEGIN

	SELECT NVL(AVG(RATING), 0) INTO OWNER_RATING FROM PEER_REVIEW WHERE OWNER_ID=OWN_ID;
	RETURN OWNER_RATING;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/


-----------------------------------------------------------------------------------

--------------------------function for CYCLE rating calculation---------------------

CREATE OR REPLACE FUNCTION CYCLE_RATING( CYC_ID IN NUMBER )
RETURN NUMBER IS
	CYCLE_RATING NUMBER;
BEGIN

	SELECT NVL(AVG(RATING), 0) INTO CYCLE_RATING FROM CYCLE_REVIEW WHERE CYCLE_ID=CYC_ID;
	RETURN CYCLE_RATING;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

--------------------------------------------------------------------