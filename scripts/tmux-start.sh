#!/bin/bash

# TODO: make this sessionizer better

SESSION_NAME="main"

FOLDER_PATH=""
NVIM_CONFIG_FOLDER="$HOME/.config/nvim"

# Attach if session already exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "Attaching to existing tmux session: $SESSION_NAME"
    tmux attach-session -t $SESSION_NAME
    exit 0
fi

# Window 1: Neovim in project folder
tmux new-session -d -s $SESSION_NAME -n "nvim"
tmux send-keys -t $SESSION_NAME:1 "cd $FOLDER_PATH" C-m
tmux send-keys -t $SESSION_NAME:1 "clear" C-m
tmux send-keys -t $SESSION_NAME:1 "nvim ." C-m

# Window 2: General terminal in project folder
tmux new-window -t $SESSION_NAME -n "term"
tmux send-keys -t $SESSION_NAME:2 "cd $FOLDER_PATH" C-m
tmux send-keys -t $SESSION_NAME:2 "clear" C-m

# Window 3: SSH into gpu1
tmux new-window -t $SESSION_NAME -n "seg"
tmux send-keys -t $SESSION_NAME:3 "clear" C-m
tmux send-keys -t $SESSION_NAME:3 "ssh gpu1" C-m

# Window 4: Neovim config folder
tmux new-window -t $SESSION_NAME -n "config"
tmux send-keys -t $SESSION_NAME:4 "cd $NVIM_CONFIG_FOLDER" C-m
tmux send-keys -t $SESSION_NAME:4 "clear" C-m

# Focus window 1 on attach
tmux select-window -t $SESSION_NAME:1

tmux attach-session -t $SESSION_NAME
