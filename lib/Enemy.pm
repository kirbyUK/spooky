package Enemy;
use parent qw(Character);
use Data::Dumper;

sub symbol { "X" }

sub set_position
{
	my $self = shift;
	my $position = shift;
	$self->{position} = $position;
}

sub move
{
	my $self = shift;
	my $player = shift;

	open my $file, '>', "debug";
	print $file Dumper($player);

	# Homes in on the player:
	$self->position->{x} += ($player->position->{x} <=> $self->position->{x});
	$self->position->{y} += ($player->position->{y} <=> $self->position->{y});
}

1;
