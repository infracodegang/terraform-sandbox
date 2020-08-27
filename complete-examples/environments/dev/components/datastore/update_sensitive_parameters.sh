#!/bin/bash

cd $(dirname "$0") || exit

read -p "Update DB endpoint [DB endpoint]: " DB_ENDPOINT
if [[ -n "${DB_ENDPOINT}" ]]; then
  aws ssm put-parameter --name '/db/endpoint' --value="${DB_ENDPOINT}" --type SecureString --overwrite
  echo "Updated DB endpoint!" 1>&2
fi

read -p "Update DB username [DB username]: " DB_USER
if [[ -n "${DB_USER}" ]]; then
  aws ssm put-parameter --name '/db/username' --value="${DB_USER}" --type SecureString --overwrite
  echo "Updated DB username!" 1>&2
fi

read -p "Update DB password [DB password]: " DB_PASSWORD
read -p "Update db-instance-identifier [db-instance-identifier]: " DB_IDENTIFIER
if [[ -n "${DB_PASSWORD}" && -n "${DB_IDENTIFIER}" ]]; then
  aws ssm put-parameter --name '/db/password' --value="${DB_PASSWORD}" --type SecureString --overwrite
  aws rds modify-db-instance --db-instance-identifier=${DB_IDENTIFIER} --master-user-password=${DB_PASSWORD}
  echo "Updated DB password!" 1>&2
fi

read -p "Update Elasticache primary endpoint [primary endpoint]: " PRIMARY_ENDPOINT
if [[ -n "${PRIMARY_ENDPOINT}" ]]; then
  aws ssm put-parameter --name '/elasticache/primaryendpoint' --value="${PRIMARY_ENDPOINT}" --type SecureString --overwrite
  echo "Updated Elasticache primary endpoint!" 1>&2
fi

read -p "Update Elasticache reader endpoint [reader endpoint]: " READER_ENDPOINT
if [[ -n "${READER_ENDPOINT}" ]]; then
  aws ssm put-parameter --name '/elasticache/readerendpoint' --value="${READER_ENDPOINT}" --type SecureString --overwrite
  echo "Updated Elasticache reader endpoint!" 1>&2
fi
