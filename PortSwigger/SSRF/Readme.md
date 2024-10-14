SSRF - Server-side Request Forgery occurs when an attacker manipulates a server-side application to perform HTTP requests to other domain. <b>Initial step to access internal resources</b>.

Exploit the trust between server and another server and backend.

1. Attacker craft HTTP payload
2. Vulnerable system handle request
3. Malicious request executed

Usually, the attacker provides URL pointing to localhost. HTTP .... api=127.0.0.1/admin

- Initial Access to Intenal System
- Internal Reconnaissance (enumerate the internal network)
- Access to Internal APIs or Services (credentials, privileges escalation ...)

Goal: Reach admin panels, access databases

---

Defend:

- Whitelist - some apps allow only input that match a whitelist
- Blacklist - some apps block input like hostname (localhost, admin, 127.0.0.1)

Bypass Blacklist:

- https://book.hacktricks.xyz/pentesting-web/ssrf-server-side-request-forgery/url-format-bypass

Bypass Whitelist:

- Embed credentials in url https://host:user@pass
- Use # https://host#ID
- url encode characters to confuse url parse code

Open Redirect vuln:
stockApi=http://weliketoshop.net/product/nextProduct?currentProductId=6&path=http://192.168.0.68/admin
-> local admin

Blind SSRF (may be RCE): Request processed -> but without server response.
We can use Burp Collaborator or any server to catch response. <b>out-of-band (OAST) techniques</b>
