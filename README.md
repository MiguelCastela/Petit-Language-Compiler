# Petit Language Compiler

This repository collects compiler construction work from the Compilers course
(2024/25) at the Department of Informatics Engineering, University of Coimbra.
It contains two independent compilers:

- **Petit** (this top level): a small functional-style language built across the
  practical classes. Written in C with Lex (Flex) and Yacc (Bison), it generates
  LLVM intermediate representation.
- **deiGo** (in [`deiGo/`](deiGo/)): the graded course project, a compiler for a
  subset of the Go language. See [`deiGo/README.md`](deiGo/README.md) for details.

The rest of this file describes the Petit compiler.

## The Petit language

A Petit program is a list of function definitions. Each function has the form
`name(parameters) = expression`. Parameters are typed (`integer` or `double`),
and execution starts from the `main` function.

```
factorial(integer n) = if n then n * factorial(n-1) else 1

main(integer i) = write(factorial(read(0)))
```

Language features:

- Two primitive types: `integer` and `double`.
- Function definitions with typed parameters and a single expression body.
- Arithmetic operators `+`, `-`, `*`, `/` with standard precedence and
  associativity.
- Conditional expressions: `if condition then expression else expression`.
- Function calls, including recursion.
- Built-in `read` and `write` for integer input and output, backed by a small C
  runtime (`io.c`).
- Line comments and block comments (`/* ... */`).

Sample programs live in [`examples/`](examples/).

## Repository structure

```
.
├── README.md
├── .gitignore
├── .gitattributes
├── examples/                   Sample Petit programs (.pt)
├── phases/                     The Petit compiler, stage by stage
│   ├── 1-lexical-analysis/     Lexer for the base token set (Lex)
│   ├── 2-advanced-lexer/       Lexer with comments and extended rules
│   ├── 3-syntactic-analysis/   Yacc grammar (calculator exercise)
│   ├── 4-abstract-syntax/      Parser building an abstract syntax tree
│   ├── 5-semantic-analysis/    Type checking and symbol tables
│   └── 6-code-generation/      LLVM IR generation (full compiler)
└── deiGo/                      The deiGo course project (separate compiler)
```

The final, complete Petit compiler is in
[`phases/6-code-generation/`](phases/6-code-generation/). Earlier phases are kept
as milestones that show how the compiler was built up.

## The phases

| Phase | Directory | What it does |
| ----- | --------- | ------------ |
| 1 | `1-lexical-analysis` | Recognizes the core tokens of the language with a Lex specification. |
| 2 | `2-advanced-lexer` | Extends the lexer with comment handling and additional rules. |
| 3 | `3-syntactic-analysis` | A Yacc grammar for a small calculator, used to practice parser construction. |
| 4 | `4-abstract-syntax` | Parses Petit programs and builds an abstract syntax tree (`ast.c`, `ast.h`). |
| 5 | `5-semantic-analysis` | Adds symbol tables and type checking (`semantics.c`, `semantics.h`). |
| 6 | `6-code-generation` | Emits LLVM IR for a checked program (`codegen.c`, `codegen.h`). |

Phases 4, 5, and 6 also include the original assignment specification as a PDF in
the same directory.

## Requirements

- A C compiler (`cc`, `gcc`, or `clang`).
- `flex` (or another `lex`).
- `bison` (or another `yacc`).
- For phase 6, the LLVM toolchain (`llc`, `clang`) to turn the generated IR into a
  runnable program.

On a Debian or Ubuntu system:

```sh
sudo apt install build-essential flex bison llvm clang
```

## Building

Phases 4, 5, and 6 ship a `build.sh` that regenerates the lexer and parser and
compiles the result. For example, to build the full compiler:

```sh
cd phases/6-code-generation
sh build.sh
```

This produces an executable named `petit` in that directory. Phases 1, 2, and 3
are built with the usual Lex and Yacc commands, for example:

```sh
cd phases/1-lexical-analysis
lex lexer.l
cc -o lexer lex.yy.c
```

## Running the compiler

The `petit` binary reads a Petit program from standard input, runs semantic
checks, and writes LLVM IR to standard output:

```sh
cd phases/6-code-generation
./petit < ../../examples/factorial.pt > factorial.ll
```

To produce a native executable, compile the generated IR and link it against the
runtime in `io.c`:

```sh
clang -c io.c -o io.o
clang factorial.ll io.o -o factorial
./factorial
```

The `factorial` program reads an integer from standard input and prints its
factorial.

## The deiGo project

The graded project for the same course lives in [`deiGo/`](deiGo/). It is a
separate compiler for a subset of Go, organized into four stages of its own
(lexical, syntax, semantic, and code generation), with a full report and test
suites. The project report, which documents the design of the deiGo compiler, is
in [`deiGo/report/`](deiGo/report/).

## Authors

<<<<<<< Updated upstream
- Miguel Castela 
- Nuno Batista 
=======
- Miguel Castela
- Nuno Batista
>>>>>>> Stashed changes

Developed for the Compilers course, 2024/25, University of Coimbra.
