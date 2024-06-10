1. Morty Password Brute Force
   
   a. Generate password phrases for "Snuffles" and "Snowball".  
   b. Generate fake ips to avoid 429 (rate limit)  
   c. Run Intruder with PitchFork strategy.  

---

2. Unsigned JWT token
   
   Just create new <b>header</b> (base64url) with alg:none, and <b>payload</b> with email:jwtn3d@juice-sh.op.  
   Format: {header}.{payload}.  
   No need signature, but '.' after payload is mandatory.  

Make any request to server like /rest/user/whoami.  
Server uses only cookie value (skip header value) but for completion this unit, you need to add to both of them.  

---

3. Forged Coupon  

a. In twitter we can find coupon n(XLuga+po  
b. Package.json have library z85. (encoding)  
c. Decode of 'n(XLuga+po' by z85 => JUL22-30  
d. Encode of MAY24-80 -> 'o\*I]qg+yWv' (remove \)  

\*\*Not working for coupons with very long expiration time  

---

4. Foged Signed JWT
   
   Idea is to impersonate someone  
   Idea is to change encryption algorithm from RS (assymetric) => HS (symmetric).  
   RS256 has more complex structure (public/private), when HS256 is simple secret string.  

a. Make new header (with HS256) and payload of you token (decode both to base64)  
b. Put values inside generate-jwt.sh  
c. chmod +x generate_jwt.sh && ./generate_jwt.sh  

- Read .pem file  
- Sign you header.payload with .pem data (via HS256)  
- Encode signature to base64url  
- return header.payload.signature  
- makes api call to verify response  

---

5. Support Team
   In main.js by searching /support, we can find regexp validation of password
   /(?=._[a-z])(?=._[A-Z])(?=._\d)(?=._[@$!%*?&])[A-Za-z\d@$!%*?&]{12,30}/

   And error message 'Parola echipei de asistență' => Romanian Language.

   - (?=.\*[a-z]): At least one lowercase letter
   - (?=.\*[A-Z]): At least one uppercase letter.
   - (?=.\*\d): At least one digit.
   - (?=._[@$!%_?&]): At least one special character from the set @$!%\*?&.
   - [A-Za-z\d@$!%*?&]{12,30}: The entire phrase must be between 12 and 30 characters

   Example password: Passw0rd!2024

   a. /ftp and download .kdbx (or use same existed)  
   b. python keepass2john/keepass2john.py your_database.kdbx > output.txt (HASH of .kdbx file)  
   c. Remove prefix in hash file, so you hash should start from $keepass.....  
   d. hashcat -m 13400 -a 0 ./output.txt ./rockyou-55.txt. (m -13400 Keepass hash type. a -0 Dictionary Attack.)  
   f. Use different wordlists, or masks (because we have regex hint)  
