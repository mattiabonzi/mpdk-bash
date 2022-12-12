#!/usr/bin/env bash

reset='rm -rf ./.asset/config ./.asset/moodle-docker ./.asset/recipe ./.asset/cache ./.asset/myplugins'

#TEST: install
####
printf "\n\n###### INSTRUCTION #######\n"
echo "Answer the question EXACTLY this way: "
echo "- Copytight: 'Jonh smith <Jonhsmith@myorg.com>'"
echo "- Editor: '/Applications/PhpStorm.app'"
echo "- Add mpdk on PATH: 'n'"
echo "To reset run: $reset"
printf "##########################\n\n"
printf " \n"
sleep 2
####

#Load osht
source .asset/t/osht.sh
mpdk=./mpdk
asset=./.asset
PLAN=10


######### START #########
$mpdk install
#Check file and dir
OK -f "$asset/moodle-docker/local.yml" #1
OK -f "$asset/moodle-docker/base.yml" #2
OK -f "$asset/moodle-docker/dockerfile" #3

OK -f "$asset/config" #4
OK -f "$asset/myplugins" #5
OK -d "$asset/cache" #6
#Check file contents
#Config
RUNS cat $asset/config #7
GREP "export MPDK_EDIOTR=\"/Applications/PhpStorm" #8
GREP "export COPYRIGHT_STRING=\"Jonh smith <Jonhsmith@myorg" #9




