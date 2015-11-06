# Kata - run a command

    $ docker run ubuntu dpkg -l
    $ docker run centos rpm -qa

# Kata - how much overhead?

    Use "time" to measure the overhead of running a command in a container.

    $ time docker run centos sh -c "time rpm -qa"

# Kata - run a shell

    $ docker run -i -t ubuntu bash

# Kata - show Docker containers

    $ docker ps
    $ docker ps -a

# Kata - install some software

    $ docker run -i -t ubuntu bash

    root@container# curl http://example.com

    root@container# apt-get update
    root@container# apt-get install -y curl

    root@container# curl http://example.com

# Kata - manually snapshot an image

    $ last_container=`docker ps -a -q -n 1`
    $ docker commit $last_container curly-ubuntu

    $ docker run -i -t curly-ubuntu curl http://example.com

# Kata - show Docker images

    $ docker images
    $ docker history curly-ubuntu

# Kata - build an image using a Dockerfile

    $ docker build -t hello ./hello

    $ docker run hello /app/run
    $ docker run hello

# Kata - make a change, and rebuild

# Kata - configure using environment variables

    $ docker run -e GREETEE=Kitty hello

# Kata - push an image to the public registry

    $ docker build -t YOURNAMEHERE/hello ./hello

    $ docker push YOURNAMEHERE/hello

# Kata - run an image from the public registry

    $ docker run YOURNEIGHBOUR/hello

# Kata - build a more complex image

    $ docker build -t mysite ./mysite

    $ docker run -d -p 80:80 mysite
    $ docker ps

    $ curl http://localhost

    Browse to http://192.168.66.6

# Kata - here's one I prepared earlier

    $ docker run -p 80:80 woollyams/blob-store

    Browse to http://192.168.66.6
