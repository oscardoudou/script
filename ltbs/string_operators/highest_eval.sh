#!/bin/bash
eval sort -nr \$1 ${2:+"| head -$2"}