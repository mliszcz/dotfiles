set fish_prompt_pwd_dir_length 0

function ll
    command exa --long --classify --all --group --git --sort=name
end
