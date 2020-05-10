#!/bin/bash
# to verify until `cpuntilsucceed unexistfile unexistfile_cp`
function cpuntilsucceed () {
    until cp $1 $2; do
        echo 'Attempt to copy failed. waiting... '
        sleep 5
    done
}
