#!/bin/bash

xcodebuild clean build-for-testing \
    -workspace FOSSAsia.xcworkspace \
    -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.2' \
    -scheme FOSSAsia | xcpretty -c && exit ${PIPESTATUS[0]}
