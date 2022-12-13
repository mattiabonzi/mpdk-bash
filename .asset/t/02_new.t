#!/usr/bin/env bash
source .asset/t/osht.sh

#TEST: new
#Crete a new instance, download moodle

####
echo "rm -rf ./mpdktest1 ./mpdktest2 ./mpdktest3" >> reset
printf "\n\n###### INSTRUCTION #######\n"
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
RUNS $mpdk new mpdktest1
GREP "Instance ready, located in"
OK -d ./mpdktest1/moodle
OK -f ./mpdktest1/moodle/.mpdkinstance
OK -f ./mpdktest1/moodle/version.php
RUNS ls $asset/cache
GREP .

RUNS $mpdk new -d mpdktest2
OK -d ./mpdktest2/moodle
OK -f ./mpdktest2/moodle/.mpdkinstance 
OK -f ./mpdktest2/moodle/version.php 
OK -f ./mpdktest2//moodle/admin/tool/pluginskel/version.php 
OK -f ./mpdktest2/moodle/local/codechecker/version.php 
OK -f ./mpdktest2/moodle/local/moodlecheck/version.php 

RUNS $mpdk new -v 3.9.18 mpdktest3 
OK -d ./mpdktest3/moodle 
OK -f ./mpdktest3/moodle/.mpdkinstance 
OK -f ./mpdktest3/moodle/version.php 
RUNS cat ./mpdktest3/moodle/version.php 
GREP 2020061518 
IS $(ls .asset/cache | wc -l) -eq 2 
######### END #########