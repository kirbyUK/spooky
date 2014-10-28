package Costume;

sub new
{
	my $class = shift;

	# Right so JSON can't export subs so we'll do it live!
	my $costumes =
	[
		{
			name => "Toilet Paper Mummy of Cheapness",
			buffs =>
			{
				strength => 0,
				defence => 0,
				speed => 0
			}
		},
		{
			name => "'My Costume Didn't Arrive I Swear it was Great'",
			buffs =>
			{
				strength => 1,
				strength => 0
			}
		},
		{
			name => "Frankenstein's Monster's Bride's Daughter's Dress",
			buffs =>
			{
				strength => 2,
				defence => 2,
			}
		},
		{
			name => "Inappropriate Female Halloween Attire",
			buffs =>
			{
				strength => 3,
				defence => 0,
			}
		#	attack =>
		#	{
		#		text => "Lemme take a #SELFIE",
		#		sub => sub
		#		{
		#		}
		#	}
		},
		{
			name => "Candy (tm) Crush Toga",
			buffs =>
			{
				strength => 3,
				defence => 1,
			},
			attack =>
			{
				text => "Ever played Bejeweled? (-2 candy, +2 strength)",
				sub => sub
				{
					my $player = shift;
					my $enemy = shift;
					my %p_stats = %{$player->total_stats};
					my %s_stats = %{$enemy->total_stats};

					my $enemy_dmg;
					if($player->candy >= 2)
					{
						$enemy_dmg =
							int((($p_stats{strength} + 2) - $e_stats{defence}) * rand(1));
						$player->add_candy(-2);
					}
					else
					{
						$enemy_dmg =
							int((($p_stats{strength}) - $e_stats{defence}) * rand(1));
					}

					my $player_dmg =
						int(($e_stats{strength} - $p_stats{defence}) * rand(1));

					$enemy_dmg = 0 if($enemy_dmg < 0);
					$player_dmg = 0 if($player_dmg < 0);
				}
			}
		},
		{
			name => "Cheaply-made Gorilla Suit",
			buffs =>
			{
				strength => 4,
				defence => 1,
			}
		},
		{
			name => "Adobe Photoshop Pirate",
			buffs =>
			{
				strength => 3,
				defence => 2,
			}
		},
	];
	bless $costumes, $class;
}

1;
