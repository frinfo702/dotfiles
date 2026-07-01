#!/bin/zsh
SESSION_NAME="main"
TMUX=/opt/homebrew/bin/tmux

if $TMUX has-session -t $SESSION_NAME 2>/dev/null; then
  $TMUX attach-session -t $SESSION_NAME
else
  $TMUX new-session -s $SESSION_NAME
fi
