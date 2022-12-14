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

#TEST: install
#Downlaod and install all the required asset, create config files...

#RESET
echo 'rm -rf ./.asset/config ./.asset/moodle-docker ./.asset/recipe ./.asset/cache ./.asset/myplugins' > reset


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


#RESET
$(cat $root/reset)
rm -f $root/reset





