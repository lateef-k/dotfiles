
function ssh-agent
    eval (command ssh-agent -c $argv)
    trap "__ssh_agent_cleanup" exit
end

function __ssh_agent_cleanup
    kill $SSH_AGENT_PID
    ssh-agent -k
    echo "Shut down ssh_agent $SSH_AGENT_PID" | systemd-cat -t ssh_agent_wrapper -p info
end
