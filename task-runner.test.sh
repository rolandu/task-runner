#!/bin/bash

# Test script

source task-runner.lib.sh

# Test 1: Successful command
task-runner \
  "echo 'foobar'" \
  "Foobar Command" \
  "foobar.log"

if [ $? -eq 0 ]; then
	echo "✅ Successful command returned correct response code"
else
	echo "❌ Successful command returned wrong response code"
fi

# Test 2: Expected error
task-runner \
  "ls foobardir/" \
  "This should return an error" \
  "foobar.log"

if [ $? -eq 2 ]; then
	echo "✅ Error command returned correct response code"
else
	echo "❌ Error command returned wrong response code"
fi

# Test 3: Timeout scenario
task-runner \
  "sleep 10" \
  "Sleep Command expected to timeout" \
  "foobar.log" \
  "3s"

if [ $? -eq 124 ]; then
	echo "✅ Timeout was correctly detected"
else
	echo "❌ Timeout was expected but did not occur"
fi

