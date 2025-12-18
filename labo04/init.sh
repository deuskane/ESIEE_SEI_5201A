#!/bin/bash

function init_main()
{
    local repo_work=asylum-soc-OB8_gpio
    local repo_cores=asylum-cores
    
    # Header
    echo ""
    echo "Run initialization script for $(basename ${PWD})"
    echo ""

    # Get Repository
    if test -d ${repo_work};
    then
	echo "Directory \"${repo_work}\" exists, exit the script"
	return
    fi

    git clone https://github.com/deuskane/${repo_work}.git

    # Re-create directory if unexist
    rm -fr   ~/.config/fusesoc/
    mkdir -p ~/.config/fusesoc/

    # Remove previous clone repo
    rm -fr   ~/.local/share/fusesoc/${repo_cores}

    # Add global Library
    fusesoc library add ${repo_cores} https://github.com/deuskane/${repo_cores}.git --global

    # Add local Library
    cd ${repo_work}
    rm -f fusesoc.conf
    fusesoc library add local .

    # Check Core list
    make info

    echo ""
    echo "Initialization complete"
    echo ""
}

init_main $*
