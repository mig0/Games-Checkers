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

package Games::Checkers::Board::_6x6;

use strict;
use warnings;

use base 'Games::Checkers::Board';
use Games::Checkers::Constants;

use constant size_x => 6;
use constant size_y => 6;
use constant locs => 18;
use constant default_rows => 2;

use constant loc_directions => [
	[ NL,  3, NL, NL ], [  3,  4, NL, NL ], [  4,  5, NL, NL ],
	[  6,  7,  0,  1 ], [  7,  8,  1,  2 ], [  8, NL,  2, NL ],
	[ NL,  9, NL,  3 ], [  9, 10,  3,  4 ], [ 10, 11,  4,  5 ],
	[ 12, 13,  6,  7 ], [ 13, 14,  7,  8 ], [ 14, NL,  8, NL ],
	[ NL, 15, NL,  9 ], [ 15, 16,  9, 10 ], [ 16, 17, 10, 11 ],
	[ NL, NL, 12, 13 ], [ NL, NL, 13, 14 ], [ NL, NL, 14, NL ],
];

use constant is_crowning => [
[
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	1, 1, 1,
], [
	1, 1, 1,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
	0, 0, 0,
]
];

use constant pawn_step => [
[
	[ NL,  3 ], [  3,  4 ], [  4,  5 ],
	[  6,  7 ], [  7,  8 ], [  8, NL ],
	[ NL,  9 ], [  9, 10 ], [ 10, 11 ],
	[ 12, 13 ], [ 13, 14 ], [ 14, NL ],
	[ NL, 15 ], [ 15, 16 ], [ 16, 17 ],
	[ NL, NL ], [ NL, NL ], [ NL, NL ],
], [
	[ NL, NL ], [ NL, NL ], [ NL, NL ],
	[  0,  1 ], [  1,  2 ], [  2, NL ],
	[ NL,  3 ], [  3,  4 ], [  4,  5 ],
	[  6,  7 ], [  7,  8 ], [  8, NL ],
	[ NL,  9 ], [  9, 10 ], [ 10, 11 ],
	[ 12, 13 ], [ 13, 14 ], [ 14, NL ],
]
];

use constant pawn_beat => [
	[ NL,  7, NL, NL ], [  6,  8, NL, NL ], [  7, NL, NL, NL ],
	[ NL, 10, NL, NL ], [  9, 11, NL, NL ], [ 10, NL, NL, NL ],
	[ NL, 13, NL,  1 ], [ 12, 14,  0,  2 ], [ 13, NL,  1, NL ],
	[ NL, 16, NL,  4 ], [ 15, 17,  3,  5 ], [ 16, NL,  4, NL ],
	[ NL, NL, NL,  7 ], [ NL, NL,  6,  8 ], [ NL, NL,  7, NL ],
	[ NL, NL, NL, 10 ], [ NL, NL,  9, 11 ], [ NL, NL, 10, NL ],
];

use constant king_step => [
	[ NL,  3, NL, NL, NL,  7, NL, NL, NL, 10, NL, NL, NL, 14, NL, NL, NL, 17, NL, NL ],
	[  3,  4, NL, NL,  6,  8, NL, NL, NL, 11, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  4,  5, NL, NL,  7, NL, NL, NL,  9, NL, NL, NL, 12, NL, NL, NL, NL, NL, NL, NL ],
	[  6,  7,  0,  1, NL, 10, NL, NL, NL, 14, NL, NL, NL, 17, NL, NL, NL, NL, NL, NL ],
	[  7,  8,  1,  2,  9, 11, NL, NL, 12, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  8, NL,  2, NL, 10, NL, NL, NL, 13, NL, NL, NL, 15, NL, NL, NL, NL, NL, NL, NL ],
	[ NL,  9, NL,  3, NL, 13, NL,  1, NL, 16, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  9, 10,  3,  4, 12, 14,  0,  2, NL, 17, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 10, 11,  4,  5, 13, NL,  1, NL, 15, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 12, 13,  6,  7, NL, 16, NL,  4, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, 14,  7,  8, 15, 17,  3,  5, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 14, NL,  8, NL, 16, NL,  4, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 15, NL,  9, NL, NL, NL,  7, NL, NL, NL,  4, NL, NL, NL,  2, NL, NL, NL, NL ],
	[ 15, 16,  9, 10, NL, NL,  6,  8, NL, NL, NL,  5, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, 17, 10, 11, NL, NL,  7, NL, NL, NL,  3, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, 12, 13, NL, NL, NL, 10, NL, NL, NL,  8, NL, NL, NL,  5, NL, NL, NL, NL ],
	[ NL, NL, 13, 14, NL, NL,  9, 11, NL, NL,  6, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 14, NL, NL, NL, 10, NL, NL, NL,  7, NL, NL, NL,  3, NL, NL, NL,  0, NL ],
];

use constant king_beat => [
	[ NL,  7, NL, NL, NL, 10, NL, NL, NL, 14, NL, NL, NL, 17, NL, NL ],
	[  6,  8, NL, NL, NL, 11, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  7, NL, NL, NL,  9, NL, NL, NL, 12, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 10, NL, NL, NL, 14, NL, NL, NL, 17, NL, NL, NL, NL, NL, NL ],
	[  9, 11, NL, NL, 12, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 10, NL, NL, NL, 13, NL, NL, NL, 15, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 13, NL,  1, NL, 16, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 12, 14,  0,  2, NL, 17, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, NL,  1, NL, 15, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 16, NL,  4, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 15, 17,  3,  5, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, NL,  4, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, NL,  7, NL, NL, NL,  4, NL, NL, NL,  2, NL, NL, NL, NL ],
	[ NL, NL,  6,  8, NL, NL, NL,  5, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL,  7, NL, NL, NL,  3, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, NL, 10, NL, NL, NL,  8, NL, NL, NL,  5, NL, NL, NL, NL ],
	[ NL, NL,  9, 11, NL, NL,  6, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 10, NL, NL, NL,  7, NL, NL, NL,  3, NL, NL, NL,  0, NL ],
];

1;
