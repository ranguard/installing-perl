#!/bin/bash

# Installer script for Perl on Linux/Unix systems

INSTALLER_PERL_VERSION=5.14.0

BASHP=~/.bash_profile
BASHR=~/.bashrc
CPANMTMP=~/.cpanm

# See if 'make' is installed
if [ "" == "$(which 'make')" ]; then
	echo "Unable to find 'make' please check you have Apple's developer tools installed"
	exit;
fi;

echo -n "Checking for .bash_profile... "
if [ -f $BASHP ]; then
	echo "FOUND"
	echo -n "Checking for .bashrc sourcing inside of .bash_profile... "
	if [ "" != "$( cat $BASHP | grep 'source ' | grep 'bashrc' )" ]; then
		echo "FOUND"
	else
		echo "NOT FOUND"
		echo "Adding 'source $BASHR' to $BASHP"
		echo "# Added by install_latest_perl_osx.pl" >>$BASHP
		echo "[ -r $BASHR ] && source $BASHR" >>$BASHP
	fi
else
	echo "NOT FOUND"
	echo "Creating $BASHP"
	echo "# Added by install_latest_perl_osx.pl" >>$BASHP
	echo "[ -r $BASHR ] && source $BASHR" >>$BASHP
fi

# Ask them to clean ~/.cpanm - so we don't have file perm issues
if [ -d "$CPANMTMP" ]; then
	echo "------------------------"
	echo "Please delete $CPANMTMP and then re-run this command"
	echo "You may need to run 'sudo rm $CPANMTMP' if you ran cpanm with sudo"
	exit;
fi

echo "Installing perlbrew"
curl -L http://xrl.us/perlbrewinstall | bash

# Build as i386 only
arch=`uname -m`
if [[ "$arch" == 'i386']]
then
	echo 'export ARCHFLAGS="-arch i386"' >> ~/perl5/perlbrew/etc/bashrc
else
fi

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
