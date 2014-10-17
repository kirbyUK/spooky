package Interface;
use Curses;
use Data::Dumper 'Dumper';

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
	Curses::initscr();
	Curses::clear();
	my $w = Window->new({
		height => 25,
		width => 50,
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
	endwin;
}

# Draw the interface:
sub draw
{
	my $self = shift;
	Curses::clear();
	my $windows = $self->{windows};
	for my $win(@$windows) { $win->draw }
	Curses::refresh;
}

1;
