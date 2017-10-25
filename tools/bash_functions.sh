# This files contains functions for bash scripts

# function for output with timestamp
function echo_time() {
	echo '[' `date` ']'	"$1"

    if [ ! -z "$logfile_name" ]
    then
        echo '[' `date` ']'	"$1" >> log/$logfile_name
    fi
}

# function for parallel execution
function execute_partition_script() {
    number=$1
    filename="$2"
    text="$3"

    cat $filename | sed -e "s/XX/${number}/g" | psql > /dev/null

    echo_time "  - ${text} for partition ${number} completed"
}
