__get_git_branch() {
    # Based on: http://stackoverflow.com/a/13003854/170413
    local branch
    local git_branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        if [[ "$branch" == "HEAD" ]]; then
            branch='detached*'
        fi
        git_branch=" ($branch)"
    else
        git_branch=""
    fi
    echo -ne "$git_branch"
}

__get_git_dirty() {
    local status=$(git status --porcelain 2> /dev/null)
    local git_dirty
    if [[ ! -z "$status" ]]; then
        git_dirty=true
    else
        git_dirty=false
    fi
    echo -ne "$git_dirty"
}

__prompt_command() {
    PS1="\[$bldgrn\]\u\[$txtrst\]@\[$bldred\]\h\[$txtrst\]:\[$txtblu\]\w"

    local git_branch=$(__get_git_branch)
    local git_dirty=$(__get_git_dirty)
    local title_text="${PWD}"

    if [[ ! -z "$git_branch" ]]; then
        title_text+="$git_branch"
        if [[ "$git_branch" == " (master)" ]]; then
            PS1+="\[$bldred\]"
        else
            PS1+="\[$txtcyn\]"
        fi
        PS1+="$git_branch"
        if [[ "$git_dirty" == true ]]; then
            PS1+=" \[$txtred\]✗"
            title_text+=" ✗"
        else
            PS1+=" \[$txtgrn\]✓"
            title_text+=" ✓"
        fi
    fi
    PS1+="\[$txtrst\] \$ "
    echo -ne "\033];$title_text\007"
}

export PROMPT_COMMAND=__prompt_command
