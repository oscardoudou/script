#!/bin/bash
for id in `blueutil --favourites| cut -d' ' -f 2 | cut -d , -f 1`; do blueutil --disconnect $id; done
blueutil -p 0