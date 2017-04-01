#!/usr/bin/env bash

echo "Installing Rome..."
make dependencies 

echo "Setting up AWS credentials"
mkdir -p "${HOME}/.aws"
cp "${BUDDYBUILD_SECURE_FILES}/aws-config" "${HOME}/.aws/config"
cp "${BUDDYBUILD_SECURE_FILES}/aws-credentials" "${HOME}/.aws/credentials"

rome list --platform ios

echo "Downloading dependencies from S3 using Rome..."
make bootstrap
