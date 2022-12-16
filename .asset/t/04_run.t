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
    $mpdk new mpdktest2
    $mpdk new mpdktest3
fi

######### BEGIN #########
#Dev instance
cd ./mpdktest1
$mpdk run > /dev/null
RUNS lsof -i:8000
GREP "com\.docke"
RUNS lsof -i:8001
GREP "com\.docke"
RUNS curl -iso- localhost:8000
GREP "HTTP/1.1 200 OK"
GREP '<h1 class="h2">mpdktest1</h1>'
NGREP 'alert-danger'
NGREP 'Parse error'
RUNS cat ./moodle/.init
GREP "1 0 0"
RUNS $mpdk sh cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
GREP "xdebug\.client_host"
RUNS $mpdk sh ls ../behatdata
NGREP .
RUNS $mpdk sh ls ../moodledata
GREP .
RUNS $mpdk sh ls ../phpunitdata
NGREP .
cd ..

#Test instance
cd ./mpdktest2
$mpdk run -t -p 8002 -P 8003 > /dev/null
RUNS lsof -i:8002
GREP "com\.docke"
RUNS lsof -i:8003
GREP "com\.docke"
RUNS cat ./moodle/.init
GREP "0 1 0"
RUNS $mpdk sh cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
NGREP .
RUNS $mpdk sh ls ../behatdata
NGREP .
RUNS $mpdk sh ls ../moodledata
NGREP .
RUNS $mpdk sh ls ../phpunitdata
GREP .
cd ..

#Behat instance
cd ./mpdktest3
$mpdk run -b -p 8004 -P 8005 > /dev/null
RUNS lsof -i:8004
GREP "com\.docke"
RUNS lsof -i:8005
GREP "com\.docke"
RUNS cat ./moodle/.init
GREP "0 0 1"
RUNS $mpdk sh cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
NGREP .
RUNS $mpdk sh ls ../behatdata
GREP .
RUNS $mpdk sh ls ../moodledata
NGREP .
RUNS $mpdk sh ls ../phpunitdata
NGREP .
cd ..

#Dev PhpUnit Behat instance
$mpdk new -d mpdktest4
cd ./mpdktest4
$mpdk run -tbd -p 8006 -P 8007 > /dev/null
RUNS lsof -i:8006
GREP "com\.docke"
RUNS lsof -i:8007
GREP "com\.docke"
RUNS curl -iso- localhost:8000
GREP "HTTP/1.1 200 OK"
GREP '<h1 class="h2">mpdktest4</h1>'
NGREP 'alert-danger'
NGREP 'Parse error'
CAT ./mpdktest4/moodle/.init
GREP "1 1 1"
RUNS $mpdk sh cat '/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'
GREP "xdebug\.client_host"
RUNS $mpdk sh ls ../behatdata
GREP .
RUNS $mpdk sh ls ../moodledata
GREP .
RUNS $mpdk sh ls ../phpunitdata
GREP .
cd ..
######### END #########

#RESET
if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $(cat $root/reset)
    rm -f $root/reset
fi