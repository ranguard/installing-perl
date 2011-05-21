#!/usr/bin/env perl

use strict;
use warnings;

my $perl_version = '5.14.0';

my $bash_profile = $ENV{'HOME'} . '/.bash_profile';
my $bashrc       = $ENV{'HOME'} . '/.bashrc';

my @sh_lines;

# if .bash_profile is missing or does not source .bashrc
# then we should creat/add: [ -r $bashrc ] && source $bashrc
if ( !-r "$bash_profile" || !bashrc_in_profile($bash_profile) ) {

	run_cmd("Setting up $bash_profile and $bashrc",
        join(
            '',
            (   'echo "[ -r ',   $bashrc,
                ' ] && source ', $bashrc,
                '" >> ',         $bash_profile
            )
        )
    );
}

my $sh = <<EOF;

echo "Installing perlbrew"
curl -L http://xrl.us/perlbrewinstall | bash

echo "Updating $bashrc with perlbrew command"
source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc

echo "Updating your current environment"
source ~/perl5/perlbrew/etc/bashrc

echo "Installing Perl $perl_version through perlbrew"
perlbrew install perl-$perl_version

echo "Setting Perl $perl_version to default"
perlbrew switch perl-$perl_version

# Perlbrew switch suggests exec /bin/bash to use NOW
exec /bin/bash

echo "Installing cpanm",
curl -L http://cpanmin.us/ | perl - App::cpanminus

EOF

sub bashrc_in_profile {
    my $profile = shift;
    open FH, '<', $profile;
    while ( my $line = <FH> ) {
        if ( $line =~ /source/ && $line =~ /bashrc/ ) {
            return 1;
        }
    }
    close(FH);
    return 0;
}

sub run_cmd {
    my ( $msg, $cmd ) = @_;
    print "Installer is.. $msg\n";
    system($cmd);
}
