

--------adding cycle---------

cursor = connection.cursor()
sql = "SELECT COUNT(*) FROM CYCLE"
cursor.execute(sql)
result = cursor.fetchall()
cursor.close()
count = int(result[0][0])
cycle_id = 101 + count
## photo_path = save_owner_photo(photo, owner_id)

owner_id = request.session.get('owner_id')

cursor = connection.cursor()
sql = "INSERT INTO CYCLE(CYCLE_ID,MODEL,STATUS,RATING,PHOTO_PATH,OWNER_ID) VALUES(%s, %s, %s, %s, %s, %s)"
cursor.execute(sql, [cycle_id, model, status, rating, photo_path, owner_id])
connection.commit()
cursor.close()

---------------------------------------------------------

----------------show my cycle--------------

owner_id = request.session.get('owner_id')

cursor = connection.cursor()
sql = "SELECT PHOTO,MODEL,RATING FROM CYCLE WHERE OWNER_ID = %s"
cursor.execute(sql,owner_id)
result = cursor.fetchall()
cursor.close()

for r in result:
	photo_path = r[0]
	model = r[1]
	rating = r[3]

----------------------------------------------------

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

-----------------
-------------------------trigger for updating rating of cycle-----------------

CREATE OR REPLACE TRIGGER UPDATE_RATING_CYCLE
AFTER INSERT
ON CYCLE_REVIEW
FOR EACH ROW
DECLARE
	CYC_ID NUMBER;
	NEW_RATING NUMBER;
	NEW_AVG_RATING NUMBER;
	SUM_RATING NUMBER;
	COUNTING NUMBER;
BEGIN
	CYC_ID := :NEW.CYCLE_ID;
	NEW_RATING := :NEW.RATING;
	SUM_RATING := 0;
	COUNTING := 0;

	FOR R IN (SELECT RATING FROM CYCLE_REVIEW WHERE CYCLE_ID = CYC_ID )
	LOOP
		SUM_RATING := SUM_RATING + R.RATING;
		COUNTING := COUNTING + 1;
	END LOOP;

	SUM_RATING := SUM_RATING + NEW_RATING;
	NEW_AVG_RATING := SUM_RATING/(COUNTING + 1);

	UPDATE CYCLE SET RATING = NEW_AVG_RATING WHERE CYCLE_ID = CYC_ID;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

-----------------------------------------
---------------------------trigger for updating owner rating--------------------------

CREATE OR REPLACE TRIGGER UPDATE_RATING_OWNER
AFTER INSERT
ON PEER_REVIEW
FOR EACH ROW
DECLARE
	OWN_ID NUMBER;
	NEW_RATING NUMBER;
	NEW_AVG_RATING NUMBER;
	SUM_RATING NUMBER;
	COUNTING NUMBER;
BEGIN
	OWN_ID := :NEW.OWNER_ID;
	NEW_RATING := :NEW.RATING;
	SUM_RATING := 0;
	COUNTING := 0;

	FOR R IN (SELECT RATING FROM PEER_REVIEW WHERE OWNER_ID = OWN_ID )
	LOOP
		SUM_RATING := SUM_RATING + R.RATING;
		COUNTING := COUNTING + 1;
	END LOOP;

	SUM_RATING := SUM_RATING + NEW_RATING;
	NEW_AVG_RATING := SUM_RATING/(COUNTING + 1);

	UPDATE OWNER SET RATING = NEW_AVG_RATING WHERE OWNER_ID = OWN_ID;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('NO DATA');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('DO NOT KNOW');
END;
/

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