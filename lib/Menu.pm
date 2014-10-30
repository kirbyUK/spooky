package Menu;

sub new
{
	my $class = shift;
	my $height = shift;
	my $items = shift;

	bless { height => $height, items => $items, selection => 0 }, $class;
}

sub drawable
{
	my $self = shift;
	my $drawables = [ ];
	for(my $i = $self->{selection}; $i < $self->{height}; $i++)
	{
		last if($i >= @{$self->{items}});
		my $prefix = "  ";
		if($i == $self->{selection}) { $prefix = "> " }
		push @$drawables, { x => 0, y => $i,
			text => ($prefix . $self->{items}->[$i]->{name}) };
	}
	$drawables;
}

sub handle_input
{
	my $self = shift;
	my $input = shift;

	if($input =~ /[wk]/i) { $self->{selection}++; }
	if($input =~ /[sj]/i) { $self->{selection}--; }
}

1;
