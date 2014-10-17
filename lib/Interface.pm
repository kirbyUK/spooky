package Interface;
use Curses;

# Lump windows in an easy-to-use package:
package Window
{
	# The box drawing chracters for the window's border:
	my %BOX_CHARS =
	(
		corners =>
		{
			topleft => "┌",
			topright => "┐",
			bottomleft => "└",
			bottomright => "┘"
		},
		horizontal => "─",
		vertical => "│"
	);

	# Creates a new window:
	sub new
	{
		my $class = shift;
		my $properties = shift;
		$$properties{window} = Curses::newwin(
			$$properties{height},
			$$properties{width},
			$$properties{y},
			$$properties{x}
		);
		bless $properties, $class;
	}

	# Draws the window:
	sub draw
	{
		my $self = shift;
		Curses::clear($self->{window});
		Curses::border(
			$self->{window},
			$BOX_CHARS{vertical},
			$BOX_CHARS{vertical},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{corners}{topleft},
			$BOX_CHARS{corners}{topright},
			$BOX_CHARS{corners}{bottomleft},
			$BOX_CHARS{corners}{bottomright}
		);
		Curses::refresh($self->{window});
	}
};

# Set up curses and the interface:
sub new
{
	my $class = shift;

	# Initialise curses:
	Curses::initscr();
	Curses::clear();

	# Create the main window:
	Curses::getmaxyx(my $y, my $x);
	my $w = Window->new({
		width => ($x - 20),
		height => ($y - 20),
		x => 10,
		y => 10,
	});
	my $stuff = {
		windows => [
			$w,
		],
	};
	bless $stuff, $class;
}

# Close curses:
sub close
{
	Curses::endwin;
}

# Draw the interface:
sub draw
{
	my $self = shift;
	Curses::clear();
	Curses::refresh;
	my $windows = $self->{windows};
	for my $win(@$windows) { $win->draw }
}

1;
