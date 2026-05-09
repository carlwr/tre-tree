tre-help() {
  # print help for shorthands
  # pass -h for standard help; --help to include tree-native help
  # the --help variant is shaped to work well with `compdef _gnu_generic ..`
  local helpFlag=$1
  local helpArr
  helpArr=(
    'short-hand `tree` invocations (zsh functions)'
    ''
    'USAGE'
    ''
    '  tre? [-h | --help] [-_n | --_dry] [-_c | --_cmt] [TREE-OPTIONS]'
    ''
    ''
    'VARIANTS'
    ''
    '  command   |   skips                 mnemonic              verbose?'
    '  =======   |   ==================    ==================    ========'
    '            |                                                       '
    '  trea      |   nothing               (a)ll                 MOST    '
    '  treg      |   .git/                 use in (g)it repos    ..      '
    '  tre       |   common ignore-s                             ..      '
    '  treh      |   ...and hidden (.*)    for (h)umans          LEAST   '
    ''
    ''
    '  command   |   printed tree includes'
    '  =======   |   ====================='
    '            |                                     even if in...         '
    '            |                  .github/,      ...global      ...local   '
    '            |   .*?            .git/?         git-ignore?    .gitignore?'
    '            |   ¨¨¨            ¨¨¨¨¨¨¨¨¨¨¨    ¨¨¨¨¨¨¨¨¨¨¨    ¨¨¨¨¨¨¨¨¨¨¨'
    '  trea      |   Y              Y              Y              Y          '
    '  treg      |   Y              -              Y              Y          '
    '  tre       |   Y              -              -              -          '
    '  treh      |   -              -              -              -          '
    ''
    ''
    'OPTIONS'
    ''
    '    -_n, --_dry     Print the `tree` command that would be run'
    '    -_c, --_cmt     Print with a preceding `#`'
    '    -_h             Display help for the wrapper'
    '         --help     Display help for the wrapper and for `tree`'
    '    -h              Same as -_h/--help'
         # (all three variants should be available, but should not have >2 identical descriptions per option since that eats characters available for the explanations in completions)
    ''
    '  TREE-OPTIONS'
    '    Any options not listed above are passed on to `tree`.'
    ''
    ''
    'ENVIRONMENT'
    ''
    '    __DBG_tre      Set to non-0/"" to also print debug info'
    ''
    ''
    'HOW TO USE'
    ''
    '  source tre.zsh from .zshrc, which will:'
    ''
    '    declare the shorthands as shell functions'
    '    declare the `tre-help` shell function, used by all short-hands'
    '    register completions (uses `compdef _gnu_generic ..`)'
    ''
    ''
    'REQUIREMENTS'
    ''
    '  tree'
    ''
    '    Intended to be used with the tree(1) implementation:'
    '      > `tree`'
    '      > _Steve Baker, Thomas Moore, Francesc Rocher_ et al'
    '      > https://github.com/Old-Man-Programmer/tree'
    '      > https://oldmanprogrammer.net/source.php?dir=projects/tree'
    ''
    '    Install:'
    '      brew install tree'
    '      apt-get install tree'
    ''
    ''
    '  grep'
    ''
    '    used to generate completions'
    '    (tested with GNU grep and BSD/macOS grep)'
    ''
    ''
    'NOTES'
    ''
    '  for completions for tree(1) itself, it is suggested to use'
    ''
    '    compdef _gnu_generic tree'
    ''
    '  which provides richer completions than those in zsh/5.9/functions/_tree'
  )
  
  case $helpFlag in
    (-h)
      print -lr -- '' "$helpArr[@]" ''
      true
      ;;
    (--help)
      print -lr -- '' "$helpArr[@]" ''
      print -- ''
      print -- '================================'
      print -- 'TREE-NATIVE HELP (`tree --help`)'
      print -- ''
      # for `tree`, if not tty, remove lines confusing `compdef _gnu_generic`:
      [[ -t 1 ]] &&   command tree --help                        \
                 || { command tree --help | grep -Ev '^[[:space:]]*---'; }
      ;;
    (*)
      print "$0: internal error"
      ;;
  esac
  }


trea treg tre treh () {
  emulate -L zsh
  setopt nounset err_return
  
  __dbgVar() if ((${__DBG_tre-})) { >&2 typeset -p1 $@; } 

  local me=$0 userArg=( "$@" )

  local -a userArg_parsed=()
  local -i dry=0 cmt=0
  while (($#userArg))
  do case ${userArg[1]} in
          (-h        )  tre-help -h    ; return 0
       ;; (    --help)  tre-help --help; return 0
       ;; (-_n|--_dry)  dry=1
       ;; (-_c|--_cmt)  cmt=1
       ;; (   *      )  userArg_parsed+=( "$userArg[1]" )
       ;;
     esac
     shift userArg
  done

  local -r global_gign=$HOME/.config/git/ignore
  local -a base gitd giti
  base=( --dirsfirst
         --noreport                 # no "x directories, y files" print
         -F                     )   # /'s, *'s etc.
  gitd=( -I .git/ -I .github/   )
  giti=( --gitignore
         --gitfile $global_gign )
  
  local color
  [[ -t 1 ]] && color='-C' ||
                color=''
    # special handling of color argument needed
    # ref.: my answer here: https://stackoverflow.com/a/74008131/1562596

  local -A argSpec=(
    [trea]=" $base $color -a             "
    [treg]=" $base $color -a $gitd       "
     [tre]=" $base $color -a $gitd $giti "
    [treh]=" $base $color    $gitd $giti "
    )

  local treeCmd=( tree ${=argSpec[$me]:?} "${(@)userArg_parsed}" )
  ((cmt)) && treeCmd+=( "| sed 's/^/#  /'" )

  __dbgVar userArg_parsed treeCmd

  case $dry in (0)              command "${(@)treeCmd}" ;;
               (1) print -rD --         "${(q@)treeCmd}" ;;
  esac

  unfunction __dbgVar
  }


# register completions, fix fzf:
() {
  local cmd
  foreach cmd ( trea treg tre treh ) {
    whence -w compdef &>/dev/null && compdef ${cmd}=tree
    if ! (( ${FZF_COMPLETION_DIR_COMMANDS[(Iew)$cmd]-} ))
    then
      FZF_COMPLETION_DIR_COMMANDS+=" $cmd"
    fi
    }
  }


if false  # for development
then
  tre-addHook-doSource() {
    local help=(
      'register a zle hook sourcing the file that declares the tre* functions'
      'intended for development'
      )
    local path_thisFile=${${(%):-%x}:a}
    eval "tre-doSource() { source $path_thisFile; }"
    case ${1-} in
         (''         ) add-zsh-hook    preexec tre-doSource
      ;; (  |--remove) add-zsh-hook -d preexec tre-doSource
      ;; (-h|--help  ) echo ${(F)help}
      ;; 
    esac
    }
  # tre-sourcehook
  # echo ---
  # echo "1  $0"
  # echo "2  ${(%):-%x}"
  # echo "2b ${${(%):-%x}:a}"
  # echo "3  $functions_source[trea]"
  # echo "4  ${functions_source[trea]:a}"
fi
