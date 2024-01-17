export SCRIPT_DIR="$BATS_TEST_FILENAME"
export CONTAINER_NAME=trust-testing-ubuntu

function setup() {
  load 'common-setup'
  _common_setup

  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME ubuntu:latest "/bin/sh" "-c" "sleep 10000"
  docker cp -a ${SCRIPT_DIR}/../bin/curl-amd64 $CONTAINER_NAME:/usr/bin/curl
  
  # This is what actually sets the TLS trust store for this distribution
  docker exec -it $CONTAINER_NAME mkdir -p /etc/ssl/certs
  docker cp "$SCRIPT_DIR/../cert/root.crt" $CONTAINER_NAME:/etc/ssl/certs/ca-certificates.crt
  docker exec -it $CONTAINER_NAME chmod 0777 /etc/ssl/certs/ca-certificates.crt
}

@test "test_tls_ubuntu" {
  _check_tls
}

teardown() {
  _tear_down
}