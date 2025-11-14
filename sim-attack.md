# SQL Injection :
http://localhost:8080/?id=1+and+1=2+union+select+1

# code injection:
http://localhost:8080/?id=%3Cscript%3Ealert(%27Attack%20Blocked!%27)%3C/script%3E


# Path Traversal

Path Traversal: <http://localhost:8080/?id=../../../../etc/passwd>


# XSS Command injection
http://localhost:8080/?id=%3E%3Cimg+src=x+onerror=alert()

