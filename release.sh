#!/usr/bin/env bash

RELEASE_LEVEL=$1
tag=$(clj -Arelease $RELEASE_LEVEL)

if [ $? -eq 0 ]; then
    echo "Successfully release \"keycloak-clojure\" tag $tag"
else
    echo "Fail to release \"keycloak-clojure\"!"
    exit 1
fi

if [[ $tag =~ v(.+) ]]; then
    newversion=${BASH_REMATCH[1]}
else
    echo "unable to parse tag $tag"
fi
mvn versions:set -DnewVersion=$newversion  2>&1 > /dev/null

if [ $? -eq 0 ]; then
    echo "Successfully set new version of \"keycloak-clojure\"'s pom to $nreversion"
else
    echo "Fail to set new version of \"keycloak-clojure\"'s pom!"
    exit 1
fi

mvn deploy  2>&1 > /dev/null
if [ $? -eq 0 ]; then
    echo "Successfully deploy \"keycloak-clojure\" version $newversion to clojars"
else
    echo "Fail to deploy \"keycloak-clojure\" to clojars!"
    exit 1
fi
