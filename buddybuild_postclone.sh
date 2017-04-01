#!/usr/bin/env bash

echo "Installing Rome..."
make dependencies 

echo "Setting up AWS credentials"
mkdir -p "${HOME}/.aws" || true
cp "${BUDDYBUILD_SECURE_FILES}/aws-config" "${HOME}/.aws/config" || true
cp "${BUDDYBUILD_SECURE_FILES}/aws-credentials" "${HOME}/.aws/credentials" || true

rome list --platform ios

echo "Downloading dependencies from S3 using Rome..."
make bootstrap || true

#cp ${BUDDYBUILD_SECURE_FILES}/Config.xcconfig ${BUDDYBUILD_WORKSPACE}/Memoires/Config.xcconfig || true
