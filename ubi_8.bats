export SCRIPT_DIR="$BATS_TEST_FILENAME"
export CONTAINER_NAME=trust-testing-ubi8
export IMAGE="registry.access.redhat.com/ubi8/ubi"
export VERSION="@sha256:e5d89fb9c9b6592d0d5e576c53021598cde831b20213207ecd896049c4b21c08"


function update_trust_store(){
  
 # using the method from :https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-shared-system-certificates
  # This is what actually sets the TLS trust store for this distribution
  docker exec -it $CONTAINER_NAME mkdir -p /etc/pki/ca-trust/source/anchors
  docker cp "$SCRIPT_DIR/../cert/root.crt" $CONTAINER_NAME:/etc/pki/ca-trust/source/anchors
  docker commit -m "Image before nginx cert added to trust store" $CONTAINER_NAME ubi8:pre-trust
  docker exec -it $CONTAINER_NAME update-ca-trust
  docker commit -m "Image after nginx cert added to trust store" $CONTAINER_NAME ubi8:post-trust
}

function setup() {
  load 'common-setup'
  _common_setup

  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME "${IMAGE}${VERSION}" "/bin/sh" "-c" "sleep 10000"
  docker exec "${CONTAINER_NAME}" yum update && yum install curl -y 
  update_trust_store
}

@test "test_tls_${IMAGE}_${VERSION}" {
  #sleep 10000
  _check_tls
}

teardown() {
  _tear_down
}