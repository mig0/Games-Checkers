#!/usr/bin/perl

use strict;
use warnings;

use FindBin;

my $libdir = "$FindBin::Bin/../lib";
eval qq(use lib "$libdir");

my @classes = map {
	s!^$libdir/!!; s!/!::!g; s!\.pm$!!g;
	$_;
} "$libdir/Games/Checkers.pm", glob("$libdir/Games/Checkers/*.pm");

eval qq(use Test::More tests => ) . (0 + @classes); die $@ if $@;

use_ok($_) foreach @classes;
