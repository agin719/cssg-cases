#!/bin/sh

cssg build
cd project
./gradlew app:connectedDebugAndroidTest -i
