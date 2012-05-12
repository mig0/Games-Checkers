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

use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Rect;
use SDL::Surface;
use SDL::Video;
use SDL::Image;
use SDLx::Text;

sub new ($$$%) {
	my $class = shift;
	my $title = shift || die;
	my $board = shift || die;
	my %params = @_;

	my $image_dir = ($FindBin::Bin || "bin") . "/../data/images";
	die "No expected image dir $image_dir\n"
		unless -d $image_dir && -x _;

	my $size = $board->get_size;
	my $w = $size == 8 ? 800 : 1024;
	my $h = $size == 8 ? 600 : 768;

	my $fullscreen = $params{fullscreen} ? 1 : 0;

	SDL::init(SDL_INIT_VIDEO);
	my $mode = SDL_HWSURFACE | SDL_HWACCEL | ($fullscreen && SDL_FULLSCREEN);
	my $display = SDL::Video::set_video_mode($w, $h, 32, $mode);

	SDL::Video::fill_rect($display, SDL::Rect->new(0, 0, $w, $h), 0x286068);
	SDL::Video::fill_rect($display, SDL::Rect->new(41, 41, 64 * $size + 6, 64 * $size + 6), 0x50d050);
	SDL::Video::fill_rect($display, SDL::Rect->new(43, 43, 64 * $size + 2, 64 * $size + 2), 0x202020);
	SDL::Video::fill_rect($display, SDL::Rect->new($w - 25, 4, 21, 21), 0xe0e0e0);
	SDL::Video::fill_rect($display, SDL::Rect->new($w - 23, 6, 17, 17), 0x707070);

	my $title_text = SDLx::Text->new(
		size    => 24,
		color   => 0xffffdc,
		bold    => 1,
		shadow  => 1,
		x       => 44 + 64 * 4,
		y       => 6,
		h_align => 'center',
		text    => $title,
	);
	$title_text->write_to($display);

	my $coord_text = SDLx::Text->new(
		size    => 20,
		color   => 0xd8d8d0,
		shadow  => 1,
		h_align => 'center',
	);
	$coord_text->write_xy($display, 28, 66 + 64 * ($size - $_), $_) for 1 .. $size;
	$coord_text->write_xy($display, 77 + 64 * $_, $h - 40, chr(ord('a') + $_)) for 0 .. $size-1;

	my $bg_surface = SDL::Surface->new(0, 64 * $size, 64 * $size);

	my $self = {
		board => $board,
		cells => [
			SDL::Image::load("$image_dir/cell-white.png"),
			SDL::Image::load("$image_dir/cell-black.png"),
		],
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
		move_str_y => 0,
		display => $display,
		bg_surface => $bg_surface,
		event => SDL::Event->new,
		text => SDLx::Text->new(shadow => 1, shadow_offset => 2, size => 20),
		mouse_pressed => 0,
		fullscreen => $fullscreen,
	};

	bless $self, $class;

	return $self;
}

sub init ($) {
	my $self = shift;

	my $size = $self->{board}->get_size;

	for my $x (0 .. $size - 1) {
		for my $y (0 .. $size - 1) {
			SDL::Video::blit_surface(
				$self->{cells}[($x + $y) % 2],
				0,
				$self->{bg_surface},
				SDL::Rect->new(64 * $x, 64 * $y, 64, 64)
			);
		}
	}

	return $self;
}

sub quit ($) {
	exit(0);
}

sub toggle_fullscreen ($) {
	my $self = shift;

	$self->{fullscreen} ^= 1;
	SDL::Video::wm_toggle_fullscreen($self->{display});
}

sub process_pending_events ($) {
	my $self = shift;

	SDL::Video::update_rect($self->{display}, 0, 0, 0, 0);

	my $event = $self->{event};

	SDL::Events::pump_events();
	while (SDL::Events::poll_event($event)) {
		$self->toggle_fullscreen
			if $event->type == SDL_KEYUP && $event->key_sym == SDLK_RETURN
			&& $event->key_mod & KMOD_ALT
			|| $event->type == SDL_KEYUP && $event->key_sym == SDLK_F11
			|| $event->type == SDL_KEYUP && $event->key_sym == SDLK_f
			|| $event->type == SDL_MOUSEBUTTONDOWN
			&& abs($event->motion_x - $self->{w} + 14) <= 10
			&& abs($event->motion_y -              14) <= 10;

		$self->{mouse_pressed} = $event->type == SDL_MOUSEBUTTONDOWN
			if $event->button_button == SDL_BUTTON_LEFT;

		$self->quit
			if $event->type == SDL_QUIT
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_ESCAPE
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_q;
	}
}

sub sleep ($$) {
	my $self = shift;
	my $fsecs = (shift || 0) * 50;

	do {
		$self->process_pending_events;
		select(undef, undef, undef, 0.02) if $fsecs--;
	} while $fsecs >= 0;
}

sub show_board ($) {
	my $self = shift;

	my $board = $self->{board};
	my $size = $board->get_size;

	# draw empty board first
if (0) {
	SDL::Video::blit_surface(
		$self->{bg_surface},
		0,
		$self->{display},
		SDL::Rect->new(44, 44, 64 * $size, 64 * $size),
	);
} else {
	for my $x (0 .. $size - 1) {
		for my $y (0 .. $size - 1) {
			SDL::Video::blit_surface(
				$self->{cells}[($x + $y) % 2],
				0,
				$self->{display},
				SDL::Rect->new(44 + 64 * $x, 44 + 64 * $y, 64, 64)
			);
		}
	}
}

	for my $color (White, Black) {
		my $iterator = Games::Checkers::FigureIterator->new($board, $color);
		for my $location ($iterator->all) {
			my $piece = $board->piece($location);
			my ($x, $y) = location_to_arr($location);
			SDL::Video::blit_surface(
				$self->{pieces}{$piece}{$color},
				0,
				$self->{display},
				SDL::Rect->new(52 + 64 * ($x - 1), 52 + 64 * ($size - $y), 48, 48)
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

	my $str = $move->dump;
	my $x = 0;
	if ($count % 2 == 0) {
		$self->{move_msg_y} += 20;
		$str = ($count / 2 + 1) . ". $str";
	} else {
		$x = 117;
	}

	$self->{text}->write_xy($self->{display}, 580 + $x, $self->{move_msg_y}, $str);

	$self->process_pending_events;
}

sub show_result ($$) {
	my $self = shift;
	my $message = shift;

	my $text = $self->{text};
	$text->h_align('center');
	$text->color([220, 220, 150]);
	$text->write_xy($self->{display}, ($self->{w} + 540) / 2, 0, $message);
	$self->sleep(6);
}

1;
