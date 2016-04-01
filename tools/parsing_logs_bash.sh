#!/bin/bash
#1 - Create database
#2 - Fill in database with data 


if [ $# -ne 5 ]
then
	echo "usage exec des1logfile des2logfile des3logfile outputfile mdc/mddash";
	exit;
fi

declare -A des1_ind;
declare -A des1_q
declare -A des1_dropped

declare -A des2_ind
declare -A des2_q
declare -A des2_dropped

declare -A des3_ind
declare -A des3_q
declare -A des3_dropped
 
declare -A final_ind
declare -A final_q;
declare -A final_overhead;
declare -A q

declare -A line_q
##### ------ ------ #####
rebuflog="./results/test/Fri_Mar_25_16_43_53_CET_2016_Rebuff.txt"
#~ des1log="./results/test/Fri_Mar_25_16_55_58_CET_2016_Description1.txt"
#~ des2log="./results/test/des2.txt"
#~ des3log="./results/test/Fri_Mar_25_16_55_58_CET_2016_Description1.txt"
des1log=$1
des2log=$2
des3log=$3
outputfile=$4
type=$5;

#delete first useless line
word=`awk NR==1'{print $1}' $des1log`;
if [ "$word" = "date" ]
then
	sed -i "1 d" $des1log;
fi
word=`awk NR==1'{print $1}' $des2log`;
if [ "$word" = "date" ]
then
	sed -i "1 d" $des2log;
fi
word=`awk NR==1'{print $1}' $des3log`;
if [ "$word" = "date" ]
then
	sed -i "1 d" $des3log;
fi


# remove init segment info
d1lineN=`wc -l $des1log | awk '{print $1}'`;
for i in $(seq $d1lineN); do
	word=`awk NR==$i'{print $6}' $des1log`;
	if [ "$word" = "null" ]
	then
		sed -i "$i d" $des1log;
	fi
done
d2lineN=`wc -l $des2log | awk '{print $1}'`;
for i in $(seq $d1lineN); do
	word=`awk NR==$i'{print $6}' $des2log`;
	if [ "$word" = "null" ]
	then
		sed -i "$i d" $des2log;
	fi
done

d3lineN=`wc -l $des3log | awk '{print $1}'`;
for i in $(seq $d1lineN); do
	word=`awk NR==$i'{print $6}' $des3log`;
	if [ "$word" = "null" ]
	then
		sed -i "$i d" $des3log;
	fi
done

# Prepare quality variables for final results

if [ $type = "mddash" ]
then 
	q[0,0]=1000
	q[1,0]=1600;
	q[2,0]=2000;
	q[3,0]=3000;
	q[4,0]=4000;
	q[5,0]=6000;
	q[6,0]=9000;
	q[7,0]=200;
	q[8,0]=400;
	

elif [ $type = "mdc" ]
then
	q[0,0]=6000
	q[1,0]=000;
	q[2,0]=0000;
	q[3,0]=0000;
	q[4,0]=00;
	q[5,0]=000;
	q[6,0]=000;
	q[7,0]=400;
	q[8,0]=400;
else
	echo "wrong type passed in parameters!";
	exit;
fi
q[0,1]=0
q[1,1]=0;
q[2,1]=0;
q[3,1]=0;
q[4,1]=0;
q[5,1]=0;
q[6,1]=0;
q[7,1]=0;
q[8,1]=0;

####### ----- Filling arrays ------ 11111
d1lineN=`wc -l $des1log | awk '{print $1}'`;
for i in $(seq $d1lineN); do
	dropInt=`awk NR==$i'{print $2}' $des1log`;
	[[ $dropInt = "true" ]] && flag=1 || flag=0;
	des1_dropped[$i]=$flag;
	des1_ind[$i]=`awk NR==$i'{print $6}' $des1log`;
	des1_q[$i]=`awk NR==$i'{print $7}' $des1log`;
done

d2lineN=`wc -l $des2log | awk '{print $1}'`;
for i in $(seq $d2lineN); do
	dropInt=`awk NR==$i'{print $2}' $des2log`;
	[[ $dropInt = "true" ]] && flag=1 || flag=0;
	des2_dropped[$i]=$flag;
	des2_ind[$i]=`awk NR==$i'{print $6}' $des2log`;
	des2_q[$i]=`awk NR==$i'{print $7}' $des2log`;
done

d3lineN=`wc -l $des3log | awk '{print $1}'`;
for i in $(seq $d3lineN); do
	dropInt=`awk NR==$i'{print $2}' $des3log`;
	[[ $dropInt = "true" ]] && flag=1 || flag=0;
	des3_dropped[$i]=$flag;
	des3_ind[$i]=`awk NR==$i'{print $6}' $des3log`;
	des3_q[$i]=`awk NR==$i'{print $7}' $des3log`;
done

# Fill final_ind
for i in $(seq $d1lineN); do
	final_ind[$i]=${des1_ind[$i]};
done;
	
# Fill final_q // final_q is a matrix which contains in the rows the segment ID and in the columns contribution of other des
for i in $(seq $d1lineN); do
	# 1 2 and 3 for the description number
	final_q[$i,1]=${des1_q[$i]};
	final_q[$i,2]=${des2_q[$i]};
	final_q[$i,3]=${des3_q[$i]};
	
	if [ ${des1_dropped[$i]} = 1 ]
	then
		final_q[$i,1]=-1;
		#echo "put at -1";
		#echo ${final_q[$i,1]};
	fi
	
	if [ ${des2_dropped[$i]} = 1 ] 
	then
		final_q[$i,2]=-1;
	fi
	
	if [ ${des3_dropped[$i]} = 1 ] 
	then
		final_q[$i,3]=-1;
	fi	
done;

for i in $(seq $d1lineN); do

	flag1=0;
	flag2=0;
	flag3=0;
	
	case "${final_q[$i,1]}" in
	0)  q[0,1]=$((${q[0,1]}+1));
	    ;;
	1)  q[1,1]=$((${q[1,1]}+1));
	    ;;
	2)  q[2,1]=$((${q[2,1]}+1));
	    ;;
	3)  q[3,1]=$((${q[3,1]}+1));
	    ;;
	4)  q[4,1]=$((${q[4,1]}+1));
	    ;;
	5)  q[5,1]=$((${q[5,1]}+1));
	    ;;
	6)  q[6,1]=$((${q[6,1]}+1));
	    ;;
	-1) flag1=1;
		max=-1;
		[[ ${final_q[$i, 2]} -ge ${final_q[$i,3]} ]] && max=${final_q[$i,2]} || max=${final_q[$i,3]}
		[[ $max -ge 5 ]] && q[8,1]=$((${q[8,1]}+1)) || q[7,1]=$((${q[7,1]}+1));
	    ;;
	*) echo "PROBLEM!!!!"
		;;
	esac

	case "${final_q[$i,2]}" in
	0)  q[0,1]=$((${q[0,1]}+1));
	    ;;
	1)  q[1,1]=$((${q[1,1]}+1));
	    ;;
	2)  q[2,1]=$((${q[2,1]}+1));
	    ;;
	3)  q[3,1]=$((${q[3,1]}+1));
	    ;;
	4)  q[4,1]=$((${q[4,1]}+1));
	    ;;
	5)  q[5,1]=$((${q[5,1]}+1));
	    ;;
	6)  q[6,1]=$((${q[6,1]}+1));
	    ;;
	-1) flag2=1;
		max=-1;
		[[ ${final_q[$i,1]} -ge ${final_q[$i,3]} ]] && max=${final_q[$i,1]} || max=${final_q[$i,3]};
		[[ $max -ge 5 ]] && q[8,1]=$((${q[8,1]}+1)) || q[7,1]=$((${q[7,1]}+1));	
		;;
	*) echo "PROBLEM!!!!??? ${final_q[$i,2]}"
		;;
	esac

	case "${final_q[$i,3]}" in
	"0")  q[0,1]=$((${q[0,1]}+1));
	    ;;
	1)  q[1,1]=$((${q[1,1]}+1));
	    ;;
	2)  q[2,1]=$((${q[2,1]}+1));
	    ;;
	3)  q[3,1]=$((${q[3,1]}+1));
	    ;;
	4)  q[4,1]=$((${q[4,1]}+1));
	    ;;
	5)  q[5,1]=$((${q[5,1]}+1));
	    ;;
	6)  q[6,1]=$((${q[6,1]}+1));
	    ;;
	-1)  flag3=1;
		max=-1;
		[[ ${final_q[$i,1]} -ge ${final_q[$i,2]} ]] && max=${final_q[$i,1]} || max=${final_q[$i,2]};
		[[ $max -ge 5 ]] && q[8,1]=$((${q[8,1]}+1)) || q[7,1]=$((${q[7,1]}+1));
	    ;;
	*) echo "PROBLEM!!!!----"
		;;
	esac
	#~ 
	#~ #if toute les description ont été perdu
	#~ if [ $flag1 = 1 ] && [ $flag2 = 1 ] && [ $flag3 = 1 ]
	#~ then
		#~ echo "très certainement du rebufferring here!";
	#~ elif [ $flag1 = 1 ] && [ $flag2 = 1 ]
	#~ then
		#~ if [ "${final_q[$i,3]}" = "6" ] || [ "${final_q[$i,3]}" = "5" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 3, ${q[8,0]}";
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo "----- ${q[7,1]}"
			#~ echo "adding quality of description 3, ${q[7,0]}";
		#~ fi
	#~ elif [ $flag1 = 1 ] && [ $flag3 = 1 ]
	#~ then
		#~ if [ ${final_q[$i,2]} = 6 ] 
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ echo "adding quality of description 2, ${q[8,0]}";
		#~ elif [ ${final_q[$i,2]} = 5 ] 
		#~ then 
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 2, ${q[8,0]}";
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo "----- ${q[7,1]}"
			#~ #echo "adding quality of description 2, ${q[7,0]}";
		#~ fi
	#~ elif [ $flag2 = 1 ] && [ $flag3 = 1 ]
	#~ then
		#~ if [ "${final_q[$i,1]}" = "6" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 1, ${q[8,0]}";
		#~ elif [ "${final_q[$i,1]}" = "5" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo " ${q[7,1]}"
			#~ #echo "adding quality of description 1, ${q[7,0]}";
		#~ fi
	#~ elif [ $flag1 = 1 ]
	#~ then
		#~ if [ "${final_q[$i,2]}" = "6" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 1, ${q[8,0]}";
		#~ elif [ "${final_q[$i,2]}" = "5" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo " ${q[7,1]}"
			#~ #echo "adding quality of description 1, ${q[7,0]}";
		#~ fi
	#~ elif [ $flag2 = 1 ]
	#~ then
		#~ if [ "${final_q[$i,1]}" = "6" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 1, ${q[8,0]}";
		#~ elif [ "${final_q[$i,1]}" = "5" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo " ${q[7,1]}"
			#~ #echo "adding quality of description 1, ${q[7,0]}";
		#~ fi
	#~ else
		#~ if [ "${final_q[$i,1]}" = "6" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
			#~ #echo "adding quality of description 1, ${q[8,0]}";
		#~ elif [ "${final_q[$i,1]}" = "5" ]
		#~ then
			#~ q[8,1]=$((${q[8,1]}+1));
		#~ else
			#~ q[7,1]=$((${q[7,1]}+1));
			#~ #echo " ${q[7,1]}"
			#~ #echo "adding quality of description 1, ${q[7,0]}";
		#~ fi
	#~ fi
done;

#compute quality change
quality_change_count=0;
for i in $(seq $d1lineN); do
	if [ ${final_q[$i,3]} -ne ${final_q[$i,2]} ] || [ ${final_q[$i,3]} -ne ${final_q[$i,1]} ] || [ ${final_q[$i,2]} -ne ${final_q[$i,1]} ]
	then
		quality_change_count=$(($quality_change_count+1));
	fi
done

#compute number of dropped and therefore quality change amplitude
j=0;
for i in $(seq $d1lineN); do

	case "${final_q[$i,1]}" in
	0) line_q[$j]=${q[0,0]};
	    ;;
	1) line_q[$j]=${q[1,0]};
	    ;;
	2) line_q[$j]=${q[2,0]};
	    ;;
	3) line_q[$j]=${q[3,0]};
	    ;;
	4) line_q[$j]=${q[4,0]};
	    ;;
	5) line_q[$j]=${q[5,0]};
	    ;;
	6) line_q[$j]=${q[6,0]};
	    ;;
	-1) flag1=1;
		[[ ${final_q[$i,3]} -ge 5 ]] && line_q[$j]=${q[8,0]} || line_q[$j]=${q[7,0]};
	    ;;
	*) echo "PROBLEM!!!! with 1 ${final_q[$i,1]}"
		;;
	esac
	j=$(($j+1));
	
	case "${final_q[$i,2]}" in
	0) line_q[$j]=${q[0,0]};
	    ;;
	1) line_q[$j]=${q[1,0]};
	    ;;
	2) line_q[$j]=${q[2,0]};
	    ;;
	3) line_q[$j]=${q[3,0]};
	    ;;
	4) line_q[$j]=${q[4,0]};
	    ;;
	5) line_q[$j]=${q[5,0]};
	    ;;
	6) line_q[$j]=${q[6,0]};
	    ;;
	-1) flag1=1;
		[[ ${final_q[$i,1]} -ge 5 ]] && line_q[$j]=${q[8,0]} || line_q[$j]=${q[7,0]};
	    ;;
	*) echo "PROBLEM!!!!??? with 2 ${final_q[$i,2]}"
		;;
	esac
	j=$(($j+1));
	
	case "${final_q[$i,3]}" in
	0) line_q[$j]=${q[0,0]};
	    ;;
	1) line_q[$j]=${q[1,0]};
	    ;;
	2) line_q[$j]=${q[2,0]};
	    ;;
	3) line_q[$j]=${q[3,0]};
	    ;;
	4) line_q[$j]=${q[4,0]};
	    ;;
	5) line_q[$j]=${q[5,0]};
	    ;;
	6) line_q[$j]=${q[6,0]};
	    ;;
	-1) flag1=1;
		[[ ${final_q[$i,2]} -ge 5 ]] && line_q[$j]=${q[8,0]} || line_q[$j]=${q[7,0]};
	    ;;
	*) echo "PROBLEM!!!!---- with 3 ${final_q[$i,3]}"
		;;
	esac
	j=$(($j+1));
done


changeCnt=0;
cumulatedDiff=0;
segmentNb=$((3*$d1lineN-1));
for i in $(seq $((3*$d1lineN-1)) )
do
	#echo "seg $i is ${line_q[$i]}";
	if [ "${line_q[$i]}" != "${line_q[$((i+1))]}" ]
	then
		if [ "${line_q[$((i+1))]}" = "" ]
		then 
			echo "... done!";
		else	
			changeCnt=$((changeCnt+1));
			val=$((${line_q[$i]}-${line_q[$((i+1))]}));
			val=${val/-/};
			cumulatedDiff=$(($cumulatedDiff+$val));
		fi
	fi
	#echo ${line_q[$i]};
done

# Compute overhead
declare -A overhead;
declare -A overhead_cnt;
declare -A ove_tmp;
ove_tmp=0;
transit_tmp=0;
declare -A transit_tmp
for i in $(seq $d1lineN)
do
	if [ ${des1_dropped[$i]} = 0 ] && [ ${des2_dropped[$i]} = 0 ] && [ ${des3_dropped[$i]} = 0 ]
	then
		tmp1=0;
		tmp2=0;
		tmp3=0;
		tmp=0;
		[[ ${des1_q[$i]} -ge 5 ]] && tmp1=$((2*400)) || tmp1=$((2*200));
		[[ ${des2_q[$i]} -ge 5 ]] && tmp2=$((2*400)) || tmp2=$((2*200));
		[[ ${des3_q[$i]} -ge 5 ]] && tmp3=$((2*400)) || tmp3=$((2*200));
		if [ $type = "mddash" ]
		then 
			tmp=$((2*$tmp1+$tmp2+$tmp3));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des1_q[$i]},0]}+${q[${des2_q[$i]},0]}+${q[${des3_q[$i]},0]}+2*$tmp1+2*$tmp2+2*$tmp3));		
		else
			tmp=$((2*400+2*400+400));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des1_q[$i]},0]}+${q[${des2_q[$i]},0]}+${q[${des3_q[$i]},0]}+2*$tmp1+2*$tmp2+2*$tmp3));		
		fi
		
		#echo "overhead is $ove_tmp | transit is $transit_tmp | overhead for this turn $tmp";
	elif [ ${des1_dropped[$i]} = 0 ] && [ ${des2_dropped[$i]} = 0 ]
	then 
		tmp=0;
		tmp1=0;
		tmp2=0;
		tmp3=0;
		[[ ${des1_q[$i]} -ge 5 ]] && tmp1=$((2*400)) || tmp1=$((2*200));
		[[ ${des2_q[$i]} -ge 5 ]] && tmp2=$((2*400)) || tmp2=$((2*200));
		if [ $type = "mddash" ]
		then 
			tmp=$(($tmp1+$tmp2));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des1_q[$i]},0]}+${q[${des2_q[$i]},0]}+2*$tmp1+$tmp2));		
		else
			tmp=$((400+400));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des1_q[$i]},0]}+${q[${des2_q[$i]},0]}+2*$tmp1+$tmp2));		
		fi
		#echo "overhead is $ove_tmp | transit is $transit_tmp | overhead for this turn $tmp";
	elif [ ${des2_dropped[$i]} = 0 ] && [ ${des3_dropped[$i]} = 0 ]
	then
		tmp=0;
		tmp1=0;
		tmp2=0;
		tmp3=0;
		[[ ${des2_q[$i]} -ge 5 ]] && tmp2=$((2*400)) || tmp2=$((2*200));
		[[ ${des3_q[$i]} -ge 5 ]] && tmp3=$((2*400)) || tmp3=$((2*200));
		if [ $type = "mddash" ]
		then 
			tmp=$(($tmp2+$tmp3));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des2_q[$i]},0]}+${q[${des3_q[$i]},0]}+2*$tmp2+$tmp3));		
		else
			tmp=$((2*400+400));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des2_q[$i]},0]}+${q[${des3_q[$i]},0]}+2*$tmp2+$tmp3));		
		fi
		#echo "overhead is $ove_tmp | transit is $transit_tmp | overhead for this turn $tmp";	
	elif [ ${des1_dropped[$i]} = 0 ] && [ ${des3_dropped[$i]} = 0 ]
	then
		tmp=0;
		tmp1=0;
		tmp2=0;
		tmp3=0;
		[[ ${des1_q[$i]} -ge 5 ]] && tmp1=$((2*400)) || tmp1=$((2*200));
		[[ ${des3_q[$i]} -ge 5 ]] && tmp3=$((2*400)) || tmp3=$((2*200));
		if [ $type = "mddash" ]
		then 
			tmp=$(($tmp1+$tmp3));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des1_q[$i]},0]}+${q[${des3_q[$i]},0]}+$tmp1+$tmp3));		
		else
			tmp=$((2*400+400));
			ove_tmp=$(($ove_tmp+$tmp));
			transit_tmp=$(($transit_tmp+${q[${des2_q[$i]},0]}+${q[${des3_q[$i]},0]}+2*$tmp1+$tmp3));		
		fi
			
	else
		echo "no overhead!";
	fi
done

#~ 
		#~ if [ ${final_q[$i,1]} != -1 ]
		#~ then
			#~ ove_tmp=0;
			#~ if [ ${final_q[$i,2]} != -1 ]
			#~ then
				#~ #consider overhead from the two descriptions
				#~ if [ ${final_q[$i,1]} >= 5 ]
				#~ then
					#~ ove_tmp=$(($ove_tmp+400));
				#~ else
					#~ ove_tmp=$(($ove_tmp+200))
				#~ fi
	#~ 
			#~ fi
		#~ else 
			#~ 
		#~ fi
	#~ 
	#~ 

# % quality
a=`echo "${q[0,1]} / $segmentNb" | bc -l`;
b=`echo "${q[1,1]} / $segmentNb" | bc -l`;
c=`echo "${q[2,1]} / $segmentNb" | bc -l`;
d=`echo "${q[3,1]} / $segmentNb" | bc -l`;
e=`echo "${q[4,1]} / $segmentNb" | bc -l`;
f=`echo "${q[5,1]} / $segmentNb" | bc -l`;
g=`echo "${q[6,1]} / $segmentNb" | bc -l`;
h=`echo "${q[7,1]} / $segmentNb" | bc -l`;
i=`echo "${q[8,1]} / $segmentNb" | bc -l`;


# % overhead
overhead=`echo "$ove_tmp / $transit_tmp" | bc -l`

# Amplitude
declare -A mean_amplitude_change;
mean_aplitude_change=0;
if [ $changeCnt != 0 ]
then
	if [ $type = "mddash"  ]
	then
		cumulatedDiff=`echo "(($cumulatedDiff - 8000 * 30/100 * (${q[7,1]} + ${q[8,1]}) ))" | bc -l`;
	fi
	mean_amplitude_change=`echo "$cumulatedDiff / $changeCnt" | bc -l`;
fi

#output result

if [ $type = "mddash" ]
then 
	echo "-----------------------------
amplitudebandwidth cumudiff changecnt
$mean_amplitude_change - $cumulatedDiff - $changeCnt
-----------------------------
Q Nb_of_segment % 
${q[0,0]} ${q[0,1]} $a
${q[1,0]} ${q[1,1]} $b
${q[2,0]} ${q[2,1]} $c
${q[3,0]} ${q[3,1]} $d
${q[4,0]} ${q[4,1]} $e
${q[5,0]} ${q[5,1]} $f
${q[6,0]} ${q[6,1]} $g
${q[7,0]} ${q[7,1]} $h
${q[8,0]} ${q[8,1]} $i
-----------------------------
overhead $overhead % " > $outputfile

	echo "-----------------------------
amplitudebandwidth cumudiff changecnt
$mean_amplitude_change - $cumulatedDiff - $changeCnt
-----------------------------
Q Nb_of_segment % 
${q[0,0]} ${q[0,1]} $a
${q[1,0]} ${q[1,1]} $b
${q[2,0]} ${q[2,1]} $c
${q[3,0]} ${q[3,1]} $d
${q[4,0]} ${q[4,1]} $e
${q[5,0]} ${q[5,1]} $f
${q[6,0]} ${q[6,1]} $g
${q[7,0]} ${q[7,1]} $h
${q[8,0]} ${q[8,1]} $i
-----------------------------
overhead $overhead % "
else
nb=$((${q[7,1]}+${q[8,1]}));
nb1=`echo "$i + $h" | bc -l`;

	echo "-----------------------------
amplitudebandwidth cumudiff changecnt
$mean_amplitude_change - $cumulatedDiff - $changeCnt
-----------------------------
Q Nb_of_segment % 
${q[0,0]} ${q[0,1]} $a
${q[7,0]} $nb $nb1;
-----------------------------
overhead $overhead % " > $outputfile
	
	echo "-----------------------------
amplitudebandwidth cumudiff changecnt
$mean_amplitude_change - $cumulatedDiff - $changeCnt
-----------------------------
Q Nb_of_segment % 
${q[0,0]} ${q[0,1]} $a
${q[7,0]} $nb $nb1;
-----------------------------
overhead $overhead % "
	

fi
# Fill final_overhead













