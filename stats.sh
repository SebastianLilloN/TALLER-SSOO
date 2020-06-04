#!/bin/bash

if [ $# != 1 ]; then
	echo "Uso: $0 <directorio busqueda>"
	exit
fi

searchDir=$1

if [ ! -e $searchDir ]; then
        echo "Directorio $1 no existe"
        exit
fi

printf "Directorio busqueda: %s\n" $1

executionSummaryFiles=(`find $searchDir -name '*.txt' -print | sort | grep execution | grep -v '._'`)

sumaInicial="sumaInicial.txt"
rm -f $sumaInicial
sumaFinal="sumaFinal.txt"
rm -f $sumaFinal
for i in ${executionSummaryFiles[*]};
do
	printf "> %s\n" $i
	timeExec1=$(cat $i | tail -n +2 | cut -d ':' -f 6 )
	timeExec2=$(cat $i | tail -n +2 | cut -d ':' -f 7 )
	timeExec3=$(cat $i | tail -n +2 | cut -d ':' -f 8 )
	printf $timeExec1"\n" >> $sumaInicial
	printf $timeExec2"\n" >> $sumaInicial
	printf $timeExec3"\n" >> $sumaInicial
	cmdSum=$(cat $sumaInicial | awk 'BEGIN {n=0} {n =+ $1}; END{print n}')
	printf $cmdSum"\n" >> $sumaFinal

done

cmdPromMaxMin=$(cat $sumaFinal | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
								if($1>max){max=$1};\
							        total+=$1; count+=1;\
						           	} \
							 	END { print total/count, max, min}')


metricsFile="metrics.txt"
rm -f $metricsFile


echo $cmdPromMaxMin

printf $cmdPromMaxMin"\n" >> $metricsFile


