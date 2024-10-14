Path Traversal or Directory Traversal.
Used to read files on server

- code
- sensitive files
- credentials
- backups
- etc

If server has logic to read something from some folder by Path. (pdf or image or any else)
Or if you server just store backup of you website in public folder.
Or you allowed to export of some data, and open this export on website (from their cache or folder system)

It possible to craft path to sensitive info

<img src=`/load?${fileName}`>
fileName = "../../../etc/passwd" instead of "./cat.jpg"
or
"/etc/passwd"
"....//....//....//etc/passwd"
"../../../etc/passwd%00.png"

Sometimes webserver can automatically remove directory traversal path (../) from input.
We can use URL encoded or even double encoded variables (%2e%2e%2f for ../ OR %252e%252e%252f (double) OR ..%c0%af or ..%ef%bc%8f) all of them has same value "../"

For safe file handling, it's crucial to sanitize paths and use functions like

- path.resolve()
- os.path.join()
  in JavaScript and Python respectively to avoid traversal attacks.
