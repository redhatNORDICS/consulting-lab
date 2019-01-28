#!/bin/bash

source /etc/sysconfig/repoconfig

#subscription-manager register --username="$ARC_USR" --password="$ARC_PWD"
#subscription-manager attach --pool="$ARC_POOL"
subscription-manager repos --disable='*'

for repo in ${REPO_LIST} ; do subscription-manager repos --enable=$repo ; done

for repo in ${REPO_LIST} ; do reposync -g -m -n -l  --download_path=${REPO_BASE_PATH}  --repoid=$repo ; done

#subscription-manager unregister

