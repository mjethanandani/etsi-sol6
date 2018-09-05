FROM fredrikjanssonse/etsi-sol006-base-image

ADD example-data/* src/
ADD packages/sol6/src/yang/* src/
ADD run-test.sh /

CMD ["/run-test.sh"]
