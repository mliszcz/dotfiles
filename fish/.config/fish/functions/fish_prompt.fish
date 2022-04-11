# Prompt with (possibly asynchronous) git status.
# The async communication is inspired by the implementation of the lucid prompt:
# https://github.com/mattgreen/lucid.fish/blob/master/functions/fish_prompt.fish


# Stop the asynchronous task. Presence of the __prompt_async_pid variable
# indicates that the task is in progress. Normally this var will be unset from
# the fish_prompt function once the task completion handler trigers a repaint.
function __prompt_abort_async_task
    if set -q __prompt_async_pid
        set -l pid $__prompt_async_pid
        functions -e __prompt_async_on_finish_$pid
        command kill $pid >/dev/null 2>&1
        # Flush the fifo in case something was already written but not yet
        # received by the 'on_finish' function. Flushing is performed by a
        # background job. It blocks until all data is read or the writer is
        # terminated. Only then we can wait for the PID to terminate.
        # An alternative would be to have a new fifo for each async task.
        command dd if=$__prompt_fifo > /dev/null 2>&1 &
        wait $pid
        # Remove the PID variable.
        set -e __prompt_async_pid
    end
end


# These variables are updated whenever the async task completes
# and the prompt is being repainted by the fish_prompt function.
if ! set -q __prompt_is_git
    set -g __prompt_is_git '0'
    or set -g __prompt_is_git_dirty '0'
    set -g __prompt_is_git_status '0'
end


# Create a fifo to communicate with the async task. Using dry-run is safe as we
# include the shell PID in the template name. The fifo must be deleted once the
# shell exits.
if ! set -q __prompt_fifo
    set -g __prompt_fifo (mktemp --tmpdir --dry-run fish.prompt.fifo.$fish_pid.XXXXXXXXXX)
    mkfifo $__prompt_fifo
end
function remove_fifo --on-event fish_exit
    rm $__prompt_fifo
end


# The script that determines git status. It is expected to produce a line in
# the following format: <is_git: 0/1> <is_dirty: 0/1> <fish_git_prompt output>.
set -g __prompt_git_command '
    if git branch 2>/dev/null 1>&2
        echo -n "1 "
        if count (git status --porcelain 2>/dev/null) >/dev/null
            echo -n "1 "
        else
            echo -n "0 "
        end
        fish_git_prompt "%s"
    else
        echo -n "0 0 none"
    end'


function __prompt_start_async_task
    # Block the execution of the event handlers in this function. This prevents
    # handling async task termination before the on-process-exit handler is set.
    block -l

    # Workaround for: https://github.com/fish-shell/fish-shell/issues/7422.
    # https://stackoverflow.com/questions/61946995/ls-fifo-blocks-fish-shell
    command fish --private --command "$__prompt_git_command" | tee $__prompt_fifo >/dev/null 2>&1 &

    # This is a pair of pids, one for the shell and one for tee.
    set -l pids_list (jobs --last --pid)
    set -l pid $pids_list[1]

    # Set global variable that points to the current async task.
    set -g __prompt_async_pid $pid

    # Set up task completion handler.
    function __prompt_async_on_finish_$pid --inherit-variable pid --on-process-exit $pid
        functions -e __prompt_async_on_finish_$pid

        # Read the task result from the fifo. We expect exactly one line.
        read -l result < $__prompt_fifo

        # Sanity check. Global PID must exist and it must match
        # the local pid that we inherited from the parent scope.
        if set -q __prompt_async_pid
            if test $pid -eq $__prompt_async_pid
                # Store the result globally for use in the fish_prompt.
                set -g __prompt_async_result $result
                # Trigger a repaint. This will call fish_prompt again.
                if status is-interactive
                    commandline -f repaint
                end
            end
        end
    end
end


# Presence of the __prompt_is_new variable indicates whether the fish_prompt
# function is being executed to display a new prompt or to repaint the already
# existing one. It is initially present because the event is not delivered if
# the prompt is displayed for the first time.
set -g __prompt_is_new
function __prompt_before_new --on-event fish_prompt
    set -g __prompt_is_new
end


# This function is called at the beginning of the fish_prompt
# function if asynchronous git status information is required.
function __prompt_handle_async_prompt
    # Check if this is a new prompt.
    if set -q __prompt_is_new
        # Unset the 'new' flag. It will remain unset during
        # subsequet repaints, until a new prompt is requested.
        set -e __prompt_is_new
        # Start async processing.
        __prompt_abort_async_task
        __prompt_start_async_task
    else
        # This is a repaint request. Check if the async task is already done.
        # This is indicated by the presence of the __prompt_async_result var.
        if set -q __prompt_async_result
            echo $__prompt_async_result | read --global \
               __prompt_is_git \
               __prompt_is_git_dirty \
               __prompt_is_git_status
            # Unset the variable to not re-evaluate it on subsequent repaints
            # which may be requested due to the reasons other than async task
            # completion. Also unset the PID variable.
            set -e __prompt_async_result
            set -e __prompt_async_pid
        end
    end
end

function fish_prompt
    # Store the status of the previous command so that it is not overwriten
    # by the statements below. It will be displayed at the end of the prompt.
    set -l last_status $status

    block -l

    # Check if async prompt is requested.
    if set -q prompt_use_async_git_status
        __prompt_handle_async_prompt
        # TODO: All variables below should have -f scope (reques fish 3.4+).
        # If async task PID is present, git status is not known.
        if set -q __prompt_async_pid
            set is_git_outdated
        end
        # Set git_prompt and is_git_dirty to the last known values.
        if test $__prompt_is_git -eq 1
            set git_prompt $__prompt_is_git_status
            if test $__prompt_is_git_dirty -eq 1
                set is_git_dirty
            end
        end
    else
        # This is not async prompt. Evaluate git status immediately.
        if git branch 2>/dev/null 1>&2
            set git_prompt (fish_git_prompt '%s')
            if count (git status --porcelain 2>/dev/null) >/dev/null
                set is_git_dirty
            end
        end
    end

    set_color brblue
    echo -n '('(whoami)'@'(prompt_hostname)') '
    set_color normal

    if set -q git_prompt
        if set -q is_git_outdated
            set_color --dim
        end
        if set -q is_git_dirty
            set_color brred
            echo -n "{$git_prompt} "
            set_color normal
        else
            set_color green
            echo -n "($git_prompt) "
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

    set_color brblack
    printf ' (%.3fs)' (math $CMD_DURATION / 1000)
    set_color normal

    if test $last_status -ne 0
        set_color brred
        echo -n " [$last_status] \$ "
        set_color normal
    else
        echo -n ' $ '
    end
end
