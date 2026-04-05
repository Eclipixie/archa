for dir in $(ls /sys/class/thermal/ | grep thermal_zone); do
    echo $(cat /sys/class/thermal/$dir/type):$(cat /sys/class/thermal/$dir/temp)
done
