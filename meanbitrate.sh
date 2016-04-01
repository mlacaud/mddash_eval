#!/bin/bash

mkdir parsed

file=parsed/percentqout.txt
file2=parsed/percentq2out.txt

>parsed/meanbitrateout.txt

echo "NetworkProfile 1 2 3 4 5 6" >> parsed/meanbitrateout.txt


echo MDDash3S `awk 'NR>1{print (200*$2+400*$3+1000*$4+1600*$5+2000*$6+3000*$7+4000*$8+6000*$9)/($2+$3+$4+$5+$6+$7+$8+$9)}' $file` >> parsed/meanbitrateout.txt

echo MDC `awk 'NR>1{print (400*$10+6000*$11)/($10+$11)}' $file` >> parsed/meanbitrateout.txt

echo MDDash9S `awk 'NR>1{print (200*$2+400*$3+1000*$4+1600*$5+2000*$6+3000*$7+4000*$8+6000*$9)/($2+$3+$4+$5+$6+$7+$8+$9)}' $file2` >> parsed/meanbitrateout.txt
