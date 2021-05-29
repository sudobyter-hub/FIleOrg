#!/bin/bash 
#author : sudobyter

while : 
do
echo "Please enter path of dirctory source: "

read src 

echo "Please enter path of destenation derctoriy: "

read dst

echo "Please type the file extention like "png , mp4" :"

read ext 

find $src -type f -iname "*.$ext" -exec mv --backup=numbered -t $dst {} + 

echo "Please note to stop press CTRL+C"

done 

