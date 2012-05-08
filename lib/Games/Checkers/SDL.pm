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

use SDL;
use SDL::Event;
use SDL::Events;
use SDL::Video;  

use SDLx::LayerManager;
use SDLx::Layer;
use SDLx::Text;

sub new ($$%) {
	my $class = shift;
	my $board = shift;
	my %params = @_;

	my $image_dir = ($FindBin::Bin || "bin") . "/../data/images";
	die "No expected image dir $image_dir\n"
		unless -d $image_dir && -x _;

	my $size = $board->get_size;
	my $w = $size == 8 ? 800 : 1024;
	my $h = $size == 8 ? 600 : 768;

	SDL::init(SDL_INIT_VIDEO);
	my $display = SDL::Video::set_video_mode($w, $h, 32, SDL_HWSURFACE | SDL_HWACCEL);
	SDL::Video::fill_rect($display, SDL::Rect->new(0, 0, $w, $h), 0x286068);
	my $layers = SDLx::LayerManager->new;

	my $self = {
		board => $board,
		cell_imgs => [
			SDL::Image::load("$image_dir/cell-white.png"),
			SDL::Image::load("$image_dir/cell-black.png"),
		],
		pawn_imgs => {
			White => SDL::Image::load("$image_dir/pawn-white.png"),
			Black => SDL::Image::load("$image_dir/pawn-black.png"),
		},
		king_imgs => {
			White => SDL::Image::load("$image_dir/pawn-white.png"),
			Black => SDL::Image::load("$image_dir/pawn-black.png"),
		},
		w => $w,
		h => $h,
		display => $display,
		layers => $layers,
		event => SDL::Event->new,
		text => SDLx::Text->new(shadow => 1, shadow_offset => 2),
		mouse_pressed => 0,
	};

	bless $self, $class;

	return $self;
}

sub init ($) {
	my $self = shift;

	my $size = $self->{board}->get_size;

	for my $x (0 .. $size - 1) {
		for my $y (0 .. $size - 1) {
			$self->{layers}->add(
				SDLx::Layer->new(
					$self->{cell_imgs}->[($x + $y) % 2],
					144 + 64 * $x,
					44 + 64 * $y,
					{ id => chr(ord('A') + $x) . ($y + 1) }
				)
			);
		}
	}

	$self->{layers}->blit($self->{display});
	$self->process_pending_events;

	return $self;
}

sub quit ($) {
	exit(0);
}

sub process_pending_events ($) {
	my $self = shift;

	SDL::Video::update_rect($self->{display}, 0, 0, 0, 0);

	my $event = $self->{event};

	SDL::Events::pump_events();
	while (SDL::Events::poll_event($event)) {
		$self->{mouse_pressed} = $event->type == SDL_MOUSEBUTTONDOWN
			if $event->button_button == SDL_BUTTON_LEFT;

		$self->quit
			if $event->type == SDL_QUIT
			|| $event->type == SDL_KEYDOWN && $event->key_sym == SDLK_ESCAPE;
	}
}

sub sleep ($$) {
	my $self = shift;
	my $secs = shift || 0;

	do {
		$self->process_pending_events;
		sleep(1) if $secs--;
	} while $secs >= 0;
}

sub show_board ($$) {
	my $self = shift;

	my $board = $self->{board};

	$self->process_pending_events;
}

sub show_move ($$$$$) {
	my $self = shift;
	my $move = shift;
	my $color = shift;
	my $count = shift;

	$self->process_pending_events;
}

sub show_result ($$) {
	my $self = shift;
	my $message = shift;

	$self->{text}->write_to($self->{display}, $message);
	$self->sleep(6);
}

1;
