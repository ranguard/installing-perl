#!/bin/bash

# Installer script for Perl on Linux/Unix systems

INSTALLER_PERL_VERSION=5.32.0

BASHR=~/.bashrc
CPANMTMP=~/.cpanm
PBREW_BASHRC=~/perl5/perlbrew/etc/bashrc

# See if 'make' is installed
if [ "" == "$(which 'make')" ]; then
	echo "Unable to find 'make' please install"
	exit;
fi;

# Ask them to clean ~/.cpanm - so we don't have file perm issues
if [ -d "$CPANMTMP" ]; then
	echo "------------------------"
	echo "Please delete $CPANMTMP and then re-run this command"
	echo "You may need to run 'sudo rm -rf $CPANMTMP'"
	echo "if you ran cpanm with sudo"
	exit;
fi

echo "Installing perlbrew"
curl -k -L http://xrl.us/perlbrewinstall | bash

echo "Checking/updating $BASHR to source perlbrew bashrc"
if [ ! -f $BASHR ]; then
	# File missing so create
	echo "source $PBREW_BASHRC" >> $BASHR
else
	if [ "" == "$( cat $BASHR | grep 'source ' | grep $PBREW_BASHRC )" ]; then
		# source line is missing - so add
		echo "source $PBREW_BASHRC" >> $BASHR
	fi;
fi;

echo "Updating your current environment"
source $PBREW_BASHRC

echo "Installing Perl $INSTALLER_PERL_VERSION through perlbrew"
perlbrew -n install perl-$INSTALLER_PERL_VERSION

echo "Setting Perl $INSTALLER_PERL_VERSION to default"
perlbrew switch perl-$INSTALLER_PERL_VERSION

echo "Installing cpanm",
perlbrew install-cpanm

echo "------------------"
echo "Install complete - close this terminal window and open a new one,"
echo "then to confirm Perl $INSTALLER_PERL_VERSION is installed type: perl -v"
