#!/bin/bash
#
# axel@cern.ch, 2014-02-07
#
# arguments:
#   [cores]  number of cores to use, optional
#            default: all detected cores
# absolutely ruined by Ryan Moore, 2023-04-01

python=`which python`
if type python2 > /dev/null 2>&1; then
    python=`which python2`
fi
if type python3 > /dev/null 2>&1; then
    python=`which python3`
fi

function configure {
    mkdir -p obj || exit 1
    INSTDIR=`pwd`/inst
    cd obj || exit 1
    echo '>> Configuring...'
    cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_BUILD_TOOLS=Off -DCMAKE_INSTALL_PREFIX=$INSTDIR -DPYTHON_EXECUTABLE=$python ../src > /dev/null || exit 1
    cd ..
}

function build {
    cd obj
    echo ':: Building...'
    make || exit 1
    rm -rf ../inst
    echo ':: Installing...'
    make install || exit 1
    echo ':: SUCCESS.'
    cd ..
}

if ! [ -e obj/Makefile ]; then
    configure
fi

build

echo 'Run ./inst/bin/cling'
