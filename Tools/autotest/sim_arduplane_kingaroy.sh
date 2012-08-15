#!/bin/bash

set -x

killall -q ArduPlane.elf
pkill -f runsim.py
set -e

autotest=$(dirname $(readlink -e $0))
pushd $autotest/../../ArduPlane
make clean obc-sitl

tfile=$(tempfile)
echo r > $tfile
#gnome-terminal -e "gdb -x $tfile --args /tmp/ArduPlane.build/ArduPlane.elf"
gnome-terminal -e /tmp/ArduPlane.build/ArduPlane.elf
#gnome-terminal -e "valgrind -q /tmp/ArduPlane.build/ArduPlane.elf"
sleep 2
rm -f $tfile
gnome-terminal -e '../Tools/autotest/jsbsim/runsim.py --home=-26.582218,151.840113,440.3,169 --wind=5,180,0'
sleep 2
popd
mavproxy.py --aircraft=test --master tcp:127.0.0.1:5760 --sitl 127.0.0.1:5501 --out 127.0.0.1:14550 --out 127.0.0.1:14551