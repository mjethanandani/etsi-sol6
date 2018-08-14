#!/bin/bash

echo "Testing"

set -e

source /opt/confd/confdrc
cd src
confdc -c --fail-on-warnings -o /opt/confd/etc/confd/etsi-nfv-common.fxs etsi-nfv-common.yang
confdc -c --fail-on-warnings -o /opt/confd/etc/confd/etsi-nfv.fxs etsi-nfv.yang
confd
confd_load -l -m nfv.xml

