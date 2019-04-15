#### CONTAINER BASICS

Current running containers
  ```
  docker ps
  ```

Current containers
  ```
  docker ps -a
  ```

List container ids only
  ```
  docker ps -aq
  ```

Stopping a container
  ```
  docker stop <container>
  ```

Stop running containers using their ids
  ```
  docker stop $(docker ps -aq)
  ```

Re-starting a container
  ```
  docker start <container>
  ```

Remove the containers once stopped
  ```
  docker rm <container>
  ```
Force remove a container (stops and removes the container, it can be dangerous if there are unsaved changes)

  ```
  docker rm -f <container>
  ```

Remove unused containers (that have been stopped)
  ```
  docker container prune
  ```

Create a container using an image
  ```
  docker run --rm -it --name bharg realestate/ciao bash
  ```

Run in daemon mode
  ```
  docker run -d --name bharg realestate/ciao
  ```

Changing something in the container
  ```
  docker exec -it bharg bash
  cd ~
  echo persistence! > my_file.txt
  ```

#### PORTS

Current ports occupied
  ```
  docker ps --> PORTS
  docker port <container>
  ```

Publishing a specific port
  ```
  docker run -d --name expose -p 1234:80 realestate/ciao
  curl localhost:1234 --> Ciao Mondo!
  ```

Publishing a random port
  ```
  docker run -d --name random -p 80 realestate/ciao
  curl $(docker port random 80)
  ```

#### NETWORKS

Our containers
  ```
  docker run -d --name proxy realestate/ciao-proxy --> reverse proxy
  docker run -d --name bharg_app realestate/ciao --> the app
  ```

Check our current networks
  ```
  docker network ls
  ```

Create a network
  ```
  docker network create shared
  ```

Run containers in the network, expose a port
  ```
  docker run -d --name app --network=shared realestate/ciao
  docker run -d --name proxy --network=shared -p 5678:80 realestate/ciao
  ```

Check we can access the app
  ```
  curl localhost:5678
  ```

Check containers are running
  ```
  docker container ls
  ```

Check the containers are in the correct network
  ```
  docker network inspect shared
  ```

Remove the network
  ```
  docker network rm -f shared
  docker network prune
  ```

#### VOLUMES

Mounting a volume
  ```
  set MY_PATH=~/Documents
  docker run -it --name bind_mount -v $MY_PATH:/notes ubuntu bash
  mount | grep notes --> mount looks for any filesystems that have been recently mounted
  ```

Persistence in a volume
  ```
  cd /notes; ls
  echo I mounted a dir! > mount-in-docker
  docker stop <container>
  docker start <container>
  ```

Creating a named volume
  ```
  docker run -it --rm -v my-cache:/cache ubuntu bash
  echo TESTING > /cache/test
  ```

Checking volume exists
  ```
  docker volume ls
  ```

Checking the /cache exists
  ```
  docker run -it --rm -v my-cache:/cache ubuntu bash
  ls /cache
  ```

Removing the volume
  ```
  docker volume rm my-cache
  ```

Creating an anonymous volume with read-only rights (more secure)
  ```
  docker run -it --rm --read-only -v /more_space ubuntu bash
  ```

Sharing a volume
  Setting up the provider
  ```
  docker run -it --rm --name provider -v data:/publish ubuntu
  echo not here > /publish/wheres-the-money
  ```

  Setting up the consumer (consume the volume)
  ```
  docker run -it --rm --name consumer -v data:/extract ubuntu
  ```
  Find the volume
  ```
  cat /extract/wheres-the-money
  ```

#### LOGS

Getting logs for a container
  ```
  docker logs <container>
  ```

Displaying timestamp and detailed log
  ```
  docker logs --detail -t <container>
  ```

Real time output
  ```
  docker logs --follow --timestamps <container>
  ```

#### ENV VARS

Processing an env variable 
  ```
  docker run -d —name Bharg -p 1234:80 -e MESSAGE='Works for me'
  ```

Check you get the new greeting
  ```
  curl localhost:1234
  ```
