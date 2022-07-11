#!/bin/bash
declare -A org_array
declare -A org_int_array
counter=0

while true 
do
sleep 3
arr="$(ls /sys/class/net/)"
declare -A int_ip_arr

readarray -d $'\n' -t newarr <<< "$arr"
echo ${newarr[1]}

for val in ${newarr[@]};
do 
ip=$(ifconfig $val | grep -o -P '(?<=inet ).*(?= netmask)')
subnet=$(ifconfig $val | grep -o -P '(?<=netmask ).*(?= broadcast)')
broadcast=$(ifconfig $val | grep -o -P '(?<=broadcast ).*')
int_specs=""
int_specs+=$ip
int_specs+=" , "
int_specs+=$subnet
int_specs+=" , "
int_specs+=$broadcast
int_ip_arr+=$val
int_ip_arr[$val]=$int_specs
echo $ip
echo $subnet
echo $broadcast
echo $int_specs
echo ${int_ip_arr[$val]}
done
echo "For loop is finished"

echo ${int_ip_arr[$1]}

if [ $counter -gt 0 ] ;
then

for int in ${newarr[@]};
do
IFS=' , ' 
read -ra spec_array <<< ${int_ip_arr[$int]}
read -ra org_spec_array <<< ${org_array[$int]}
if [ ${org_spec_array[0]}==${spec_array[0]} ] && [ ${org_spec_array[1]}==${spec_array[1]} ] && [ ${org_spec_array[2]}==${spec_array[2]} ] ;
then echo "Clean configurations!"
else echo "Bad Configurations!!!"
fi
done
fi

echo ${spec_array[2]}

if [ $counter == 0 ] ;
then org_array=$int_ip_arr
org_int_array=$newarr
for val in ${newarr[@]};
do
org_array[$val]=${int_ip_arr[$val]}
echo "ADDED"
echo $org_array[$val]
done
echo "Array Is Coppiedddd"
counter=1
fi

if [ ${#newarr[@]} == ${#org_int_array[@]} ] ;
then echo "The Number of interfaces is correct!"
else echo "The Number of interfaces is incorrect!"
fi

for val in ${org_int_array[@]};
do
if [ "${org_array[$val]}[0]"=="${int_ip_arr[$val]}[0]" ] && [ "${org_spec_array[1]}[1]"=="${spec_array[1]}[1]" ] && [ "${org_spec_array[2]}[2]"=="${spec_array[2]}[2]" ] ;
then echo "Compareeeeeeeeeed"
echo "${org_array[$val]}[0]"
echo "${int_ip_arr[$val]}[0]"
fi
done

echo "Counter is $counter"
test_1=${org_array[eth0]}
test_2=${int_ip_arr[eth0]}
echo "Original is $test_1"
echo "Init is $test_2"
int_ip_arr=()
done

