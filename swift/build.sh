#!/bin/sh

cssg compile
pod repo update
pod update --no-repo-update

xcodebuild \
  -workspace COS_Swift_Test.xcworkspace \
  -scheme COS_Swift_Test \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.1' \
  test
