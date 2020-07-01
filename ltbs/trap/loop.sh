#!/bin/bash
trap "echo 'You hit ^C'" INT 
trap "echo 'You enter KILL default to try kill me'" TERM
while true; do
    sleep 60
done