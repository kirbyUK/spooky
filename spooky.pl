#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Player;
use Enemy;
use Interface;
use Map;

# I am so, SO sorry...

#Seed the RNG:
srand time;

# Initialise the interface:
our $interface = Interface->new;

# Make the character:
our $player = Player->new(20);

# An array to hold all the enemies:
our @enemies = ();

# Make the map:
our $map = Map->new;

&main;

# The main function:
sub main
{
	# Generate a stat spread the player is happy with:
	$interface->set_textbox({ text => "Is this stat spread ok? [Y\\n]",
		x => 1, y => 3 });
	do
	{
		$player->generate_new_stats(30);
		&draw;
	} while(! $interface->input_yesno);

	$interface->reset_textbox;
	&draw;

	# The difficulty modifier that controls things like enemy stats and spawn
	# rate:
	my $difficulty_mod = 0.1;

	# The number of frames we've been through:
	my $frame = 0;

	# The main game loop:
	while($player->health > 0)
	{
		# Get input:
		my $input = Curses::getch;

		# Move the player:
		$player->move($interface->get_vector($input));

		# Possible generate a new enemy:
		if(rand(3) <= $difficulty_mod)
		{
			my $enemy = Enemy->new(int($difficulty_mod * 50));
			$enemy->move({ x => int(rand($map->get_size->{x})),
				y => int(rand($map->get_size->{y})) });

			push @enemies, $enemy;
		}

		# Draw the frame:
		&draw;
		$frame++;
		$difficulty_mod += 0.2;
	}

	# Close the interface:
	$interface->close;
}

# Draws all the stuff needed:
sub draw
{
	# There is a lot to draw to the main window, so let's deal with all that:
	my $main = $map->get_map_slice
	({
		x => $player->position->{x},
		y => $player->position->{y},
		width => $interface->get_window_dimensions("main")->{width},
		height => $interface->get_window_dimensions("main")->{height},
	});
	push @$main, $player->get_drawable;
	for(@enemies) { push @$main, $_->get_drawable; }

	my $ref =
	{
		# The main window
		main => $main,

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
			{
				x => 0,
				y => 3,
				text => "-----------------",
			},
			{
				x => 0,
				y => 4,
				text => "Health:   ${\$player->health}",
			},
			{
				x => 0,
				y => 5,
				text => "Candy:    ${\$player->candy}",
			},
		],

		# The textbox:
		textbox => [ $interface->textbox ],
	};
	$interface->draw($ref);
}
