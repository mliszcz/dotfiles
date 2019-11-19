function fish_mode_prompt
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        switch $fish_bind_mode
            case insert
                set_color brred
                echo '+'
                set_color normal
            case '*'
                echo ':'
        end
    end
end
