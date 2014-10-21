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

# The symbol we use to identify the character on screen:
sub symbol
{
	die "Attempt to call Character::symbol called!\n";
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
	my $total = shift;
	my $a = int(rand($total - 5) + 5);
	my $b = int(rand($total - 5) + 5);
	my $c = int(rand($total - 5) + 5);
	my $k = (($a + $b + $c) / $total);
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

# Returns an anonymous hash reference that can be passed to Window::draw
sub get_drawable
{
	my $self = shift;
	return { x => $self->{position}->{x}, y => $self->position->{y},
		text => $self->symbol };
}

1;
