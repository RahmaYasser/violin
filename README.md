
  
  

# GOVIOLIN

  

## Important note

#### We can build go app by using `go build -o app .` but its a common practice to combine executable files in cmd directory. For more info about go project structure read [My-Article](https://rahmayasser.hashnode.dev/how-to-structure-your-go-app).

  

## Jenkins

  

### Possible environment

1.  *Pull and run Jenkins docker image*

`docker run -p 8080:8080 -p 50000:50000 -d -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

`

You can specify any directory for mount (ex: jenkins_home)

2.  *Launch bash inside the container*

`docker exec -it --user root <container_id> bash`

3.  *Install docker engine inside the container*

`curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall

`

4.  *Get Jenkins admin hash and and copy it*

`cat var/jenkins_home/secrets/initialAdminPassword && exit`

5.  *Change permissions on **“docker.sock”***

`sudo chmod 666 /var/run/docker.sock`

### Jenkins settings

1. Open localhost:8080 and Signup

2. Install the following additional plugins

`docker`    `docker pipeline`  `docker commons` `kubernetes cli`

3. Create 4 credentials

-  github(ssh or https)
-  dockerhub account with id  (dockerhub_account)
-  slack channel token with id (slacktoken)
- minikube config with id(kube_config)
4. In *Advanced Project Options* section, Choose `pipeline script from scm`

5. Paste repo URL `git@github.com:RahmaYasser/GoViolin.git` and choose credential key

6. In *Branches to build* section, write `build` instead of master

7. In *Script Path* section, write `Jenkinsfile`

8. Click Apply & Save

9. Click `Build now`

  

## Kubernetes

#### Running instructions

1. Start cluster

`minikube start`

2. Add hostname to /etc/hosts

ex: `go-violin.com <IP>`

3. Type the hostname in browser after running jenkins pipeline
