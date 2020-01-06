grammar SL;

tokens { INDENT, DEDENT, NEWLINE, ENDMARKER }

script:
    ;
func: 'def' NAME parameters ':' suite
    ;
parameters: '(' (argslist)? ')'
    ;
argslist: NAME (',' NAME)*
    ;
suite: NEWLINE stmt+ DEDENT
    ;
stmt: simple_stmt | compoud_stmt
    ;


test: or_test ('if' or_test 'else' test)? | lambdef
    ;
or_test: and_test ('or' and_test)*
    ;
and_test: not_test ('and' not_test)*
    ;
not_test: 'not' not_test | comparison
    ;
comparison: expr (comp_op expr)*
    ;
comp_op: '<'|'>'|'=='|'>='|'<='|'<>'|'!='|'in'|'not' 'in'|'is'|'is' 'not'
    ;
expr: xor_expr ('|' xor_expr)*
    ;
xor_expr: and_expr ('^' and_expr)*
    ;
and_expr: shift_expr ('&' shift_expr)*
    ;
shift_expr: arith_expr (('<<'|'>>') arith_expr)*
    ;
arith_expr: term (('+'|'-') term)*
    ;
term: factor (('*'|'/'|'%'|'//') factor)*
    ;
factor: ('+'|'-'|'~') factor | power
    ;
power: atom trailer* ('**' factor)?
    ;
atom:  ('(' (yield_expr|testlist_comp)? ')' |
        '[' (listmaker)? ']' |
        '{' (dictorsetmaker)? '}' |
        '`' testlist1 '`' | '.' '.' '.' | // tt: added elipses.
        NAME | NUMBER | STRING+)
    ;
listmaker: test ( list_for | (',' test)* (',')? )
    ;
testlist_comp: test ( comp_for | (',' test)* (',')? )
    ;
lambdef: 'lambda' (varargslist)? ':' test
    ;
trailer: '(' (arglist)? ')' | '[' subscriptlist ']' | '.' NAME
    ;
subscriptlist: subscript (',' subscript)* (',')?
    ;
subscript: '.' '.' '.' | test | (test)? ':' (test)? (sliceop)?
    ;
sliceop: ':' (test)?
    ;
exprlist: expr (',' expr)* (',')?
    ;
testlist: test (',' test)* (',')?
    ;
dictorsetmaker: ( (test ':' test (comp_for | (',' test ':' test)* (',')?)) |
                  (test (comp_for | (',' test)* (',')?)) )
    ;


simple_stmt: small_stmt (';' small_stmt)* (';')? NEWLINE
    ;
small_stmt: (expr_stmt | pass_stmt | flow_stmt |
             import_stmt | exec_stmt | assert_stmt)
    ;
expr_stmt: (augassign (yield_expr|testlist) | ('=' (yield_expr|testlist))*)
    ;
augassign: ('+=' | '-=' | '*=' | '/=' | '%=' | '&=' | '|=' | '^=' | '<<=' | '>>=' | '**=')
    ;
pass_stmt: 'pass'
    ;
flow_stmt: break_stmt | continue_stmt | return_stmt | raise_stmt | yield_stmt
    ;
break_stmt: 'break'
    ;
continue_stmt: 'continue'
    ;
return_stmt: 'return' (testlist)?
    ;
yield_stmt: yield_expr
    ;
raise_stmt: 'raise' (test (',' test (',' test)?)?)?
    ;
import_stmt: 'load'
    ;
NAME:  ID_START ID_CONTINUE*
    ;
SKIP_: ( SPACES | COMMENT | LINE_JOINING ) -> skip
    ;
fragment SPACES: [ \t]+
    ;
fragment COMMENT: '#' ~[\r\n\f]*
    ;
fragment LINE_JOINING: '\\' SPACES? ( '\r'? '\n' | '\r' | '\f' )
    ;
fragment ID_START: [_A-Za-z]
    ;
fragment ID_CONTINUE: [_A-Za-z0-9]
    ;