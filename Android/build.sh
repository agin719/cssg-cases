#!/bin/sh

cssg compile
cd project
./gradlew app:connectedDebugAndroidTest -i
