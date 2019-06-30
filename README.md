## Jenkins IMAGE

### Building jenkins image

```
docker build --no-cache . -t anantkpal/jenkins
```

### Running Jenkins

`repo-url` should contain folder with `env` name and should contain file `repos.txt`

```
docker run -p 80:8080 -e JENKINS_USER=admin -e JENKINS_PASS=admin -e REPO_GIT_REPO=<repo-url> -e ENV_NAME=dev anantkpal/jenkins
```


## Thanks to

Inspired by https://github.com/microdc/k8s-jenkins
