#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk use java 21.0.2-open 1>&2

# Not safe but some of SDKMAN, Maven or MVMW go to hell! I had all the certs installed in the normal way systemwide, but behind proxy nothing works but this
(cd src/java && mvn clean verify -Dmaven.wagon.http.ssl.allowall=true -Dmaven.resolver.transport=wagon -Dmaven.wagon.http.ssl.insecure=true)

(cd src/java && ./prepare_abeobk.sh)
(cd src/java && ./prepare_artsiomkorzun.sh)
(cd src/java && ./prepare_royvanrijn.sh)
