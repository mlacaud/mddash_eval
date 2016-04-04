#!/bin/bash

#rebuff
paste parsed/rebuffout.txt resultsoracles/dash3S/rebuffout.txt > toplot/rebuffout.txt
paste toplot/rebuffout.txt resultsoracles/dash9S/rebuffout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/rebuffout.txt > toplot/tmp2.txt
paste toplot/tmp2.txt resultsoracles/mddash9S/rebuffout.txt > toplot/rebuffout.txt

rm toplot/tmp.txt
rm toplot/tmp2.txt

paste parsed/amplqout.txt resultsoracles/dash3S/amplqout.txt > toplot/amplqout.txt
paste toplot/amplqout.txt resultsoracles/dash9S/amplqout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/amplqout.txt > toplot/tmp2.txt
paste toplot/tmp2.txt resultsoracles/mddash9S/amplqout.txt > toplot/amplqout.txt

rm toplot/tmp.txt
rm toplot/tmp2.txt

paste parsed/nbqchangeout.txt resultsoracles/dash3S/nbqchangeout.txt > toplot/nbqchangeout.txt
paste toplot/nbqchangeout.txt resultsoracles/dash9S/nbqchangeout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/nbqchangeout.txt > toplot/tmp2.txt
paste toplot/tmp2.txt resultsoracles/mddash9S/nbqchangeout.txt > toplot/nbqchangeout.txt

rm toplot/tmp.txt
rm toplot/tmp2.txt

paste parsed/overheadout.txt resultsoracles/dash3S/overheadout.txt > toplot/overheadout.txt
paste toplot/overheadout.txt resultsoracles/dash9S/overheadout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/overheadout.txt > toplot/tmp2.txt
paste toplot/tmp2.txt resultsoracles/mddash9S/overheadout.txt > toplot/overheadout.txt

rm toplot/tmp.txt
rm toplot/tmp2.txt

paste parsed/meanbitrateout.txt resultsoracles/dash3S/meanbitrateout.txt > toplot/meanbitrateout.txt
paste toplot/meanbitrateout.txt resultsoracles/dash9S/meanbitrateout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/meanbitrateout.txt > toplot/tmp2.txt
paste toplot/tmp2.txt resultsoracles/mddash9S/meanbitrateout.txt > toplot/meanbitrateout.txt

rm toplot/tmp.txt
rm toplot/tmp2.txt

#Percent 3S
paste parsed/percentqout.txt resultsoracles/dash3S/percentqout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash3S/percentqout.txt > toplot/percentqout.txt

rm toplot/tmp.txt

#Percent 9S
paste parsed/percentq2out.txt resultsoracles/dash9S/percentqout.txt > toplot/tmp.txt
paste toplot/tmp.txt resultsoracles/mddash9S/percentqout.txt > toplot/percentq2out.txt

rm toplot/tmp.txt
