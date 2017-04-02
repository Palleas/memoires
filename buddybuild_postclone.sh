#!/usr/bin/env bash

echo "Installing Rome..."
make dependencies > /dev/null 2>&1

echo "Setting up AWS credentials"
mkdir -p "${HOME}/.aws"
cp "${BUDDYBUILD_SECURE_FILES}/aws-config" "${HOME}/.aws/config"
cp "${BUDDYBUILD_SECURE_FILES}/aws-credentials" "${HOME}/.aws/credentials"

echo "Downloading dependencies from S3 using Rome..."
time make bootstrap rebuild-assets
