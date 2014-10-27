package Encounter;
require Character;
require Player;
require Enemy;

sub new
{
	my $class = shift;
	my $player = shift;
	my $enemy = shift;

	# Construct the menu of possible actions:
	my $menu =
	[
		# Generic attack:
		{
			text => "Attack",
			sub => sub
			{
				my $player = shift;
				my $enemy = shift;
				my %p_stats = %{$player->total_stats};
				my %s_stats = %{$enemy->total_stats};

				my $enemy_dmg =
					int(($p_stats{strength} - $e_stats{defence}) * rand(1));

				my $player_dmg =
					int(($e_stats{strength} - $p_stats{defence}) * rand(1));

				$enemy_dmg = 0 if($enemy_dmg < 0);
				$player_dmg = 0 if($player_dmg < 0);

				$player->add_health(-$player_dmg);
				$enemy->add_health(-$enemy_dmg);

				# Highest speed goes first, player if tie:
#				if($p_stats{speed} >= $e_stats{speed})
#				{
#				}
#				else
#				{
#				}
			}
		},
	];

	bless { player => $player, enemy => $enemy, selected => 0, menu => $menu },
		$class;
}

sub menu
{
	my $self = shift;
	my $menu = [ { x => 0, y => 0, text => "Select an action:" } ];
	for(my $i; $i < @{$self->{menu}}; $i++)
	{
		# Used to determine if an item is selected or not:
		my $prefix = ($i == $self->{selected}) ? "> " : "  ";
		my $text = $prefix . $self->{menu}->[$i]->{text};

		my $menu_item =
			{ x => 0, y => ($i + 1), text => $text };
		push @$menu, $menu_item;
	}
	$menu;
}

# Performs the selected action:
sub perform_action
{
	my $self = shift;
	my $player = shift;
	my $enemy = shift;
	&{$self->{menu}->[$self->{selected}]->{sub}}
		($self->{player}, $self->{enemy});
}

# Moves the current selection:
sub move_selection
{
	my $self = shift;
	my $mod = shift;
	if((($self->{selected} + $mod) >= 0) && ($self->{selected} + $mod) < @{$self->{menu}})
	{
		$self->{selected} += $mod;
	}
}

# Checks the health of both parties to see if the encounter is over:
sub is_over
{
	my $self = shift;
	if(($self->{player}->health <= 0) || ($self->{enemy}->health) <= 0) { 1 }
}

# Returns the reference to the attached enemy:
sub enemy
{
	my $self = shift;
	$self->{enemy};
}

1;
