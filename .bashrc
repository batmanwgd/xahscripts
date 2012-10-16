alias l='ls -alF --color'

function acs { apt-cache search $1; }
function m { man $1; }
function g { grep $1; }

# alias g="grep";
# alias m="man";
# alias acs="apt-cache search ";
# alias py3='c:/Python32/python.exe'

PS1='\[\e[0;32m\]\u@\H\[\e[m\] ◆ \[\e[1;34m\] \D{%Y-%m-%d} ◆ \A \[\e[m\] ◆ \w\n'


