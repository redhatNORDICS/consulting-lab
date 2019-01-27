#!/bin/bash

source /etc/sysconfig/repoconfig

for i in ${REPO_LIST} ; do createrepo ${REPO_BASE_PATH}/${i} ; done

