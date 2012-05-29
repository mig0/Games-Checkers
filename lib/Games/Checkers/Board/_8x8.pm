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

package Games::Checkers::Board::_8x8;

use strict;
use warnings;

use base 'Games::Checkers::Board';
use Games::Checkers::Constants;

use constant size_x => 8;
use constant size_y => 8;
use constant locs => 32;
use constant default_rows => 3;

use constant loc_directions => [
	[ NL,  4, NL, NL ], [  4,  5, NL, NL ], [  5,  6, NL, NL ], [  6,  7, NL, NL ],
	[  8,  9,  0,  1 ], [  9, 10,  1,  2 ], [ 10, 11,  2,  3 ], [ 11, NL,  3, NL ],
	[ NL, 12, NL,  4 ], [ 12, 13,  4,  5 ], [ 13, 14,  5,  6 ], [ 14, 15,  6,  7 ],
	[ 16, 17,  8,  9 ], [ 17, 18,  9, 10 ], [ 18, 19, 10, 11 ], [ 19, NL, 11, NL ],
	[ NL, 20, NL, 12 ], [ 20, 21, 12, 13 ], [ 21, 22, 13, 14 ], [ 22, 23, 14, 15 ],
	[ 24, 25, 16, 17 ], [ 25, 26, 17, 18 ], [ 26, 27, 18, 19 ], [ 27, NL, 19, NL ],
	[ NL, 28, NL, 20 ], [ 28, 29, 20, 21 ], [ 29, 30, 21, 22 ], [ 30, 31, 22, 23 ],
	[ NL, NL, 24, 25 ], [ NL, NL, 25, 26 ], [ NL, NL, 26, 27 ], [ NL, NL, 27, NL ],
];

use constant is_crowning => [
[
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	1, 1, 1, 1,
], [
	1, 1, 1, 1,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,
]
];

use constant pawn_step => [
[
	[ NL,  4 ], [  4,  5 ], [  5,  6 ], [  6,  7 ],
	[  8,  9 ], [  9, 10 ], [ 10, 11 ], [ 11, NL ],
	[ NL, 12 ], [ 12, 13 ], [ 13, 14 ], [ 14, 15 ],
	[ 16, 17 ], [ 17, 18 ], [ 18, 19 ], [ 19, NL ],
	[ NL, 20 ], [ 20, 21 ], [ 21, 22 ], [ 22, 23 ],
	[ 24, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27, NL ],
	[ NL, 28 ], [ 28, 29 ], [ 29, 30 ], [ 30, 31 ],
	[ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ],
], [
	[ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ],
	[  0,  1 ], [  1,  2 ], [  2,  3 ], [  3, NL ],
	[ NL,  4 ], [  4,  5 ], [  5,  6 ], [  6,  7 ],
	[  8,  9 ], [  9, 10 ], [ 10, 11 ], [ 11, NL ],
	[ NL, 12 ], [ 12, 13 ], [ 13, 14 ], [ 14, 15 ],
	[ 16, 17 ], [ 17, 18 ], [ 18, 19 ], [ 19, NL ],
	[ NL, 20 ], [ 20, 21 ], [ 21, 22 ], [ 22, 23 ],
	[ 24, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27, NL ],
]
];

use constant pawn_beat => [
	[ NL,  9, NL, NL ], [  8, 10, NL, NL ], [  9, 11, NL, NL ], [ 10, NL, NL, NL ],
	[ NL, 13, NL, NL ], [ 12, 14, NL, NL ], [ 13, 15, NL, NL ], [ 14, NL, NL, NL ],
	[ NL, 17, NL,  1 ], [ 16, 18,  0,  2 ], [ 17, 19,  1,  3 ], [ 18, NL,  2, NL ],
	[ NL, 21, NL,  5 ], [ 20, 22,  4,  6 ], [ 21, 23,  5,  7 ], [ 22, NL,  6, NL ],
	[ NL, 25, NL,  9 ], [ 24, 26,  8, 10 ], [ 25, 27,  9, 11 ], [ 26, NL, 10, NL ],
	[ NL, 29, NL, 13 ], [ 28, 30, 12, 14 ], [ 29, 31, 13, 15 ], [ 30, NL, 14, NL ],
	[ NL, NL, NL, 17 ], [ NL, NL, 16, 18 ], [ NL, NL, 17, 19 ], [ NL, NL, 18, NL ],
	[ NL, NL, NL, 21 ], [ NL, NL, 20, 22 ], [ NL, NL, 21, 23 ], [ NL, NL, 22, NL ],
];

use constant king_step => [
	[ NL,  4, NL, NL, NL,  9, NL, NL, NL, 13, NL, NL, NL, 18, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL ],
	[  4,  5, NL, NL,  8, 10, NL, NL, NL, 14, NL, NL, NL, 19, NL, NL, NL, 23, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  5,  6, NL, NL,  9, 11, NL, NL, 12, 15, NL, NL, 16, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  6,  7, NL, NL, 10, NL, NL, NL, 13, NL, NL, NL, 17, NL, NL, NL, 20, NL, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL ],
	[  8,  9,  0,  1, NL, 13, NL, NL, NL, 18, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL, NL, NL, NL, NL ],
	[  9, 10,  1,  2, 12, 14, NL, NL, 16, 19, NL, NL, NL, 23, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 10, 11,  2,  3, 13, 15, NL, NL, 17, NL, NL, NL, 20, NL, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 11, NL,  3, NL, 14, NL, NL, NL, 18, NL, NL, NL, 21, NL, NL, NL, 25, NL, NL, NL, 28, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 12, NL,  4, NL, 17, NL,  1, NL, 21, NL, NL, NL, 26, NL, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 12, 13,  4,  5, 16, 18,  0,  2, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, 14,  5,  6, 17, 19,  1,  3, 20, 23, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 14, 15,  6,  7, 18, NL,  2, NL, 21, NL, NL, NL, 25, NL, NL, NL, 28, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, 17,  8,  9, NL, 21, NL,  5, NL, 26, NL,  2, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 17, 18,  9, 10, 20, 22,  4,  6, 24, 27,  0,  3, NL, 31, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 18, 19, 10, 11, 21, 23,  5,  7, 25, NL,  1, NL, 28, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 19, NL, 11, NL, 22, NL,  6, NL, 26, NL,  2, NL, 29, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 20, NL, 12, NL, 25, NL,  9, NL, 29, NL,  5, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 20, 21, 12, 13, 24, 26,  8, 10, NL, 30, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 21, 22, 13, 14, 25, 27,  9, 11, 28, 31,  4,  7, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 22, 23, 14, 15, 26, NL, 10, NL, 29, NL,  5, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 24, 25, 16, 17, NL, 29, NL, 13, NL, NL, NL, 10, NL, NL, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 25, 26, 17, 18, 28, 30, 12, 14, NL, NL,  8, 11, NL, NL, NL,  7, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 26, 27, 18, 19, 29, 31, 13, 15, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 27, NL, 19, NL, 30, NL, 14, NL, NL, NL, 10, NL, NL, NL,  5, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 28, NL, 20, NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL, 10, NL, NL, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL ],
	[ 28, 29, 20, 21, NL, NL, 16, 18, NL, NL, NL, 14, NL, NL, NL, 11, NL, NL, NL,  7, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 29, 30, 21, 22, NL, NL, 17, 19, NL, NL, 12, 15, NL, NL,  8, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 30, 31, 22, 23, NL, NL, 18, NL, NL, NL, 13, NL, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, 24, 25, NL, NL, NL, 21, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL, 11, NL, NL, NL,  7, NL, NL, NL, NL ],
	[ NL, NL, 25, 26, NL, NL, 20, 22, NL, NL, 16, 19, NL, NL, NL, 15, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 26, 27, NL, NL, 21, 23, NL, NL, 17, NL, NL, NL, 12, NL, NL, NL,  8, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 27, NL, NL, NL, 22, NL, NL, NL, 18, NL, NL, NL, 13, NL, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL ],
];

use constant king_beat => [
	[ NL,  9, NL, NL, NL, 13, NL, NL, NL, 18, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL ],
	[  8, 10, NL, NL, NL, 14, NL, NL, NL, 19, NL, NL, NL, 23, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  9, 11, NL, NL, 12, 15, NL, NL, 16, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 10, NL, NL, NL, 13, NL, NL, NL, 17, NL, NL, NL, 20, NL, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 13, NL, NL, NL, 18, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL, NL, NL, NL, NL ],
	[ 12, 14, NL, NL, 16, 19, NL, NL, NL, 23, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, 15, NL, NL, 17, NL, NL, NL, 20, NL, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 14, NL, NL, NL, 18, NL, NL, NL, 21, NL, NL, NL, 25, NL, NL, NL, 28, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 17, NL,  1, NL, 21, NL, NL, NL, 26, NL, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, 18,  0,  2, NL, 22, NL, NL, NL, 27, NL, NL, NL, 31, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 17, 19,  1,  3, 20, 23, NL, NL, 24, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 18, NL,  2, NL, 21, NL, NL, NL, 25, NL, NL, NL, 28, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 21, NL,  5, NL, 26, NL,  2, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 20, 22,  4,  6, 24, 27,  0,  3, NL, 31, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 21, 23,  5,  7, 25, NL,  1, NL, 28, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 22, NL,  6, NL, 26, NL,  2, NL, 29, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 25, NL,  9, NL, 29, NL,  5, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 24, 26,  8, 10, NL, 30, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 25, 27,  9, 11, 28, 31,  4,  7, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 26, NL, 10, NL, 29, NL,  5, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 29, NL, 13, NL, NL, NL, 10, NL, NL, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 28, 30, 12, 14, NL, NL,  8, 11, NL, NL, NL,  7, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 29, 31, 13, 15, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 30, NL, 14, NL, NL, NL, 10, NL, NL, NL,  5, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL, 10, NL, NL, NL,  6, NL, NL, NL,  3, NL, NL, NL, NL ],
	[ NL, NL, 16, 18, NL, NL, NL, 14, NL, NL, NL, 11, NL, NL, NL,  7, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 17, 19, NL, NL, 12, 15, NL, NL,  8, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 18, NL, NL, NL, 13, NL, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, NL, 21, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL, 11, NL, NL, NL,  7, NL, NL, NL, NL ],
	[ NL, NL, 20, 22, NL, NL, 16, 19, NL, NL, NL, 15, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 21, 23, NL, NL, 17, NL, NL, NL, 12, NL, NL, NL,  8, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 22, NL, NL, NL, 18, NL, NL, NL, 13, NL, NL, NL,  9, NL, NL, NL,  4, NL, NL, NL,  0, NL ],
];

1;
