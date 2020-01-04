grammar SL;

script: ;

import_stmt: 'LOAD';

func: 'def' NAME parameters ':' suite;

parameters: '(' (argslist)? ')';

argslist: ;

suite: ;

stmt: NAME;

NAME:  ID_START ID_CONTINUE*;

SKIP_: ( SPACES | COMMENT | LINE_JOINING ) -> skip;

fragment SPACES: [ \t]+;

fragment COMMENT: '#' ~[\r\n\f]*;

fragment LINE_JOINING: '\\' SPACES? ( '\r'? '\n' | '\r' | '\f' );

fragment ID_START: [_A-Za-z];

fragment ID_CONTINUE: [_A-Za-z0-9];
