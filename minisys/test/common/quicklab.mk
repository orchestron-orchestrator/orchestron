SYSNAME=mini
build-otron-image:
	docker build -t $(SYSNAME)-otron-base -f ../common/Dockerfile.otron .

.PHONY: start
start: build-otron-image
	$(CLAB_BIN) deploy --topo $(TESTENV:$(SYSNAME)-%=%).clab.yml --log-level debug --reconfigure

.PHONY: stop
stop:
	$(CLAB_BIN) destroy --topo $(TESTENV:$(SYSNAME)-%=%).clab.yml --log-level debug

.PHONY: wait $(addprefix wait-,$(ROUTERS_XR))
WAIT?=60
wait: $(addprefix platform-wait-,$(ROUTERS_XR))

.PHONY: copy
copy:
	docker cp ../../out/bin/$(SYSNAME) $(TESTENV)-otron:/$(SYSNAME)
	docker cp netinfra.xml $(TESTENV)-otron:/netinfra.xml

ifndef CI
INTERACTIVE=-it
endif

.PHONY: run
run: copy
	docker exec $(INTERACTIVE) $(TESTENV)-otron /$(SYSNAME) --rts-bt-dbg

.PHONY: run-and-configure
run-and-configure: copy
	docker exec $(INTERACTIVE) -e EXIT_ON_DONE=$(CI) $(TESTENV)-otron /$(SYSNAME) netinfra.xml --rts-bt-dbg

.PHONY: configure
configure:
	$(MAKE) FILE="netinfra.xml" send-config

.PHONY: shell
shell:
	docker exec -it $(TESTENV)-otron bash -l

.PHONY: send-config-async
send-config-async:
	curl -X PUT -H "Content-Type: application/yang-data+xml" -H "Async: true" -d @$(FILE) http://localhost:$(shell docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $(TESTENV)-otron)/restconf

.PHONY: send-config-wait
send-config-wait:
	curl -X PUT -H "Content-Type: application/yang-data+xml" -d @$(FILE) http://localhost:$(shell docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $(TESTENV)-otron)/restconf

.PHONY: get-config0 get-config1 get-config2
get-config0 get-config1 get-config2:
	curl -H "Accept: application/yang-data+xml" http://localhost:$(shell docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $(TESTENV)-otron)/layer/$(subst get-config,,$@)

.PHONY: get-config-adata0 get-config-adata1 get-config-adata2
get-config-adata0 get-config-adata1 get-config-adata2:
	@curl -H "Accept: application/yang-data+acton-adata" http://localhost:$(shell docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $(TESTENV)-otron)/layer/$(subst get-config-adata,,$@)

.PHONY: delete-foo2
delete-foo2:
	curl -X DELETE http://localhost:$(shell docker inspect -f '{{(index (index .NetworkSettings.Ports "80/tcp") 0).HostPort}}' $(TESTENV)-otron)/restconf/netinfra:netinfra/foo=rtr1,4.5.6.7
