#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Interface;
use Map;

# I am so, SO sorry...

#Seed the RNG:
srand time;

# Initialise the interface:
my $interface = Interface->new;

# Make the character:
my $player = Character->new;

# Make the map:
my $map = Map->new;

# Generate a stat spread the player is happy with:
$interface->set_textbox({ text => "Is this stat spead ok? [Y\\n]",
	x => 1, y => 1 });
do
{
	$player->generate_new_stats;
	&draw;
} while(! $interface->input_yesno);

$interface->reset_textbox;
&draw;

Curses::getch;

# Close the interface:
$interface->close;

# Draws all the stuff needed:
sub draw
{
	my $ref =
	{
		# The main window
		main => $map->get_map_slice
		({
			x => $player->position->{x},
			y => $player->position->{y},
			width => $interface->get_window_dimensions("main")->{width},
			height => $interface->get_window_dimensions("main")->{height},
		}),

		# The stats window:
		stats =>
		[
			{
				x => 0,
				y => 0,
				text => "Strength: ${\$player->stats->{strength}}",
			},
			{
				x => 0,
				y => 1,
				text => "Defence:  ${\$player->stats->{defence}}",
			},
			{
				x => 0,
				y => 2,
				text => "Speed:    ${\$player->stats->{speed}}",
			},
		],

		# The textbox:
		textbox => [ $interface->get_textbox ],
	};
	$interface->draw($ref);
}
