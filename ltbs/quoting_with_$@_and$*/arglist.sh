echo "$IFS" | cat -vte
echo "$*"
IFS=,
echo "$IFS" | cat -vte
echo "$*"

function countArgs
{
    echo "$# args."
}

countArgs "$*"

countArgs "$@"