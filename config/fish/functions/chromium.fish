function chromium
    echo $argc
    if test $(count $argv) -gt 1
        eval (command firefox $argv)
    else
        eval (command firefox)
    end
end
