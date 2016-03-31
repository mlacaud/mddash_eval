#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Please write : ./rebuff.sh [nbprofiles] [nbtests}"
else
  mkdir plot
  folder1=mddash/RebufferingStats
  folder2=mdc/RebufferingStats
  nbprofiles=$(($1 - 1))
  nbtest=$2
  #nbtest=$(ls ${folder1}|grep np0|wc -l)
  #nbprofiles=$(ls ${folder1}|grep test1|wc -l)

echo nbtest $nbtest
echo nbprofiles $nbprofiles
  echo 'NetworkProfiles mddash mdc' > plot/rebuffout.txt

  >tmp1.txt
  >tmp2.txt

  # For every network profile
  for i in `seq 0 $nbprofiles`
  do

    # For every test
    for j in `seq 1 $nbtest`
    do
      for k in `seq 1 2`
      do
        if [ $k = 1 ]
          then
            folder=$folder1
          else
            folder=$folder2
        fi

        file1=$folder/Rebuff_np${i}_test${j}.txt

        result=`bash parsing_rebuff.sh $file1`

        echo `bash parsing_rebuff.sh $file1` >> tmp$k.txt
      done
    done

    mean1=`awk 'NR>0{v+=$1;count++}END{print v/'$nbtest'}' tmp1.txt`
    mean2=`awk 'NR>0{v+=$1;count++}END{print v/'$nbtest'}' tmp2.txt`

    echo ${i} ${mean1} ${mean2} >> plot/rebuffout.txt

    >tmp1.txt
    >tmp2.txt
  done

rm tmp1.txt
rm tmp2.txt

fi
