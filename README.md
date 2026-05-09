# `tre*` - _shorthands for `tree`_

```

short-hand `tree` invocations (zsh functions)

USAGE

  tre? [-h | --help] [-_n | --_dry] [-_c | --_cmt] [TREE-OPTIONS]


VARIANTS

  command   |   skips                 mnemonic              verbose?
  =======   |   ==================    ==================    ========
            |                                                       
  trea      |   nothing               (a)ll                 MOST    
  treg      |   .git/                 use in (g)it repos    ..      
  tre       |   common ignore-s                             ..      
  treh      |   ...and hidden (.*)    for (h)umans          LEAST   


  command   |   printed tree includes
  =======   |   =====================
            |                                     even if in...         
            |                  .github/,      ...global      ...local   
            |   .*?            .git/?         git-ignore?    .gitignore?
            |   ¨¨¨            ¨¨¨¨¨¨¨¨¨¨¨    ¨¨¨¨¨¨¨¨¨¨¨    ¨¨¨¨¨¨¨¨¨¨¨
  trea      |   Y              Y              Y              Y          
  treg      |   Y              -              Y              Y          
  tre       |   Y              -              -              -          
  treh      |   -              -              -              -          


OPTIONS

    -_n, --_dry     Print the `tree` command that would be run
    -_c, --_cmt     Print with a preceding `#`
    -_h             Display help for the wrapper
         --help     Display help for the wrapper and for `tree`
    -h              Same as -_h/--help

  TREE-OPTIONS
    Any options not listed above are passed on to `tree`.


ENVIRONMENT

    __DBG_tre      Set to non-0/"" to also print debug info


HOW TO USE

  source tre.zsh from .zshrc, which will:

    declare the shorthands as shell functions
    declare the `tre-help` shell function, used by all short-hands
    register completions (uses `compdef _gnu_generic ..`)


REQUIREMENTS

  tree

    Intended to be used with the tree(1) implementation:
      > `tree`
      > _Steve Baker, Thomas Moore, Francesc Rocher_ et al
      > https://github.com/Old-Man-Programmer/tree
      > https://oldmanprogrammer.net/source.php?dir=projects/tree

    Install:
      brew install tree
      apt-get install tree


  grep

    used to generate completions
    (tested with GNU grep and BSD/macOS grep)


NOTES

  for completions for tree(1) itself, it is suggested to use

    compdef _gnu_generic tree

  which provides richer completions than those in zsh/5.9/functions/_tree

```
