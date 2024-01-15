#!/bin/bash -x

export SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
export CONTAINER_NAME=trust-testing-ubuntu

function setup() {
  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME ubuntu:latest "/bin/sh" "-c" "sleep 10000"
  docker cp -a ${SCRIPT_DIR}/../../bin/curl-amd64 $CONTAINER_NAME:/usr/bin/curl
}

function trust_cert() {
  CERT_ABS_PATH=$1
  docker exec -it $CONTAINER_NAME mkdir -p /etc/ssl/certs
  docker cp $CERT_ABS_PATH $CONTAINER_NAME:/etc/ssl/certs/ca-certificates.crt
  docker exec -it $CONTAINER_NAME chmod 0777 /etc/ssl/certs/ca-certificates.crt
}

function test_ssl() {
  docker exec -it $CONTAINER_NAME curl -f https://self-signed-server
  if ! [ $? -eq 0 ]; then
    echo "Failed!"
  fi
}


setup
trust_cert $SCRIPT_DIR/../..//cert/root.crt

test_ssl