#!/bin/sh -x

# platform-independent lib.sh
cd `dirname $0` || exit 1
opt_dir=`pwd`
. lib.sh || exit 1

# FreeBSD users: note: you may want to install libzstd to make
# compression go faster;
#  pkg install zstd
# then run this script with --enable-zstd

# Anyway: so long as recent/latest `tor` is accessible in $PATH, then
# EOTK will be happy.

# platform dependencies
shared_deps="gmake libevent pkgconf"
echo $0: calling su to satisfy package dependencies
su root -c "pkg install $shared_deps" || exit 1
MAKE=gmake # use GNU make

# build openresty
SetupOpenRestyVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureOpenResty || exit 1
BuildAndCleanup || exit 1

# build tor
SetupTorVars || exit 1
CustomiseVars || exit 1
SetupForBuild || exit 1
ConfigureTor || exit 1
BuildAndCleanup || exit 1

# done
exit 0
