#!/usr/bin/perl -w -Ilib
use strict;
use Character;
use Player;
use Enemy;
use Interface;
use Map;
use Encounter;
use Costume;

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
	my $costumes = Costume->new;

	# As we defeat enemies, we traverse the costume array to get better ones:
	my $costume_value = 0;

	# Set the player's costume:
	$player->add_costume($$costumes[0]);
	$player->set_costume(0);

	# Generate a stat spread the player is happy with:
	$interface->set_textbox([{ text => "Is this stat spread ok? [Y\\n]",
		x => 1, y => 2 }]);
	do
	{
		$player->generate_new_stats(20);
		&draw;
	} while(! $interface->input_yesno);

	$interface->reset_textbox;
	&draw;

	# Any enouncters that are ongoing or in the queue:
	my @encounters;

	# The difficulty modifier that controls things like enemy stats and spawn
	# rate:
	my $difficulty_mod = 0.1;

	# The number of frames we've been through:
	my $frame = 0;

	# The main game loop:
	while($player->health > 0)
	{
		# No movement happens while we're in an encounter:
		if(@encounters == 0)
		{
			# Get input:
			my $input = Curses::getch;

			# Move the player:
			$player->move($interface->get_vector($input));

			# Possible generate a new enemy:
			if(rand(3) <= $difficulty_mod)
			{
				my $enemy = Enemy->new(int($difficulty_mod * 10));
				$enemy->set_position({ x => int(rand($map->get_size->{x})),
					y => int(rand($map->get_size->{y})) });

				$enemy->generate_new_stats(int(rand(2) * $difficulty_mod * 50));
				push @enemies, $enemy;
			}

			# Move the enemies:
			for(@enemies) { $_->move($player); }

			# Check for any adjascent enemies:
			for my $enemy(@enemies)
			{
				my %enemy_pos = %{$enemy->position};
				my %pos = %{$player->position};
				for(my $i; $i < 3; $i++)
				{
					for(my $j; $j < 3; $j++)
					{
						if((($enemy_pos{x} + $j) == $pos{x}) &&
						($enemy_pos{y} + $i) == $pos{y})
						{
							my $encounter = Encounter->new($player, $enemy);
							push @encounters, $encounter;
						}
					}
				}
			}
		}
		# Otherwise, process the ongoing encounter:
		else
		{
			$interface->set_textbox($encounters[0]->menu);
			&draw;
			my $input = Curses::getch;

			# Check the input:
			if($input =~ /^[wk]$/i) { $encounters[0]->move_selection(-1); }
			if($input =~ /^[sj]$/i) { $encounters[0]->move_selection(1);  }
			if($input =~ /^\n$/)    { $encounters[0]->perform_action;     }

			# If the encounter is over, destroy it and reset the textbox:
			if($encounters[0]->is_over)
			{
				$interface->reset_textbox;
				for(my $i = 0; $i < @enemies; $i++)
				{
					if($enemies[$i] == $encounters[0]->enemy)
					{
						splice(@enemies, $i, 1);
						last;
					}
				}
				shift @encounters;
			}
		}

		# Draw the frame:
		&draw;
		$difficulty_mod += 0.1 if(($frame++ % 10) == 0);
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
				x => 13,
				y => 0,
				text => "(+${\$player->costume->{buffs}->{strength}})",
			},
			{
				x => 0,
				y => 1,
				text => "Defence:  ${\$player->stats->{defence}}",
			},
			{
				x => 13,
				y => 1,
				text => "(+${\$player->costume->{buffs}->{defence}})",
			},
			{
				x => 0,
				y => 2,
				text => "-" x ($interface->get_window_dimensions("stats")->
					{width} - 2),
			},
			{
				x => 0,
				y => 3,
				text => "Health:   ${\$player->health}",
			},
			{
				x => 0,
				y => 4,
				text => "Candy:    ${\$player->candy}",
			},
		],

		# The textbox:
		textbox => $interface->textbox,

		# The player's current costume:
		costume =>
		[
			{
				x => (($interface->get_window_dimensions("costume")->{width} -
						length($player->costume->{name})) / 2),
				y => 0,
				text => $player->costume->{name},
			}
		],
	};
	$interface->draw($ref);
}
