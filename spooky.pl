#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Interface;

# I am so, SO sorry...

#Seed the RNG:
srand time;

# Make the character:
my $char = Character->new;
$char->generate_new_stats;

# Initialise the interface:
my $interface = Interface->new;
&draw;
Curses::getch;
$interface->close;

# Draws all the stuff needed:
sub draw
{
	$interface->draw
	(
		{
			# The stats window:
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

			# The textbox:
			textbox =>
			[
				{
					x => 1,
					y => 1,
					text => "test string",
				}
			],
		},
	);
}
