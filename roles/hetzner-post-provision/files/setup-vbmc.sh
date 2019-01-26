#!/bin/bash
vbmc add ctrl01 --port 6230 --username admin --password redhat123
vbmc add ctrl02 --port 6231 --username admin --password redhat123
vbmc add ctrl03 --port 6232 --username admin --password redhat123
vbmc add compute01 --port 6240 --username admin --password redhat123
vbmc add compute02 --port 6241 --username admin --password redhat123
#vbmc add compute03 --port 6241 --username admin --password redhat123

vbmc start ctrl01
vbmc start ctrl02
vbmc start ctrl03
vbmc start compute01
vbmc start compute02
#vbmc start compute03

