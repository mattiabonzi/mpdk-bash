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

#TEST: download moodle
#Crete a new instance

#VAR
root=$(PWD)
mpdk=$root/mpdk
asset=$root/.asset
PLAN $(grep -c "^\s*RUNS\|^\s*OK\|^\s*NOK\|^\s*GREP\|^\s*NGREP\|^\s*NEGREP\|^\s*NOGREP\|^\s*EGREP\|^\s*OGREP\|^\s*IS\|^\s*ISNT\|^\s*NRUNS\|^\s*DIFF\|^\s*TODO" $0)


if [ -n "$MPDK_TEST_RESET_EACH" ];then
    $mpdk install --copyright "Jonh smith <Jonhsmith@myorg,com>" --editor "/Applications/PhpStorm" --global no
fi

######### BEGIN #########
RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u)"
GREP "HTTP/1.1 200 OK"
GREP "latest"
GREP "stable"

RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 4.0.0)"
GREP "HTTP/1.1 200 OK"
NGREP "latest"
GREP "stable400"
GREP "4.0"

RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 3.9.10)"
GREP "HTTP/1.1 200 OK"
NGREP "latest"
GREP "stable39"
GREP "3.9.10"

RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 3.9.9)"
GREP "HTTP/1.1 200 OK"
NGREP "latest"
GREP "stable39"
GREP "3.9.9"


RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 3.9)"
GREP "HTTP/1.1 200 OK"
GREP "latest-39"
GREP "stable39"


RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 4.0)"
GREP "HTTP/1.1 200 OK"
GREP "latest-400"
GREP "stable400"



RUNS wget -o - -O - -S --spider "$($mpdk download-moodle -u -v 4.1.0)"
GREP "HTTP/1.1 200 OK"
NGREP "latest"
GREP "stable401"
GREP "4.1"

NRUNS $mpdk download-moodle -u -v 4.1.0.2
NRUNS $mpdk download-moodle -u -v 4

######### END #########