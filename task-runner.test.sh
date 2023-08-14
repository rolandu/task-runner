#!/bin/bash

# Test script

source task-runner.lib.sh

task-runner \
  "echo 'foobar'" \
  "Foobar Command" \
  "foobar.log"

task-runner \
  "ls foobardir/" \
  "This should return an error" \
  "foobar.log"

if [ $? -eq 2 ]; then
	echo "[OK] this also returns the correct response code"
else
	echo "[ERROR] wrong response code"
fi

