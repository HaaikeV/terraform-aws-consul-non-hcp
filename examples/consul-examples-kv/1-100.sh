#!/bin/sh
counter=1
while [ $counter -le 100 ]
do
    fizz=$(( counter % 3 ))
    buzz=$(( counter % 5 ))
    fizzbuzz="fizzbuzz"
    echo "Counter is $counter"
    if [ "$fizz" -eq 0 ] && [ "$buzz" -eq 0 ]; then
    	echo 'fizzbuzz'
    elif [ "$fizz" -eq 0 ]; then
        echo 'fizz'
    elif [ "$buzz" -eq 0 ]; then
        echo 'buzz'
    fi

   # buzz=$(( counter % 5 ))
   # if [ "$buzz" -eq 0 ]; then
   #     echo 'buzz'
   # else
   #     echo 'not 5'
   # fi
   # 
   # if [ "$fizz" -eq 0 ] && [ "$buzz" -eq 0 ]; then
   #     echo 'fizzbuzz'
   # else
   #     echo 'not 5 or 3'
   # fi

    counter=$(($counter+1))
done
