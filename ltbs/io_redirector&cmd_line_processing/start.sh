#!/bin/bash
echo "$@"
"$@" > logfile 2>&1  &