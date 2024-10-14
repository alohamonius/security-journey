Preface:
In 1993 was created first html tag <img>. If you browser see <img> with different host of image (protocol || port || domain), so we have a cross-origin request.
http://a.com and https://a.com has cross-origin.

World without CORS: (csrf attack)
On website hack.com we have <script> fetch('some-bank.com/api/user/delete')</script>
So if someone who authorized in this bank, open this page => he delete his account (by saved cookie).

But what about audio/video or scripts with analytics, links and iframe?
RFC6454.

Another case.
We want to understand, who is a customer of intranet website in specific company.
We create malicious page with <img src='admin.some-bank.com/assets/1.png' onerror='console.log("this customer not admin")' onload='console.log("whoap, admin")'>

CORS - mechanism to control access between different origins/domains.
Allows for server to define domains list who can access server assets.

HttpHeaders:

- Access-Control-Allow-Origin
- Access-Control-Allow-Credentials

C#
`builder.Services.AddCors(options =>
{
    options.AddPolicy(name: MyAllowSpecificOrigins,
    policy =>
    {
    policy.WithOrigins("http://example.com",
    "http://www.contoso.com");
    });
});`

---

Origin header similar to Referer. (where request originated from)
origin - protocol/host/port (may be null)
Referer - full url with payj

Common rules mistake:

- \*test.com -> badtest.com
- \*.test.com -> captured.test.com (if this website vulnerable => XSS to inject js that uses cors trusted domain )
  (https://subdomain.test.com/?xss=<script></script>)
- test.com\* -> test.com.hack.com

---

How to prevent?

- Use Access-Control-Allow-Origin header properly on sensitive resources
- Allow only trusted sites, as limited as possible (public/private) | no wildcards
- Avoid A-C-A-O:null
