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

sumaInicialExec="sumaInicialExec.txt"
rm -f $sumaInicialExec

sumaInicialMem="sumaInicialMem.txt"
rm -f $sumaInicialMem

for i in ${executionSummaryFiles[*]};
do
	printf "> %s\n" $i
	timeExec1=$(cat $i | tail -n +2 | cut -d ':' -f 6 )
	timeExec2=$(cat $i | tail -n +2 | cut -d ':' -f 7 )
	timeExec3=$(cat $i | tail -n +2 | cut -d ':' -f 8 )
	echo $timeExec1 >> $sumaInicialExec
	echo $timeExec2 >> $sumaInicialExec
	echo $timeExec3 >> $sumaInicialExec
	memoryUsage=$(cat $i | tail -n +2 | cut -d ':' -f 9)
	echo $memoryUsage >> $sumaInicialMem

done

cmdPromMaxMinExec=$(cat $sumaInicialExec | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
								if($1>max){max=$1};\
							        total+=$1; count+=1;\
						           	} \
							 	END { print total":"total/count":"min":"max}')

cmdPromMaxMinMem=$(cat $sumaInicialMem  | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                if($1>max){max=$1};\
                                                                total+=$1; count+=1;\
                                                                } \
                                                                END { print total":"total/count":"min":"max}')


metricsFile="metrics.txt"
rm -f $metricsFile


echo $cmdPromMaxMinExec >> $metricsFile
echo $cmdPromMaxMinMem >> $metricsFile

rm sumaInicialExec.txt
rm sumaInicialMem.txt



