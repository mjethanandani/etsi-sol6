all: fxs
.PHONY: all

# Include standard NCS examples build definitions and rules
include $(NCS_DIR)/src/ncs/build/include.ncs.mk

SRC  = $(wildcard yang/*.yang)
DIRS = ../load-dir
FXS = $(DIRS)/etsi-nfv.fxs

$(DIRS)/etsi-nfv.fxs: yang/etsi-nfv-common.yang yang/etsi-nfv-vnf.yang  yang/etsi-nfv-pnf.yang yang/etsi-nfv-ns.yang

YANGPATH += yang

NCSCPATH   = $(YANGPATH:%=--yangpath %)
YANGERPATH = $(YANGPATH:%=--path %)

fxs: $(DIRS) $(FXS)
.PHONY: fxs

$(DIRS):
	mkdir -p $@

../load-dir/%.fxs: yang/%.yang
	# $(NCSC) $(NCSCPATH) -c --fail-on-warnings --strict-yang `ls yang/$*-ann.yang  > /dev/null 2>&1 && echo "-a yang/$*-ann.yang"` -o $@ $<
	$(NCSC) $(NCSCPATH) -c -o $@ $<
clean:
	rm -rf $(DIRS)
.PHONY: clean
