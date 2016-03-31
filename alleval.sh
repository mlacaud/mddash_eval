#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Please write : ./alleval.sh [nbprofiles] [nbtests]"
  exit;
fi
nbprofiles=$(($1 - 1))
nbtest=$2

bash percentq.sh $nbprofiles $nbtest
bash amplq.sh $nbprofiles $nbtest
bash nbqchange.sh $nbprofiles $nbtest
bash overhead.sh $nbprofiles $nbtest
bash rebuff.sh $nbprofiles $nbtest

bash meanbitrate.sh $nbprofiles $nbtest
