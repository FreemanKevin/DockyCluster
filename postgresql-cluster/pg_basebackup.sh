#!/bin/bash

set -x
PGUSER=repmgr
PGPASSWORD=repmgrpassword
BASE_BACKUP_DIR=/bitnami/postgresql/data/backup
DATE_DIR=$(date +%Y%m%d)
REPMGR_NAME=pgw-0
REPMGR_CONF=/opt/bitnami/repmgr/conf/repmgr.conf
LOG_DIR=/data/postgresql_backup
LOG_FILE="${LOG_DIR}/${DATE_DIR}_backup.log"

mkdir -p "${LOG_DIR}"

BACKUP_DIR="${BASE_BACKUP_DIR}/${DATE_DIR}"

CLUSTER_STATUS=$(docker-compose exec ${REPMGR_NAME} /opt/bitnami/scripts/postgresql-repmgr/entrypoint.sh repmgr -f "${REPMGR_CONF}" cluster show 2>&1)
echo "$CLUSTER_STATUS" | tee -a "${LOG_FILE}"

PRIMARY_NODE=$(echo "$CLUSTER_STATUS" | grep -m 1 'primary' | awk '{print $3}')

if [ -z "$PRIMARY_NODE" ]; then
  echo "Unable to find the primary node in the cluster." | tee -a "${LOG_FILE}"
  exit 1
fi

mkdir -p "${BACKUP_DIR}"

export PGPASSWORD

docker-compose exec -e PGPASSWORD="${PGPASSWORD}" "${PRIMARY_NODE}" \
pg_basebackup -h localhost -p 5432 -U "${PGUSER}" -D "${BACKUP_DIR}" -Fp -X stream -P >> "${LOG_FILE}" 2>&1

if [ $? -eq 0 ]; then
  echo "Backup was successful on the primary node (${PRIMARY_NODE})." | tee -a "${LOG_FILE}"
else
  echo "Backup failed on the primary node (${PRIMARY_NODE})." | tee -a "${LOG_FILE}"
  exit 1
fi

unset PGPASSWORD

set +x