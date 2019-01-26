#!/bin/bash

source /etc/sysconfig/repoconfig

for i in ${REPO_LIST} ; do rm -f $(repomanage ${REPO_BASE_PATH}/${i} -k 1 --old) ; done

