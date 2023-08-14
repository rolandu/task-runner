#!/bin/bash

# Test script

source task-runner.lib.sh

task-runner \
  "echo 'foobar'" \
  "Foobar" \
  "foobar.log"


