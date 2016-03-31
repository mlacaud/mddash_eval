#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Please write : ./percentq.sh.sh [nbprofiles] [nbtests]"
else
  mkdir plot
  folder1=mddash/DescriptionStats
  folder2=mdc/DescriptionStats
  nbprofiles=$(($1 - 1))
  nbtest=$2

echo nbtest $nbtest
echo nbprofiles $nbprofiles
  echo 'NetworkProfiles mddash200 mddash400 mddash1M mddash1M6 mddash2M mddash3M mddash4M mddash6M mdc200 mdc400 mdc1M mdc1M6 mdc2M mdc3M mdc4M mdc6M' > plot/percentqout.txt


  touch tmp.txt
  for l in `seq 1 16`
  do
    touch tmp${l}.txt
  done

  # For every network profile
  for i in `seq 0 $nbprofiles`
  do

    # For every test
    for j in `seq 1 $nbtests`
    do
      for k in `seq 1 2`
      do
        if [ $k = 1 ]
          then
            folder=$folder1
            ko='seq 1 8'
          else
            folder=$folder2
            ko='seq 9 16'
        fi
        echo 'test'
        file1=$folder/Description1_np${i}_test${j}.txt
        file2=$folder/Description2_np${i}_test${j}.txt
        file3=$folder/Description3_np${i}_test${j}.txt
        echo 'parsing'
        ./parsing_logs_bash.sh ${file1} ${file2} ${file3} tmp.txt

        for l in `$ko`
        do
          if [ $l = 1 ] || [ $l = 9 ]
            then
              echo `awk 'NR==13{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 2 ] || [ $l = 10 ]
            then
              echo `awk 'NR==14{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 3 ] || [ $l = 11 ]
            then
              echo `awk 'NR==6{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 4 ] || [ $l = 12 ]
            then
              echo `awk 'NR==7{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 5 ] || [ $l = 13 ]
            then
              echo `awk 'NR==8{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 6 ] || [ $l = 14 ]
            then
              echo `awk 'NR==9{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 7 ] || [ $l = 15 ]
            then
              echo `awk 'NR==10{print $3}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 8 ] || [ $l = 16 ]
            then
              echo `awk 'NR==11{print $3}' tmp.txt` >> tmp$l.txt
          fi

        done
      done
    done

    # Mean
    declare -a mean=()
    for l in `seq 1 16`
    do
      mean=("${mean[@]}" `awk 'NR>0{v+=$1;count++}END{print v/count}' tmp${l}.txt`)
    done

    echo ${i} ${mean[@]} >> plot/percentqout.txt

  done

rm tmp.txt
for l in `seq 1 16`
do
  rm tmp${l}.txt
done


fi
