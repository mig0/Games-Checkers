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
	[      3 ], [  3,  4 ], [  4,  5 ],
	[  6,  7 ], [  7,  8 ], [  8     ],
	[      9 ], [  9, 10 ], [ 10, 11 ],
	[ 12, 13 ], [ 13, 14 ], [ 14     ],
	[     15 ], [ 15, 16 ], [ 16, 17 ],
	[        ], [        ], [        ],
], [
	[        ], [        ], [        ],
	[  0,  1 ], [  1,  2 ], [  2     ],
	[      3 ], [  3,  4 ], [  4,  5 ],
	[  6,  7 ], [  7,  8 ], [  8     ],
	[      9 ], [  9, 10 ], [ 10, 11 ],
	[ 12, 13 ], [ 13, 14 ], [ 14     ],
]
];

use constant pawn_beat => [
	[      7         ], [  6,  8         ], [  7             ],
	[     10         ], [  9, 11         ], [ 10             ],
	[     13,      1 ], [ 12, 14,  0,  2 ], [ 13,      1     ],
	[     16,      4 ], [ 15, 17,  3,  5 ], [ 16,      4     ],
	[              7 ], [          6,  8 ], [          7     ],
	[             10 ], [          9, 11 ], [         10     ],
];

use constant king_step => [
	[      3,              7,             10,             14,             17         ],
	[  3,  4,          6,  8,             11                                         ],
	[  4,  5,          7,              9,             12                             ],
	[  6,  7,  0,  1,     10,             14,             17                         ],
	[  7,  8,  1,  2,  9, 11,         12                                             ],
	[  8,      2,     10,             13,             15                             ],
	[      9,      3,     13,      1,     16                                         ],
	[  9, 10,  3,  4, 12, 14,  0,  2,     17                                         ],
	[ 10, 11,  4,  5, 13,      1,     15                                             ],
	[ 12, 13,  6,  7,     16,      4,              2                                 ],
	[ 13, 14,  7,  8, 15, 17,  3,  5,          0                                     ],
	[ 14,      8,     16,      4,              1                                     ],
	[     15,      9,              7,              4,              2                 ],
	[ 15, 16,  9, 10,          6,  8,              5                                 ],
	[ 16, 17, 10, 11,          7,              3,              0                     ],
	[         12, 13,             10,              8,              5                 ],
	[         13, 14,          9, 11,          6                                     ],
	[         14,             10,              7,              3,              0     ],
];

use constant king_beat => [
	[      7,             10,             14,             17         ],
	[  6,  8,             11                                         ],
	[  7,              9,             12                             ],
	[     10,             14,             17                         ],
	[  9, 11,         12                                             ],
	[ 10,             13,             15                             ],
	[     13,      1,     16                                         ],
	[ 12, 14,  0,  2,     17                                         ],
	[ 13,      1,     15                                             ],
	[     16,      4,              2                                 ],
	[ 15, 17,  3,  5,          0                                     ],
	[ 16,      4,              1                                     ],
	[              7,              4,              2                 ],
	[          6,  8,              5                                 ],
	[          7,              3,              0                     ],
	[             10,              8,              5                 ],
	[          9, 11,          6                                     ],
	[         10,              7,              3,              0     ],
];

use constant enclosed_locs => [
	{  7 => [  3 ], 10 => [  3,  7 ], 14 => [  3,  7, 10 ], 17 => [  3,  7, 10, 14 ] },
	{  6 => [  3 ],  8 => [  4 ], 11 => [  4,  8 ] },
	{  7 => [  4 ],  9 => [  4,  7 ], 12 => [  4,  7,  9 ] },
	{ 10 => [  7 ], 14 => [  7, 10 ], 17 => [  7, 10, 14 ] },
	{  9 => [  7 ], 11 => [  8 ], 12 => [  7,  9 ] },
	{ 10 => [  8 ], 13 => [  8, 10 ], 15 => [  8, 10, 13 ] },
	{  1 => [  3 ], 13 => [  9 ], 16 => [  9, 13 ] },
	{  0 => [  3 ],  2 => [  4 ], 12 => [  9 ], 14 => [ 10 ], 17 => [ 10, 14 ] },
	{  1 => [  4 ], 13 => [ 10 ], 15 => [ 10, 13 ] },
	{  2 => [  7,  4 ],  4 => [  7 ], 16 => [ 13 ] },
	{  0 => [  7,  3 ],  3 => [  7 ],  5 => [  8 ], 15 => [ 13 ], 17 => [ 14 ] },
	{  1 => [  8,  4 ],  4 => [  8 ], 16 => [ 14 ] },
	{  2 => [  9,  7,  4 ],  4 => [  9,  7 ],  7 => [  9 ] },
	{  5 => [ 10,  8 ],  6 => [  9 ],  8 => [ 10 ] },
	{  0 => [ 10,  7,  3 ],  3 => [ 10,  7 ],  7 => [ 10 ] },
	{  5 => [ 13, 10,  8 ],  8 => [ 13, 10 ], 10 => [ 13 ] },
	{  6 => [ 13,  9 ],  9 => [ 13 ], 11 => [ 14 ] },
	{  0 => [ 14, 10,  7,  3 ],  3 => [ 14, 10,  7 ],  7 => [ 14, 10 ], 10 => [ 14 ] },
];

1;
