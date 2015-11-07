# Exercise: run a command

    $ docker run ubuntu dpkg -l
    $ docker run centos rpm -qa

# Exercise: how much overhead?

Use "time" to measure the overhead of running a command in a container.

    $ time docker run ubuntu bash -c "time sleep 1"

How much time did Docker add?

# Exercise: run a shell

    $ docker run -i -t ubuntu bash

# Exercise: show Docker containers

    $ docker ps
    $ docker ps -a

# Exercise: install some software

    $ docker run -i -t ubuntu bash

    root@container# curl http://example.com

    root@container# apt-get update && apt-get install -y curl

    root@container# curl http://example.com

# Exercise: manually snapshot an image

    $ last_container=`docker ps -a -q -n 1`
    $ docker commit $last_container ubuntu-with-curl

    $ docker run -i -t ubuntu-with-curl curl http://example.com

# Exercise: show Docker images

    $ docker images
    $ docker history ubuntu-with-curl

# Exercise: build an image using a Dockerfile

Build it:

    $ docker build -t hello ./hello

Run it:

    $ docker run hello /app/run
    $ docker run hello

# Exercise: configure using environment variables

    $ docker run -e GREETEE=Kitty hello

# Exercise: inspect built image

    $ docker history hello

# Exercise: build cache

Build again:

    $ docker build -t hello ./hello

Why so fast?

# Exercise: make a change, and rebuild

Edit `hello/hello.sh`, then:

    $ docker build -t hello ./hello

# Exercise: push an image to Docker Hub

    $ docker build -t YOURNAMEHERE/hello ./hello

    $ docker push YOURNAMEHERE/hello

# Exercise: run an image from the public registry

    $ docker run hello-world
    $ docker run YOURNEIGHBOUR/hello

# Exercise: build a more complex image

    $ docker build -t mysite ./mysite

    $ docker run -d -p 80:80 mysite
    $ docker ps

    $ docker_ip=$(docker-machine ip $(docker-machine active))
    $ curl http://$docker_ip

(then browse to http://$docker_ip)

# Exercise: here's one I prepared earlier

    $ docker run -p 80:80 woollyams/blob-store

(then browse to http://$docker_ip)
