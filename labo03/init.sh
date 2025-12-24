#!/bin/bash

function init_main()
{
    local work_repo=asylum-soc-picosoc
    local cores_repo=asylum-cores
    
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

    cp -r ../labo02/${repo_work} .

    # Add local Library
    cd ${work_repo}
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
