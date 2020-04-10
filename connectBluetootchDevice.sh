#!/bin/bash
for id in `blueutil --favourites| cut -d' ' -f 2 | cut -d , -f 1`; do blueutil --connect $id; done