#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[+] Saliendo...${endColour}\n"
  tput cnorm; exit 1
}
# ctrl+c
trap ctrl_c INT

while getopts "m:t:h" arg; do
  case $arg in
    m) money="$OPTARG";;
    t) technique="$OPTARG";;
    #i) ipAddress="$OPTARG"; let parameter_conunter+=3;;
    #y) machineName="$OPTARG"; let parameter_conunter+=4;;
    #d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_conunter+=5;;
    #o) so="$OPTARG"; chivato_so=1; let parameter_conunter+=6;;
    h) helpPanel;;
  esac
done

function helpPanel(){
  echo -e "\n[!] Uso: $0\n"
  echo -e "\t${purpleColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar.${endColour}"
  echo -e "\t${purpleColour}-t)${endColour}${grayColour} Técnica a utilizar:${endColour}${blueColour}(martingala/inverseLabrouchere)${endColour}"
  echo -e "\t${purpleColour}-h)${endColour}${grayColour} Mostrat panel de ayuda.\n${endColour}"
  exit 1
}

function martingala(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money $ ${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas aportar continuamente (par/impar)? ->${endColour} " && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${blueColour} Vamos a jugar con una cantidad inicial de:${endColour}${yellowColour} $initial_bet$ ${endColour}${blueColour}a${endColour}${yellowColour} $par_impar${endColour}\n"

  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""

  tput civis
  while true; do
    money=$(($money-$initial_bet))
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${yellowColour} $initial_bet$ ${endColour}${grayColour} y tienes${endColour}${yellowColour} $money$ ${endColour}"
    random_number="$(($RANDOM % 37))"
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${yellowColour} $random_number${endColour}"

    if [ ! "$money" -lt 0 ]; then
      if [ "$par_impar" == "par" ]; then
        # Toda esta definición es para cuando apostamos con número pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
#            echo -e "${redColour}[!] Has perdido, salió el número 0 !!${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en:${endColour}${yellowColour} $money$ ${endColour}"
          else
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par, ¡Ganas!${endColour}"
            reward=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de:${endColour}${yellowColour} $reward$ ${endColour}"
            money=$(($money+$reward))
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money$ ${endColour}"
            initial_bet=$backup_bet

            jugadas_malas=""
          fi
        else
#          echo -e "${redColour}[+] El número que ha salido es impar, ¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en:${endColour}${yellowColour} $money$ ${endColour}"
        fi
      else
      # Toda esta definición es para cuando apostamos con número impares  
        if [ "$(($random_number % 2))" -eq 1 ]; then
#          echo -e "${yellowColour}[+]${endColour}${greenColour} El número que ha salido es impar, ¡Ganas!${endColour}"
          reward=$(($initial_bet*2))
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de:${endColour}${yellowColour} $reward$ ${endColour}"
          money=$(($money+$reward))
#          echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${yellowColour} $money$ ${endColour}"
          initial_bet=$backup_bet

          jugadas_malas=""
        else
#        echo -e "${redColour}[+] El número que ha salido es par, ¡Pierdes!${endColour}"
        initial_bet=$(($initial_bet*2))
        jugadas_malas+="$random_number "
#        echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en:${endColour}${yellowColour} $money$ ${endColour}"
        fi
      fi
    else
      # Nos quedamos sin dinero
      echo -e "\n${redColour}[!] Te has quedado sin dinero${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de:${endColour}${yellowColour} $((play_counter-1))${endColour}${grayColour} jugadas.${endColour}"
      echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
      echo -e "${blueColour}[ $jugadas_malas]${endColour}"
      tput cnorm; exit 0
    fi
    let play_counter+=1
  done

  tput cnorm

}

function inverseLabrouchere(){

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money $ ${endColour}\n"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas aportar continuamente (par/impar)? ->${endColour} " && read par_impar
  
  declare -a my_secuencia=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${blueColour}[${my_secuencia[@]}]${endColour}"

  bet=$((${my_secuencia[0]} + ${my_secuencia[-1]}))

  unset my_secuencia[0]
  unset my_secuencia[-1]

  my_secuencia=(${my_secuencia[@]})

  echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet$ ${endColour}${grayColour} y nuestra secuencia queda en:${endColour}${blueColour}[${my_secuencia[@]}]${endColour}"
  
  tput civis
  while true; do
    random_number=$(($RANDOM % 37))

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ]; then
          echo -e "${yellowColour}[+]${endColour}${greenColour} El número es par ¡Ganas!${endColour}"
        else
          echo -e "${redColour}[!] El número es impar ¡Pierdes!${endColour}"
        fi
      fi
    sleep 5
  done
  tput cnorm
  
}

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    inverseLabrouchere
  else
    echo -e "\n${redColour}[!] La técnica utilizada no existe.${endColour}"
    helpPanel
  fi
else
  helpPanel
fi
