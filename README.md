# Build
ncs-project update -v -y
make all start

# Load example data
```
ncs_cli -u admin
configure
load merge example-data/nfv.xml
commit
```
