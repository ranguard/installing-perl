#!/bin/bash

# Installer script for Perl on Linux/Unix systems

INSTALLER_PERL_VERSION=5.32.0

BASHP=~/.bash_profile
BASHR=~/.bashrc
CPANMTMP=~/.cpanm
PBREW_BASHRC=~/perl5/perlbrew/etc/bashrc

MAVERICKS=$( perl -e 'print `sw_vers` =~ /ProductVersion:\s+10[.](\d+)/ && $1 >=9' );

# See if 'make' is installed
if [ "" == "$(which 'make')" ]; then
	echo "Unable to find 'make'. Please install 'Command Line Tools for Xcode'."
	echo ""
	if [ $MAVERICKS == "1" ]; then
		echo "Please run 'xcode-select --install' from the command line, then follow"
		echo "the gui instructions."
		exit 1;
	fi;
	echo "If you have Xcode installed (free from the Mac App Store) you can"
	echo "install 'Command Line Tools' in the following way:"
	echo ""
	echo "  1. Make sure you're online"
	echo "  2. Start Xcode"
	echo "  3. Go to Preferences (i.e. press Cmd-,)"
	echo "  4. Click on 'Downloads'"
	echo "  5. Click on the 'Install' icon next to 'Command Line Tools'"
	echo ""
	echo "If you do not have Xcode installed you can simply download 'Command"
	echo "Line Tools for Xcode' from https://developer.apple.com/downloads/"
	echo "(free registration required)"
	echo ""
	exit 1;
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
	echo "You may need to run 'sudo rm -rf $CPANMTMP'"
	echo "if you ran cpanm with sudo"
	exit 2;
fi

echo "Installing perlbrew"
curl -k -L http://xrl.us/perlbrewinstall | bash

# Build as i386 only
arch=`uname -m`
if [ "$arch" == 'i386' ]; then
	echo 'export ARCHFLAGS="-arch i386"' >> ~/perl5/perlbrew/etc/bashrc
fi

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
