Cross-Site Request Forgery (CSRF) - vulnerability to perform authenticatied actions on vulnerable website, from real website user.

- User session should be managed in [cookies or http auth header]

The easiest form of CSRF - create a url with specific action and send it to the victim.
But in real cases, it should be as separeted evil website.

Example 1:
We have form with POST request to change some user info on website.com/user {lastName, firstName, email}.

    Case1. We have controlled any sibling domain of victim website (exploit.website.com).
    Just store new form with new values, send this link to victim. Or just construct url /user?lastName=bob&....
    When victim opens => it automatically made POST request to api and change visitor personal information. (If you able to change someone email => you able to reset password)
    -------
    Case2. We controls any sibling domain but website has csrf token inside of cookie.
    If in request to change user data we have something like Cookie: session=...; csrfKey=....; and in body {email, csrf}
    We can try to find any server response what returns SetCookie and trying to infect this request to provide any session values.
    In this scenario, where request return SetCookie are [GET], we can put inside any desired cookie params/values (by using special characket CRLF (\n)) to make CSRF attack.
    https://book.hacktricks.xyz/pentesting-web/crlf-0d-0a

    Evil website:
    <img src='../?search=something%d%0aSet-Cookie:%20csrfKey=someValue' onerror='document.forms[0].submit' + form to change user data with predefined values.

    In result, when victim opens this link, we inject some value into csrf cookie (valid key from past action or from another user) and this csrfKey will be validated on server, and perform request to update user.
    -------

Defense:

1. CSRF token - pseudo-random generated unique parameters for each sensitive request (part of any form). /user?lastName=bob&csrf=????
   a. Handle this token on server and validate
   b. Tied to user session/token but not part of it!
   c. Block parameters in query, ready only from body.
2. Cookies control - use SameSite attribute to control cookie movement between origins/sites.
   a. SameSite=Strict policy by default. (perfect against cross-site, but powerless in cross-origin)
3. Origin header validation (not cross-origin: \*)

---
