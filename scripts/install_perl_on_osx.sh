#!/bin/bash

INSTALLER_PERL_VERSION=5.14.0

BASHP=~/.bash_profile
BASHR=~/.bashrc

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
curl -L http://cpanmin.us/ | perl - App::cpanminus

echo "------------------"
echo "Install complete - close this terminal window and open a new one,"
echo "then to confirm $INSTALLER_PERL_VERSION is installed type: perl -v"