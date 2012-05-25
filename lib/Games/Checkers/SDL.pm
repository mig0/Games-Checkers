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

package Games::Checkers::SDL;

use Games::Checkers::Constants;
use Games::Checkers::Iterators;
use Games::Checkers::LocationConversions;
use Games::Checkers::Board;

use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Rect;
use SDL::Surface;
use SDL::Video;
use SDL::Image;
use SDLx::Text;

sub rect_to_xywh ($;$) {
	my $surface = shift || die;
	my $rect = shift;

	return (0, 0, $surface->w, $surface->h)
		unless $rect;

	$rect = [ $rect->x, $rect->y, $rect->w, $rect->h ]
		unless ref($rect) eq 'ARRAY';

	$rect->[2] ||= $surface->w - $rect->[0];
	$rect->[3] ||= $surface->h - $rect->[1];

	return @$rect;
}

sub fill_rect_tiled ($$$) {
	my $surface = shift || die;
	my $rect = shift;
	my $tile = shift || die;

	my ($x0, $y0, $w0, $h0) = rect_to_xywh($surface, $rect);
	my $w = $tile->w;
	my $h = $tile->h;

	for (my $x = $x0; $x < $x0 + $w0; $x += $w) {
		for (my $y = $y0; $y < $y0 + $h0; $y += $h) {
			SDL::Video::blit_surface($tile, 0, $surface, SDL::Rect->new($x, $y, $w, $h));
		}
	}
}

sub new ($$$%) {
	my $class = shift;
	my $title = shift || die;
	my $board = shift || die;
	my %params = @_;

	my $image_dir = ($FindBin::Bin || "bin") . "/../data/images";
	$image_dir = ($FindBin::Bin || "bin") . "/../share/pcheckers/images"
		unless -d $image_dir;
	die "No expected image dir $image_dir\n"
		unless -d $image_dir && -x _;

	my $size = $board->get_size;
	my $w = $size == 8 ? 800 : 1024;
	my $h = $size == 8 ? 600 : 768;

	my $fullscreen = $params{fullscreen} ? 1 : 0;

	SDL::init(SDL_INIT_VIDEO);
	my $mode = SDL_HWSURFACE | SDL_HWACCEL | ($fullscreen && SDL_FULLSCREEN);
	my $display = SDL::Video::set_video_mode($w, $h, 32, $mode);

	SDL::Video::wm_set_caption("Checkers: $title", "Checkers");

	my $bg = SDL::Surface->new(SDL_HWSURFACE | SDL_PHYSPAL, $w, $h);

	fill_rect_tiled($bg, 0, SDL::Image::load("$image_dir/bg-tile.jpg"));

	SDL::Video::fill_rect($bg, SDL::Rect->new(41, 41, 64 * $size + 6, 64 * $size + 6), 0x50d050ff);
	SDL::Video::fill_rect($bg, SDL::Rect->new(43, 43, 64 * $size + 2, 64 * $size + 2), 0x202020ff);
	SDL::Video::fill_rect($bg, SDL::Rect->new($w - 18, 2, 16, 16), 0xe0e0e0);
	SDL::Video::fill_rect($bg, SDL::Rect->new($w - 16, 4, 12, 12), 0x707070);
	SDL::Video::fill_rect($bg, SDL::Rect->new($w - 34, 6,  8,  8), 0xf0f0f0);
	SDL::Video::fill_rect($bg, SDL::Rect->new($w - 58, 2, 16, 16), 0xc0c0c0);
	SDL::Video::fill_rect($bg, SDL::Rect->new($w - 55, 5, 10, 10), 0xa0a0a0);

	my $coord_text = SDLx::Text->new(
		size    => 20,
		color   => 0xd8d8d0,
		shadow  => 1,
		h_align => 'center',
	);
	$coord_text->write_xy($bg, 28, 66 + 64 * ($size - $_), $_) for 1 .. $size;
	$coord_text->write_xy($bg, 77 + 64 * $_, $h - 40, chr(ord('a') + $_)) for 0 .. $size-1;

	SDL::Video::blit_surface($bg, 0, $display, 0);

	my @cells = (
		SDL::Image::load("$image_dir/cell-white.png"),
		SDL::Image::load("$image_dir/cell-black.png"),
	);

	for my $x (0 .. $size - 1) {
		for my $y (0 .. $size - 1) {
			SDL::Video::blit_surface(
				$cells[($x + $y) % 2],
				0,
				$bg,
				SDL::Rect->new(44 + 64 * $x, 44 + 64 * $y, 64, 64)
			);
		}
	}

	my $self = {
		board => $board,
		title => $title,
		pieces => {
			&Pawn => {
				&White => SDL::Image::load("$image_dir/pawn-white.png"),
				&Black => SDL::Image::load("$image_dir/pawn-black.png"),
			},
			&King => {
				&White => SDL::Image::load("$image_dir/king-white.png"),
				&Black => SDL::Image::load("$image_dir/king-black.png"),
			},
		},
		w => $w,
		h => $h,
		move_msg_y => 0,
		display => $display,
		bg => $bg,
		event => SDL::Event->new,
		text => SDLx::Text->new(shadow => 1, shadow_offset => 2, size => 20),
		mouse_pressed => 0,
		skip_unpress => 0,
		fullscreen => $fullscreen,
	};

	bless $self, $class;

	return $self;
}

sub init ($) {
	my $self = shift;

	$self->show_title;

	return $self;
}

sub blit_bg ($;$) {
	my $self = shift;
	my $rect = shift;

	my $display = $self->{display};

	my ($x, $y, $w, $h) = rect_to_xywh($display, $rect);
	$rect = SDL::Rect->new($x, $y, $w, $h);
	SDL::Video::blit_surface($self->{bg}, $rect, $display, $rect);
}

sub show_title ($;$) {
	my $self = shift;
	my $title = shift || $self->{title};

	my $size = $self->{board}->get_size;
	my $display = $self->{display};

	$self->blit_bg([ 0, 6, 2 * 44 + 64 * $size, 30 ]);

	my $title_text = SDLx::Text->new(
		size    => 24,
		color   => 0xffffdc,
		bold    => 1,
		shadow  => 1,
		x       => 44 + 64 * $size / 2,
		y       => 6,
		h_align => 'center',
		text    => $title,
	);
	$title_text->write_to($display);
}

sub clear_helper ($) {
	my $self = shift;

	$self->blit_bg([580, 20]);
}

sub restart ($$) {
	my $self = shift;
	my $board = shift;

	$self->{move_msg_y} = 0;
	$self->{board} = $board;

	$self->clear_helper;
}

sub quit ($) {
	return 1;
}

sub pause ($) {
	my $self = shift;

	my $size = $self->{board}->get_size;
	my $display = $self->{display};

	my $display_copy = SDL::Video::display_format($display);

	$self->{paused} = 1;
	SDLx::Text->new(
		size    => 110,
		color   => 0xffffff,
		bold    => 0,
		shadow  => 1,
		x       => $self->{w} / 2,
		y       => $self->{h} / 2 - 58,
		h_align => 'center',
		text    => 'PAUSED',
	)->write_to($display);

	while ($self->process_pending_events != 1) {
		select(undef, undef, undef, 0.1);
	}

	$self->{paused} = 0;
	SDL::Video::blit_surface($display_copy, 0, $display, 0);
}

sub toggle_fullscreen ($) {
	my $self = shift;

	$self->{fullscreen} ^= 1;
	SDL::Video::wm_toggle_fullscreen($self->{display});
}

sub update_display ($) {
	my $self = shift;

	SDL::Video::update_rect($self->{display}, 0, 0, 0, 0);
}

sub process_pending_events ($;$) {
	my $self = shift;
	my $want_unpress = shift;

	$self->update_display;

	my $event = $self->{event};

	SDL::Events::pump_events();
	while (SDL::Events::poll_event($event)) {
		$self->{skip_unpress} = 0, next
			if $self->{skip_unpress} == SDL_KEYDOWN         && $event->type == SDL_KEYUP
			|| $self->{skip_unpress} == SDL_MOUSEBUTTONDOWN && $event->type == SDL_MOUSEBUTTONUP;

		my $pressed_button = $event->type == SDL_MOUSEBUTTONDOWN
			&& $event->motion_y < 20 && $event->motion_x >= $self->{w} - 20 * 3
			? 1 + int(($self->{w} - $event->motion_x) / 20) : 0;

		$self->toggle_fullscreen, $self->{skip_unpress} = $event->type, next
			if $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_RETURN
			&& $event->key_mod & KMOD_ALT
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_F11
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_f
			|| $pressed_button == 1;

		return 1
			if ($self->{paused} || $want_unpress)
			&& ($event->type == SDL_KEYUP || $event->type == SDL_MOUSEBUTTONUP);

		next
			if $self->{paused};

		return -1
			if $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_r
			|| $pressed_button == 3;

		$self->{mouse_pressed} = $event->type == SDL_MOUSEBUTTONDOWN
			if $event->button_button == SDL_BUTTON_LEFT;

		return -2
			if $event->type == SDL_QUIT
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_ESCAPE
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_q;

		$self->{skip_unpress} = $event->type, return $self->pause
			if $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_p
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_SPACE
			|| $pressed_button == 2;
	}

	return 0;
}

sub sleep ($$) {
	my $self = shift;
	my $fsecs = (shift || 0) * 50;

	do {
		my $rv = $self->process_pending_events;
		return $rv if $rv < 0;
		select(undef, undef, undef, 0.02) if $fsecs--;
	} while $fsecs >= 0;

	return 0;
}

sub wait ($;$) {
	my $self = shift;

	while (SDL::Events::wait_event) {
		my $rv = $self->process_pending_events("want_unpress");
		return $rv if $rv < 0;
		last if $rv == 1;
		$self->update_display;
	}

	return 0;
}

use constant QUIT_PRESSED      => -2;
use constant RESTART_PRESSED   => -1;
use constant MISC_PRESSED      => 0;
use constant RECT_PRESSED      => 1;
use constant BOARD_LOC_PRESSED => 2;

sub wait_for_press ($;$) {
	my $self = shift;
	my $rects = shift || [];

	my $rv = $self->wait;
	return $rv if $rv < 0;

	my $event = $self->{event};
	goto RETURN unless $event->type == SDL_MOUSEBUTTONUP;

	my $mouse_x = $event->motion_x;
	my $mouse_y = $event->motion_y;

	# check rectangles
	for my $i (0 .. @$rects - 1) {
		my ($x, $y, $w, $h) = rect_to_xywh($self->{display}, $rects->[$i]);
		return (RECT_PRESSED, $i)
			if $mouse_x >= $x && $mouse_x < $x + $w
			&& $mouse_y >= $y && $mouse_y < $y + $h;
	}

	# check board locations
	my $size = $self->{board}->get_size;
	$mouse_x -= 44;
	$mouse_y -= 44;
	if (
		$mouse_x >= 0 && $mouse_x < $size * 64 &&
		$mouse_y >= 0 && $mouse_y < $size * 64
	) {
		my $x = 1 + int($mouse_x / 64);
		my $y = 8 - int($mouse_y / 64);
		return (BOARD_LOC_PRESSED, arr_to_location($x, $y), $event->button_button == SDL_BUTTON_RIGHT)
			if ($x + $y) % 2 == 0;
	}

RETURN:
	return MISC_PRESSED;
}

sub hold ($) {
	my $self = shift;

	my $rv = $self->wait;

	return $rv == QUIT_PRESSED ? QUIT_PRESSED : MISC_PRESSED;
}

sub show_board ($) {
	my $self = shift;

	my $display = $self->{display};
	my $board = $self->{board};
	my $size = $board->get_size;

	# draw empty board first
	$self->blit_bg([ 44, 44, 64 * $size, 64 * $size ]);

	for my $color (White, Black) {
		my $iterator = Games::Checkers::FigureIterator->new($board, $color);
		for my $location ($iterator->all) {
			my $piece = $board->piece($location);
			my ($x, $y) = location_to_arr($location);
			SDL::Video::blit_surface(
				$self->{pieces}{$piece}{$color}, 0,
				$display, SDL::Rect->new(52 + 64 * ($x - 1), 52 + 64 * ($size - $y), 48, 48)
			);
		}
	}

	$self->process_pending_events;
}

sub show_move ($$$$$) {
	my $self = shift;
	my $move = shift;
	my $color = shift;
	my $count = shift;

	my $text = $self->{text};
	my $display = $self->{display};

	my $str = $move->dump;
	my $n_str = int($count / 2 + 1) . '.';
	my $x = 0;
	if ($count % 2 == 0) {
		$self->{move_msg_y} += 20;
		$str = "$n_str $str";
	} else {
		$x = 117;
	}

	$text->write_xy($display, 580 +  0, $self->{move_msg_y} += 20, $n_str)
		if !$self->{move_msg_y};
	$text->write_xy($display, 580 + $x, $self->{move_msg_y}, $str);

	$self->process_pending_events;
}

sub show_result ($$) {
	my $self = shift;
	my $message = shift;

	my $text = $self->{text};
	$text->h_align('center');
	$text->color([220, 220, 150]);
	$text->write_xy($self->{display}, ($self->{w} + 540) / 2, 0, $message);

	$self->process_pending_events;
}

sub edit_board ($;$) {
	my $self = shift;
	my $board = shift || $self->{board};

	my $orig_board = $board->clone;
	my $display = $self->{display};

	my @rects = (
		[ 580 +  20, 200, 64, 64 ],
		[ 580 + 120, 200, 64, 64 ],
		[ 580 +  20, 300, 64, 64 ],
		[ 580 + 120, 300, 64, 64 ],
	);
	my @cp = (
		[ White, Pawn ],
		[ Black, Pawn ],
		[ White, King ],
		[ Black, King ],
	);

	my $current = 0;

	$self->show_title("Edit Board");

	while (1) {
		for my $i (0 .. 3) {
			my $rect = $rects[$i];
			if ($i == $current) {
				SDL::Video::blit_surface(
					$self->{bg}, SDL::Rect->new(44, 44 + 64, 64, 64),
					$display, SDL::Rect->new(@$rect),
				);
			} else {
				$self->blit_bg($rect);
			}
			my $piece_rect = SDL::Rect->new($rect->[0] + 8, $rect->[1] + 8, 48, 48);
			my ($color, $piece) = @{$cp[$i]};
			SDL::Video::blit_surface(
				$self->{pieces}{$piece}{$color}, 0,
				$display, $piece_rect,
			);
		}

		$self->show_board;
		my ($rv, $which, $is_second) = $self->wait_for_press(\@rects);

		if ($rv == QUIT_PRESSED) {
#			$board->copy($orig_board);
			last;
		}
		if ($rv == RESTART_PRESSED) {
			$board->copy($orig_board);
		}
		if ($rv == BOARD_LOC_PRESSED) {
			my $loc = $which;
			$is_second || $board->chk($loc, @{$cp[$current]})
				? $board->clr($loc)
				: $board->set($loc, @{$cp[$current]});
		}
		if ($rv == RECT_PRESSED) {
			$current = $which;
		}
	}

	$self->clear_helper;

	return $board;
}

1;
