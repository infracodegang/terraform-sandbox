#!/bin/bash

cd $(dirname "$0") || exit

read -p "Remote State Bucket [unique bucket name]: " BUCKET_NAME
if [[ -z "${BUCKET_NAME}" ]]; then
  echo "Bucket name must not be empty!" 1>&2
  exit 1
fi

REGION="ap-northeast-1"

## Create a remote-state bucket
read -p "create-bucket? [y/N]: " yn
case "${yn}" in
  [yY]*) aws s3api create-bucket --bucket "${BUCKET_NAME}" --create-bucket-configuration LocationConstraint="${REGION}" ;;
  *) ;;
esac

## Versioning
read -p "put-bucket-versioning? [y/N]: " yn
case "${yn}" in
  [yY]*) aws s3api put-bucket-versioning --bucket "${BUCKET_NAME}" --versioning-configuration Status=Enabled ;;
  *) ;;
esac

## Encryption
read -p "put-bucket-encryption? [y/N]: " yn
case "${yn}" in
  [yY]*) aws s3api put-bucket-encryption --bucket "${BUCKET_NAME}" --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
  ;;
  *) ;;
esac

## Deny public acccess
read -p "deny-public-access? [y/N]: " yn
case "${yn}" in
  [yY]*) aws s3api put-public-access-block --bucket "${BUCKET_NAME}" --public-access-block-configuration '{"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":true,"RestrictPublicBuckets":true}'
  ;;
  *) ;;
esac
  