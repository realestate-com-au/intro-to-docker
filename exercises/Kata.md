# Kata - run a command

    vagrant$ docker run ubuntu dpkg -l
    vagrant$ docker run centos rpm -qa

# Kata - how much overhead?

    Use "time" to measure the overhead of running a command in a container.

    vagrant$ time docker run centos sh -c "time rpm -qa"

# Kata - run a shell

    vagrant$ docker run -i -t ubuntu bash

# Kata - show Docker containers

    vagrant$ docker ps
    vagrant$ docker ps -a

# Kata - install some software

    vagrant$ docker run -i -t ubuntu bash

    root@container# curl http://example.com

    root@container# apt-get update
    root@container# apt-get install -y curl

    root@container# curl http://example.com

# Kata - manually snapshot an image

    vagrant$ last_container=`docker ps -a -q -n 1`
    vagrant$ docker commit $last_container curly-ubuntu

    vagrant$ docker run -i -t curly-ubuntu curl http://example.com

# Kata - show Docker images

    vagrant$ docker images
    vagrant$ docker history curly-ubuntu

# Kata - build an image using a Dockerfile

    vagrant$ docker build -t hello /vagrant/hello

    vagrant$ docker run hello /app/run
    vagrant$ docker run hello

# Kata - make a change, and rebuild

# Kata - configure using environment variables

    vagrant$ docker run -e GREETEE=Kitty hello

# Kata - push an image to the public registry

    vagrant$ docker build -t YOURNAMEHERE/hello /vagrant/hello

    vagrant$ docker push YOURNAMEHERE/hello

# Kata - run an image from the public registry

    vagrant$ docker run YOURNEIGHBOUR/hello

# Kata - build a more complex image

    vagrant$ docker build -t mysite /vagrant/mysite

    vagrant$ docker run -d -p 80:80 mysite
    vagrant$ docker ps

    vagrant$ curl http://localhost

    Browse to http://192.168.66.6

# Kata - here's one I prepared earlier

    vagrant$ docker run -p 80:80 woollyams/blob-store

    Browse to http://192.168.66.6

