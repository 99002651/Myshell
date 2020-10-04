#!/usr/bin/bash

INPUT_FILE='Input.csv'
mydir="$(pwd)"

IFS=','
[ ! -f $INPUT_FILE ] && { echo "$INPUT_FILE file not found"; exit 99; }
while read Name Email_ID Repo_link
do

echo "Name - $Name"
echo "Email - $Email_ID"
echo "Repo_link - $Repo_link"
echo "status"
echo "status1"
echo "status2"

repository=$Repo_link
localFolder="/home/anusha/Downloads/ShellScripting/Sandhya"

git clone "$repository" "$localFolder"

if [ $? -eq 0 ]; then
       cd Sandhya
       make
	if [ $? -eq 0 ]; then
		cppcheck *.c* > "$mydir"/cppreport.txt 2>&1
		if [ $? -eq 0 ]; then
			valgrind ./*.out >"$mydir"/valgrind.txt 2>&1
			lastline="$(tail -n 1 "$mydir"/valgrind.txt)"
			errors="$(cut -d" " -f4 <<<"$lastline")"
			echo -n "$errors " >>"$mydir"/Results.csv 
        printf '%s' $Name,$Email_ID,$Repo_link,success,success,success | paste -sd ',' >> Results.csv
       else
        printf '%s' $Name,$Email_ID,$Repo_link,failed,failed,failed | paste -sd ',' >> Results.csv
    	fi
   fi
fi
done < $INPUT_FILE
