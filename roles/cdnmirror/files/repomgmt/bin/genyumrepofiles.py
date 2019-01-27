#!/usr/bin/python
# -*- coding: UTF-8 -*-

# author: François Cami
# license: MIT

from mako.template import Template 
import os,socket

mylist = next(os.walk('/var/www/html/repos'))[1]

if not os.path.exists('/var/www/html/yum/'):
    os.makedirs('/var/www/html/yum/')

for i in mylist:
    mytemplate = Template(filename='/usr/share/repomgmt/yum.repo.tmpl')
    file = mytemplate.render(name=i,hostname=socket.gethostname())
    f = open("".join(["/var/www/html/yum/",i,".repo"]), "w+")
    f.writelines(file)
    f.flush()
    os.fsync(f.fileno())
    f.close()


