# Games::Checkers, Copyright (C) 1996-2012 Mikhael Goikhman, migo@cpan.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

package Games::Checkers::Board;

use Games::Checkers::Constants;
use Games::Checkers::Iterators;

sub init_default ($) {
	my $self = shift;

	$self->init_empty;
	my $locs = $self->locs;

	for (0 .. $self->default_rows * $self->size_x / 2 - 1) {
		$self->set(            $_, White, Pawn);
		$self->set($locs - 1 - $_, Black, Pawn);
	}
}

sub init_empty ($) {
	my $self = shift;

	vec($$self, $_, 1) = 0 for 0 .. 3 * $self->locs - 1;
}

sub init ($$) {
	my $self = shift;
	my $board_or_locs = shift;

	my $param_class = ref($board_or_locs);

	# support Board param
	if ($param_class && $param_class->isa('Games::Checkers::Board')) {
		return $self->copy($board_or_locs);
	}

	if (!$board_or_locs || $board_or_locs eq 'default') {
		$self->init_default;
		return $self;
	}

	$self->init_empty;

	# support "a1,a3/h6/h2/b8" or "/22,4,8/9" param
	if (!$param_class) {
		my @l;
		if ($board_or_locs eq 'random') {
			push @{$l[4 * rand() ** 2] ||= []}, $_ for grep { rand(2) > 1 } 1 .. $self->locs;
		} elsif ($board_or_locs ne 'empty') {
			@l = map { [ split ',' ] } split '/', $board_or_locs;
		}
		$board_or_locs = \@l;
		$param_class = 'ARRAY';
	}

	die "Unsupported $board_or_locs param in Board::init\n"
		unless $param_class eq 'ARRAY';

	# support [ [], [ 22, 4, 8 ], [ 9 ] ] param
	my @piece_color_locs = @$board_or_locs;
	for my $piece (Pawn, King) {
		for my $color (White, Black) {
			my $locs = shift @piece_color_locs || [];
			for my $loc (@$locs) {
				$loc = ref($loc) eq 'ARRAY'
					? $self->arr_to_loc($loc->[0], $loc->[1])
					: $loc =~ /^\d/
						? $self->num_to_loc($loc)
						: $self->str_to_loc($loc);
				$self->set($loc, $color, $piece);
				$self->cnv($loc) if $piece == Pawn && $self->is_crowning->[$color][$loc];
			}
		}
	}

	return $self;
}

sub new ($;$$) {
	my $class = shift;
	my $board_or_locs = shift;
	my $size = shift;

	if ($class eq __PACKAGE__) {
		$size ||= 8;
		$size = "${size}x$size" if $size =~ /^\d+$/;
		$class = __PACKAGE__ . "::_$size";
		eval "use $class"; die $@ if $@;
	}

	my $data = '';
	my $self = \$data;
	bless $self, $class;

	return $self->init($board_or_locs);
}

sub notation ($) {
	# BL - 0, BR - 1, TL - 2, TR - 3
	return $ENV{ITALIAN_BOARD_NOTATION} ? 3 : 1;
}

sub size_x_1 ($) {
	return $_[0]->size_x - 1;
}

sub size_x_2 ($) {
	return $_[0]->size_x / 2;
}

sub size_y_1 ($) {
	return $_[0]->size_y - 1;
}

sub loc_to_arr ($$) {
	my $self = shift;
	my $loc = shift;

	my $size_x_2 = $self->size_x_2;

	return (int($loc % $size_x_2) * 2 + int(($loc / $size_x_2) % 2) + 1, int($loc / $size_x_2) + 1);
}

sub arr_to_loc ($$$) {
	my $self = shift;
	my ($x, $y) = @_;

	return int(($x - 1) / 2) + ($y - 1) * $self->size_x_2;
}

sub ind_to_chr ($$) {
	my $self = shift;
	my $ind = shift;
	
	return chr(ord('a') + $ind - 1 + ($ind >= 10));
}

sub chr_to_ind ($$) {
	my $self = shift;
	my $chr = shift;
	
	return ord($chr) - ord('a') + 1 - ($chr ge 'j');
}

sub loc_to_str ($$) {
	my $self = shift;
	my $loc = shift;

	my @c = $self->loc_to_arr($loc);

	return $self->ind_to_chr($c[0]) . $c[1];
}

sub str_to_loc ($$) {
	my $self = shift;
	my $str = shift;

	$str =~ /^(\w)(\d)$/ || die "Invalid board coordinate string ($str)\n";

	return $self->arr_to_loc($self->chr_to_ind($1), $2);
}

sub loc_to_num ($$) {
	my $self = shift;
	my $loc = shift;

	my $size_x_2 = $self->size_x_2;
	my $notation = $self->notation;

	my $num = $notation == 1 || $notation == 2
		? (int($loc / $size_x_2) + 1) * $size_x_2 - $loc % $size_x_2
		: $loc + 1;

	return $notation <= 1 ? $num : $self->locs - 1 - $num;
}

sub num_to_loc ($$) {
	my $self = shift;
	my $num = shift;

	my $size_x_2 = $self->size_x_2;
	my $notation = $self->notation;

	my $loc = $notation == 1 || $notation == 2
		? (int(($num - 1) / $size_x_2) + 1) * $size_x_2 - 1 - ($num - 1) % $size_x_2
		: $num - 1;

	return $notation <= 1 ? $loc : $self->locs - 1 - $loc;
}

sub occup ($$) {
	my $self = shift;
	my $loc = shift;
	return vec($$self, $loc, 1);
}

sub color ($$) {
	my $self = shift;
	my $loc = shift;
	return vec($$self, $loc + $self->locs, 1);
}

sub piece ($$) {
	my $self = shift;
	my $loc = shift;
	return vec($$self, $loc + $self->locs * 2, 1);
}

sub white ($$) {
	my $self = shift;
	my $loc = shift;
	return $self->occup($loc) && $self->color($loc) == White;
}

sub black ($$) {
	my $self = shift;
	my $loc = shift;
	return $self->occup($loc) && $self->color($loc) == Black;
}

sub clone ($) {
	my $self = shift;

	return ref($self)->new($self);
}

sub copy ($$) {
	my $self = shift;
	my $board = shift;

	die "Can't copy $board to $self\n" unless ref($self) eq ref($board);
	$$self = $$board;

	return $self;
}

sub equals ($$) {
	my $self = shift;
	my $board = shift;

	return ref($self) eq ref($board) && $$self eq $$board;
}

sub clr_all ($) {
	my $self = shift;
	vec($$self, $_, 1) = 0 for 0 .. $self->locs - 1;
}

sub clr ($$) {
	my $self = shift;
	my $loc = shift;
	vec($$self, $loc, 1) = 0;
}

sub cnv ($$) {
	my $self = shift;
	my $loc = shift;
	vec($$self, $loc + 2 * $self->locs, 1) ^= 1;
}

sub set ($$$$) {
	my $self = shift;
	my ($loc, $color, $piece) = @_;

	my $locs = $self->locs;

	vec($$self, $loc + 0 * $locs, 1) = 1;
	vec($$self, $loc + 1 * $locs, 1) = $color;
	vec($$self, $loc + 2 * $locs, 1) = $piece;
}

sub chk ($$$$) {
	my $self = shift;
	my ($loc, $color, $piece) = @_;
	return
		$self->occup($loc) &&
		$self->color($loc) == $color &&
		$self->piece($loc) == $piece ? 1 : 0;
}

sub get_cost ($$) {
	my $self = shift;
	my $turn = shift;

	my $size_y_1 = $self->size_y_1;
	my $size_x_2 = $self->size_x_2;

	# Count white & black figures
	my (
		$white_pawns, $white_kings, $white_bonus,
		$black_pawns, $black_kings, $black_bonus
	) = (0) x 6;

	my $whites_iterator = new Games::Checkers::FigureIterator($self, White);
	while ($whites_iterator->left) {
		my $loc = $whites_iterator->next;
		my $is_pawn = $self->piece($loc) == Pawn;
		$is_pawn ? $white_pawns++ : $white_kings++;
		$white_bonus += int($loc / $size_x_2) if $is_pawn;
	}

	my $blacks_iterator = new Games::Checkers::FigureIterator($self, Black);
	while ($blacks_iterator->left) {
		my $loc = $blacks_iterator->next;
		my $is_pawn = $self->piece($loc) == Pawn;
		$is_pawn ? $black_pawns++ : $black_kings++;
		$black_bonus += $size_y_1 - int($loc / $size_x_2) if $is_pawn;
	}

	return -1e8 if $white_pawns + $white_kings == 0;
	return +1e8 if $black_pawns + $black_kings == 0;

	return
		+ $white_pawns * 100
		+ $white_kings * 600
		+ $white_bonus * 10
		- $black_pawns * 100
		- $black_kings * 600
		- $black_bonus * 10
		+ ($turn == White ? 1 : -1);
}

sub step_destinations ($$;$$) {
	my $self = shift;
	my $loc = shift;
	my $piece = shift;
	my $color = shift;

	(defined $piece ? $piece : $self->piece($loc)) == Pawn
		? $self->pawn_step->[defined $color ? $color : $self->color($loc)][$loc]
		: $self->king_step->[$loc];
}

sub beat_destinations ($$;$$) {
	my $self = shift;
	my $loc = shift;
	my $piece = shift;
	my $color = shift;

	(defined $piece ? $piece : $self->piece($loc)) == Pawn
		? $self->pawn_beat->[$loc]
		: $self->king_beat->[$loc];
}

sub apply_move ($) {
	my $self = shift;
	my $move = shift;

	my $src = $move->source;
	my $dst = $move->destin(0);
	my $beat = $move->is_beat;
	my $color = $self->color($src);
	my $piece = $self->piece($src);
	for (my $n = 0; $dst != NL; $src = $dst, $dst = $move->destin(++$n)) {
		$self->clr($src);
		$self->set($dst, $color, $piece);
		$self->clr($self->figure_between($src, $dst)) if $beat;
		# convert to king if needed
		if ($piece == Pawn && $self->is_crowning->[$color][$dst]) {
			$self->cnv($dst);
			$piece ^= 1;
		}
	}
}

sub can_piece_step ($$;$) {
	my $self = shift;
	my $loc = shift;
	my $locd = shift;
	$locd = NL unless defined $locd;

	if (!$self->occup($loc)) {
		warn("Internal error in can_piece_step, loc=$loc is not occupied");
		&DIE_WITH_STACK();
		return No;
	}
	for my $loc2 (@{$self->step_destinations($loc)}) {
		next if $locd != NL && $locd != $loc2;
		next if $self->figure_between($loc, $loc2) != NL;
		return Yes unless $self->occup($loc2);
	}
	return No;
}

sub can_piece_beat ($$;$) {
	my $self = shift;
	my $loc = shift;
	my $locd = shift;
	$locd = NL unless defined $locd;

	if (!$self->occup($loc)) {
		warn("Internal error in can_piece_beat, loc=$loc is not occupied");
		&DIE_WITH_STACK();
		return No;
	}
	my $color = $self->color($loc);
	for my $loc2 (@{$self->beat_destinations($loc)}) {
		next if $locd != NL && $locd != $loc2;
		my $loc1 = $self->figure_between($loc, $loc2);
		next if $loc1 == NL || $loc1 == ML;
		return Yes unless $self->occup($loc2) ||
			!$self->occup($loc1) || $self->color($loc1) == $color;
	}
	return No;
}

sub can_color_step ($$) {
	my $self = shift;
	my $color = shift;
	my $iterator = Games::Checkers::FigureIterator->new($self, $color);
	while ($iterator->left) {
		return Yes if $self->can_piece_step($iterator->next);
	}
	return No;
}

sub can_color_beat ($$) {
	my $self = shift;
	my $color = shift;
	my $iterator = Games::Checkers::FigureIterator->new($self, $color);
	while ($iterator->left) {
		return Yes if $self->can_piece_beat($iterator->next);
	}
	return No;
}

sub can_color_move ($$) {
	my $self = shift;
	my $color = shift;
	return $self->can_color_beat($color) || $self->can_color_step($color);
}

sub figure_between ($$$) {
	my $self = shift;
	my $src = shift;
	my $dst = shift;

	my $num_directions = @{$self->loc_directions->[$src]};
	for (my $drc = 0; $drc < $num_directions; $drc++) {
		my $figures = 0;
		my $figure = NL;
		for (my $loc = $self->loc_directions->[$src][$drc];
			$loc != NL; $loc = $self->loc_directions->[$loc][$drc]
		) {
			if ($loc == $dst) {
				return $figures > 1 ? ML : $figures == 1 ? $figure : NL;
			}
			if ($self->occup($loc)) {
				$figure = $loc;
				$figures++;
			}
		}
	}
	return NL;
}

#
#   +-------------------------------+
# 8 |###| @ |###| @ |###| @ |###| @ |
#   |---+---+---+---+---+---+---+---|
# 7 | @ |###| @ |###| @ |###| @ |###|
#   |---+---+---+---+---+---+---+---|
# 6 |###| @ |###| @ |###| @ |###| @ |
#   |---+---+---+---+---+---+---+---|
# 5 |   |###|   |###|   |###|   |###|
#   |---+---+---+---+---+---+---+---|
# 4 |###|   |###|   |###|   |###|   |
#   |---+---+---+---+---+---+---+---|
# 3 | O |###| O |###| O |###| O |###|
#   |---+---+---+---+---+---+---+---|
# 2 |###| O |###| O |###| O |###| O |
#   |---+---+---+---+---+---+---+---|
# 1 | O |###| O |###| O |###| O |###|
#   +-------------------------------+
#     a   b   c   d   e   f   g   h  
#

sub dump ($;$$$) {
	my $self = shift;
	my $sprefix = shift || "";
	my $cprefix = shift || "";
	my $compact = shift || $ENV{COMPACT_BOARD};

	my $char_sets = [
		{
			tlc => "+",
			trc => "+",
			blc => "+",
			brc => "+",
			vcl => "|",
			vll => "|",
			vrl => "|",
			hcl => "-",
			htl => "-",
			hbl => "-",
			ccl => "+",
			bcs => "",
			bce => "",
			bcf => " ",
			wcs => "",
			wce => "",
			wcf => "#",
		},
		{
			tlc => "\e)0\016l\017",
			trc => "\016k\017",
			blc => "\016m\017",
			brc => "\016j\017",
			vcl => "\016x\017",
			vll => "\016t\017",
			vrl => "\016u\017",
			hcl => "\016q\017",
			htl => "\016w\017",
			hbl => "\016v\017",
			ccl => "\016n\017",
			bcs => "\e[0;7m",
			bce => "\e[0m",
			bcs => "",
			bce => "",
			bcf => " ",
			wcs => "",
			wce => "",
			wcs => "\e[0;7m",
			wce => "\e[0m",
			wcf => " ",
		},
	];
	my %ch = %{$char_sets->[$ENV{DUMB_CHARS} ? 0 : 1]};

	my $size_x   = $self->size_x;
	my $size_y   = $self->size_y;
	my $size_x_1 = $self->size_x_1;
	my $size_x_2 = $self->size_x_2;
	my $size_y_1 = $self->size_y_1;

	my $str = "";
	$str .= "\n";
	$str .= "   " . $ch{tlc} . ("$ch{hcl}$ch{hcl}$ch{hcl}$ch{htl}" x $size_x_1) . "$ch{hcl}$ch{hcl}$ch{hcl}$ch{trc}\n"
		unless $compact;
	for (my $i = 0; $i < $size_y; $i++) {
		$str .= sprintf("%2d", $size_y - $i) . " $ch{vcl}";
		for (my $j = 0; $j < $size_x; $j++) {
			my $is_used = ($i + $j) % 2;
			if (($i + $j) % 2) {
				my $loc = ($size_y_1 - $i) * $size_x_2 + int($j / 2);
				my $ch0 = $ch{bcf};
				my $is_king = $self->piece($loc) == King;
				$ch0 = $self->white($loc) ? $is_king ? "8" : "O" : $is_king ? "&" : "@"
					if $self->occup($loc);
				$ch0 = $self->white($loc) ? "\e[1m$ch0\e[0m" : "\e[4m$ch0\e[0m"
					if $self->occup($loc);
				$str .= "$ch{bcs}$ch{bcf}$ch0$ch{bcs}$ch{bcf}$ch{bce}";
			} else {
				$str .= "$ch{wcs}$ch{wcf}$ch{wcf}$ch{wcf}$ch{wce}";
			}
			$str .= $ch{vcl};
		}
		$str .= "\n";
		$str .= "   " . $ch{vll} . ("$ch{hcl}$ch{hcl}$ch{hcl}$ch{ccl}" x $size_x_1) . "$ch{hcl}$ch{hcl}$ch{hcl}$ch{vrl}\n"
			unless $compact || $i == $size_y_1;
	}
	$str .= "   " . $ch{blc} . ("$ch{hcl}$ch{hcl}$ch{hcl}$ch{hbl}" x $size_x_1) . "$ch{hcl}$ch{hcl}$ch{hcl}$ch{brc}\n"
		unless $compact;
   $str .= "     " . join('', map { $self->ind_to_chr($_) . "   " } 1 .. $size_x) . "\n";
	$str .= "\n" unless $compact;

	$str =~ s/(?:^.|)(?:\e\)0)?((?:\e.*?m)*.(?:\e.*?m)*)(\016.\017|.)((?:\e.*?m)*)(\016.\017|.)((?:\e.*?m)*)(\016.\017|.)((?:\e.*?m)*)/$1$3$5$7/mg
		if $compact;

	# prepare prefix for each board line, if any
	my $lines = () = $str =~ /\n/g;
	$sprefix = " " x ($size_x_2 / ($compact && 2.5 || 1) * $sprefix) if $sprefix =~ /^\d+$/;
	my @cprefix = $cprefix ? $cprefix =~ /(\w\d[:-]\w\d|:\w\d|-\d{1,5}|\d{1,6})/g : ();
	my $l = 0;
	my @prefix = map {
		my $p = $sprefix ? $sprefix =~ s!(.*)\n!! ? $1 : $sprefix : '';
		$p .= sprintf " %6s  ", @cprefix && $l++ >= ($lines - @cprefix) / 2 ? shift @cprefix : ''
			if $cprefix;
		$p
	} 1 .. $lines;

	$str =~ s/^/shift @prefix/gme;

	return $str;
}

1;
