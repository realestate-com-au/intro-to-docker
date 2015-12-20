#! /bin/bash

yay() {
  echo -ne "\033[32mYAY: \033[0m"; echo "$1"
}

boo() {
  (echo -ne "\033[31mBOO: \033[0m"; echo "$1") >&2
  exit 1
}

check_docker_host() {
  if test -n "$DOCKER_HOST"; then
    yay "\$DOCKER_HOST is set"
  else
    boo "\$DOCKER_HOST is NOT set"
  fi
}

check_docker_sock() {
  docker_sock=/var/run/docker.sock
  if test -e $docker_sock; then
    yay "$docker_sock exists"
  else
    boo "$docker_sock does NOT exist"
  fi
}

check_docker_connectivity() {
  if docker info > /dev/null; then
    yay "I can talk to docker"
  else
    boo "I can't talk to docker"
  fi
}

check_docker_ip() {
  expected_value=$1
  if test "$DOCKER_IP" = "$expected_value"; then
    yay "\$DOCKER_IP is set correctly"
  else
    boo "\$DOCKER_IP is wrong; please export DOCKER_IP=$expected_value"
  fi
}

check_darwin_setup() {
  check_docker_host
  check_docker_connectivity
  check_docker_ip $(echo $DOCKER_HOST | sed -e 's|tcp://\(.*\):[0-9]*|\1|')
}

check_linux_setup() {
  check_docker_sock
  check_docker_connectivity
}

case "`uname`" in
  Darwin)
    check_darwin_setup
    ;;
  Linux)
    check_linux_setup
    ;;
  *)
    boo "Oh dear, what ARE you running?"
    ;;
esac
