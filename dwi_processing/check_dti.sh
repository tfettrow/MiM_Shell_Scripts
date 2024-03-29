# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# this script requires arguments 

# example >> check_dti.sh '1002,1004,1007,1009,1010,1011,1013,1020,1022,1024,1026,1027,2002,2007,2008,2012,2013,2015,2017,2018,2020,2021,2022,2023,2025,2026,2027,2033,2034,2037,2042,2052,3004,3006,3007,3008,3021,3023'
# check_gmv_rois.sh '1002' 02_T1 ROI_settings_MiMRedcap_wfuMasked_CAT12.txt
# FYI>> This is setup to deal with CAT12 output atm


##################################################

argument_counter=0
for this_argument in "$@"; do
	if	[[ $argument_counter == 0 ]]; then
		subjects=$this_argument
	fi
	(( argument_counter++ ))
done

Study_dir=/blue/rachaelseidler/share/FromExternal/Research_Projects_UF/CRUNCH/MiM_Data

ml fsl/6.0.3
ml itksnap

while IFS=',' read -ra subject_list; do
    for this_subject in "${subject_list[@]}"; do
    	echo checking $this_subject
    	cd ${Study_dir}/$this_subject/Processed/MRI_files/08_DWI
   	
		# fslview_deprecated eddycorrected_driftcorrected_DWI.nii eddycorrected_driftcorrected_DWI.nii
			itksnap -g tensorfit_eddycorrected_driftcorrected_DWI_FA.nii 
	done
done <<< "$subjects"
