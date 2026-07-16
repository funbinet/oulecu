#!/bin/bash
set -e

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

# Wait for APK to exist if it doesn't already
echo "Waiting for APK to be built..."
while [ ! -f "$APK_PATH" ]; do
  sleep 2
done
echo "APK found!"

BODY=$(cat release_notes.md)

# GitHub Release
echo "Creating GitHub Release..."
GH_RESPONSE=$(curl -s -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GH_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/funbinet/oulecu/releases \
  -d "{\"tag_name\":\"v2.6.0\",\"name\":\"Version 2.6.0\",\"body\":$(jq -Rs . < release_notes.md),\"draft\":false,\"prerelease\":false}")

UPLOAD_URL=$(echo $GH_RESPONSE | jq -r '.upload_url' | sed -e "s/{?name,label}//")

if [ "$UPLOAD_URL" != "null" ] && [ -n "$UPLOAD_URL" ]; then
  echo "Uploading APK to GitHub..."
  curl -s -L \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GH_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/vnd.android.package-archive" \
    --data-binary @"$APK_PATH" \
    "$UPLOAD_URL?name=oulecu-v2.6.0-arm64.apk" > /dev/null
  echo "GitHub Release created and APK uploaded."
else
  echo "Failed to create GitHub release. Response: $GH_RESPONSE"
fi

# Codeberg Release
echo "Creating Codeberg Release..."
CB_RESPONSE=$(curl -s -X POST "https://codeberg.org/api/v1/repos/funbinet/oulecu/releases" \
  -H "accept: application/json" \
  -H "Authorization: token $CB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"tag_name\":\"v2.6.0\",\"name\":\"Version 2.6.0\",\"body\":$(jq -Rs . < release_notes.md),\"draft\":false,\"prerelease\":false}")

RELEASE_ID=$(echo $CB_RESPONSE | jq -r '.id')

if [ "$RELEASE_ID" != "null" ] && [ -n "$RELEASE_ID" ]; then
  echo "Uploading APK to Codeberg..."
  curl -s -X POST "https://codeberg.org/api/v1/repos/funbinet/oulecu/releases/$RELEASE_ID/assets" \
    -H "accept: application/json" \
    -H "Authorization: token $CB_TOKEN" \
    -F "attachment=@$APK_PATH" > /dev/null
  echo "Codeberg Release created and APK uploaded."
else
  echo "Failed to create Codeberg release. Response: $CB_RESPONSE"
fi

