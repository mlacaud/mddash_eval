#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Please write : ./alleval.sh [nbprofiles] [nbtests] [nbtest3]"
  exit;
fi
nbprofiles=$1
nbtest=$2
nbtest3=$3

bash percentq.sh $nbprofiles $nbtest
bash percentq2.sh $nbprofiles $nbtest
bash amplq.sh $nbprofiles $nbtest $nbtest3
bash nbqchange.sh $nbprofiles $nbtest $nbtest3
bash overhead.sh $nbprofiles $nbtest $nbtest3
bash rebuff.sh $nbprofiles $nbtest $nbtest3

bash meanbitrate.sh $nbprofiles $nbtest
