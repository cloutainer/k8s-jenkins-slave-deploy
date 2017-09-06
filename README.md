<img src="https://cloutainer.github.io/documentation/images/cloutainer.svg?v5" align="right">

# k8s-jenkins-slave-deploy

[![](https://codeclou.github.io/doc/badges/generated/docker-image-size-333.svg)](https://hub.docker.com/r/cloutainer/k8s-jenkins-slave-oracle-java/tags/) [![](https://codeclou.github.io/doc/badges/generated/docker-from-ubuntu-16.04.svg)](https://www.ubuntu.com/) [![](https://codeclou.github.io/doc/badges/generated/docker-run-as-root.svg)](https://docs.docker.com/engine/reference/builder/#/user)


Kubernetes Docker image providing all the Deploy Tools.

-----
&nbsp;

### Preinstalled Tools

| tool | version |
|------|---------|
| cloudfoundry cli | apt-get |
| kubernetes cli | apt-get |
| docker cli`*` | apt-get |
| git | apt-get |
| curl, wget | apt-get |
| zip, bzip2 | apt-get |
| jq | apt-get |

`*` You need to mount the `/var/run/docker.sock` as volume.

-----
&nbsp;

### Usage


Use with [Kubernetes Jenkins Plugin](https://github.com/jenkinsci/kubernetes-plugin) like so:

```groovy
podTemplate(
  name: 'deploy-v1',
  label: 'k8s-jenkins-slave-deploy-v1',
  cloud: 'mycloud',
  nodeSelector: 'failure-domain.beta.kubernetes.io/zone=eu-west-1a',
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: 'cloutainer/k8s-jenkins-slave-deploy:v1',
      privileged: false,
      command: '/opt/docker-entrypoint.sh',
      args: '',
      alwaysPullImage: false,
      workingDir: '/home/jenkins',
      resourceRequestCpu: '500m',
      resourceLimitCpu: '1',
      resourceRequestMemory: '3000Mi',
      resourceLimitMemory: '3000Mi',
      volumes: [hostPathVolume(
        hostPath: '/var/run/docker.sock',
        mountPath: '/var/run/docker.sock'
        )]
    )
  ]
) {
  node('k8s-jenkins-slave-deploy-v1') {
    stage('docker') {
      sh 'docker ps'
    }
  }
}
```

**Debug** - Open a bash to e.g. check the tools

```
docker run -i -t -v /var/run/docker.sock:/var/run/docker.sock \
       --entrypoint "/bin/bash" cloutainer/k8s-jenkins-slave-deploy:v1
$> docker ps
...
```

**Why does it run as root?** - Well - Because of the docker.sock.
Long Story: The docker.sock belongs to user root and group docker.
But the GID of the docker group might vary on your k8s host system,
so there is no (clean) way to add the jenkins user to that gid inside the container.
Simply `chmod 777` on the sock is a big security risk too.
So for now, this particular pod runs as root user until I have figured out a cleaner solution.

-----
&nbsp;

### License

[MIT](https://github.com/cloutainer/k8s-jenkins-slave-deploy/blob/master/LICENSE) © [Bernhard Grünewaldt](https://github.com/clouless)
