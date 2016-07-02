# Try it: Hello world!

"Pull" an image:

```
$ `docker pull hello-world`

Using default tag: latest
latest: Pulling from library/hello-world
3f12c794407e: Pull complete
975b84d108f1: Pull complete
Digest: sha256:517f03be3f8169d84711c9ffb2b3235a4d27c1…
Status: Downloaded newer image for hello-world:latest
```

Run a container:

```
$ `docker run hello-world`

Hello from Docker.
…
```

# Try it: different Linux distros

Run Ubuntu:

```
$ `docker run ubuntu dpkg -l`
```

or CentOS:

```
$ `docker run centos rpm -qa`
```

--
…

Speedy, huh?

--

… or not, if you have a slow internet connection :-(

# Try it: run a shell

```
$ `docker run -i -t ubuntu bash`
```

* `-i` = Keep STDIN open
* `-t` = Allocate a pseudo-TTY

Now, try doing an Ubuntu thing:

```
root@container# `apt-get update`
```

# Try it: which kernel?

Run `uname -a` on both `ubuntu` and `centos`:

```
$ `docker run ubuntu uname -a`
$ `docker run centos uname -a`
```

Can you explain the result?

--

…

Different distros, same kernel: same result.

.center[
![2 distros, one kernel](diagrams/two-distros-one-kernel.png)
]

# Try it: overhead, much?

Use "time" to measure the overhead of running a command in a container.

```
$ `time docker run ubuntu bash -c "time sleep 1"`
```

How much time did Docker add?

# Try it: test container file system isolation

Attempt to cripple your Ubuntu image:

```
$ `docker run -i -t ubuntu bash`
root@3256d8252fe6:/# `ls /usr/bin`
root@3256d8252fe6:/# `rm -fr /usr/bin`
root@3256d8252fe6:/# `ls /usr/bin`
^D
```

Now, start another container:

```
$ `docker run -i -t ubuntu bash`
root@3ed46bfba026:/# `ls /usr/bin`
```

# Try it: check out those layers

Use `docker history` to view image layers

```
$ `docker history ubuntu`
IMAGE               CREATED             CREATED BY
a005e6b7dd01        3 weeks ago         /bin/sh -c #(nop) CMD ["/bin
002fa881df8a        3 weeks ago         /bin/sh -c sed -i 's/^#\s*\(
66395c31eb82        3 weeks ago         /bin/sh -c echo '#!/bin/sh'
0105f98ced6d        3 weeks ago         /bin/sh -c #(nop) ADD file:7

```

# Try it: investigate tags in the `ubuntu` repository

Run a command using `ubuntu:15.04`:

```
$ `docker run ubuntu:15.04 grep -v "^#" /etc/apt/sources.list`
```

Try the same thing using `ubuntu:14.04`:

```
$ `docker run ubuntu:14.04 grep -v "^#" /etc/apt/sources.list`
```

--

View images in the `ubuntu` repository:

```
$ `docker images ubuntu`
```

# Try it: build an image,<br/> the hard way

Install some software in an `ubuntu` container:

```
$ `docker run -i -t ubuntu bash`
root@f78d00da1408:/# `apt-get update && apt-get install -y curl`
…
^D
```

Now, `commit` that container to create an image:

```
$ `last_container=$(docker ps -ql)`
$ `docker commit $last_container ubuntu-with-curl`
```

Check it out:

```
$ `docker history ubuntu-with-curl`
…
$ `docker run ubuntu-with-curl curl http://example.com`
```

# Try it: build an image,<br/> the easy way

Use a `Dockerfile`:

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
```

to build an image:

```
$ `docker build -t ubuntu-with-curl exercises/ubuntu-with-curl`
Sending build context to Docker daemon 2.048 kB
Step 0 : FROM ubuntu
 ---> a005e6b7dd01
Step 1 : RUN apt-get update && apt-get install -y curl
 ---> Running in 51bf195331b7
Ign http://archive.ubuntu.com trusty InRelease
Get:1 http://archive.ubuntu.com trusty-updates InRelease [64.4 kB]
…
 ---> 70b42c74bb66
Removing intermediate container 51bf195331b7
Successfully built 70b42c74bb66
```

# Try it: leverage the "build cache"

Build an image from the recipe provided:

```
$ `docker build -t ciao exercises/ciao`
```

--

Build it again:

```
$ `docker build -t ciao exercises/ciao`
```

Faster, eh?

# Try it: invalidate the "build cache"

Make a change to `exercises/ciao/index.js`, then build again:

```
$ `docker build -t ciao exercises/ciao`
```

What happens at "Step 5"?

--

Now make a change to `exercises/ciao/package.json`, and build again.

```
$ `docker build -t ciao exercises/ciao`
```

What happens at "Step 4"?

# Try it: push an image to Docker Hub

Authenticate to Docker Hub:

```
$ `docker login`
```

"Tag" an image into _your_ namespace:

```
$ `docker tag ciao YOURNAMEHERE/ciao`
```

Now you can push it:

```
$ `docker push YOURNAMEHERE/ciao`
```

# Try it: pull an image someone else pushed

Talk to the esteemed colleague next to you, and ask them
for their Docker Hub username.  Then, you shoud be able to
fetch the image _they_ pushed.

```
$ `docker pull YOURNEIGHBOUR/ciao`
```

# Try it: container basics

Run a container as a daemon (in the background):

```
$ `docker run -d ciao`
```

List the running containers:

```
$ `docker ps`
```

List ALL the containers:

```
$ `docker ps -a`
```

Remove a container:

```
$ `docker rm <ID_OR_NAME>`
```

Remove a RUNNING container:

```
$ `docker rm -f <ID_OR_NAME>`
```

# Try it: name your containers

Start a container with a `--name`:

```
$ `docker run --name app ciao`
```

Now you can use the NAME rather than an ID:

```
$ `docker rm -f app`
```

# Try it: map a port to a host port

```
$ `docker run -d --name app -p 5678:80 ciao`
```

.center[
<img src="diagrams/ciao-explicit-port.png" width=40% />
]

```
$ `curl ${DOCKER_IP-localhost}:5678`
```

Remember to clean up:

```
$ `docker rm -f app`
```

# Try it: use a random host port

If you don't specify a host port, Docker will choose one:

```
$ `docker run -d --name app -p 80 ciao`
```

.center[
<img src="diagrams/ciao-random-port.png" width=40% />
]

Use `docker port` to discover which one it chose:

```
$ `docker port app 80`
```

# Try it: logs

You can get the output using `docker logs`:

```
$ `docker logs app`
```

or even follow along in real time:

```
$ `docker logs --follow --timestamps app`
```

# Try it: link two containers

You can link containers together, without exposing ports to the host:

```
$ `docker run -d --name app -p 80 ciao`
$ `docker run -d --name proxy -p 5678:80 --link app:app realestate/ciao-proxy`
```

.center[
  <img src="diagrams/nginx-ciao.png" width="60%" />
]

To see proof:

```
$ `curl -si ${DOCKER_IP-localhost}:5678 | grep Server`
```

Cleanup:

```
$ `docker rm -f app proxy`
```

# Try it: set environment variables

Assuming your application looks for environment variables, e.g.

```javascript
var MESSAGE = (process.env.MESSAGE || "Ciao mondo.");
```

You can set them to provide configuration:

```
$ `docker run -d --name app -p 5678:80 -e MESSAGE='Hey, guys!' ciao`
```

Test the result:

```
$ `curl ${DOCKER_IP-localhost}:5678`
```

# Try it: map a volume from the host

Mount a directory from the "host":

```
$ `docker run -it --rm -v /tmp/my-cache:/var/cache ubuntu bash`
root@c10a43c38793:/# `mount | grep cache`
root@c10a43c38793:/# `echo TESTING > /var/cache/test`
^D
```

and then later:

```
$ `docker run -it --rm -v /tmp/my-cache:/var/cache ubuntu bash`
root@f5be5dec8a5a:/# `ls /var/cache/`
```

# Try it: use a volume for extra writable space

Tip: you can improve security by:

* mounting your root volume read-only
* creating writable volumes as required

```
$ `docker run -it --rm --read-only -v /scratch ubuntu`
root@c10a43c38793:/# `mount | grep scratch`
root@c10a43c38793:/# `echo TESTING > /tmp/test`
root@c10a43c38793:/# `echo TESTING > /scratch/test`
```

# Try it: share a volume with another container

Create a container, with a volume:

```
$ `docker run -it --name provider -v /shared ubuntu`
root@118f38503653:/# `echo ohai > /shared/stuff`
```

Use the volume from a different container:

```
$ `docker run -it --rm --volumes-from provider ubuntu`
root@118f38503653:/# `cat /shared/stuff`
```

NOTE: Docker 1.9 adds first-class volume support.

# Try it: link containers using docker-compose

- Lifecycle management for _groups_ of containers.

Given YAML config file:

```
app:
  image: ciao

proxy:
  image: realestate/ciao-proxy
  links:
  - app
  ports:
  - 5678:80
```

You can start all the containers with:

```
$ `cd exercises/composed`
$ `docker-compose up`
```
