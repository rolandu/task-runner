#!/bin/bash
 
# This function runs the task, logs its output to a file and returns only ok/error
# Params:
# - $1: command to be run
# - $2: descriptive name for the task
# - $3: log file for the task
function task-runner {
	
	if [[ ! $# -eq 3 ]]
	then
		echo "Error: this function requires 3 parameters!"
		echo "Usage: worker to_be_evaled description log_file_name"
	        exit 1
	fi

	TO_BE_RUN="$1"
	DESCRIPTION="$2"
	LOG_FILE_NAME="$3"

	# Header
	echo "Task: $DESCRIPTION" >> "$LOG_FILE_NAME"
	echo "Command: $TO_BE_RUN" >> "$LOG_FILE_NAME"
	TS_START=`date +%s`
	echo "Task started: $(date --iso-8601=seconds)" >> "$LOG_FILE_NAME"

	# Execution
	eval "$TO_BE_RUN" >> "$LOG_FILE_NAME" 2>&1
	RESULT=$?

	# Evaluation
	TS_FINISH=`date +%s`
	runtime=$((TS_FINISH - TS_START))
        runtime_hrs=$(( $runtime / 3600 ))
        runtime_mins=$((( $runtime % 3600 ) / 60 ))
        runtime_secs=$(( $runtime % 60 ))
        printf -v runtime_mins "%02d" $runtime_mins
        printf -v runtime_secs "%02d" $runtime_secs
	runtime_print=$runtime_hrs:$runtime_mins:$runtime_secs

	# Footer
	echo "Task finished: $(date --iso-8601=seconds); return code: $RESULT; runtime: $runtime_print" >> "$LOG_FILE_NAME" 
	echo "------------------------------------------------------------------" >> "$LOG_FILE_NAME"

	# Return
        if [ $RESULT -eq 0 ]
        then
                echo "[OK] $DESCRIPTION; runtime: $runtime_print; log: $LOG_FILE_NAME"
        else
                echo "[ERROR] $DESCRIPTION; runtime: $runtime_print; log: $LOG_FILE_NAME"
        fi

	return $RESULT
}

