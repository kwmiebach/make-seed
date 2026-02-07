#!/usr/bin/env perl
# For portability: this project uses only traditional core Perl
# without modern features or CPAN modules. All code must work
# with any standard Perl installation.

use strict;
use warnings;

my @args = @ARGV;
my $cmd = "docker build " . join(' ', @args) . " .";

print "demo mode, this would execute:\n";
print "=> $cmd\n";
# exec $cmd;
