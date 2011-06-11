#!/bin/bash

# Installer script for Perl on Linux/Unix systems

INSTALLER_PERL_VERSION=5.14.0

BASHR=~/.bashrc
CPANMTMP=~/.cpanm

# See if 'make' is installed
if [ "" == "$(which 'make')" ]; then
	echo "Unable to find 'make' please install"
	exit;
fi;

# Ask them to clean ~/.cpanm - so we don't have file perm issues
if [ -d "$CPANMTMP" ]; then
	echo "------------------------"
	echo "Please delete $CPANMTMP and then re-run this command"
	echo "You may need to run 'sudo rm $CPANMTMP' if you ran cpanm with sudo"
	exit;
fi

echo "Installing perlbrew"
curl -L http://xrl.us/perlbrewinstall | bash

echo "Updating $BASHR with perlbrew command"
cat ~/perl5/perlbrew/etc/bashrc >>$BASHR

echo "Updating your current environment"
source ~/perl5/perlbrew/etc/bashrc

echo "Installing Perl $INSTALLER_PERL_VERSION through perlbrew"
perlbrew install perl-$INSTALLER_PERL_VERSION

echo "Setting Perl $INSTALLER_PERL_VERSION to default"
perlbrew switch perl-$INSTALLER_PERL_VERSION

echo "Installing cpanm",
perlbrew install-cpanm

echo "------------------"
echo "Install complete - close this terminal window and open a new one,"
echo "then to confirm $INSTALLER_PERL_VERSION is installed type: perl -v"
