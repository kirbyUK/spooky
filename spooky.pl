#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Interface;

# I am so, SO sorry...

#Seed the RNG:
srand time;

# Initialise the interface:
my $interface = Interface->new;

# Make the character:
my $char = Character->new;

# Generate a stat spread the player is happy with:
$interface->set_textbox({ text => "Is this stat spead ok? [Y\\n]",
	x => 1, y => 1 });
do
{
	$char->generate_new_stats;
	&draw;
} while(! $interface->input_yesno);

Curses::getch;

# Close the interface:
$interface->close;

# Draws all the stuff needed:
sub draw
{
	my $ref =
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
		textbox => [ $interface->get_textbox ],
	};
	$interface->draw($ref);
}
