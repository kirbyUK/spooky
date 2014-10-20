package Character;
use POSIX;

sub new
{
	my $class = shift;
	my $properties =
	{
		# The position (relative to the main window, not stdscr):
		position =>
		{
			x => 25,
			y => 25,
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
	my $a = int(rand(25) + 5);
	my $b = int(rand(30) + 5);
	my $c = int(rand(25) + 5);
	my $k = (($a + $b + $c) / 30);
	my @values = map { floor($_ /= $k) } ($a, $b, $c);
	$self->{stats} =
	{
		strength => $values[0],
		defence => $values[1],
		speed => $values[2],
	};
}

# Gets the player's stats:
sub stats
{
	my $self = shift;
	$self->{stats};
}

1;
