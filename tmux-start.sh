#!/bin/bash

# TODO: make this sessionaizer better
#
SESSION_NAME="main"
HOME="/home/vs/"

FOLDER_PATH=""
FOLDER_PATH2=""

NVIM_CONFIG_FOLDER="$HOME/.config/nvim"

# Ensure valid folder paths
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Folder path $FOLDER_PATH does not exist."
    exit 1
fi

if [ ! -d "$NVIM_CONFIG_FOLDER" ]; then
    echo "Error: Neovim config folder $NVIM_CONFIG_FOLDER does not exist."
    exit 1
fi

# Check if the session already exists
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "Attaching to existing tmux session: $SESSION_NAME"
    tmux attach-session -t $SESSION_NAME
    exit 0
fi

# Start a new tmux session
tmux new-session -d -s $SESSION_NAME -n "nvim"
tmux send-keys -t $SESSION_NAME:1 "cd $FOLDER_PATH" C-m
tmux send-keys -t $SESSION_NAME:1 "conda activate generic310" C-m
tmux send-keys -t $SESSION_NAME:1 "clear" C-m
tmux send-keys -t $SESSION_NAME:1 "nvim ." C-m

# Create a second window: Terminal in the given folder
tmux new-window -t $SESSION_NAME -n "term"
tmux send-keys -t $SESSION_NAME:2 "conda activate generic310" C-m
tmux send-keys -t $SESSION_NAME:2 "cd $FOLDER_PATH" C-m
tmux send-keys -t $SESSION_NAME:2 "clear" C-m

# Create a third window: Vim in the given folder
# tmux new-window -t $SESSION_NAME -n "seg"
# tmux send-keys -t $SESSION_NAME:3 "conda activate generic310" C-m
# tmux send-keys -t $SESSION_NAME:3 "cd $FOLDER_PATH2" C-m
# tmux send-keys -t $SESSION_NAME:3 "clear" C-m
# tmux send-keys -t $SESSION_NAME:3 "nvim ." C-m
#

tmux new-window -t $SESSION_NAME -n "seg"
tmux send-keys -t $SESSION_NAME:3 "conda activate generic310" C-m
tmux send-keys -t $SESSION_NAME:3 "clear" C-m
tmux send-keys -t $SESSION_NAME:3 "ssh gpu1" C-m

# Create a fourth window: Terminal in the Neovim config folder
tmux new-window -t $SESSION_NAME -n "config"
tmux send-keys -t $SESSION_NAME:4 "conda activate generic310" C-m
tmux send-keys -t $SESSION_NAME:4 "clear" C-m
tmux send-keys -t $SESSION_NAME:4 "cd $NVIM_CONFIG_FOLDER" C-m

# Switch to the first window
tmux select-window -t $SESSION_NAME:0
#
# Attach to the session
tmux attach-session -t $SESSION_NAME
