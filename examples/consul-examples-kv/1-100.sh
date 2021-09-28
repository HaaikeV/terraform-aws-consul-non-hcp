#!/bin/sh
counter=1
output=""
consul_server_ip=54.202.210.81
while [ $counter -le 100 ]
do
    fizz=$(( counter % 3 ))
    buzz=$(( counter % 5 ))
    fizzbuzz="fizzbuzz"
    echo "Counter is $counter"
    if [ "$fizz" -eq 0 ] && [ "$buzz" -eq 0 ]; then
    	echo 'fizzbuzz'
        consul kv put -http-addr=$consul_server_ip:8500 $counter 'fizzbuzz'
    elif [ "$fizz" -eq 0 ]; then
        echo 'fizz'
        consul kv put -http-addr=$consul_server_ip:8500 $counter 'fizz'
    elif [ "$buzz" -eq 0 ]; then
        echo 'buzz'
        consul kv put -http-addr=$consul_server_ip:8500 $counter 'buzz'
    fi
    counter=$(($counter+1))
done

