%unzip the .gz file
gunzip('filename')
%show the header information
v = spm_vol('filename')
%show TR
TR = v(1).timing.tspace