for x in estaciones/*; do head -1 ${x} > temp1.csv; break; done
sed 's/.*/ESTACION\;&/g' temp1.csv > temp2.csv
for x in estaciones/*; do est=$(echo $x | sed -e 's/[a-zA-Z]*\///' -e 's/\.[a-zA-Z]*//');sed -e 1d -e "s/.*/${est}\;&/g" $x >> temp2.csv; done
head -n 200000 temp2.csv > temp3.csv 
sed 's/\,/\./g' temp3.csv > temp4.csv
sed 's/\;/\,/g' temp4.csv > temp5.csv
sed 's/\,\([0-9]\)\//\,0\1\//' temp5.csv  > temp6.csv
sed 's/\([0-9][0-9]\)\/\([0-9][0-9]\)\/\([0-9][0-9]\)/\1\/\2\/\3\,20\3\,\2/' temp6.csv > temp7.csv
sed 's/\,\([0-9]\)\:/\,0\1\:/' temp7.csv > temp10.csv
sed 's/\([0-9][0-9]\)\:/\1,\1\:/' temp10.csv > temp8.csv
head -n 1 temp8.csv | sed 's/,/,YEAR,MES,HORA,/2' > temp9.csv
sed 1d temp8.csv >> temp9.csv
csvsql --query 'select ESTACION,HORA,AVG(VEL) AS VELOCIDAD_PROMEDIO from temp9 group by ESTACION,HORA' temp9.csv > velocidad-por-hora.csv 
csvsql --query 'select ESTACION,YEAR,AVG(VEL) AS VELOCIDAD_PROMEDIO from temp9 group by ESTACION,YEAR' temp9.csv > velocidad-por-ano.csv 
csvsql --query 'select ESTACION,MES,AVG(VEL) AS VELOCIDAD_PROMEDIO from temp9 group by ESTACION,MES' temp9.csv > velocidad-por-mes.csv 
rm temp*.csv