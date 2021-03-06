# Include standard NCS build definitions and rules
include $(NCS_DIR)/src/ncs/build/include.ncs.mk

# Include setup makefile (autogenerated) for handling packages and netsims
include ./setup.mk

.PHONY: all start stop clean db-clean

all: packages netsim etsi-nfv-tree.txt etsi-nfv-tree.html etsi-nfv-swagger.json
	if [ ! -d ncs-cdb ]; then mkdir ncs-cdb; fi
	if [ ! -d init_data ]; then mkdir init_data; fi
	cp init_data/* ncs-cdb/. > /dev/null 2>&1 || true

start: stop netsim-start
	ncs

stop: netsim-stop
	ncs --stop || true

clean: packages-clean netsim-clean db-clean
	rm -rf logs/* lux_logs
	rm -rf .bundle
	rm -rf etsi-nfv-tree.* nfv-swagger.json

db-clean:
	rm -rf state/* ncs-cdb/*

# Handy CLI targets
.PHONY: cli cli-c cli-j

cli: cli-c

cli-c:
	ncs_cli -u admin -C

cli-j:
	ncs_cli -u admin


###
### HERE FOLLOWS SOME HANDY GIT TARGETS WHEN WORKING WITH REMOTE REPOS
###
.PHONY: gstat glog
gstat:
	@for i in `grep GIT_PACKAGES .build-meta 2> /dev/null | cut -d= -f2`; \
	  do \
	    echo ""; \
	    echo "--- $$i ---"; \
	    (cd "packages/$$i"; \
	    git status -uno --ignore-submodules;); \
	  done

# Set N=<n> on the command line for more log output.
N = 1
glog:
	@for i in `grep GIT_PACKAGES .build-meta 2> /dev/null | cut -d= -f2`; \
	  do \
	    echo ""; \
	    echo "--- $$i ---"; \
	    (cd "packages/$$i"; \
	     git --no-pager log -n "$(N)";); \
	    echo ""; \
	  done

container-test:
	docker build -t etsi-test .
	docker run --rm -it etsi-test

etsi-nfv-swagger.json: packages/sol6/src/yang/*.yang
	yanger -f swagger -o $@ -p packages/sol6/src/yang packages/sol6/src/yang/etsi-nfv.yang

etsi-nfv-tree.txt: packages/sol6/src/yang/*.yang
	pyang -f tree -o $@ -p packages/sol6/src/yang packages/sol6/src/yang/etsi-nfv.yang

etsi-nfv-tree.html: packages/sol6/src/yang/*.yang
	pyang -f jstree -o $@ -p packages/sol6/src/yang packages/sol6/src/yang/etsi-nfv.yang
