inotifywait -m $1 -e create -e moved_to -e delete |
    while read path action file; do
        echo "$action: ${path}${file}"
    done
