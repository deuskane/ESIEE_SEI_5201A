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

    cp -r ../labo04/${repo_work} .

    # Add local Library
    cd ${repo_work}
    rm -f fusesoc.conf
    fusesoc library add local .

    # Clean
    make clean
    
    # Check Core list
    make info

    echo ""
    echo "Initialization complete"
    echo ""
}

init_main $*
