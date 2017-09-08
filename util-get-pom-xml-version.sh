#!/bin/bash

# USAGE: util-get-pom-xml-version.sh /foo/pom.xml

xmlstarlet sel -N my=http://maven.apache.org/POM/4.0.0 -t -m my:project -v my:version $1
