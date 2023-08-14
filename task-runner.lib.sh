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

	echo "Command: $TO_BE_RUN" >> "$LOG_FILE_NAME"
	echo "Task: $DESCRIPTION" >> "$LOG_FILE_NAME"
	echo "Task started: $(date)" >> "$LOG_FILE_NAME"

	if eval $TO_BE_RUN >> "$LOG_FILE_NAME" 2>&1
	then
		echo "[OK] $DESCRIPTION"
		RETURNCODE=0
	else
		echo "[ERROR] $DESCRIPTION"
		RETURNCODE=1
	fi

	echo "Task finished: $(date)" >> "$LOG_FILE_NAME" 
	echo "------------------------------------" >> "$LOG_FILE_NAME"

}



