#!/usr/bin/perl -w -Ilib
use strict;
use Interface;

# I am so, SO sorry...
my $interface = Interface->new;
$interface->draw;
Curses::getch;
$interface->close;
