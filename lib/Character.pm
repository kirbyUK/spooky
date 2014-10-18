package Character;

sub new
{
	my $class = shift;
	my $properties =
	{
		# The position (relative to the main window, not stdscr):
		position =>
		{
			x => 100,
			y => 100,
		},

		# The characters stats (these are initalised with generate_new_stats):
		stats =>
		{
			strength => 0,
			defence => 0,
			speed => 0,
		},

		# The amount of candy the player has:
		candy => 5,
	};
	bless $properties, $class;
}

# Modifies the player's position:
sub move
{
	my $self = shift;
	my $vector = shift;
	$self->{position}->{x} += $vector->{x};
	$self->{position}->{y} += $vector->{y};
}

# Returns the player's position:
sub position
{
	my $self = shift;
	$self->{position};
}

# Adds the given amount of candy:
sub add_candy
{
	my $self = shift;
	my $value = shift;
	$self->{candy} += $value;
}

# Gets candy:
sub candy
{
	my $self = shift;
	$self->{candy};
}

# Generates a new stat spread:
sub generate_new_stats
{
	my $self = shift;
	$self->{stats} =
	{
		strength => 10,
		defence => 10,
		speed => 10,
	};
}

# Gets the player's stats:
sub stats
{
	my $self = shift;
	$self->{stats};
}

1;
