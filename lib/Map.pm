package Map;

my $MAP_FILE = "assets/map";

sub new
{
	my $class = shift;
	open my $file, '<', $MAP_FILE or die "Cannot open file '$MAP_FILE': $!\n";
	chomp(my @file = <$file>);
	my @map;
	for my $line(@file)
	{
		my @chars = split //, $line;
		push @map, \@chars;
	}
	bless \@map, $class;
}

sub get_map_slice
{
	my $self = shift;
	my $rect = shift;
	my ($x_min, $y_min, $x_max, $y_max, $width, $height);
	$width = $rect->{width} - 2;
	$height = $rect->{height} - 2;
	if(($rect->{x} - $width) > 0)
	{
		$x_min = int($rect->{x} - ($width / 2));
		$x_max = int($rect->{x} + ($width / 2));
	}
	else
	{
		$x_min = 0;
		$x_max = $width - 1;
	}
	if(($rect->{y} - ($height / 2)) > 0)
	{
		$y_min = int($rect->{y} - ($height / 2));
		$y_max = int($rect->{y} + ($height / 2));
	}
	else
	{
		$y_min = 0;
		$y_max = $height - 1;
	}
	# Get a slice of the map and convert it to a format Interface::draw likes
	# (an array reference containing hash references):
	my @slice;
	for(my $i = $y_min; $i < $y_max; $i++)
	{
		my @line = @{$self->[$i]};
		my $text = join "", @line[$x_min..$x_max];
		push @slice, { x => 0, y => ($i - $y_min), text => $text };
	}
	\@slice;
}

1;
