# Try it: Hello world!

"Pull" an image:

```
$ `docker pull hello-world`

Using default tag: latest
latest: Pulling from library/hello-world
c04b14da8d14: Pull complete
Digest: sha256:0256e8a36e2070f7bf2d0b0763dbabdd67798512411de4cdcf9431a1feb60fd9
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

# Try it: run a shell

```
$ `docker run -i -t ubuntu bash`
```

* `-i` = Keep STDIN open
* `-t` = Allocate a pseudo-TTY

Now, try doing an Ubuntu thing:

```
root@container# `apt update`
```

# Try it: which kernel?

Run `uname -a` on both `ubuntu` and `centos`:

```
$ `docker run ubuntu uname -a`
$ `docker run centos uname -a`
```

Can you explain the result?

--

Different distros, same kernel.

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
07c86167cdc4        2 days ago          /bin/sh -c #(nop) CMD ["/bin
<missing>           2 days ago          /bin/sh -c sed -i 's/^#\s*\(
<missing>           2 days ago          /bin/sh -c echo '#!/bin/sh'
<missing>           2 days ago          /bin/sh -c #(nop) ADD file:b

```

# Try it: a long-running container

Run a container as a daemon (in the background):

```
$ `docker run -d realestate/ciao`
```

List the running containers:

```
$ `docker ps`
```

List ALL the containers:

```
$ `docker ps -a`
```

???

`-d` starts a long-running process.

Containers have an exit-status, and can be restarted with `docker start`.

# Try it: container cleanup

Remove a container:

```
$ `docker rm <ID>`
```

Remove a RUNNING container:

```
$ `docker rm -f <ID>`
```

Cleanup dead containers:

```
$ `docker rm $(docker ps -aq) 2>/dev/null`
```

# Try it: name your containers

Start a container with a `--name`:

```
$ `docker run -d --name app realestate/ciao`
```

Now you can use the NAME rather than an ID:

```
$ `docker rm -f app`
```

# Try it: map a port to a host port

```
$ `docker run -d --name app -p 5678:80 realestate/ciao`
```

.center[
<img src="diagrams/ciao-explicit-port.png" width=40% />
]

```
$ `curl localhost:5678`
```

# Try it: use a random host port

If you don't specify a host port, Docker will choose one:

```
$ `docker run -d --name app -p 80 realestate/ciao`
```

.center[
<img src="diagrams/ciao-random-port.png" width=40% />
]

Use `docker port` to discover which one it chose:

```
$ `docker port app 80`
```

Hit it:

```
$ `curl $(docker port app 80)`
```

# Try it: logs

You can get the output using `docker logs`:

```
$ `docker logs app`
```

Again, with timestamps:

```
$ `docker logs --timestamps app`
```

or even follow along in real time:

```
$ `docker logs --follow --timestamps app`
```

# Try it: set environment variables

Assuming your application looks for environment variables, e.g.

```javascript
var MESSAGE = (process.env.MESSAGE || "Ciao mondo.");
```

You can set them to provide configuration:

```
$ `docker run -d --name app -p 5678:80 \`
  `-e MESSAGE='Hey, guys!' \`
  `realestate/ciao`
```

Test the result:

```
$ `curl localhost:5678`
```

# Try it: inter-container networking

Create a "network":

```
$ `docker network create shared`
$ `docker network ls`
```

Attach some containers:

```
$ `docker rm -f app proxy`
$ `docker run -d --net=shared --name app \`
  `realestate/ciao`
$ `docker run -d --net=shared --name proxy \`
  `-p 5678:80 \`
  `realestate/ciao-proxy`
```

```
$ `curl -si localhost:5678`
```

# Try it: explore the network

```
$ `docker network inspect shared`
```

.center[
<img src="diagrams/shared-network.png" width="60%" />
]

```
$ `docker run -it --rm --network shared busybox`
/ # `nslookup app`
```

# Try it: volume from host

Mount your home directory from the "host":

```
$ `docker run -it --rm -v $HOME:/myhome ubuntu bash`
root@c10a43c38793:/# `mount | grep home`
root@c10a43c38793:/# `cd /myhome; ls`
root@c10a43c38793:/# `echo HELLO FROM DOCKER > written-from-docker`
root@c10a43c38793:/# `exit`
$ `ls $HOME`
```

# Try it: named cache volume

```
$ `docker run -it --rm -v my-cache:/cache ubuntu bash`
root@c10a43c38793:/# `echo TESTING > /cache/test`
^D
```

Observe, volume created:

```
$ `docker volume ls`
```

Use it again:

```
$ `docker run -it --rm -v my-cache:/cache ubuntu bash`
root@f5be5dec8a5a:/# `ls /cache`
```

Clean up:

```
$ `docker volume rm my-cache`
```

# Try it: anonymous volume for extra writable space

```
$ `docker run -it --rm --read-only -v /scratch ubuntu`
root@c10a43c38793:/# `echo TESTING > /tmp/test`
root@c10a43c38793:/# `echo TESTING > /scratch/test`
```

.center[
<img src="diagrams/cow-vs-data-volume.png" width=60% />
]

Tip: read-only root volume is great for security!

# Try it: share a volume with another container

Create a container, with a volume:

```
$ `docker run -it --rm --name provider -v data:/published ubuntu`
root@118f38503653:/# `echo ohai > /published/stuff`
```

.center[
<img src="diagrams/shared-volume.png" width=80% />
]

Use the volume from a different container:

```
$ `docker run -it --rm --name consumer -v data:/provided:ro ubuntu`
root@d88a7a468b01:/# `cat /provided/stuff`
```

# Try it: list images

View images on your Docker host:

```
$ `docker images`
REPOSITORY   TAG          IMAGE ID       CREATED       SIZE
busybox      latest       e02e811dd08f   4 days ago    1.093 MB
debian       latest       ddf73f48a05d   2 weeks ago   123 MB
nginx        latest       ba6bed934df2   2 weeks ago   181.4 MB
ruby         2.3-alpine   2467a614f30b   2 weeks ago   125.8 MB
...
ubuntu       16.04        45bc58500fa3   3 weeks ago   126.9 MB
ubuntu       latest       45bc58500fa3   3 weeks ago   126.9 MB
ubuntu       <none>       45bc58500fa3   3 weeks ago   126.9 MB
```

--

View images in the `ubuntu` repository:

```
$ `docker images ubuntu`
```

# Try it: use an image tag

Image repositories can contain multiple images, identified by tag:

.center[
`<REPOSITORY>[:<TAG>]`
]

Run different versions of Ruby:

```
$ `docker run ruby:2.3 ruby --version`
$ `docker run ruby:2.4 ruby --version`
```

--

By convention, there's usually a `latest` tag:

```
$ `docker run ruby:latest ruby --version`
```

which is the default:

```
$ `docker run ruby ruby --version`
```

# Try it: stable image references

Image can also be addressed with immutable digests:

.center[
`<REPOSITORY>[@<DIGEST>]`
]

```
$ `docker pull ruby:2.4 | grep Digest`
```

Use the digest:

```
$ `docker run ruby@sha256:ec92755b46504ec2d27d8a2887d080ca9ef799dfe7c010b7019b2165f875c738 \`
  `ruby --version`
```

Or, a different (older) one:

```
$ `docker run ruby@sha256:450ce48d8021d33c306168654256b9c960711e6c02991f270d55488caf860410 \`
  `ruby --version`
```

# Try it: non-standard namespace

Repositories can have an optional namespace:

.center[
`[<NAMESPACE>/]<REPOSITORY>`
]

Use a community image:

```
$ `docker run -it supertest2014/nyan`
```

# Try it: build an image, the hard way

Install some software in an `ubuntu` container:

```
$ `docker run -it ubuntu bash`
root@f55393e5dc31:/# `apt-get update && apt-get install -y curl`
…
root@f55393e5dc31:/# `exit`
```

Now, `commit` that container to create an image:

```
$ `container=$(docker ps -lq)`
$ `image=$(docker commit $container)`
```

Try it out:

```
$ `docker run ubuntu curl http://example.com`
$ `docker run $image curl http://example.com`
```

# Try it: name your image

Attach a tag to an existing image:

```
$ `docker tag $image curly`
```

Or, when making it:

```
$ `docker commit $container curly`
```

For later use:

```
$ `docker run curly curl http://example.com`
```


# Try it: build an image, the easy way

Use a `Dockerfile`:

```
FROM ubuntu
RUN apt-get update && apt-get install -y curl
```

to build an image:

```
$ `docker build exercises/ubuntu-with-curl`
Sending build context to Docker daemon 2.048 kB
Step 1 : FROM ubuntu
 ---> 07c86167cdc4
Step 2 : RUN apt-get update && apt-get install -y curl
 ---> Running in 51bf195331b7
Ign http://archive.ubuntu.com trusty InRelease
Get:1 http://archive.ubuntu.com trusty-updates InRelease [64.4 kB]
…
 ---> 70b42c74bb66
Removing intermediate container 51bf195331b7
Successfully built 70b42c74bb66
```

# Try it: leverage the "build cache"

Use the recipe provided:

```
FROM node:6.2.2

COPY package.json /app/
WORKDIR /app
RUN npm install
COPY index.js /app/

ENV PORT 80
CMD ["node", "/app/index.js"]
```

to build an image:

```
$ `docker build -t ciao exercises/ciao`
```

# Try it: invalidate the "build cache"

Build it again:

```
$ `docker build -t ciao exercises/ciao`
```

Faster, eh? Observe: "Using cache".

--

Now try this:

* Edit `exercises/ciao/index.js`, changing the default MESSAGE from "Ciao mondo" to something else, then build again. What happens at "Step 5"?

--

* Make a change to `exercises/ciao/package.json`, and build again. What happens at "Step 4"?

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

# Try it: docker-compose

Given YAML config file:

```
version: '3'

services:

  app:
    image: realestate/ciao

  proxy:
    image: realestate/ciao-proxy
    depends_on:
      - app
    environment:
      BACKEND: app
    ports:
      - 5678:80
```

You can start the containers with:

```
$ `cd exercises/composed/basic`
$ `docker-compose up`
```

# Try it: under the covers of compose

In a different window, generate some traffic:

```
$ `curl localhost:5678`
```

What containers are running?

```
$ `docker ps`
$ `cd exercises/composed/basic`
$ `docker-compose ps`
```

How about networking?

```
$ `docker inspect basic_app_1 \`
  `| jq '.[0].NetworkSettings.Networks'`
```

Take it all down:

```
$ `docker-compose down`
```

# Try it: get compose to build your images

```
version: '3'

services:

  app:
    `build: ../../ciao`

  proxy:
    `build: ../../ciao-proxy`
    depends_on:
      - app
    environment:
      BACKEND: app:80
    ports:
      - 5678:80
```
--

```
$ `cd exercises/composed/autobuilt`
$ `docker-compose up`
```

# Try it: add a "client" container

```
version: '3'

services:
  app: ...
  proxy: ...

  client:
    build: ../../ubuntu-with-curl
    depends_on:
      - proxy
    command: sh -c "while true; do curl http://proxy; sleep 1; done"
```

```
$ `cd exercises/composed/with-curl`
$ `docker-compose up`
```

(Press Ctrl-C to tear everything down.)

# Try it: docker-compose run

Try "running" a "client" container:

```
$ `docker-compose run --rm client`
```

Or, go interactive:

```
$ `docker-compose run --rm client bash`
root@ebb0d01e63b0:/# `curl -i app`
root@ebb0d01e63b0:/# `curl -i proxy`
```

# Try it: sharing a volume

```
version: '3'

volumes:
  shared: {}

services:

  producer:
    image: busybox
    volumes:
      - shared:/out
    command: sh -c "while true; do date; sleep 1; done > /out/dates"

  consumer:
    image: ubuntu:16.04
    depends_on:
      - producer
    volumes:
      - shared:/data
    command: tail -f /data/dates
```

```
$ `cd exercises/composed/sharing`
$ `docker-compose up`
```

# Try it: Python and Redis and .Net and PostgreSQL and Node.js

```
$ `cd exercises/example-voting-app`
$ `docker-compose up`
```

.center[
<img src="exercises/example-voting-app/architecture.png" width="75%"/>
]

# Try it: Python and Redis and .Net and PostgreSQL and Node.js

Once it's started running ...

* voting-app at <a href="http://localhost:5000" target="vote">http://localhost:5000</a>
* result-app at <a href="http://localhost:5001" target="results">http://localhost:5001</a>

When you're done, clean up:

```
$ `^C`
$ `docker-compose down`
```

