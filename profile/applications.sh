#!/bin/bash
# applications.sh
alias code='open -a "Visual Studio Code"'
alias ij='open -a "IntelliJ IDEA CE"'
alias c.='repo_info -s 2>/dev/null;code $git_local_path'
alias i.='repo_info -s 2>/dev/null;ij $git_local_path'
alias a.='repo_info -s 2>/dev/null;atom $git_local_path'
alias o.='open .'
alias stree='open -a "SourceTree"'
alias chfox='open -a Charles;open -a Firefox'
alias excel='open -a "Microsoft Excel"'
alias chrome='open -a "Google Chrome"'

alias ports='lsof -P | grep -E "(LISTEN|ESTABLISHED)"'
alias epc='code $PROFILE_DIR'
alias epa='atom $PROFILE_DIR'
alias esl='code $SHELL_LIB_DIR'
alias ep='epc'
alias sp='source ~/.profile'
