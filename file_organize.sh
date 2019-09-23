
subjects=(2003)

#####################################################################################
ml mricrogl
ml gcc/5.2.0
ml pigz


convertDICOM(){

	this_raw_folder_name=$(cat file_settings.txt | sed -n ${this_folder_row}p | cut -d ',' -f1)
	this_processed_folder_name=$(cat file_settings.txt | sed -n ${this_folder_row}p | cut -d ',' -f2)
	this_processed_file_name=$(cat file_settings.txt | sed -n ${this_folder_row}p | cut -d ',' -f3)



	mkdir -p "${Subject_dir}/Processed/MRI_files/${this_processed_folder_name}"

	cd ${Subject_dir}/Raw/MRI_files/$this_raw_folder_name
	if [ -e *.nii ]; then 
		rm *.nii*
		rm *.json*
	fi 
	if [ -e *.nii.gz ]; then 
		rm *.nii.gz*
	fi
	dcm2niix -ba n ${Subject_dir}/Raw/MRI_files/$this_raw_folder_name

	for nii_file in *.nii*; do
		mv -v ${nii_file} $this_processed_file_name.nii
		cp $this_processed_file_name.nii "${Subject_dir}/Processed/MRI_files/${this_processed_folder_name}";
	done

	for json_file in *.json*; do
		mv -v ${json_file} $this_processed_file_name.json
		cp $this_processed_file_name.json "${Subject_dir}/Processed/MRI_files/$this_processed_folder_name";
	done
	cd $Subject_dir
}


for SUB in ${subjects[@]}; do

	Subject_dir=/ufrc/rachaelseidler/share/FromExternal/Research_Projects_UF/CRUNCH/Pilot_Study_Data/${SUB}

	cd $Subject_dir
	
	lines_to_ignore=$(awk '/#/{print NR}' file_settings.txt)

	number_of_folders_to_extract=$(cat file_settings.txt | wc -l )


	for (( this_folder_row=1; this_folder_row<=${number_of_folders_to_extract}; this_folder_row++ )); do

		if [[ ${lines_to_ignore[*]} =~ $this_folder_row ]]; then
			echo # just a filler for now because unable to get inverse of if statement to work properly..
		else
			convertDICOM $SUB $this_folder_row &
		fi
	done
	wait
done
echo "This script took $SECONDS seconds to execute"
