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

    # Get current dir
    dirname_current=$(basename "$PWD")
    dirname_current_prefix=${dirname_current//[0-9]/}
    dirname_current_number=$(echo $dirname_current | grep -oE '[0-9]+')

    # Get previous dir
    dirname_previous_number=$(printf "%02d" $((10#$dirname_current_number - 1)))
    dirname_previous="${dirname_current_prefix}${dirname_previous_number}"

    cp -r ../${dirname_previous}/${work_repo} .

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
