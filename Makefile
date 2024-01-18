BATS = test/bats test/test-helper/bats-assert test/test-helper/bats-support

$(BATS) &:
	git submodule update

test: cert/tls.crt $(BATS) run-target-server
	./test.sh

.PHONY: run-target-server
run-target-server: cert/tls.crt
	@-docker network create trust-store-testing
	@-docker build -t self-signed-server .
	@-docker run --network trust-store-testing --name self-signed-server self-signed-server &

validate-server:
	docker run -it --network trust-store-testing curlimages/curl -k -f https://self-signed-server

.PHONY: clean
clean: stop-target-server
	-docker rm -f $$(docker ps -a | grep 'trust-testing-' | awk '{print $$1}')
	-rm cert/*.key cert/*.crt

.PHONY: stop-target-server
stop-target-server:
	@-docker stop self-signed-server
	@-docker rm self-signed-server


cert/root.crt:
	openssl req  -nodes -new -x509  -keyout ./cert/root.key -out ./cert/root.crt \
    -subj "/C=US/ST=State/L=City/O=company/OU=Com/CN=CA"
	
cert/tls.crt: cert/root.crt
	openssl req  -nodes -new -x509 -CA ./cert/root.crt -CAkey ./cert/root.key  -keyout ./cert/tls.key -out ./cert/tls.crt \
    -subj "/C=US/ST=State/L=City/O=company/OU=Com/CN=self-signed-server"
	

