#!/bin/bash

usage_manual(){
        printf "\nUso $0 -d <directorio> [-h]\n"
        printf "\t-d: directorio donde estan los datos.\n"
        printf "\t-h: muestra este mensaje y termina.\n"
        exit 1
}

while getopts "d:h" opcion; do
        case "$opcion" in


                d)
                        directorio=$OPTARG
                        ;;

                h)
                        usage_manual
                        ;;
                *)
                        echo "Función incorrecta"
                        usage_manual
                        ;;
        esac
done

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

#Parte 1

executionSummaryFiles=(`find $searchDir -name '*.txt' -print | sort | grep execution | grep -v '._'`)

metricsFile="metrics.txt"
rm -f $metricsFile

sumaInicialExec="sumaInicialExec.txt"
rm -f $sumaInicialExec

sumaInicialMem="sumaInicialMem.txt"
rm -f $sumaInicialMem

for i in ${executionSummaryFiles[*]};
do
        printf "> %s\n" $i
        timeSimTotal=$(cat $i | tail -n +2 | awk -F ':' 'BEGIN{sumTimeExec=0}{sumTimeExec=$6+$7+$8} END{print sumTimeExec}')
        echo $timeSimTotal >> $sumaInicialExec
        memoryUsageTotal=$(cat $i | tail -n +2 | cut -d ':' -f 10)
        echo $memoryUsageTotal >> $sumaInicialMem

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


printf "tsimTotal:promedio:min:max\n" >> $metricsFile
echo $cmdPromMaxMinExec >> $metricsFile
printf "memUsed:promedio:min:max\n" >> $metricsFile
echo $cmdPromMaxMinMem >> $metricsFile

rm -f sumaInicialExec.txt sumaInicialMem.txt

#Parte 2

summaryFiles=(`find $searchDir -name '*.txt' -print | sort | grep summary | grep -v '._'`)

evacuationFiles="evacuation.txt"
rm -f $evacuationFiles

allPeople="personasTotales.txt"
rm -f $allPeople

residents="residentes.txt"
rm -f $residents

visitType1="visitanteTipo1.txt"
rm -f $visitType1

#residentAge="residenteEdad.txt"
#rm -f $residentAge

#visitAge="visitanteEdad.txt"
#rm -f $visitAge

for i in ${summaryFiles[*]};
do
        printf "> %s\n" $i
        alls=$(cat $i | tail -n +2 | awk -F ':' 'BEGIN{sumPeople=0}{sumPeople+=$8} END{print sumPeople}')
        echo $alls >> $allPeople
        resident=$(cat $i | tail -n +2 | awk -F ':' 'BEGIN{sumResidents=0}; {if($3==0){sumResidents+=$8}} END{print sumResidents}')
        echo $resident >> $residents
        visitType=$(cat $i | tail -n +2 | awk -F ':' 'BEGIN{sumVisitType1=0}; {if($3==1){sumVisitType1+=$8}} END{print sumVisitType1}')
        echo $visitType >> $visitType1
 #       for j in {0..3 }
  #      do
   #             residentAgeN=$(cat $i | tail -n +2 | awk -F ':' 'BEGIN{residentAge0=0}; {if($3==0 && $4==j){residentAge0+=$8}} END{print residentAge0}')
    #            echo $residentAgeN >> $residentAge
     #   done

done

cmdPromMaxMinAllPeople=$(cat $allPeople | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                if($1>max){max=$1};\
                                                                total+=$1; count+=1;\
                                                                } \
                                                                END { print total":"total/count":"min":"max}')
cmdPromMaxMinResidents=$(cat $residents | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                if($1>max){max=$1};\
                                                                total+=$1; count+=1;\
                                                                } \
                                                                END { print total":"total/count":"min":"max}')
cmdPromMaxMinVisitorsI=$(cat $visitType1 | awk 'BEGIN{ min=2**63-1; max=0}{ if($1<min){min=$1};\
                                                                if($1>max){max=$1};\
                                                                total+=$1; count+=1;\
                                                                } \
                                                                END { print total":"total/count":"min":"max}')


printf "alls:promedio:min:max \n" >> $evacuationFiles
echo $cmdPromMaxMinAllPeople >> $evacuationFiles
printf "residents:promedio:min:max \n" >> $evacuationFiles
echo $cmdPromMaxMinResidents >> $evacuationFiles
printf "visitorsI:promedio:min:max \n" >> $evacuationFiles
echo $cmdPromMaxMinVisitorsI >> $evacuationFiles


rm -f personasTotales.txt residentes.txt visitanteTipo1.txt

#Parte 3
#Basado en ejemplo de profesor

usePhoneresults="usePhone-stats.txt"
rm -f $usePhoneresults


usePhoneFiles=(`find $searchDir -name '*.txt' -print | sort | grep usePhone | grep -v '._'`)

phoneUsage="phoneUsage.txt"
rm -f $phoneUsage

for i in ${usePhoneFiles[*]};
do
        printf "> %s\n" $i
        tiempos=(`cat $i | tail -n+3 | cut -d ':' -f 3`)
        for i in ${tiempos[*]};
        do
                printf "%d:" $i >> $phoneUsage
        done
        printf "\n" >> $phoneUsage
done

totalFields=$(head -1 $phoneUsage | sed 's/.$//' | tr ':' '\n'| wc -l) >> $usePhoneresults
printf "timestamp:promedio:min:max\n" >> $usePhoneresults
for i in $(seq 1 $totalFields); do
        usage=$(cat $phoneUsage | cut -d ':' -f $i |\
                             awk 'BEGIN{ min=2**63-1; max=0}\
                             {if($1<min){min=$1};if($1>max){max=$1};total+=$1; count+=1;}\
                             END {print total/count":"max":"min}')
        printf "$i:$usage\n" >> $usePhoneresults
done

rm -f phoneUsage.txt



