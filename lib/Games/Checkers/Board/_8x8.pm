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
	[      4 ], [  4,  5 ], [  5,  6 ], [  6,  7 ],
	[  8,  9 ], [  9, 10 ], [ 10, 11 ], [ 11     ],
	[     12 ], [ 12, 13 ], [ 13, 14 ], [ 14, 15 ],
	[ 16, 17 ], [ 17, 18 ], [ 18, 19 ], [ 19     ],
	[     20 ], [ 20, 21 ], [ 21, 22 ], [ 22, 23 ],
	[ 24, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27     ],
	[     28 ], [ 28, 29 ], [ 29, 30 ], [ 30, 31 ],
	[        ], [        ], [        ], [        ],
], [
	[        ], [        ], [        ], [        ],
	[  0,  1 ], [  1,  2 ], [  2,  3 ], [  3     ],
	[      4 ], [  4,  5 ], [  5,  6 ], [  6,  7 ],
	[  8,  9 ], [  9, 10 ], [ 10, 11 ], [ 11     ],
	[     12 ], [ 12, 13 ], [ 13, 14 ], [ 14, 15 ],
	[ 16, 17 ], [ 17, 18 ], [ 18, 19 ], [ 19     ],
	[     20 ], [ 20, 21 ], [ 21, 22 ], [ 22, 23 ],
	[ 24, 25 ], [ 25, 26 ], [ 26, 27 ], [ 27     ],
]
];

use constant pawn_beat => [
	[      9         ], [  8, 10         ], [  9, 11         ], [ 10             ],
	[     13         ], [ 12, 14         ], [ 13, 15         ], [ 14             ],
	[     17,      1 ], [ 16, 18,  0,  2 ], [ 17, 19,  1,  3 ], [ 18,      2     ],
	[     21,      5 ], [ 20, 22,  4,  6 ], [ 21, 23,  5,  7 ], [ 22,      6     ],
	[     25,      9 ], [ 24, 26,  8, 10 ], [ 25, 27,  9, 11 ], [ 26,     10     ],
	[     29,     13 ], [ 28, 30, 12, 14 ], [ 29, 31, 13, 15 ], [ 30,     14     ],
	[             17 ], [         16, 18 ], [         17, 19 ], [         18     ],
	[             21 ], [         20, 22 ], [         21, 23 ], [         22     ],
];

use constant pawn_beat_forward => [
[
	[      9 ], [  8, 10 ], [  9, 11 ], [ 10     ],
	[     13 ], [ 12, 14 ], [ 13, 15 ], [ 14     ],
	[     17 ], [ 16, 18 ], [ 17, 19 ], [ 18     ],
	[     21 ], [ 20, 22 ], [ 21, 23 ], [ 22     ],
	[     25 ], [ 24, 26 ], [ 25, 27 ], [ 26     ],
	[     29 ], [ 28, 30 ], [ 29, 31 ], [ 30     ],
	[        ], [        ], [        ], [        ],
	[        ], [        ], [        ], [        ],
], [
	[        ], [        ], [        ], [        ],
	[        ], [        ], [        ], [        ],
	[      1 ], [  0,  2 ], [  1,  3 ], [  2     ],
	[      5 ], [  4,  6 ], [  5,  7 ], [  6     ],
	[      9 ], [  8, 10 ], [  9, 11 ], [ 10     ],
	[     13 ], [ 12, 14 ], [ 13, 15 ], [ 14     ],
	[     17 ], [ 16, 18 ], [ 17, 19 ], [ 18     ],
	[     21 ], [ 20, 22 ], [ 21, 23 ], [ 22     ],
]
];

use constant king_step => [
	[      4,              9,             13,             18,             22,             27,             31         ],
	[  4,  5,          8, 10,             14,             19,             23                                         ],
	[  5,  6,          9, 11,         12, 15,         16                                                             ],
	[  6,  7,         10,             13,             17,             20,             24                             ],
	[  8,  9,  0,  1,     13,             18,             22,             27,             31                         ],
	[  9, 10,  1,  2, 12, 14,         16, 19,             23                                                         ],
	[ 10, 11,  2,  3, 13, 15,         17,             20,             24                                             ],
	[ 11,      3,     14,             18,             21,             25,             28                             ],
	[     12,      4,     17,      1,     21,             26,             30                                         ],
	[ 12, 13,  4,  5, 16, 18,  0,  2,     22,             27,             31                                         ],
	[ 13, 14,  5,  6, 17, 19,  1,  3, 20, 23,         24                                                             ],
	[ 14, 15,  6,  7, 18,      2,     21,             25,             28                                             ],
	[ 16, 17,  8,  9,     21,      5,     26,      2,     30                                                         ],
	[ 17, 18,  9, 10, 20, 22,  4,  6, 24, 27,  0,  3,     31                                                         ],
	[ 18, 19, 10, 11, 21, 23,  5,  7, 25,      1,     28                                                             ],
	[ 19,     11,     22,      6,     26,      2,     29                                                             ],
	[     20,     12,     25,      9,     29,      5,              2                                                 ],
	[ 20, 21, 12, 13, 24, 26,  8, 10,     30,      6,              3                                                 ],
	[ 21, 22, 13, 14, 25, 27,  9, 11, 28, 31,  4,  7,          0                                                     ],
	[ 22, 23, 14, 15, 26,     10,     29,      5,              1                                                     ],
	[ 24, 25, 16, 17,     29,     13,             10,              6,              3                                 ],
	[ 25, 26, 17, 18, 28, 30, 12, 14,          8, 11,              7                                                 ],
	[ 26, 27, 18, 19, 29, 31, 13, 15,          9,              4,              0                                     ],
	[ 27,     19,     30,     14,             10,              5,              1                                     ],
	[     28,     20,             17,             13,             10,              6,              3                 ],
	[ 28, 29, 20, 21,         16, 18,             14,             11,              7                                 ],
	[ 29, 30, 21, 22,         17, 19,         12, 15,          8                                                     ],
	[ 30, 31, 22, 23,         18,             13,              9,              4,              0                     ],
	[         24, 25,             21,             18,             14,             11,              7                 ],
	[         25, 26,         20, 22,         16, 19,             15                                                 ],
	[         26, 27,         21, 23,         17,             12,              8                                     ],
	[         27,             22,             18,             13,              9,              4,              0     ],
];

use constant king_beat => [
	[      9,             13,             18,             22,             27,             31         ],
	[  8, 10,             14,             19,             23                                         ],
	[  9, 11,         12, 15,         16                                                             ],
	[ 10,             13,             17,             20,             24                             ],
	[     13,             18,             22,             27,             31                         ],
	[ 12, 14,         16, 19,             23                                                         ],
	[ 13, 15,         17,             20,             24                                             ],
	[ 14,             18,             21,             25,             28                             ],
	[     17,      1,     21,             26,             30                                         ],
	[ 16, 18,  0,  2,     22,             27,             31                                         ],
	[ 17, 19,  1,  3, 20, 23,         24                                                             ],
	[ 18,      2,     21,             25,             28                                             ],
	[     21,      5,     26,      2,     30                                                         ],
	[ 20, 22,  4,  6, 24, 27,  0,  3,     31                                                         ],
	[ 21, 23,  5,  7, 25,      1,     28                                                             ],
	[ 22,      6,     26,      2,     29                                                             ],
	[     25,      9,     29,      5,              2                                                 ],
	[ 24, 26,  8, 10,     30,      6,              3                                                 ],
	[ 25, 27,  9, 11, 28, 31,  4,  7,          0                                                     ],
	[ 26,     10,     29,      5,              1                                                     ],
	[     29,     13,             10,              6,              3                                 ],
	[ 28, 30, 12, 14,          8, 11,              7                                                 ],
	[ 29, 31, 13, 15,          9,              4,              0                                     ],
	[ 30,     14,             10,              5,              1                                     ],
	[             17,             13,             10,              6,              3                 ],
	[         16, 18,             14,             11,              7                                 ],
	[         17, 19,         12, 15,          8                                                     ],
	[         18,             13,              9,              4,              0                     ],
	[             21,             18,             14,             11,              7                 ],
	[         20, 22,         16, 19,             15                                                 ],
	[         21, 23,         17,             12,              8                                     ],
	[         22,             18,             13,              9,              4,              0     ],
];

use constant king_step_short => [
	[      4         ], [  4,  5         ], [  5,  6         ], [  6,  7         ],
	[  8,  9,  0,  1 ], [  9, 10,  1,  2 ], [ 10, 11,  2,  3 ], [ 11,      3     ],
	[     12,      4 ], [ 12, 13,  4,  5 ], [ 13, 14,  5,  6 ], [ 14, 15,  6,  7 ],
	[ 16, 17,  8,  9 ], [ 17, 18,  9, 10 ], [ 18, 19, 10, 11 ], [ 19,     11     ],
	[     20,     12 ], [ 20, 21, 12, 13 ], [ 21, 22, 13, 14 ], [ 22, 23, 14, 15 ],
	[ 24, 25, 16, 17 ], [ 25, 26, 17, 18 ], [ 26, 27, 18, 19 ], [ 27,     19     ],
	[     28,     20 ], [ 28, 29, 20, 21 ], [ 29, 30, 21, 22 ], [ 30, 31, 22, 23 ],
	[         24, 25 ], [         25, 26 ], [         26, 27 ], [         27     ],
];

use constant king_beat_short => [
	[      9         ], [  8, 10         ], [  9, 11         ], [ 10             ],
	[     13         ], [ 12, 14         ], [ 13, 15         ], [ 14             ],
	[     17,      1 ], [ 16, 18,  0,  2 ], [ 17, 19,  1,  3 ], [ 18,      2     ],
	[     21,      5 ], [ 20, 22,  4,  6 ], [ 21, 23,  5,  7 ], [ 22,      6     ],
	[     25,      9 ], [ 24, 26,  8, 10 ], [ 25, 27,  9, 11 ], [ 26,     10     ],
	[     29,     13 ], [ 28, 30, 12, 14 ], [ 29, 31, 13, 15 ], [ 30,     14     ],
	[             17 ], [         16, 18 ], [         17, 19 ], [         18     ],
	[             21 ], [         20, 22 ], [         21, 23 ], [         22     ],
];

use constant enclosed_locs => [
	{  9 => [  4 ], 13 => [  4,  9 ], 18 => [  4,  9, 13 ], 22 => [  4,  9, 13, 18 ], 27 => [  4,  9, 13, 18, 22 ], 31 => [  4,  9, 13, 18, 22, 27 ] },
	{  8 => [  4 ], 10 => [  5 ], 14 => [  5, 10 ], 19 => [  5, 10, 14 ], 23 => [  5, 10, 14, 19 ] },
	{  9 => [  5 ], 11 => [  6 ], 12 => [  5,  9 ], 15 => [  6, 11 ], 16 => [  5,  9, 12 ] },
	{ 10 => [  6 ], 13 => [  6, 10 ], 17 => [  6, 10, 13 ], 20 => [  6, 10, 13, 17 ], 24 => [  6, 10, 13, 17, 20 ] },
	{ 13 => [  9 ], 18 => [  9, 13 ], 22 => [  9, 13, 18 ], 27 => [  9, 13, 18, 22 ], 31 => [  9, 13, 18, 22, 27 ] },
	{ 12 => [  9 ], 14 => [ 10 ], 16 => [  9, 12 ], 19 => [ 10, 14 ], 23 => [ 10, 14, 19 ] },
	{ 13 => [ 10 ], 15 => [ 11 ], 17 => [ 10, 13 ], 20 => [ 10, 13, 17 ], 24 => [ 10, 13, 17, 20 ] },
	{ 14 => [ 11 ], 18 => [ 11, 14 ], 21 => [ 11, 14, 18 ], 25 => [ 11, 14, 18, 21 ], 28 => [ 11, 14, 18, 21, 25 ] },
	{  1 => [  4 ], 17 => [ 12 ], 21 => [ 12, 17 ], 26 => [ 12, 17, 21 ], 30 => [ 12, 17, 21, 26 ] },
	{  0 => [  4 ],  2 => [  5 ], 16 => [ 12 ], 18 => [ 13 ], 22 => [ 13, 18 ], 27 => [ 13, 18, 22 ], 31 => [ 13, 18, 22, 27 ] },
	{  1 => [  5 ],  3 => [  6 ], 17 => [ 13 ], 19 => [ 14 ], 20 => [ 13, 17 ], 23 => [ 14, 19 ], 24 => [ 13, 17, 20 ] },
	{  2 => [  6 ], 18 => [ 14 ], 21 => [ 14, 18 ], 25 => [ 14, 18, 21 ], 28 => [ 14, 18, 21, 25 ] },
	{  2 => [  9,  5 ],  5 => [  9 ], 21 => [ 17 ], 26 => [ 17, 21 ], 30 => [ 17, 21, 26 ] },
	{  0 => [  9,  4 ],  3 => [ 10,  6 ],  4 => [  9 ],  6 => [ 10 ], 20 => [ 17 ], 22 => [ 18 ], 24 => [ 17, 20 ], 27 => [ 18, 22 ], 31 => [ 18, 22, 27 ] },
	{  1 => [ 10,  5 ],  5 => [ 10 ],  7 => [ 11 ], 21 => [ 18 ], 23 => [ 19 ], 25 => [ 18, 21 ], 28 => [ 18, 21, 25 ] },
	{  2 => [ 11,  6 ],  6 => [ 11 ], 22 => [ 19 ], 26 => [ 19, 22 ], 29 => [ 19, 22, 26 ] },
	{  2 => [ 12,  9,  5 ],  5 => [ 12,  9 ],  9 => [ 12 ], 25 => [ 20 ], 29 => [ 20, 25 ] },
	{  3 => [ 13, 10,  6 ],  6 => [ 13, 10 ],  8 => [ 12 ], 10 => [ 13 ], 24 => [ 20 ], 26 => [ 21 ], 30 => [ 21, 26 ] },
	{  0 => [ 13,  9,  4 ],  4 => [ 13,  9 ],  7 => [ 14, 11 ],  9 => [ 13 ], 11 => [ 14 ], 25 => [ 21 ], 27 => [ 22 ], 28 => [ 21, 25 ], 31 => [ 22, 27 ] },
	{  1 => [ 14, 10,  5 ],  5 => [ 14, 10 ], 10 => [ 14 ], 26 => [ 22 ], 29 => [ 22, 26 ] },
	{  3 => [ 17, 13, 10,  6 ],  6 => [ 17, 13, 10 ], 10 => [ 17, 13 ], 13 => [ 17 ], 29 => [ 25 ] },
	{  7 => [ 18, 14, 11 ],  8 => [ 17, 12 ], 11 => [ 18, 14 ], 12 => [ 17 ], 14 => [ 18 ], 28 => [ 25 ], 30 => [ 26 ] },
	{  0 => [ 18, 13,  9,  4 ],  4 => [ 18, 13,  9 ],  9 => [ 18, 13 ], 13 => [ 18 ], 15 => [ 19 ], 29 => [ 26 ], 31 => [ 27 ] },
	{  1 => [ 19, 14, 10,  5 ],  5 => [ 19, 14, 10 ], 10 => [ 19, 14 ], 14 => [ 19 ], 30 => [ 27 ] },
	{  3 => [ 20, 17, 13, 10,  6 ],  6 => [ 20, 17, 13, 10 ], 10 => [ 20, 17, 13 ], 13 => [ 20, 17 ], 17 => [ 20 ] },
	{  7 => [ 21, 18, 14, 11 ], 11 => [ 21, 18, 14 ], 14 => [ 21, 18 ], 16 => [ 20 ], 18 => [ 21 ] },
	{  8 => [ 21, 17, 12 ], 12 => [ 21, 17 ], 15 => [ 22, 19 ], 17 => [ 21 ], 19 => [ 22 ] },
	{  0 => [ 22, 18, 13,  9,  4 ],  4 => [ 22, 18, 13,  9 ],  9 => [ 22, 18, 13 ], 13 => [ 22, 18 ], 18 => [ 22 ] },
	{  7 => [ 25, 21, 18, 14, 11 ], 11 => [ 25, 21, 18, 14 ], 14 => [ 25, 21, 18 ], 18 => [ 25, 21 ], 21 => [ 25 ] },
	{ 15 => [ 26, 22, 19 ], 16 => [ 25, 20 ], 19 => [ 26, 22 ], 20 => [ 25 ], 22 => [ 26 ] },
	{  8 => [ 26, 21, 17, 12 ], 12 => [ 26, 21, 17 ], 17 => [ 26, 21 ], 21 => [ 26 ], 23 => [ 27 ] },
	{  0 => [ 27, 22, 18, 13,  9,  4 ],  4 => [ 27, 22, 18, 13,  9 ],  9 => [ 27, 22, 18, 13 ], 13 => [ 27, 22, 18 ], 18 => [ 27, 22 ], 22 => [ 27 ] },
];

1;
