# deiGo Compiler

A compiler for **deiGo**, a subset of the Go programming language, developed as
the graded project for the Compilers course (2024/25) at the Department of
Informatics Engineering, University of Coimbra. The compiler is written in C
using Lex (Flex) and Yacc (Bison) and produces LLVM intermediate representation.

## The deiGo language

deiGo keeps the look and feel of Go while restricting it to a small, well defined
core. A program is a single `package main` followed by global variable and
function declarations.

```go
package main;

func factorial(n int) int {
    if n == 0 {
        return 1;
    };
    return n * factorial(n-1);
};

var argument int;
func main() {
    argument, _ = strconv.Atoi(os.Args[1]);
    fmt.Println(factorial(argument));
};
```

Language features:

- Types: `int`, `float32`, `bool`, and `string`.
- Global variable declarations and function declarations with typed parameters
  and an optional return type.
- Control flow: `if`/`else` and `for`.
- Arithmetic, relational, and logical operators with Go-like precedence.
- `return` statements and recursive calls.
- Output through `fmt.Print` and `fmt.Println`.
- Reading command line arguments via `os.Args` and `strconv.Atoi`.
- Line comments, block comments, and string literals with escape sequences.

## Structure

The project was delivered in four stages. Each directory under `phases/` is a
cumulative snapshot that adds one stage of the pipeline, so the final and
complete compiler is in `phases/4-code-generation/`.

```
deiGo/
├── README.md
├── enunciado_projeto_2024_v3.pdf   Assignment statement
├── report/                         Project report (LaTeX, PDF, Markdown, figures)
└── phases/
    ├── 1-lexical-analysis/         Tokenizer (Lex)
    ├── 2-syntax-analysis/          Parser and abstract syntax tree
    ├── 3-semantic-analysis/        Symbol tables and type checking
    └── 4-code-generation/          LLVM IR generation (full compiler)
```

Each phase contains its own `gocompiler.l` (and from phase 2 on, `gocompiler.y`,
`ast.c`, `ast.h`), the shared `semantics.*` and `codegen.*` files where
relevant, and `meta*/` directories holding the test programs (`.dgo`) with their
expected output (`.out`). Phases 1 to 3 include a `test.sh` runner. Phase 4 adds
`examples/`, a `comp.sh` diff helper, and a `crashes/` directory documenting
known failure cases.

## Requirements

- A C compiler (`gcc` or `clang`).
- `flex` (or another `lex`).
- `bison` (or another `yacc`).
- The LLVM toolchain (`llc`, `clang`) to run the generated IR.

On a Debian or Ubuntu system:

```sh
sudo apt install build-essential flex bison llvm clang
```

## Building

Phases 2, 3, and 4 ship a `build.sh`. To build the full compiler:

```sh
cd phases/4-code-generation
sh build.sh
```

This produces an executable named `gocompiler`. Run `sh build.sh clean` to remove
generated files, or `sh build.sh zip` to package the sources.

## Running

The `gocompiler` binary reads a deiGo program from standard input. The first
argument selects which stage to run; with no argument it generates code:

| Command | Stage | Output |
| ------- | ----- | ------ |
| `./gocompiler -l` | Lexical analysis | The token stream |
| `./gocompiler -t` | Syntax analysis | The abstract syntax tree |
| `./gocompiler -s` | Semantic analysis | Symbol tables and the annotated AST |
| `./gocompiler`    | Code generation | LLVM IR on standard output |

For example, to compile and run a program:

```sh
cd phases/4-code-generation
./gocompiler < examples/factorial.dgo > factorial.ll
clang factorial.ll -o factorial
./factorial 5
```

## Tests

Phases 1 to 3 include a `test.sh` that runs the compiler against the programs in
the `meta*/` directories and compares the result with the stored `.out` files.
Point it at a built binary and choose which deliverable (meta) to test:

```sh
cd phases/3-semantic-analysis
sh build.sh
./test.sh -b gocompiler -m 3
```

In phase 4, `comp.sh file1 file2` shows a side by side diff of two outputs, which
is useful for comparing generated IR against a reference.

## Report

A detailed write-up covering the grammar, abstract syntax tree, semantic
analysis, and code generation is in [`report/`](report/), as LaTeX source, a
compiled PDF, and Markdown.

## Authors

- Miguel Castela (uc2022212972)
- Nuno Batista (uc2022216127)
