package Interface;
use Curses;

# Lump windows in an easy-to-use package:
package Window
{
	my %BOX_CHARS =
	(
		corners =>
		{
			topleft => "+",
			topright => "+",
			bottomleft => "+",
			bottomright => "+"
		},
		horizontal => "-",
		vertical => "|"
	);
#	my %BOX_CHARS =
#	(
#		corners =>
#		{
#			topleft => "┌",
#			topright => "┐",
#			bottomleft => "└",
#			bottomright => "┘"
#		},
#		horizontal => "─",
#		vertical => "│"
#	);

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

	sub draw
	{
		my $class = shift;
		clear($class->window);
		border(
			$class->window,
			$BOX_CHARS{vertical},
			$BOX_CHARS{vertical},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{horizontal},
			$BOX_CHARS{corners}{topleft},
			$BOX_CHARS{corners}{topright},
			$BOX_CHARS{corners}{bottomleft},
			$BOX_CHARS{corners}{bottomright}
		);
		refresh($class->window);
	}

	sub window
	{
		$$properties{window};
	}
};

sub new
{
	my $class = shift;
	initscr();
	clear();
	my $w = Window->new({
		height => 50,
		width => 200,
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

sub close
{
	endwin;
}

sub draw
{
	my $class = shift;
	my $windows = $class->windows;
	for my $win(@$windows) { $win->draw }
	refresh;
}

sub windows
{
	my $class = shift;
	$$stuff{windows};
}

1;
