# For details on some of these "prelude" settings, see:
# https://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-builtin-rules
SHELL := /usr/bin/env bash
.SHELLFLAGS := -uo pipefail -c
.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.SUFFIXES:

include make/website.mk 

BATS = test/bats test/test-helper/bats-assert test/test-helper/bats-support

$(BATS) &:
	git submodule update

test: cert/tls.crt $(BATS) run-target-server
	./test.sh

test-%:
	./test/bats/bin/bats $*.bats
	container-diff diff --type=file --json daemon://$*:pre-trust daemon://$*:post-trust > $*-trust-diff.json    

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
	