#!/bin/sh

# extract ROI(BA45) from atlas

export $SUBJECTS_DIR={subject_dictionary}
#subject dictionary = .../freesurfer_results

cd $SUBJECTS_DIR

mri_label2label \
  --srcsubject fsaverage \
  --srclabel $FREESURFER_HOME/subjects/fsaverage/label/lh.BA45_exvivo.label \
  --trgsubject sub-101 \ 
  --trglabel sub-101/label/lh.BA45_exvivo.label \ 
  --hemi lh \
  --regmethod surface
  
#check subcortical volumes
cd sub-101/stats
cat aseg.stats

#check cortical parcellation area
cat lh.aparc.stats
cat rh.aparc.stats

#creat a statistic file for ROI
cd sub-101
mris_anatomical_stats \ 
-l label/lh.BA45_exvivo.label \ 
-f stats/lh.BA45_exvivo.stats \ 
sub-001 \ 
lh

#Group stats files
#volume
asegstats2table --subjects sub-004 sub-021 sub-040 \
  --segno \
  --tablefile aseg.vol.table
#white matter
asegstats2table \ 
  --subjects 004 021 040 067 080 092 \ 
  --segno \ 
  --stats wmparc.stats \ 
  --tablefile wmparc.vol.table
