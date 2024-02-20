# Automation_Jenkins
Our Automation Jenkins service is running on a reserved VPS with a Cloudflare proxied SSL/TLS encryption. Server traffic managed by Nginx.
<BR>
The address is https://automation.hinsonli.com/
<BR>
## Visitor account:
Username: visitor
<BR>
Password: Visitor123
<BR>
## Jenkins running inside a docker container launched by below command
```
docker run --name jenkins \
-u root \
-d \
-v /root/jenkins/jenkins_workspace:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-p 8081:8080 \
-p 50000:50000 \
jenkins/jenkins:lts-jdk11
```
<img width="1367" alt="image" src="https://github.com/hihinsonli/Automation_Jenkins/assets/134122199/6cc5cac3-1b89-486f-bad6-8049c1153ef5">

