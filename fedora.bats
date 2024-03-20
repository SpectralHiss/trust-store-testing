export SCRIPT_DIR="$BATS_TEST_FILENAME"
export CONTAINER_NAME=trust-testing-fedora
export IMAGE=fedora
export VERSION=:latest

function update_trust_store(){
  
  # This is what actually sets the TLS trust store for this distribution
  docker exec -it $CONTAINER_NAME mkdir -p /etc/pki/ca-trust/source/anchors/
  docker cp "$SCRIPT_DIR/../cert/root.crt" $CONTAINER_NAME:/etc/pki/ca-trust/source/anchors/
  docker exec -it $CONTAINER_NAME update-ca-trust
}

function setup() {
  load 'common-setup'
  _common_setup

  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME ${IMAGE}${VERSION} "/bin/sh" "-c" "sleep 10000"
  docker exec "${CONTAINER_NAME}" yum update && yum install curl -y 
  update_trust_store
}

@test "test_tls_fedora" {
  _check_tls
}

teardown() {
  _tear_down
}