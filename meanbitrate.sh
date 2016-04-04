#!/bin/bash

mkdir parsed

file=parsed/percentqout.txt
file2=parsed/percentq2out.txt

>parsed/meanbitrateout2.txt

echo "NetworkProfile 1 2 3 4 5 6" >> parsed/meanbitrateout2.txt

echo MDC `awk 'NR>1{print (400*$10+6000*$11)/($10+$11)}' $file` >> parsed/meanbitrateout2.txt

echo MDDash3S `awk 'NR>1{print (200*$2+400*$3+1000*$4+1600*$5+2000*$6+3000*$7+4000*$8+6000*$9)/($2+$3+$4+$5+$6+$7+$8+$9)}' $file` >> parsed/meanbitrateout2.txt

echo MDDash9S `awk 'NR>1{print (200*$2+400*$3+1000*$4+1600*$5+2000*$6+3000*$7+4000*$8+6000*$9)/($2+$3+$4+$5+$6+$7+$8+$9)}' $file2` >> parsed/meanbitrateout2.txt

awk 'function max(a, b) {
  if (a > b) { return a; } else { return b; }
}BEGIN{
  max_col = 0;
}
{
  for (i = 1; i <= NF; i++) {
    array[NR, i] = $i;
  }
  max_col = max(max_col, NF);
}END{
  for (y = 1; y <= max_col; y++) {
    printf "%s", array[1, y];
    for (x = 2; x <= NR; x++) {
      printf " %s", array[x, y];
    }
    printf "\n";
  }
}' parsed/meanbitrateout2.txt > parsed/meanbitrateout.txt

rm parsed/meanbitrateout2.txt
