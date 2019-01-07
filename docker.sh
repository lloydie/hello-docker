#!/usr/bin/env bash

Docker_Create_Dockerfile() {
    cat <<EOF > Dockerfile
FROM=
WORKDIR=
COPY=
RUN=
EXPOSE=
ENV=
CMD=
EOF
}

PKG_REPO='hello-py2'
PKG_TAG='latest'

docker-run() {
    docker run -p 4000:80 "$PKG_REPO/$PKG_NAME"
}

docker-build() {
    docker build --tag="$PKG_REPO/$PKG_NAME:$PKG_TAG" .
}


_docker-compose-create() {
_REPLICAS=
_LIMIT_CPU=
_LIMIT_MEM='50M'
_RESTART_CONDITION='on-failure'
_PORTS='4000:80'
_NETWORKS=webnet

    cat <<EOF > docker-compose.yml
version: "$PKG_VERSION"
services:
  web:
    image: $DOCKER_USER/$HUB_REPO:$PKG_VERSION
    deploy:
      replicas: $DOCKER_SWARM_REPLICAS
      resources:
        limits:
          cpus: "$_LIMIT_CPU"
          memory: $_LIMIT_MEM
      restart_policy:
        condition: $_RESTART_CONDITION
    ports:
      - "4000:80"
    networks:
      - webnet
networks:
  webnet:
EOF
}

docker-compose() {
    # create docker-compose.yml
    docker stack deploy -c docker-compose.yml $PKG_NAME
}

docker-swarm-leave() {
    docker stack rm $PKG_NAME
}

