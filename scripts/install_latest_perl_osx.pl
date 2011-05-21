#!/usr/bin/env perl

use strict;
use warnings;

my $perl_version = '5.14.0';

my $bash_profile = $ENV{'HOME'} . '/.bash_profile';
my $bashrc       = $ENV{'HOME'} . '/.bashrc';

# if .bash_profile is missing or does not source .bashrc
# then we should creat/add: [ -r $bashrc ] && source $bashrc
if ( !-r "$bash_profile" || !bashrc_in_profile($bash_profile) ) {
    run_cmd(
        "Setting up $bash_profile and $bashrc",
        join(
            '',
            (   'echo "[ -r ',   $bashrc,
                ' ] && source ', $bashrc,
                '" >> ',         $bash_profile
            )
        )
    );
}

run_cmd( "Installing perlbrew",
    "curl -L http://xrl.us/perlbrewinstall | bash" );

run_cmd( "Updating $bashrc with perlbrew command",
    'echo "source ~/perl5/perlbrew/etc/bashrc" >> ~/.bashrc' );

run_cmd(
    "Updating your current environment",
    'source ~/perl5/perlbrew/etc/bashrc'
);

run_cmd(
    "Updating your current environment",
    'source ~/perl5/perlbrew/etc/bashrc'
);

run_cmd(
    "Installing Perl $perl_version through perlbrew",
    "perlbrew install perl-$perl_version"
);

run_cmd(
    "Setting Perl $perl_version to default",
    "perlbrew switch perl-$perl_version"
);

run_cmd(
    "Switching to $perl_version for this session",
    "exec /bin/bash"
);

run_cmd( "Installing cpanm",
    "curl -L http://cpanmin.us/ | perl - App::cpanminus" );

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
