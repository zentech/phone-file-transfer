#!/bin/bash

#this is a file that unloads pictures, and recordings from 
#my phone, and place them in the log section of local computer
#created: Jorge Luis Vazquez 2/28/2015

total_files=""			#total files transfered
phone=""										#device where phone storage is mounted
videos=""										#array of all videos files
audios=""										#array of all audio files
vid_ext="3gp"									#extension for video files
au_ext="wav"									#extension for audio files
v_directory='DCIM/Photo Album'					#phone video directory
a_directory="SmartVoiceRecorder"				#phone audio directory
pc_logs="/media/jorge/DATA/log"					#logs directory to store vid and audio files
dest_dir=$(date +%d-%m-%y)						#directory in local computer to hold vid and audio files


#detect phone mounting point
get_phone_device() {
	phone="$(df -h | grep sdb | awk '{print $6, $7}')"
	echo "Mount Device: $phone"
}


#creating destination directory in local computer
create_dest_dir() {
	#creating destination directory
	mkdir "$pc_logs/$dest_dir"
	
	if [ $? -ne 0 ]; then
		echo "ERROR: unable to create destination directory! "
		exit 1
	fi
}


#tranfering video files
transfer_video() {
	#listing all videos in phones and put them in array
	videos=$(ls -1 "$phone/$v_directory" | grep $vid_ext)
	
	#transfer videos from phone to computer	
	for file in ${videos}; do
		echo "Transfering: $file"
		mv "$phone/$v_directory/$file" "$pc_logs/$dest_dir"
		total_files=$((total_files + 1))
		
	done	
	echo "transfered ${#videos} video files!...."
	
}
	
	
#transfer audio files
transfer_audio() {
	#list all audio files
	audios=$(ls -1 "$phone/$a_directory" | grep $au_ext)
	
	#transfer audio from phone to computer
	for file in ${audios}; do
		echo "Transfering $file"
		mv "$phone/$a_directory/$file" "$pc_logs/$dest_dir"
		total_files=$((total_files + 1))
	done
	echo "transfered ${#audios} audio files!...."
}


get_phone_device

#detecting if mount point exists
if [ ! -d "$phone" ]; then 
	echo "EXIT: problem mounting phone!... try again"
	exit
fi

create_dest_dir
echo "VIDEO TRANSER======================>"
transfer_video
echo
echo "AUDIO TRANSER======================>"
transfer_audio
echo
echo
echo "################### TRANSFER COMPLETE ###################"
echo "Transfered a total of $total_files files"


#END
		
	
	

