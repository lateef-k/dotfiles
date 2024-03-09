
function _kill_all_ssh_agent
    for line in $(ps aux | rg "\d\sssh-agent" | awk '{print $2}')
        SSH_AGENT_PID=$line ssh-agent -k
    end
end
