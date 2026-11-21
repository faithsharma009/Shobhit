#!/usr/bin/env bash
# Builds the web files, creates the Android project and applies Faith Personal's icons, splash and colours.
set -euo pipefail
cd "$(dirname "$0")/.."
npm run build:web
[ -d android ] || npx cap add android
npx cap sync android
RES=android/app/src/main/res
cp -r native/res/. "$RES/"
find "$RES" -name splash.png -exec cp native/splash.png {} \;
sed -i 's/#FFFFFF/#0b0716/' "$RES/values/ic_launcher_background.xml"
# Each build gets a higher version number so the APK installs over the old one (data is kept).
VC="${VERSION_CODE:-1}"
sed -i -E "s/versionCode [0-9]+/versionCode $VC/; s/versionName \"[^\"]+\"/versionName \"1.0.$VC\"/" android/app/build.gradle
# Same signing key every build, so updates install without uninstalling.
mkdir -p "$HOME/.android"
cp native/keystore/debug.keystore "$HOME/.android/debug.keystore"
