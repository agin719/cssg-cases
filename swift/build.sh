#!/bin/sh

cssg compile
pod install

xcodebuild \
  -workspace COS_Swift_Test.xcworkspace \
  -scheme COS_Swift_Test \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.2.2' \
  test
