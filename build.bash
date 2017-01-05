#!/usr/bin/env bash

#check params count
if [ $# -ne 1 ];then
    echo "Usage: build.bash xxx"
    echo "Note: xxx is the install path of the module"
    exit -1
fi

installTargetPath=$1
scriptPath=$(cd `dirname $0`;pwd)

#list all modules in current directory
modules=($(ls -l $scriptPath|grep '^d'|awk '{print $9}'))
modulesCount=${#modules[*]}
echo $modules

for ((i=0; i<"$modulesCount"; i=i+1)) 
do
    module=$scriptPath/${modules[$i]}
    echo "Current Module:-->"$module
    cd $module && catkin_make install
    if [ $? -eq 0 ];then
        echo "begin install $module ........"
	rsync -lortP $module/install/ $installTargetPath/
        echo "Install $module Succeeded!........"
        rm -fr build devel install >/dev/null 2>&1
        echo "clean $module Succeeded!........"
    else 
        echo "Install $module failed!......."
        exit -1
    fi
done
echo "All modules install succeeded!........."
echo "Finish building!........."
