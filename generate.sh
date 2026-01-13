#!/bin/sh
#
rm -rf .tmp/ || true

TAG_VERSION="4.0.0-alpha.18"
VLC_URL="https://download.videolan.org/cocoapods/unstable/VLCKit-4.0.0a18-844dff57e-c833c4be0.tar.xz"

mkdir .tmp/

#Download and extract VLCKit
wget -O .tmp/VLCKit.tar.xz $VLC_URL
tar -xf .tmp/VLCKit.tar.xz -C .tmp/

# The new location of the xcframework
XCFRAMEWORK_LOCATION=".tmp/VLCKit-binary/VLCKit.xcframework"

# Zip the xcframework
ditto -c -k --sequesterRsrc --keepParent "$XCFRAMEWORK_LOCATION" ".tmp/VLCKit-all.xcframework.zip"

#Update package file
PACKAGE_HASH=$(sha256sum ".tmp/VLCKit-all.xcframework.zip" | awk '{ print $1 }')
PACKAGE_STRING="Target.binaryTarget(name: \"VLCKit-all\", url: \"https:\/\/github.com\/nusability\/vlckit-spm-4alpha\/releases\/download\/$TAG_VERSION\/VLCKit-all.xcframework.zip\", checksum: \"$PACKAGE_HASH\")"
echo "Changing package definition for xcframework with hash $PACKAGE_HASH"
sed -i '' -e "s/let vlcBinary.*/let vlcBinary = $PACKAGE_STRING/" Package.swift

cp -f .tmp/VLCKit-binary/COPYING.txt ./LICENSE
