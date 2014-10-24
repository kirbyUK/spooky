package Enemy;
use parent qw(Character);

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

	# Homes in on the player:
	$self->position->{x} += ($player->position->{x} <=> $self->position->{x});
	$self->position->{y} += ($player->position->{y} <=> $self->position->{y});
}

1;
