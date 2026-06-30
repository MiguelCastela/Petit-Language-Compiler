#!/bin/sh
# The lexer includes "petit.tab.h", so the parser must be generated with the
# "petit" file prefix (yacc -b petit) instead of the default y.tab.* names.
rm -f petit lex.yy.c petit.tab.c petit.tab.h
yacc -d -v -t -g --report=all -b petit petit.y
lex petit.l
cc -o petit lex.yy.c petit.tab.c ast.c semantics.c codegen.c -Wall -Wno-unused-function
