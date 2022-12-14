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

source .asset/t/osht.sh

#TEST: new
#Crete a new instance, download moodle

####
echo "" >> reset
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
cd ./mpdktest1
RUNS $mpdk stop
RUNS docker ps -f "name=mpdktest1"
NGREP "webserver"
cd ..

RUNS $mpdk stop -a
GREP "All instances have been stopped"
RUNS docker ps -f "name=mpdktest*" 
NGREP "webserver"
######### END #########

#Run agan the conainer to continue testing
cd ./mpdktest1 && $mpdk run > /dev/null && cd ..
cd ./mpdktest2 && $mpdk run -p 8002 -P 8003 > /dev/null && cd ..
cd ./mpdktest3 && $mpdk run -p 8004 -P 8005 > /dev/null && cd ..
cd ./mpdktest4 && $mpdk run -p 8006 -P 8007 > /dev/null && cd ..