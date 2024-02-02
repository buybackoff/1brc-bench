#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk use java 21.0.2-open 1>&2

# Not safe but some of SDKMAN, Maven or MVMW go to hell! I had all the certs installed in the normal way systemwide, but behind proxy nothing works but this
(cd src/java && mvn clean verify -Dmaven.wagon.http.ssl.allowall=true -Dmaven.resolver.transport=wagon -Dmaven.wagon.http.ssl.insecure=true)

(cd src/java && ./prepare_abeobk.sh)
(cd src/java && ./prepare_artsiomkorzun.sh)
(cd src/java && ./prepare_jerrinot.sh)
(cd src/java && ./prepare_mtopolnik.sh)
(cd src/java && ./prepare_royvanrijn.sh)
(cd src/java && mv -f prepare_serkan-ozal.sh prepare_serkan_ozal.sh 2>/dev/null; true && sed -i 's/21\.0\.1-open/21.0.2-open/g' prepare_serkan_ozal.sh && ./prepare_serkan_ozal.sh >/dev/null)
(cd src/java && ./prepare_stephenvonworley.sh)
(cd src/java && ./prepare_thomaswue.sh)

