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

DOCKER_HUB_USER=lloydie
PKG_REPO='hello-docker'
PKG_TAG='latest'

Docker-run() {
    docker run -p 4000:80 "$DOCKER_HUB_USER/$PKG_REPO:$PKG_TAG"
}

Docker-build() {
    docker build --tag="$DOCKER_HUB_USER/$PKG_REPO:$PKG_TAG" .
}

Docker-publish() {
    docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASS
    docker push $PKG_REPO:$PKG_TAG
    docker logout
}

Docker-compose-create() {
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
    image: $DOCKER_HUB_USER/$PKG_REPO:$PKG_VERSION
    deploy:
      replicas: $_REPLICAS
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

Docker-compose() {
    # create docker-compose.yml
    docker stack deploy -c docker-compose.yml $PKG_NAME
}

Docker-swarm-leave() {
    docker stack rm $PKG_NAME
}

