#!/bin/bash
if [ $# -ne 1 ]
then
	echo "usage exec inputfile";
	exit;
fi

input=$1

size=$((`cat $input | wc -l`-2))

error=0

numberstop=`cat $input | grep Start |wc -l`

if [ $numberstop = 0 ]
then
echo 0
exit;
fi

#compute real number
>tmprebuff.txt
declare datestop
declare datestart
declare result

for i in $(seq $size)
do
  datestop[$i]=`awk NR==$(($i+2))'{if($2 == "Stop") print $1;}' $input`
done
echo ${datestop[@]} >> tmprebuff.txt
for i in $(seq $size)
do
  datestart[$i]=`awk NR==$(($i+2))'{if($2 == "Start") print $1;}' $input`
done
echo ${datestart[@]} >> tmprebuff.txt

for i in $(seq $numberstop)
do
  max=`awk 'NR==2{print $'$i'}' tmprebuff.txt`
  min=`awk 'NR==1{print $'$i'}' tmprebuff.txt`
if [ $((max-min)) -le 100 ]
then
  error=$(($error+1))
fi
done

rm tmprebuff.txt

#create output
echo $((${numberstop}-${error}))
