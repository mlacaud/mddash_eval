#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Please write : ./overheadgraph.sh [nbprofiles] [nbtests]"
else
  mkdir plot
  folder1=mddash/DescriptionStats
  folder2=mdc/DescriptionStats
  nbprofiles=$(($1 - 1))
  nbtest=$2

echo nbtest $nbtest
echo nbprofiles $nbprofiles
  echo 'NetworkProfiles mddash mdc' > plot/overheadout.txt

  >tmp.txt
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

        file1=$folder/Description1_np${i}_test${j}.txt
        file2=$folder/Description2_np${i}_test${j}.txt
        file3=$folder/Description3_np${i}_test${j}.txt

        ./parsing_logs_bash.sh ${file1} ${file2} ${file3} tmp.txt


        echo `awk 'NR==16{print $2}' tmp.txt` >> tmp$k.txt
      done

    done

    mean1=`awk 'NR>0{v+=$1;count++}END{print v/count}' tmp1.txt`
    mean2=`awk 'NR>0{v+=$1;count++}END{print v/count}' tmp2.txt`

    echo ${i} ${mean1} ${mean2} >> plot/overheadout.txt
    >tmp1.txt
    >tmp2.txt
  done

rm tmp.txt
rm tmp1.txt
rm tmp2.txt

fi
