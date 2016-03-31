#!/bin/bash

mkdir plot

file=plot/percentqout.txt

>plot/meanbitrateout.txt

echo "NetworkProfile 1 2 3 4 5 6" >> plot/meanbitrateout.txt


echo MDDash `awk 'NR>1{print (200*$2+400*$3+1000*$4+1600*$5+2000*$6+3000*$7+4000*$8+6000*$9)/($2+$3+$4+$5+$6+$7+$8+$9)}' $file` >> plot/meanbitrateout.txt

echo MDC `awk 'NR>1{print (400*$10+6000*$11)/($10+$11)}' $file` >> plot/meanbitrateout.txt
