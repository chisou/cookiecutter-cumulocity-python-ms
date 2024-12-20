#!/bin/bash
# Copyright (c) 2024 Cumulocity GmbH

NAME="$1"
VERSION="$2"
ISOLATION="$3"
IMG_NAME=`echo "$NAME" | tr '[:upper:]' '[:lower:]' | tr '[:punct:]' '-'`

BUILD_DIR="./build"
DIST_DIR="./dist"
TARGET="$DIST_DIR/$IMG_NAME.zip"

echo "Name: $NAME, Image Name: $IMG_NAME, Version: $VERSION"
echo "Build directory: $BUILD_DIR"
echo "Dist directory:  $DIST_DIR"
echo "Target location: $TARGET"
echo ""

if ! [[ -d "src" ]]; then
  echo "This script must be run from the project base directory."
  exit 2
fi

# prepare directories
[[ -d "$BUILD_DIR" ]] && rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
[[ -d "$DIST_DIR" ]] && rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR"

# copy & render sources
cp ./requirements.txt "$BUILD_DIR"
cp -r src/main "$BUILD_DIR"
sed -e "s/{VERSION}/$VERSION/g" ./src/cumulocity.json > "$BUILD_DIR/cumulocity.json"
sed -e "s/{ISOLATION}/$ISOLATION/g" ./src/cumulocity.json > "$BUILD_DIR/cumulocity.json"
sed -e "s/{SAMPLE}/$NAME/g" ./src/Dockerfile > "$BUILD_DIR/Dockerfile"

# build image
echo "Building image ..."
docker build -t "$NAME" "$BUILD_DIR"
docker save -o "$DIST_DIR/image.tar" "$NAME"
zip -j "$DIST_DIR/$IMG_NAME.zip" "$BUILD_DIR/cumulocity.json" "$DIST_DIR/image.tar"

echo ""
echo "Created uploadable archive: $TARGET"