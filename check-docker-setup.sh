#! /bin/bash

yay() {
  echo -ne "\033[32mYAY: \033[0m"; echo "$1"
}

boo() {
  (echo -ne "\033[31mBOO: \033[0m"; echo "$1") >&2
  exit 1
}

docker_sock=/var/run/docker.sock
if test -n "$DOCKER_HOST"; then
  yay "\$DOCKER_HOST is set"
  docker_addr=$(echo $DOCKER_HOST | sed -e 's|tcp://\(.*\):[0-9]*|\1|')
elif test -e $docker_sock; then
  yay "$docker_sock exists"
  docker_addr=localhost
else
  boo "No \$DOCKER_HOST, no $docker_sock ... where's Docker?"
fi

if docker info > /dev/null; then
  yay "I can talk to docker"
else
  boo "I can't talk to docker"
fi

echo "Docker is at $docker_addr"

echo "Pulling some images to get you started ..."
docker pull alpine
docker pull busybox
docker pull centos
docker pull ubuntu
