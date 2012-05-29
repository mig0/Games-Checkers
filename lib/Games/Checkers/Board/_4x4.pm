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

package Games::Checkers::Board::_4x4;

use strict;
use warnings;

use base 'Games::Checkers::Board';
use Games::Checkers::Constants;

use constant size_x => 4;
use constant size_y => 4;
use constant locs => 8;
use constant default_rows => 1;

use constant loc_directions => [
	[ NL,  2, NL, NL ], [  2,  3, NL, NL ],
	[  4,  5,  0,  1 ], [  5, NL,  1, NL ],
	[ NL,  6, NL,  2 ], [  6,  7,  2,  3 ],
	[ NL, NL,  4,  5 ], [ NL, NL,  5, NL ],
];

use constant is_crowning => [
[
	0, 0,
	0, 0,
	0, 0,
	1, 1,
], [
	1, 1,
	0, 0,
	0, 0,
	0, 0,
]
];

use constant pawn_step => [
[
	[ NL,  2 ], [  2,  3 ],
	[  4,  5 ], [  5, NL ],
	[ NL,  6 ], [  6,  7 ],
	[ NL, NL ], [ NL, NL ],
], [
	[ NL, NL ], [ NL, NL ],
	[  0,  1 ], [  1, NL ],
	[ NL,  2 ], [  2,  3 ],
	[  4,  5 ], [  5, NL ],
]
];

use constant pawn_beat => [
	[ NL,  5, NL, NL ], [  4, NL, NL, NL ],
	[ NL,  7, NL, NL ], [  6, NL, NL, NL ],
	[ NL, NL, NL,  1 ], [ NL, NL,  0, NL ],
	[ NL, NL, NL,  3 ], [ NL, NL,  2, NL ],
];

use constant king_step => [
	[ NL,  2, NL, NL, NL,  5, NL, NL, NL,  7, NL, NL ],
	[  2,  3, NL, NL,  4, NL, NL, NL, NL, NL, NL, NL ],
	[  4,  5,  0,  1, NL,  7, NL, NL, NL, NL, NL, NL ],
	[  5, NL,  1, NL,  6, NL, NL, NL, NL, NL, NL, NL ],
	[ NL,  6, NL,  2, NL, NL, NL,  1, NL, NL, NL, NL ],
	[  6,  7,  2,  3, NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL,  4,  5, NL, NL, NL,  3, NL, NL, NL, NL ],
	[ NL, NL,  5, NL, NL, NL,  2, NL, NL, NL,  0, NL ],
];

use constant king_beat => [
	[ NL,  5, NL, NL, NL,  7, NL, NL ],
	[  4, NL, NL, NL, NL, NL, NL, NL ],
	[ NL,  7, NL, NL, NL, NL, NL, NL ],
	[  6, NL, NL, NL, NL, NL, NL, NL ],
	[ NL, NL, NL,  1, NL, NL, NL, NL ],
	[ NL, NL,  0, NL, NL, NL, NL, NL ],
	[ NL, NL, NL,  3, NL, NL, NL, NL ],
	[ NL, NL,  2, NL, NL, NL,  0, NL ],
];

1;
