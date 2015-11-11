# Try it: Hello world!

"Pull" an image:

```
$ docker pull hello-world

Using default tag: latest
latest: Pulling from library/hello-world
3f12c794407e: Pull complete
975b84d108f1: Pull complete
Digest: sha256:517f03be3f8169d84711c9ffb2b3235a4d27c1…
Status: Downloaded newer image for hello-world:latest
```

Run a container:

```
$ docker run hello-world

Hello from Docker.
…
```

# Try it: different Linux distros

Run Ubuntu:

```
$ docker run ubuntu dpkg -l
```

or CentOS:

```
$ docker run centos rpm -qa
```

--
…

Speedy, huh?

# Try it: run a shell

```
$ docker run -i -t ubuntu bash
```

* `-i` = Keep STDIN open
* `-t` = Allocate a pseudo-TTY

Now, try doing an Ubuntu thing:

```
root@container# apt-get update
```

# Try it: which kernel?

Run `uname -a` on both `ubuntu` and `centos`:

```
$ docker run ubuntu uname -a
$ docker run centos uname -a
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
$ time docker run ubuntu bash -c "time sleep 1"
```

How much time did Docker add?

# Try it: test container file system isolation

Attempt to cripple your Ubuntu image:

```
$ docker run -i -t ubuntu bash
root@3256d8252fe6:/# ls /usr/bin
root@3256d8252fe6:/# rm -fr /usr/bin
root@3256d8252fe6:/# ls /usr/bin
^D
```

Now, start another container:

```
$ docker run -i -t ubuntu bash
root@3ed46bfba026:/# ls /usr/bin
```

# Try it: check out those layers

Use `docker history` to view image layers

```
$ docker history ubuntu
IMAGE               CREATED             CREATED BY
a005e6b7dd01        3 weeks ago         /bin/sh -c #(nop) CMD ["/bin
002fa881df8a        3 weeks ago         /bin/sh -c sed -i 's/^#\s*\(
66395c31eb82        3 weeks ago         /bin/sh -c echo '#!/bin/sh'
0105f98ced6d        3 weeks ago         /bin/sh -c #(nop) ADD file:7

```

# Try it: investigate tags in the `ubuntu` repository

Run a command using `ubuntu:15.04`:

```
$ docker run ubuntu:15.04 grep -v "^#" /etc/apt/sources.list
```

Try the same thing using `ubuntu:14.04`:

```
$ docker run ubuntu:14.04 grep -v "^#" /etc/apt/sources.list
```

--

View images in the `ubuntu` repository:

```
$ docker images ubuntu
```

# Try it: build an image,<br/> the hard way

Install some software in an `ubuntu` container:

```
$ docker run -i -t ubuntu bash
root@f78d00da1408:/# apt-get update && apt-get install -y curl
…
^D
```

Now, `commit` that container to create an image:

```
$ last_container=$(docker ps -ql)
$ docker commit $last_container ubuntu-with-curl
```

Check it out:

```
$ docker history ubuntu-with-curl
…
$ docker run ubuntu-with-curl curl http://example.com
```

# Try it: build an image,<br/> the easy way

Create a `Dockerfile`:

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
```

And use it to build an image:

```
$ docker build -t ubuntu-with-curl .
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

# Try it: show Docker images

```
$ docker images
$ docker history ubuntu-with-curl
```

# Try it: build an image using a Dockerfile

Build it:

```
$ docker build -t hello ./hello
```

Run it:

```
$ docker run hello /app/run
$ docker run hello
```
# Try it: configure using environment variables

```
$ docker run -e GREETEE=Kitty hello
```

# Try it: show Docker containers

```
$ docker ps
$ docker ps -a
```

# Try it: build cache

Build again:

```
$ docker build -t hello ./hello
```

Why so fast?

# Try it: make a change, and rebuild

Edit `hello/hello.sh`, then:

```
$ docker build -t hello ./hello
```

# Try it: push an image to Docker Hub

```
$ docker build -t YOURNAMEHERE/hello ./hello

$ docker push YOURNAMEHERE/hello
```

# Try it: run an image from the public registry

```
$ docker run hello-world
$ docker run YOURNEIGHBOUR/hello
```

# Try it: build a more complex image

```
$ docker build -t mysite ./mysite

$ docker run -d -p 80:80 mysite
$ docker ps

$ docker_ip=$(docker-machine ip $(docker-machine active))
$ curl http://$docker_ip
```

(then browse to `http://$docker_ip`)

# Try it: here's one I prepared earlier

```
$ docker run -p 80:80 woollyams/blob-store
```

(then browse to `http://$docker_ip`)

    
