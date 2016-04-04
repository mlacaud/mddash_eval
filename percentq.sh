#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Please write : ./percentq.sh.sh [nbprofiles] [nbtests]"
else
  mkdir parsed
  folder1=mddash3/DescriptionStats
  folder2=mdc/DescriptionStats
  nbprofiles=$(($1 - 1))
  nbtest=$2

echo nbtest $nbtest
echo nbprofiles $nbprofiles
  echo 'NetworkProfiles mddash_3S_200 mddash_3S_400 mddash_3S_1M mddash_3S_1M6 mddash_3S_2M mddash_3S_3M mddash_3S_4M mddash_3S_6M mdc400 mdc6M' > parsed/percentqout.txt


  >tmp.txt
  for l in `seq 1 10`
  do
    >tmp${l}.txt
  done

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
            ko='seq 1 8'
            typeMD='mddash'
          else
            folder=$folder2
            ko='seq 9 10'
            typeMD='mdc'
        fi

        file1=$folder/Description1_np${i}_test${j}.txt
        file2=$folder/Description2_np${i}_test${j}.txt
        file3=$folder/Description3_np${i}_test${j}.txt

        tools/parsing_logs_bash.sh ${file1} ${file2} ${file3} tmp.txt $typeMD

        for l in `$ko`
        do
          if [ $l = 1 ]
            then
              echo `awk 'NR==13{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 2 ]
            then
              echo `awk 'NR==14{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 3 ] || [ $l = 10 ]
            then
              echo `awk 'NR==6{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 4 ] || [ $l = 9 ]
            then
              echo `awk 'NR==7{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 5 ]
            then
              echo `awk 'NR==8{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 6 ]
            then
              echo `awk 'NR==9{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 7 ]
            then
              echo `awk 'NR==10{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi
          if [ $l = 8 ]
            then
              echo `awk 'NR==11{print ($3*100)}' tmp.txt` >> tmp$l.txt
          fi

        done
      done
    done

    # Mean
    declare -a mean=()
    for l in `seq 1 10`
    do
      mean=("${mean[@]}" `awk 'NR>0{v+=$1;count++}END{print v/count}' tmp${l}.txt`)
    done

    echo $(($i+1)) ${mean[@]} >> parsed/percentqout.txt
    for l in `seq 1 10`
    do
      >tmp${l}.txt
    done
  done

rm tmp.txt
for l in `seq 1 10`
do
  rm tmp${l}.txt
done


fi
