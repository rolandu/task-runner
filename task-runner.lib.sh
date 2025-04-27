#!/bin/bash

# This function runs the task, logs its output to a file and returns only ok/error
# Params:
# - $1: command to be run
# - $2: descriptive name for the task
# - $3: log file for the task
# - $4 (optional): timeout duration (e.g., 30s, 5m, 2h)
function task-runner {

	if [[ $# -lt 3 || $# -gt 4 ]]
	then
		echo "Error: this function requires 3 or 4 parameters!"
		echo "Usage: script_to_be_run description log_file_name [timeout_duration]"
		exit 1
	fi

	TO_BE_RUN="$1"
	DESCRIPTION="$2"
	LOG_FILE_NAME="$3"
	TIMEOUT_DURATION="$4"

	# Header
	echo "Task: $DESCRIPTION" >> "$LOG_FILE_NAME"
	echo "Command: $TO_BE_RUN" >> "$LOG_FILE_NAME"
	TS_START=$(date +%s)
	echo "Task started: $(date --iso-8601=seconds)" >> "$LOG_FILE_NAME"

	# Execution
	if [[ -n "$TIMEOUT_DURATION" ]]; then
		timeout "$TIMEOUT_DURATION" bash -c "$TO_BE_RUN" >> "$LOG_FILE_NAME" 2>&1
	else
		eval "$TO_BE_RUN" >> "$LOG_FILE_NAME" 2>&1
	fi
	RESULT=$?

	# Evaluation
	TS_FINISH=$(date +%s)
	runtime=$((TS_FINISH - TS_START))
	runtime_hrs=$(( runtime / 3600 ))
	runtime_mins=$((( runtime % 3600 ) / 60 ))
	runtime_secs=$(( runtime % 60 ))
	printf -v runtime_mins "%02d" $runtime_mins
	printf -v runtime_secs "%02d" $runtime_secs
	runtime_print=$runtime_hrs:$runtime_mins:$runtime_secs

	# Footer
	echo "Task finished: $(date --iso-8601=seconds); return code: $RESULT; runtime: $runtime_print" >> "$LOG_FILE_NAME"
	echo "------------------------------------------------------------------" >> "$LOG_FILE_NAME"

	# Return
	if [ $RESULT -eq 0 ]; then
		echo "[OK] $DESCRIPTION; runtime: $runtime_print; log: $LOG_FILE_NAME"
	elif [ $RESULT -eq 124 ]; then
		echo "[TIMEOUT] $DESCRIPTION; exceeded $TIMEOUT_DURATION; runtime: $runtime_print; log: $LOG_FILE_NAME"
	else
		echo "[ERROR] $DESCRIPTION; runtime: $runtime_print; log: $LOG_FILE_NAME"
	fi

	return $RESULT
}

