export SCRIPT_DIR="$BATS_TEST_FILENAME"
export CONTAINER_NAME=trust-testing-ubuntu
export IMAGE="ubuntu"
export VERSION=":latest"


function update_trust_store(){
 # using the method from : https://ubuntu.com/server/docs/security-trust-store
  # This is what actually sets the TLS trust store for this distribution

  docker exec -it $CONTAINER_NAME apt update -y
  docker exec -it $CONTAINER_NAME apt install -y ca-certificates
  docker exec -it $CONTAINER_NAME mkdir -p /usr/local/share/ca-certificates
  docker cp "$SCRIPT_DIR/../cert/root.crt" $CONTAINER_NAME:/usr/local/share/ca-certificates/
  docker commit -m "Image before nginx cert added to trust store" $CONTAINER_NAME ubuntu:pre-trust
  docker exec -it $CONTAINER_NAME update-ca-certificates
  docker commit -m "Image after nginx cert added to trust store" $CONTAINER_NAME ubuntu:post-trust
}

function setup() {
  load 'common-setup'
  _common_setup

  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME "${IMAGE}${VERSION}" "/bin/sh" "-c" "sleep 10000"
  docker exec "${CONTAINER_NAME}" sh -c "apt update -y -q &&  apt install curl -y -q"
  update_trust_store
 
}

@test "test_tls_${IMAGE}_${VERSION}" {
  _check_tls
}

teardown() {
  _tear_down
}