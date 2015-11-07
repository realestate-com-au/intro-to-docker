# Kata - run a command

    $ docker run ubuntu dpkg -l
    $ docker run centos rpm -qa

# Kata - how much overhead?

Use "time" to measure the overhead of running a command in a container.

    $ time docker run ubuntu bash -c "time sleep 1"

How much time did Docker add?

# Kata - run a shell

    $ docker run -i -t ubuntu bash

# Kata - show Docker containers

    $ docker ps
    $ docker ps -a

# Kata - install some software

    $ docker run -i -t ubuntu bash

    root@container# curl http://example.com

    root@container# apt-get update && apt-get install -y curl

    root@container# curl http://example.com

# Kata - manually snapshot an image

    $ last_container=`docker ps -a -q -n 1`
    $ docker commit $last_container ubuntu-with-curl

    $ docker run -i -t ubuntu-with-curl curl http://example.com

# Kata - show Docker images

    $ docker images
    $ docker history ubuntu-with-curl

# Kata - build an image using a Dockerfile

Build it:

    $ docker build -t hello ./hello

Run it:

    $ docker run hello /app/run
    $ docker run hello

# Kata - configure using environment variables

    $ docker run -e GREETEE=Kitty hello

# Kata - inspect built image

    $ docker history hello

# Kata - build cache

Build again:

    $ docker build -t hello ./hello

Why so fast?

# Kata - make a change, and rebuild

Edit `hello/hello.sh`, then:

    $ docker build -t hello ./hello

# Kata - push an image to Docker Hub

    $ docker build -t YOURNAMEHERE/hello ./hello

    $ docker push YOURNAMEHERE/hello

# Kata - run an image from the public registry

    $ docker run hello-world
    $ docker run YOURNEIGHBOUR/hello

# Kata - build a more complex image

    $ docker build -t mysite ./mysite

    $ docker run -d -p 80:80 mysite
    $ docker ps

    $ docker_ip=$(docker-machine ip $(docker-machine active))
    $ curl http://$docker_ip

(then browse to http://$docker_ip)

# Kata - here's one I prepared earlier

    $ docker run -p 80:80 woollyams/blob-store

(then browse to http://$docker_ip)
