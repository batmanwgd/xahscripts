# -*- coding: utf-8 -*-
# 2012-11-07
# bash init on Windows, Cygwin

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias l='ls -alF --color'

function m { man $1; }
function g { grep $1; }

PS1='◆ \[\e[0;32m\]\u@\H\[\e[m\]◆\[\e[1;34m\] \D{%Y-%m-%d} \A \[\e[m\]◆ \w\n◆ '

alias py3='c:/Python32/python.exe'
PS1='◆ \[\e[0;32m\]\u@\H\[\e[m\]◆\[\e[1;34m\] \D{%Y-%m-%d} \A \[\e[m\]◆ \w\n◆ '
