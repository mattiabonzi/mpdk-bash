#!/usr/bin/env bash
source .asset/t/osht.sh

#TEST: install
#Downlaod and install all the required asset, create config files...

####
echo 'rm -rf ./.asset/config ./.asset/moodle-docker ./.asset/recipe ./.asset/cache ./.asset/myplugins' > reset
printf "\n\n###### INSTRUCTION #######\n"
echo "Answer the question EXACTLY this way: (or the test will fail)"
echo "- Copytight: Jonh smith <Jonhsmith@myorg.com>"
echo "- Editor: /Applications/PhpStorm.app"
echo "- Add mpdk on PATH: n"
echo "To reset run: chmod +x ./reset && ./reset && rm -f ./reset"
printf "##########################\n\n"
printf " \n"
sleep 2
####

#VAR
root=$(PWD)
mpdk=$root/mpdk
asset=$root/.asset
PLAN $(grep -c "^\s*RUNS\|^\s*OK\|^\s*NOK\|^\s*GREP\|^\s*NGREP\|^\s*NEGREP\|^\s*NOGREP\|^\s*EGREP\|^\s*OGREP\|^\s*IS\|^\s*ISNT\|^\s*NRUNS\|^\s*DIFF\|^\s*TODO" $0)



######### BEGIN #########
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
echo $0
######### END #########




