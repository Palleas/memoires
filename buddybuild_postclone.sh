#!/usr/bin/env bash

echo "Installing Rome..."
brew install blender/homebrew-tap/rome

echo "Setting up AWS credentials"
mkdir -p "${HOME}/.aws" || true
cp "${BUDDYBUILD_SECURE_FILES}/aws-config" "${HOME}/.aws/config"
cp "${BUDDYBUILD_SECURE_FILES}/aws-credentials" "${HOME}/.aws/credentials"

echo "Downloading dependencies from S3 using Rome..."
make deps

#cp ${BUDDYBUILD_SECURE_FILES}/Config.xcconfig ${BUDDYBUILD_WORKSPACE}/Memoires/Config.xcconfig || true
