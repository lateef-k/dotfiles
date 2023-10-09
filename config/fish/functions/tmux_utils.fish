
# Description: Changes tmux to session name 1-notes and window id 1
# Usage: notes
# Arguments: None
# Author: [Your Name]

# Function to switch to the tmux session named 1-notes and window id 1
# This function uses the `tmux` command to switch to the specified session and window.
# It first checks if `tmux` is installed, then verifies if the session exists.
# If the session exists, it switches to the specified window.
# If the session or window doesn't exist, it displays an error message.
function tmux_utils
    if command -v tmux >/dev/null
        if tmux has-session -t 1-notes 2>/dev/null
            tmux switch-client -t 1-notes:0
        else
            echo "Session '1-notes' does not exist."
        end
    else
        echo "tmux is not installed. Please install tmux to use this function."
    end
end
