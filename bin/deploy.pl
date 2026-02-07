#!/usr/bin/env perl

use strict;
use warnings;

my @args = @ARGV;
my $cmd = "deploy " . join(' ', @args);

print "demo mode, this would execute:\n";
print "=> $cmd\n";
# exec $cmd;
