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

package Games::Checkers::Board::_10x10;

use strict;
use warnings;

use base 'Games::Checkers::Board';
use Games::Checkers::Constants;

use constant size_x => 10;
use constant size_y => 10;
use constant locs => 50;
use constant default_rows => 4;

use constant loc_directions => [
	[ NL,  5, NL, NL ], [  5,  6, NL, NL ], [  6,  7, NL, NL ], [  7,  8, NL, NL ], [  8,  9, NL, NL ],
	[ 10, 11,  0,  1 ], [ 11, 12,  1,  2 ], [ 12, 13,  2,  3 ], [ 13, 14,  3,  4 ], [ 14, NL,  4, NL ],
	[ NL, 15, NL,  5 ], [ 15, 16,  5,  6 ], [ 16, 17,  6,  7 ], [ 17, 18,  7,  8 ], [ 18, 19,  8,  9 ],
	[ 20, 21, 10, 11 ], [ 21, 22, 11, 12 ], [ 22, 23, 12, 13 ], [ 23, 24, 13, 14 ], [ 24, NL, 14, NL ],
	[ NL, 25, NL, 15 ], [ 25, 26, 15, 16 ], [ 26, 27, 16, 17 ], [ 27, 28, 17, 18 ], [ 28, 29, 18, 19 ],
	[ 30, 31, 20, 21 ], [ 31, 32, 21, 22 ], [ 32, 33, 22, 23 ], [ 33, 34, 23, 24 ], [ 34, NL, 24, NL ],
	[ NL, 35, NL, 25 ], [ 35, 36, 25, 26 ], [ 36, 37, 26, 27 ], [ 37, 38, 27, 28 ], [ 38, 39, 28, 29 ],
	[ 40, 41, 30, 31 ], [ 41, 42, 31, 32 ], [ 42, 43, 32, 33 ], [ 43, 44, 33, 34 ], [ 44, NL, 34, NL ],
	[ NL, 45, NL, 35 ], [ 45, 46, 35, 36 ], [ 46, 47, 36, 37 ], [ 47, 48, 37, 38 ], [ 48, 49, 38, 39 ],
	[ NL, NL, 40, 41 ], [ NL, NL, 41, 42 ], [ NL, NL, 42, 43 ], [ NL, NL, 43, 44 ], [ NL, NL, 44, NL ],
];

use constant is_crowning => [
[
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	1, 1, 1, 1, 1,
], [
	1, 1, 1, 1, 1,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
	0, 0, 0, 0, 0,
]
];

use constant pawn_step => [
[
	[ NL,  5 ], [  5,  6 ], [  6,  7 ], [  7,  8 ], [  8,  9 ],
	[ 10, 11 ], [ 11, 12 ], [ 12, 13 ], [ 13, 14 ], [ 14, NL ],
	[ NL, 15 ], [ 15, 16 ], [ 16, 17 ], [ 17, 18 ], [ 18, 19 ],
	[ 20, 21 ], [ 21, 22 ], [ 22, 23 ], [ 23, 24 ], [ 24, NL ],
	[ NL, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27, 28 ], [ 28, 29 ],
	[ 30, 31 ], [ 31, 32 ], [ 32, 33 ], [ 33, 34 ], [ 34, NL ],
	[ NL, 35 ], [ 35, 36 ], [ 36, 37 ], [ 37, 38 ], [ 38, 39 ],
	[ 40, 41 ], [ 41, 42 ], [ 42, 43 ], [ 43, 44 ], [ 44, NL ],
	[ NL, 45 ], [ 45, 46 ], [ 46, 47 ], [ 47, 48 ], [ 48, 49 ],
	[ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ],
], [
	[ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ], [ NL, NL ],
	[  0,  1 ], [  1,  2 ], [  2,  3 ], [  3,  4 ], [  4, NL ],
	[ NL,  5 ], [  5,  6 ], [  6,  7 ], [  7,  8 ], [  8,  9 ],
	[ 10, 11 ], [ 11, 12 ], [ 12, 13 ], [ 13, 14 ], [ 14, NL ],
	[ NL, 15 ], [ 15, 16 ], [ 16, 17 ], [ 17, 18 ], [ 18, 19 ],
	[ 20, 21 ], [ 21, 22 ], [ 22, 23 ], [ 23, 24 ], [ 24, NL ],
	[ NL, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27, 28 ], [ 28, 29 ],
	[ 30, 31 ], [ 31, 32 ], [ 32, 33 ], [ 33, 34 ], [ 34, NL ],
	[ NL, 35 ], [ 35, 36 ], [ 36, 37 ], [ 37, 38 ], [ 38, 39 ],
	[ 40, 41 ], [ 41, 42 ], [ 42, 43 ], [ 43, 44 ], [ 44, NL ],
]
];

use constant pawn_beat => [
	[ NL, 11, NL, NL ], [ 10, 12, NL, NL ], [ 11, 13, NL, NL ], [ 12, 14, NL, NL ], [ 13, NL, NL, NL ],
	[ NL, 16, NL, NL ], [ 15, 17, NL, NL ], [ 16, 18, NL, NL ], [ 17, 19, NL, NL ], [ 18, NL, NL, NL ],
	[ NL, 21, NL,  1 ], [ 20, 22,  0,  2 ], [ 21, 23,  1,  3 ], [ 22, 24,  2,  4 ], [ 23, NL,  3, NL ],
	[ NL, 26, NL,  6 ], [ 25, 27,  5,  7 ], [ 26, 28,  6,  8 ], [ 27, 29,  7,  9 ], [ 28, NL,  8, NL ],
	[ NL, 31, NL, 11 ], [ 30, 32, 10, 12 ], [ 31, 33, 11, 13 ], [ 32, 34, 12, 14 ], [ 33, NL, 13, NL ],
	[ NL, 36, NL, 16 ], [ 35, 37, 15, 17 ], [ 36, 38, 16, 18 ], [ 37, 39, 17, 19 ], [ 38, NL, 18, NL ],
	[ NL, 41, NL, 21 ], [ 40, 42, 20, 22 ], [ 41, 43, 21, 23 ], [ 42, 44, 22, 24 ], [ 43, NL, 23, NL ],
	[ NL, 46, NL, 26 ], [ 45, 47, 25, 27 ], [ 46, 48, 26, 28 ], [ 47, 49, 27, 29 ], [ 48, NL, 28, NL ],
	[ NL, NL, NL, 31 ], [ NL, NL, 30, 32 ], [ NL, NL, 31, 33 ], [ NL, NL, 32, 34 ], [ NL, NL, 33, NL ],
	[ NL, NL, NL, 36 ], [ NL, NL, 35, 37 ], [ NL, NL, 36, 38 ], [ NL, NL, 37, 39 ], [ NL, NL, 38, NL ],
];

use constant king_step => [
	[ NL,  5, NL, NL, NL, 11, NL, NL, NL, 16, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL ],
	[  5,  6, NL, NL, 10, 12, NL, NL, NL, 17, NL, NL, NL, 23, NL, NL, NL, 28, NL, NL, NL, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  6,  7, NL, NL, 11, 13, NL, NL, 15, 18, NL, NL, 20, 24, NL, NL, NL, 29, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  7,  8, NL, NL, 12, 14, NL, NL, 16, 19, NL, NL, 21, NL, NL, NL, 25, NL, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[  8,  9, NL, NL, 13, NL, NL, NL, 17, NL, NL, NL, 22, NL, NL, NL, 26, NL, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL ],
	[ 10, 11,  0,  1, NL, 16, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL ],
	[ 11, 12,  1,  2, 15, 17, NL, NL, 20, 23, NL, NL, NL, 28, NL, NL, NL, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 12, 13,  2,  3, 16, 18, NL, NL, 21, 24, NL, NL, 25, 29, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, 14,  3,  4, 17, 19, NL, NL, 22, NL, NL, NL, 26, NL, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 14, NL,  4, NL, 18, NL, NL, NL, 23, NL, NL, NL, 27, NL, NL, NL, 32, NL, NL, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 15, NL,  5, NL, 21, NL,  1, NL, 26, NL, NL, NL, 32, NL, NL, NL, 37, NL, NL, NL, 43, NL, NL, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 15, 16,  5,  6, 20, 22,  0,  2, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, 17,  6,  7, 21, 23,  1,  3, 25, 28, NL, NL, 30, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 17, 18,  7,  8, 22, 24,  2,  4, 26, 29, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 18, 19,  8,  9, 23, NL,  3, NL, 27, NL, NL, NL, 32, NL, NL, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 20, 21, 10, 11, NL, 26, NL,  6, NL, 32, NL,  2, NL, 37, NL, NL, NL, 43, NL, NL, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 21, 22, 11, 12, 25, 27,  5,  7, 30, 33,  0,  3, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 22, 23, 12, 13, 26, 28,  6,  8, 31, 34,  1,  4, 35, 39, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 23, 24, 13, 14, 27, 29,  7,  9, 32, NL,  2, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 24, NL, 14, NL, 28, NL,  8, NL, 33, NL,  3, NL, 37, NL, NL, NL, 42, NL, NL, NL, 46, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 25, NL, 15, NL, 31, NL, 11, NL, 36, NL,  6, NL, 42, NL,  2, NL, 47, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 25, 26, 15, 16, 30, 32, 10, 12, NL, 37, NL,  7, NL, 43, NL,  3, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 26, 27, 16, 17, 31, 33, 11, 13, 35, 38,  5,  8, 40, 44,  0,  4, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 27, 28, 17, 18, 32, 34, 12, 14, 36, 39,  6,  9, 41, NL,  1, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 28, 29, 18, 19, 33, NL, 13, NL, 37, NL,  7, NL, 42, NL,  2, NL, 46, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 30, 31, 20, 21, NL, 36, NL, 16, NL, 42, NL, 12, NL, 47, NL,  7, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 31, 32, 21, 22, 35, 37, 15, 17, 40, 43, 10, 13, NL, 48, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 32, 33, 22, 23, 36, 38, 16, 18, 41, 44, 11, 14, 45, 49,  5,  9, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 33, 34, 23, 24, 37, 39, 17, 19, 42, NL, 12, NL, 46, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 34, NL, 24, NL, 38, NL, 18, NL, 43, NL, 13, NL, 47, NL,  7, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 35, NL, 25, NL, 41, NL, 21, NL, 46, NL, 16, NL, NL, NL, 12, NL, NL, NL,  7, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 35, 36, 25, 26, 40, 42, 20, 22, NL, 47, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 36, 37, 26, 27, 41, 43, 21, 23, 45, 48, 15, 18, NL, NL, 10, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 37, 38, 27, 28, 42, 44, 22, 24, 46, 49, 16, 19, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 38, 39, 28, 29, 43, NL, 23, NL, 47, NL, 17, NL, NL, NL, 12, NL, NL, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 40, 41, 30, 31, NL, 46, NL, 26, NL, NL, NL, 22, NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 41, 42, 31, 32, 45, 47, 25, 27, NL, NL, 20, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 42, 43, 32, 33, 46, 48, 26, 28, NL, NL, 21, 24, NL, NL, 15, 19, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 43, 44, 33, 34, 47, 49, 27, 29, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 44, NL, 34, NL, 48, NL, 28, NL, NL, NL, 23, NL, NL, NL, 17, NL, NL, NL, 12, NL, NL, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 45, NL, 35, NL, NL, NL, 31, NL, NL, NL, 26, NL, NL, NL, 22, NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL ],
	[ 45, 46, 35, 36, NL, NL, 30, 32, NL, NL, NL, 27, NL, NL, NL, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 46, 47, 36, 37, NL, NL, 31, 33, NL, NL, 25, 28, NL, NL, 20, 24, NL, NL, NL, 19, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 47, 48, 37, 38, NL, NL, 32, 34, NL, NL, 26, 29, NL, NL, 21, NL, NL, NL, 15, NL, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 48, 49, 38, 39, NL, NL, 33, NL, NL, NL, 27, NL, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, 40, 41, NL, NL, NL, 36, NL, NL, NL, 32, NL, NL, NL, 27, NL, NL, NL, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL ],
	[ NL, NL, 41, 42, NL, NL, 35, 37, NL, NL, 30, 33, NL, NL, NL, 28, NL, NL, NL, 24, NL, NL, NL, 19, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 42, 43, NL, NL, 36, 38, NL, NL, 31, 34, NL, NL, 25, 29, NL, NL, 20, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 43, 44, NL, NL, 37, 39, NL, NL, 32, NL, NL, NL, 26, NL, NL, NL, 21, NL, NL, NL, 15, NL, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 44, NL, NL, NL, 38, NL, NL, NL, 33, NL, NL, NL, 27, NL, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL ],
];

use constant king_beat => [
	[ NL, 11, NL, NL, NL, 16, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL ],
	[ 10, 12, NL, NL, NL, 17, NL, NL, NL, 23, NL, NL, NL, 28, NL, NL, NL, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 11, 13, NL, NL, 15, 18, NL, NL, 20, 24, NL, NL, NL, 29, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 12, 14, NL, NL, 16, 19, NL, NL, 21, NL, NL, NL, 25, NL, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 13, NL, NL, NL, 17, NL, NL, NL, 22, NL, NL, NL, 26, NL, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 16, NL, NL, NL, 22, NL, NL, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL ],
	[ 15, 17, NL, NL, 20, 23, NL, NL, NL, 28, NL, NL, NL, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 16, 18, NL, NL, 21, 24, NL, NL, 25, 29, NL, NL, 30, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 17, 19, NL, NL, 22, NL, NL, NL, 26, NL, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 18, NL, NL, NL, 23, NL, NL, NL, 27, NL, NL, NL, 32, NL, NL, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 21, NL,  1, NL, 26, NL, NL, NL, 32, NL, NL, NL, 37, NL, NL, NL, 43, NL, NL, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 20, 22,  0,  2, NL, 27, NL, NL, NL, 33, NL, NL, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 21, 23,  1,  3, 25, 28, NL, NL, 30, 34, NL, NL, NL, 39, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 22, 24,  2,  4, 26, 29, NL, NL, 31, NL, NL, NL, 35, NL, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 23, NL,  3, NL, 27, NL, NL, NL, 32, NL, NL, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 26, NL,  6, NL, 32, NL,  2, NL, 37, NL, NL, NL, 43, NL, NL, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 25, 27,  5,  7, 30, 33,  0,  3, NL, 38, NL, NL, NL, 44, NL, NL, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 26, 28,  6,  8, 31, 34,  1,  4, 35, 39, NL, NL, 40, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 27, 29,  7,  9, 32, NL,  2, NL, 36, NL, NL, NL, 41, NL, NL, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 28, NL,  8, NL, 33, NL,  3, NL, 37, NL, NL, NL, 42, NL, NL, NL, 46, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 31, NL, 11, NL, 36, NL,  6, NL, 42, NL,  2, NL, 47, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 30, 32, 10, 12, NL, 37, NL,  7, NL, 43, NL,  3, NL, 48, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 31, 33, 11, 13, 35, 38,  5,  8, 40, 44,  0,  4, NL, 49, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 32, 34, 12, 14, 36, 39,  6,  9, 41, NL,  1, NL, 45, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 33, NL, 13, NL, 37, NL,  7, NL, 42, NL,  2, NL, 46, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 36, NL, 16, NL, 42, NL, 12, NL, 47, NL,  7, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 35, 37, 15, 17, 40, 43, 10, 13, NL, 48, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 36, 38, 16, 18, 41, 44, 11, 14, 45, 49,  5,  9, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 37, 39, 17, 19, 42, NL, 12, NL, 46, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 38, NL, 18, NL, 43, NL, 13, NL, 47, NL,  7, NL, NL, NL,  2, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 41, NL, 21, NL, 46, NL, 16, NL, NL, NL, 12, NL, NL, NL,  7, NL, NL, NL,  3, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 40, 42, 20, 22, NL, 47, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 41, 43, 21, 23, 45, 48, 15, 18, NL, NL, 10, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 42, 44, 22, 24, 46, 49, 16, 19, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 43, NL, 23, NL, 47, NL, 17, NL, NL, NL, 12, NL, NL, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, 46, NL, 26, NL, NL, NL, 22, NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 45, 47, 25, 27, NL, NL, 20, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 46, 48, 26, 28, NL, NL, 21, 24, NL, NL, 15, 19, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 47, 49, 27, 29, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ 48, NL, 28, NL, NL, NL, 23, NL, NL, NL, 17, NL, NL, NL, 12, NL, NL, NL,  6, NL, NL, NL,  1, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, NL, 31, NL, NL, NL, 26, NL, NL, NL, 22, NL, NL, NL, 17, NL, NL, NL, 13, NL, NL, NL,  8, NL, NL, NL,  4, NL, NL, NL, NL ],
	[ NL, NL, 30, 32, NL, NL, NL, 27, NL, NL, NL, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 31, 33, NL, NL, 25, 28, NL, NL, 20, 24, NL, NL, NL, 19, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 32, 34, NL, NL, 26, 29, NL, NL, 21, NL, NL, NL, 15, NL, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 33, NL, NL, NL, 27, NL, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, NL, 36, NL, NL, NL, 32, NL, NL, NL, 27, NL, NL, NL, 23, NL, NL, NL, 18, NL, NL, NL, 14, NL, NL, NL,  9, NL, NL, NL, NL ],
	[ NL, NL, 35, 37, NL, NL, 30, 33, NL, NL, NL, 28, NL, NL, NL, 24, NL, NL, NL, 19, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 36, 38, NL, NL, 31, 34, NL, NL, 25, 29, NL, NL, 20, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 37, 39, NL, NL, 32, NL, NL, NL, 26, NL, NL, NL, 21, NL, NL, NL, 15, NL, NL, NL, 10, NL, NL, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, 38, NL, NL, NL, 33, NL, NL, NL, 27, NL, NL, NL, 22, NL, NL, NL, 16, NL, NL, NL, 11, NL, NL, NL,  5, NL, NL, NL,  0, NL ],
];

1;
