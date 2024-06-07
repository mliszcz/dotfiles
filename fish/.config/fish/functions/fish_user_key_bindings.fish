function fish_user_key_bindings
    # Overwrite the default delete-or-exit behavior for CTRL-D.
    # This must be in the user bindings function and not in config.fish.
    # Default bindings are not yet configured when config.fish is run.
    bind --erase -s -M default --preset \cd
    bind --erase -s -M insert  --preset \cd
    bind --erase -s -M visual  --preset \cd
end 
