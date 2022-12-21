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

#TEST: run
#Run and init a new instance, or run an already initialized instance

#RESET
echo 'rm -rf ./mpdktest* && docker ps -aq -f "name=mpdktest*" | xargs docker stop | xargs docker rm' >> reset

#VAR
root=$(PWD)
mpdk=$root/mpdk
asset=$root/.asset
PLAN $(grep -c "^\s*RUNS\|^\s*OK\|^\s*NOK\|^\s*GREP\|^\s*NGREP\|^\s*NEGREP\|^\s*NOGREP\|^\s*EGREP\|^\s*OGREP\|^\s*IS\|^\s*ISNT\|^\s*NRUNS\|^\s*DIFF\|^\s*TODO" $0)

if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $mpdk install --copyright "Jonh smith <Jonhsmith@myorg,com>" --editor "/Applications/PhpStorm" --global no
    $mpdk new mpdktest1
    $mpdk new -t mpdktest2
    $mpdk new -t mpdktest3
    $mpdk new mpdktest4
fi

######### BEGIN #########
#Dev instance
cd ./mpdktest1 # Dev instances
RUNS $mpdk run #Run the instance
RUNS lsof -i:8000 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS lsof -i:8001 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS curl -iso- localhost:8000 #Check we have the right front page
GREP "HTTP/1.1 200 OK" #Check we have the right front page
GREP '<h1 class="h2">mpdktest1</h1>' #Check we have the right front page
NGREP 'alert-danger' #Check no error in front page
NGREP 'Parse error' #Check no error in front page
RUNS cat ./moodle/.init #Check the init file
GREP "1 0 0" #Check the init file
RUNS $mpdk ex cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini' #Check xdebug
GREP "xdebug\.client_host" #Check xdebug
RUNS $mpdk ex ls ../behatdata #Check NO behatdata data
NGREP . #Check NO behatdata data
RUNS $mpdk ex ls ../moodledata #Check moodledata data
GREP . #Check moodledata data
RUNS $mpdk ex ls ../phpunitdata #Check NO phpunitdata data
NGREP . #Check NO phpunitdata data
$mpdk stop
cd ..

#Test instance
cd ./mpdktest2 #Test instance
RUNS $mpdk run -t -p 8002 -P 8003 #Run the instance
RUNS lsof -i:8002 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS lsof -i:8003 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS cat ./moodle/.init #Check the init file
GREP "0 1 0" #Check the init file
RUNS $mpdk ex cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini' #Check NO xdebug
GREP "No such file or directory" #Check NO xdebug
RUNS $mpdk ex ls ../behatdata #Check NO behatdata data
NGREP . #Check NO behatdata data
RUNS $mpdk ex ls ../moodledata #Check NO moodledata data
NGREP . #Check NO moodledata data
RUNS $mpdk ex ls ../phpunitdata #Check phpunitdata data
GREP . #Check phpunitdata data
$mpdk stop
cd ..

#Behat instance
cd ./mpdktest3 #Behat instance
RUNS $mpdk run -b -p 8004 -P 8005 #Run the instance
RUNS lsof -i:8004  #Check the port is used by docker
GREP "com\.docke"  #Check the port is used by docker
RUNS lsof -i:8005 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS cat ./moodle/.init #Check the init file
GREP "0 0 1" #Check the init file
RUNS $mpdk ex cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini' #Check NO xdebug
GREP "No such file or directory" #Check NO xdebug
RUNS $mpdk ex ls ../behatdata #Check behatdata data
GREP "behatrun" #Check behatdata data
RUNS $mpdk ex ls ../moodledata #Check NO moodledata data
NGREP . #Check NO moodledata data
RUNS $mpdk ex ls ../phpunitdata #Check NO phpunitdata data
NGREP . #Check NO phpunitdata data
$mpdk stop
cd ..

#Dev PhpUnit Behat instance
cd ./mpdktest4 #Dev PhpUnit Behat instance
RUNS $mpdk run -tbd -p 8006 -P 8007 #Run the instance
RUNS lsof -i:8006 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS lsof -i:8007 #Check the port is used by docker
GREP "com\.docke" #Check the port is used by docker
RUNS curl -iso- localhost:8006 #Check we have the right front page
GREP "HTTP/1.1 200 OK" #Check we have the right front page
GREP '<h1 class="h2">mpdktest4</h1>'  #Check we have the right front page
NGREP 'alert-danger' #Check no error in front page
NGREP 'Parse error' #Check no error in front page
GREP cat ./moodle/.init #Check the init file
GREP "1 1 1" #Check the init file
RUNS $mpdk ex cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini' #Check xdebug 
GREP "xdebug\.client_host" #Check xdebug
RUNS $mpdk ex ls ../behatdata #Check behatdata data
GREP "behatrun" #Check behatdata data
RUNS $mpdk ex ls ../moodledata #Check moodledata data
GREP . #Check moodledata data
RUNS $mpdk ex ls ../phpunitdata #Check phpunitdata data
GREP . #Check phpunitdata data
$mpdk stop
cd ..
######### END #########

$mpdk -n mpdktest1 run
$mpdk -n mpdktest2 run
$mpdk -n mpdktest3 run
$mpdk -n mpdktest4 run


#RESET
if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $(cat $root/reset)
    rm -f $root/reset
fi