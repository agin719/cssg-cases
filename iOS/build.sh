#!/bin/sh

cssg compile
pod install

xcodebuild \
  -workspace COS_iOS_Test.xcworkspace \
  -scheme COS_iOS_Test \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 11 Pro,OS=13.1' \
  test