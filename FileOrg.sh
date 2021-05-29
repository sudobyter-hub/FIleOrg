#!/bin/bash 


#colors
RED="\e[31m"

GREEN="\e[32m"

YELLOW="\e[33m"

while : 
do
echo -e "${RED}Please enter path of dirctory source: "

read src 

echo -e "${GREEN}Path of destenation derctoriy: "

read dst

echo -e "${YELLOW}Please type the file extention like "png , mp4" :"

read ext 

find $src -type f -iname "*.$ext" -exec mv --backup=numbered -t $dst {} + 

echo -e "${RED}Please note to stop press CTRL+C"

done 

