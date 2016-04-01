#!/bin/bash
if [ $# -ne 3 ]
then
  echo "Please write : ./nbqchange.sh [nbprofiles] [nbtests] [nbtest3]"
else
  mkdir parsed
  folder1=mddash/DescriptionStats
  folder2=mdc/DescriptionStats
  folder3=mddash3/DescriptionStats
  nbprofiles=$(($1 - 1))
  nbtest=$2
  nbtest3=$3
  #nbtest=$(ls ${folder1}|grep np0|wc -l)
  #nbprofiles=$(ls ${folder1}|grep test1|wc -l)

echo nbtest $nbtest
echo nbprofiles $nbprofiles
echo nbtest3 $nbtest3
  echo 'NetworkProfiles mdc mddash_3S mddash_9S' > parsed/nbqchangeout.txt

  >tmp.txt
  >tmp1.txt
  >tmp2.txt
  >tmp3.txt

  # For every network profile
  for i in `seq 0 $nbprofiles`
  do

    # For every test
    for j in `seq 1 $nbtest`
    do
      for k in `seq 1 3`
      do
        if [ $k = 1 ]
          then
            folder=$folder2
            typeMD='mdc'
        fi
        if [ $k = 2 ]
          then
            folder=$folder3
            typeMD='mddash'
        fi
        if [ $k = 3 ]
          then
            folder=$folder1
            typeMD='mddash'
        fi

        if [ $k != 2 ]
        then
        file1=$folder/Description1_np${i}_test${j}.txt
        file2=$folder/Description2_np${i}_test${j}.txt
        file3=$folder/Description3_np${i}_test${j}.txt

        tools/parsing_logs_bash.sh ${file1} ${file2} ${file3} tmp.txt $typeMD

        echo `awk 'NR==3{print $5}' tmp.txt` >> tmp$k.txt
      else
        if [ $j -le $nbtest3 ]
        then
          file1=$folder/Description1_np${i}_test${j}.txt
          file2=$folder/Description2_np${i}_test${j}.txt
          file3=$folder/Description3_np${i}_test${j}.txt

          tools/parsing_logs_bash.sh ${file1} ${file2} ${file3} tmp.txt $typeMD

          echo `awk 'NR==3{print $5}' tmp.txt` >> tmp$k.txt
        fi
      fi
      done
    done

    mean1=`awk 'NR>0{v+=$1;count++}END{print ((v/count)/2)/'$nbtest'}' tmp1.txt`
    mean2=`awk 'NR>0{v+=$1;count++}END{print ((v/count)/2)/'$nbtest'}' tmp2.txt`
    mean3=`awk 'NR>0{v+=$1;count++}END{print ((v/count)/2)/'$nbtest'}' tmp3.txt`

    echo ${i} ${mean1} ${mean2} ${mean3} >> parsed/nbqchangeout.txt

    >tmp1.txt
    >tmp2.txt
    >tmp3.txt
  done

rm tmp.txt
rm tmp1.txt
rm tmp2.txt
rm tmp3.txt

fi
