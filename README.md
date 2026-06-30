# Petit Language Compiler

A compiler for **Petit**, a small functional-style language, built incrementally
as the project for the Compilers course (2024/25) at the Department of
Informatics Engineering, University of Coimbra. The compiler is written in C
using Lex (Flex) and Yacc (Bison), and it generates LLVM intermediate
representation as its final output.

The project is organized as six phases. Each phase builds on the previous one and
adds a new stage of a classic compiler pipeline, from lexical analysis through to
code generation.

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
├── docs/
│   └── report/                 Project report (LaTeX source, PDF, figures)
├── examples/                   Sample Petit programs (.pt)
└── phases/
    ├── 1-lexical-analysis/     Lexer for the base token set (Lex)
    ├── 2-advanced-lexer/       Lexer with comments and extended rules
    ├── 3-syntactic-analysis/   Yacc grammar (calculator exercise)
    ├── 4-abstract-syntax/      Parser building an abstract syntax tree
    ├── 5-semantic-analysis/    Type checking and symbol tables
    └── 6-code-generation/      LLVM IR generation (full compiler)
```

The final, complete compiler is in [`phases/6-code-generation/`](phases/6-code-generation/).
Earlier phases are kept as milestones that show how the compiler was built up.

## The phases

| Phase | Directory | What it does |
| ----- | --------- | ------------ |
| 1 | `1-lexical-analysis` | Recognizes the core tokens of the language with a Lex specification. |
| 2 | `2-advanced-lexer` | Extends the lexer with comment handling and additional rules. |
| 3 | `3-syntactic-analysis` | A Yacc grammar for a small calculator, used to practice parser construction. |
| 4 | `4-abstract-syntax` | Parses Petit programs and builds an abstract syntax tree (`ast.c`, `ast.h`). |
| 5 | `5-semantic-analysis` | Adds symbol tables and type checking (`semantics.c`, `semantics.h`). |
| 6 | `6-code-generation` | Emits LLVM IR for a checked program (`codegen.c`, `codegen.h`). |

Each phase that ships a `build.sh` also includes the original assignment
specification as a PDF in the same directory.

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

## Report

A full write-up of the project, covering the grammar design, abstract syntax
tree, semantic analysis, and code generation, is in
[`docs/report/`](docs/report/) as both LaTeX source and a compiled PDF.

## Authors

- Miguel Castela (uc2022212972)
- Nuno Batista (uc2022216127)

Developed for the Compilers course, 2024/25, University of Coimbra.
