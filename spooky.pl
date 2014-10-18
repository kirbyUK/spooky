#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Interface;

# I am so, SO sorry...

#Seed the RNG:
srand time;

my $char = Character->new;
$char->generate_new_stats;
my $interface = Interface->new;
my $str = $char->stats->{strength};
$interface->draw
(
	{
		stats =>
		[
			{
				x => 0,
				y => 0,
				text => "Strength: ${\$char->stats->{strength}}",
			},
			{
				x => 0,
				y => 1,
				text => "Defence:  ${\$char->stats->{defence}}",
			},
			{
				x => 0,
				y => 2,
				text => "Speed:    ${\$char->stats->{speed}}",
			},
		],
	},
);
Curses::getch;
$interface->close;
