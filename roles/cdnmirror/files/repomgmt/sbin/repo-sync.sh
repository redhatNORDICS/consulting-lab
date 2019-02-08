#!/bin/bash

source /etc/sysconfig/repoconfig

subscription-manager repos --disable='*'

for repo in ${REPO_LIST} ; do subscription-manager repos --enable=$repo ; done

for repo in ${REPO_LIST} ; do reposync -g -m -n -l  --download_path=${REPO_BASE_PATH}  --repoid=$repo ; done

