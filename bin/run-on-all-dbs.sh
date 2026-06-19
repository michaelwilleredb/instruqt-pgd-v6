check_result(){
    if [ $1 -eq 0 ]; then
        echo "============================================"
        echo " "
        echo " "
        echo "SUCCESS."
    else
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo " "
        echo " "
        echo "Error: FAILED"
        exit -1
    fi
}
run_in_parallel(){
    printf "================\nparallel run expect mixed output\n================\n\n\n"

    printf "%s\n" "${SERVERS[@]}" | xargs -I {} -P 3 ssh -o "StrictHostKeyChecking=no" {} "$1"
    check_result $?
}
run_serial(){
    for a in "${SERVERS[@]}"; do
        echo "==========================================="
        echo " "
        echo "                    $a"
        echo " "
        echo "==========================================="
        ssh -o "StrictHostKeyChecking=no" $a "$1"
        check_result $?
    done
}

# 1. Define your servers
SERVERS=("db-1" "db-2" "db-3")

PARALLEL=true

if [ "$1" == "-s" ]; then
    PARALLEL=false
    shift
fi

# Workaround to make debug easier
case $1 in 
    -1)
        SERVERS=("db-1")
        ;;
    -2)
        SERVERS=("db-1" "db-2")
        ;;
esac

if $PARALLEL; then
    run_in_parallel "$1"
else
    run_serial "$1"
fi