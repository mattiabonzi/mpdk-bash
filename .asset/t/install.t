#!/usr/bin/env bash

#TEST: install
####
echo "###### INSTRUCTION #######"
echo "Anser the question EXACTLY this way: "
echo "Copytight: 'Jonh smith <Jonhsmith@myorg.com>'"
echo "Editor: '/Applications/PhpStorm.app'"
echo "Add mpdk on PATH: 'n'"
echo "##########################"
sleep 5
####

#Load osht
source .asset/t/osht.sh
mpdk=./mpdk

######### START #########
$mpdk install #1
#Check file and dir
OK -f "../moodle-docker/local.yml" #2
OK -f "../moodle-docker/base.yml" #3
OK -f "../moodle-docker/dockerfile" #4

OK -f "../config" #5
OK -f "../myplugin" #6
OK -d "../cache" #7
#Check file contents
#Config
RUNS cat ../config #8
GREP "export MPDK_EDIOTR=\"/Applications/PhpStorm" #9
GREP "export COPYRIGHT_STRING=\"Jonh smith <Jonhsmith@myorg" #10


