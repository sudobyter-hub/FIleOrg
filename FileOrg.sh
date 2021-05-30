#!/bin/bash 
#Author : Ali Waleed 
#Github : github.com/sudobyter-hub

#colors
RED="\e[31m"

GREEN="\e[32m"

YELLOW="\e[33m"

while : 
do
	echo -e "${GREEN} Welcome" $USER
echo -e "${RED}Please enter path of dirctory source: "

read src 

echo -e "${RED} There are $(cd $src ; ls | wc -w) files in this dirctory"

echo -e "${GREEN}Path of destenation derctoriy: "

read dst

echo -e "${YELLOW}Please type the file extention like "png , mp4" :"

read ext 

find $src -type f -iname "*.$ext" -exec mv --backup=numbered -t $dst {} + 

echo -e "${GREEN} DONE total files in $dst are $(cd $dst ; ls $dst | wc -w)"

echo -e "${YELLOW} To stop the tool press CTRL + C"

done
