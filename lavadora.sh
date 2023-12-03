#!/bin/bash

lavadora="Software para lavadora\n\n1. Programas disponibles\n2. Lavado\n3. Agua y tiempo total\n4. Centrifugado extra\n5. Salir"
acierto=0;

funcion(){

	grep -n "@" programas.txt | awk -F ":" '{print $1}' > indice.txt
	indice1=`tail -n 3 indice.txt | head -1`
	indice2=`tail -n 2 indice.txt | head -1`
	indice3=`tail -n 1 indice.txt | head -1`
	wcProgramas=`wc -l < programas.txt`
	tailSuave=$(( wcProgramas - indice1 ))
	headSuave=$(( indice2 - indice1 -1 ))
	tailIntenso=$(( wcProgramas - indice2 ))
	headIntenso=$(( indice3 - indice2 -1 ))
	tailHeadLana=$(( wcProgramas - indice3 ))
	segundos=0
	litros=0
	if [ $1 -eq 1 ] || [ $1 -eq 4 ];then
	programa=$(tail -n "$(($tailSuave))" programas.txt | head -n "$(($headSuave))" | awk '{print $1" "$2" "$3}')
	elif [ $1 -eq 2 ] || [ $1 -eq 5 ];then
	programa=$(tail -n "$(($tailIntenso))" programas.txt | head -n "$(($headIntenso))" | awk '{print $1" "$2" "$3}')
	elif [ $1 -eq 3 ] || [ $1 -eq 6 ];then
	programa=$(tail -n "$(($tailHeadLana))" programas.txt | head -n "$(($tailHeadLana))" | awk '{print $1" "$2" "$3}')
	fi

	if [ $1 -eq 1 ] || [ $1 -eq 2 ] || [ $1 -eq 3 ];then

		echo -e "###Ok ejecutando###"

		while read programa
		do
    		echo -e "$programa" | awk '{print $1" "$2}'
    		tiempo=$(echo "$programa" | awk '{print $2}')
    		if [ "$tiempo" -gt 0 ]; then
    		sleep "$tiempo"
    		fi

		done <<< "$programa"
		rm indice.txt
	fi

	if [ $1 -eq 4 ] || [ $1 -eq 5 ] || [ $1 -eq 6 ];then

		while read programa 
		do
			consumo=$(echo "$programa" | awk '{print $3}')
			tiempo=$(echo "$programa" | awk '{print $2}')
    		if [ "$tiempo" -gt 0 ]; then
				segundos=$((segundos + tiempo))
    		fi
			if [ -z "$consumo" ] || [ "$consumo" -gt 0 ]; then
			    litros=$((litros + consumo))
			fi
		done <<< "$programa"
		rm indice.txt
		echo El programa intenso consume "$litros" litros de agua y tarda "$segundos" segundos a terminar

	fi
	
}

while [ $acierto -eq 0 ]; do
	echo -e "\n$lavadora\n"
	echo -e "Introduce la opción deseada:"
	read opcion

	if [ $opcion -eq 1 ];then
		echo -e "\nProgramas disponibles:"
		while read linea
		do
			echo -e "$linea"
		done < programas.txt | grep "@" | awk '{print $3}' 

	elif [ $opcion -eq 2 ];then
		echo -e "\nLavado"
		echo -e "Que programa deseas ejecutar:"
		read programa
		case $programa in

			suave)
				funcion 1;;
			intenso)
				funcion 2;;
			lana)
				funcion 3;;
			*)
				echo -e "### Error programa no válido ###";;
		esac

	elif [ $opcion -eq 3 ];then
		echo -e "\nAgua y tiempo total"
		echo -e "¿De qué programa quieres saber consumos?"
		read programa
		case $programa in

			suave)
				funcion 4;;
			intenso)
				funcion 5;;
			lana)
				funcion 6;;
			*)
				echo -e "### Error programa no válido ###";;
		esac

	elif [ $opcion -eq 4 ];then
		echo -e "\nCentrifugado extra"
		echo -e "¿De cuantos segundos quieres el centrifugado?"
		read centrifugado

			if [ "$centrifugado" -gt 0 ] && [ "$centrifugado" -le 10 ];then
				for i in `seq $centrifugado`; do
					echo centrifugado
					sleep 1
				done
			else
				echo -e "### Error segundos no validos ###"
			fi

	elif [ $opcion -eq 5 ];then
		acierto=1
	fi

done

