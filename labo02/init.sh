#!/bin/bash

function init_main()
{
    local work_repo=asylum-soc-picosoc
    local work_branch=student
    local cores_repo=asylum-cores
    local cores_branch=main
    local git_url="https://github.com/"
    local git_user=deuskane
    
    # Header
    echo "--------------------------------------------------"
    echo "Run initialization script for $(basename ${PWD})"
    echo "--------------------------------------------------"

    # Get Repository
    if test -d ${work_repo};
    then
	echo "Directory \"${work_repo}\" exists, exit the script"
	return
    fi

    git clone ${git_url}/${git_user}/${work_repo}.git -b ${work_branch}

    # Re-create directory if unexist

    rm -fr   ~/.config/fusesoc/
    mkdir -p ~/.config/fusesoc/

    # Remove previous clone repo
    rm -fr   ~/.local/share/fusesoc/${cores_repo}

    # Add global Library
    fusesoc library add ${cores_repo} ${git_url}/${git_user}/${cores_repo}.git --global

    # Add local Library
    cd ${work_repo}
    rm -f fusesoc.conf
    fusesoc library add local .

    # Check Core list
    make info

    echo "--------------------------------------------------"
    echo "Initialization complete"
    echo "--------------------------------------------------"
}

init_main $*
