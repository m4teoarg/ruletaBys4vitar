#!/bin/bash

declare -a myArray=(1 2 3 4)

#declare -i posision=0

#for element in ${myArray[@]}; do
#  echo "[+] Elemento en la posisión: [$posision]: $element "
#  let posision+=1
#done

#echo ${#myArray[@]}
#

#echo $((${myArray[0]}+${myArray[-1]}))

myArray+=(5)

#echo ${myArray[@]}
#

unset myArray[0]
unset myArray[-1]

myArray=(${myArray[@]})

echo ${myArray[0]}
echo ${myArray[1]}
echo ${myArray[2]}
