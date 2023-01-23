#!/usr/bin/env bash
# Copyright (C) 2022 Mattia Bonzi <mattia@mattiabonzi.it>
# 
# This file is part of Mpdk.
# 
# Mpdk is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Mpdk is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Mpdk.  If not, see <http://www.gnu.org/licenses/>.

source ".asset/lib/osht.sh"

#TEST: new
#Crete a new instance, download moodle

#RESET
echo "rm -rf ./mpdktest*" >> reset

#VAR
root=$(PWD)
mpdk=$root/mpdk
asset=$root/.asset
PLAN $(grep -c "^\s*RUNS\|^\s*OK\|^\s*NOK\|^\s*GREP\|^\s*NGREP\|^\s*NEGREP\|^\s*NOGREP\|^\s*EGREP\|^\s*OGREP\|^\s*IS\|^\s*ISNT\|^\s*NRUNS\|^\s*DIFF\|^\s*TODO" $0)


if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $mpdk install --copyright "Jonh smith <Jonhsmith@myorg,com>" --editor "/Applications/PhpStorm" --global no
fi


######### BEGIN #########
RUNS $mpdk new mpdktest1 #Dev instance
OK -d ./mpdktest1/moodle
OK -f ./mpdktest1/mpdkinstance.env 
OK -f ./mpdktest1/moodle/version.php 
OK -f ./mpdktest1//moodle/admin/tool/pluginskel/version.php 
OK -f ./mpdktest1/moodle/local/codechecker/version.php 
OK -f ./mpdktest1/moodle/local/moodlecheck/version.php
cd $asset/cache/"$(ls $asset/cache/)"
zip="$(ls)"
mkdir moodle && touch moodle/mpdkcached
zip -gr $zip moodle 
rm -rf ./moodle
cd "$root"


RUNS $mpdk new -t mpdktest2 #Test only instance
GREP "Instance ready, located in"
OK -d ./mpdktest2/moodle #Moodle is present
OK -f ./mpdktest2/mpdkinstance.env #Check taht is an instance
OK -f ./mpdktest2/moodle/version.php #Moodle is actually moodle
RUNS ls $asset/cache #Check cache folder isn't empty (the cache has been used)
GREP . #Check cache folder isn't empty (the cache has been used)
NOK -f ./mpdktest2/moodle/admin/tool/pluginskel/version.php #Check is test only
NOK -f ./mpdktest2/moodle/local/codechecker/version.php #Check is test only
NOK -f ./mpdktest2/moodle/local/moodlecheck/version.php #Check is test only
OK -f ./mpdktest2/moodle/mpdkcached #Check that the cache has been used

RUNS $mpdk new -v 4.1.0 mpdktest3 #Specific version
OK -d ./mpdktest3/moodle #Moodle exist
OK -f ./mpdktest3/mpdkinstance.env #Is an instance
OK -f ./mpdktest3/moodle/version.php #Moodle exist
RUNS cat ./mpdktest3/moodle/version.php #Check it's the right version
GREP 20221128 #Check it's the right version
IS $(ls .asset/cache | wc -l) -eq 2 #Check that now there are 2 version cached

RUNS $mpdk new -c mpdktest4 #Without the cache
OK -d ./mpdktest4/moodle #Moodle exist
OK -f ./mpdktest4/moodle/version.php #Moodle exist
OK -f ./mpdktest4/mpdkinstance.env #Is an instance
NOK -f ./mpdktest4/moodle/mpdkcached #Check that the cache hasn't been used
######### END #########

#RESET
if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $(cat $root/reset)
    rm -f $root/reset
fi