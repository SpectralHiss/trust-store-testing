export SCRIPT_DIR="$BATS_TEST_FILENAME"
export CONTAINER_NAME=trust-testing-rhel7
export IMAGE="registry.access.redhat.com/rhel7"
export VERSION="@sha256:908d15675d0daaed074abe1a8d1bf2bd185e1c1e3073230d0ced1f7073fffb42"


function update_trust_store(){
 # using the method from :https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-shared-system-certificates
  # This is what actually sets the TLS trust store for this distribution
  docker exec -it $CONTAINER_NAME mkdir -p /etc/pki/ca-trust/source/anchors
  docker cp "$SCRIPT_DIR/../cert/root.crt" $CONTAINER_NAME:/etc/pki/ca-trust/source/anchors
  docker exec -it $CONTAINER_NAME update-ca-trust
}

function setup() {
  load 'common-setup'
  _common_setup

  docker run -d --rm -i --network trust-store-testing --name $CONTAINER_NAME "${IMAGE}${VERSION}" "/bin/sh" "-c" "sleep 10000"
  docker cp -a ${SCRIPT_DIR}/../bin/curl-amd64 $CONTAINER_NAME:/usr/bin/curl
  update_trust_store
 
}

@test "test_tls_${IMAGE}_${VERSION}" {
  _check_tls
}

teardown() {
  _tear_down
}