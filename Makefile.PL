use 5.005;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME => 'Games::Checkers',
	DISTNAME => 'Games-Checkers',
	dist => {
		# default CP 'ln' is buggy, it changes source file permissions
		DIST_CP => 'cp',
		TO_UNIX => 'ln -s russian $(DISTVNAME)/data/games/default && ln -s test.pdn $(DISTVNAME)/data/games/default/default.pdn',
	},
	EXE_FILES => [ glob("bin/*") ],
	VERSION_FROM => 'lib/Games/Checkers.pm',
	ABSTRACT_FROM => 'lib/Games/Checkers.pm',
	AUTHOR => 'Mikhael Goikhman <migo@freeshell.org>',
);
