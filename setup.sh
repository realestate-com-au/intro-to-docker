#! /bin/bash

yay() {
  echo -ne "\033[32mYAY: \033[0m"; echo "$1"
}

boo() {
  (echo -ne "\033[31mBOO: \033[0m"; echo "$1") >&2
  exit 1
}

umm() {
  (echo -ne "\033[33mUMM: \033[0m"; echo "$1") >&2
}

beat() {
  echo ""
}

docker_sock=/var/run/docker.sock
if test -n "$DOCKER_HOST"; then
  yay "\$DOCKER_HOST is set"
  docker_addr=$(echo $DOCKER_HOST | sed -e 's|tcp://\(.*\):[0-9]*|\1|')
  if test -e $docker_sock; then
    umm "$docker_sock exists, too - that's weird"
    echo "     Beware of confusion between Docker for Mac and docker-machine!"
  fi
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

beat

echo "Docker is at $docker_addr"

beat

version_of() {
  $1 --version | egrep -o '[0-9]+(\.[0-9]+)+'
}

version_lte() {
  [ "$1" = "`echo -e "$1\n$2" | docker run -i debian:stable sort -V | head -n1`" ]
}

check_version() {
  app=$1
  expected_version=$2
  actual_version=$(version_of $app)
  if version_lte $expected_version $actual_version; then
    yay "$app version $actual_version >= $expected_version"
  else
    boo "$app version $actual_version < $expected_version"
  fi
}

check_version docker 1.13.0
check_version docker-compose 1.13.0

beat

pull() {
  echo ""
  echo "=== $1"
  docker pull $1
}

echo "Pulling some images to get you started ..."
pull alpine
pull busybox
pull centos
pull debian
pull ubuntu
pull ubuntu:16.04
pull microsoft/dotnet:1.0-sdk
pull node:5.11.0-slim
pull node:6.2.2
pull postgres:9.6
pull python:2.7-alpine
pull ruby:2.3
pull ruby:2.4
pull ruby
pull realestate/ciao
pull realestate/ciao-proxy
