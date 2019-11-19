function fish_prompt

    set -l last_status $status

    set_color brblue
    echo -n '('(whoami)'@'(prompt_hostname)') '
    set_color normal

    if git branch 2>/dev/null 1>&2

        if count (git status --porcelain 2>/dev/null) >/dev/null
            set_color brred
            echo -n (__fish_git_prompt '{%s} ')
            set_color normal
        else
            set_color green
            echo -n (__fish_git_prompt '(%s) ')
            set_color normal
        end

        set_color --bold bryellow
        echo -n (prompt_pwd)
        set_color normal
    else
        set_color yellow
        echo -n (prompt_pwd)
        set_color normal
    end

    if test $last_status -ne 0
        set_color brred
    end

    echo -n ' $ '

    set_color normal
end
