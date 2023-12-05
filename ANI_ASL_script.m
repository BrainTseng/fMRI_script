% Example #1: load in the first control image and display it
% First line reads the dicom image 'asl_0004_000001.dcm' into a Matlab array called ctrl1
ctrl1=dicomread('asl_0004_000001.dcm');
% Can display this array as a 2D image using the imagesc command
figure(1)
imagesc(ctrl1);
% And tell imagesc to use a simple grey scale (rather than colours)
colormap(gray);

% Read in all the control images
for k=1:2:79
    if k<10
        buffer='0';  % Only need this extra 0 if image number is <10
    else
        buffer='';   % Otherwise, nothing extra is needed
    end
    % Construct filename string by concatenating (joining) different parts
    filename=['asl_0004_0000' buffer num2str(k) '.dcm'];
    % Read the image for this iteration of the loop into appropriate place
    % in ctrl_images 3D array. Remember k=1,3,5,...,79
    ctrl_images(:,:,(k+1)/2)=dicomread(filename);
end

% Read in all the labelled images
for k=2:2:80
    if k<10
        buffer='0';
    else
        buffer='';
    end
    filename=['asl_0004_0000' buffer num2str(k) '.dcm'];
    % Read the image for this iteration of the loop into appropriate place
    % in labelled_images 3D array. Remember this time k=2,4,6,...,80
    labelled_images(:,:,k/2)=dicomread(filename);
end

% Create the means and the control-tag difference image
ctrl_av=mean(ctrl_images,3);            % The 3 here means 'average across dimension 3'
labelled_av=mean(labelled_images,3);
delta_M= ctrl_av-labelled_av;           % Subtract mean labelled image from mean control

% Define the constants needed for CBF calculation
lambda=0.9; T1app=1.3;

% Double 'for loop' to create CBF maps
for m=1:224
    for n=1:256
        if(ctrl_av(m,n))>100  % only calculate this if ctrl pixel value is >100
            CBF(m,n)=6000*(lambda/T1app)*(delta_M(m,n)/(2*ctrl_av(m,n)));
        else
            CBF(m,n)=0;       % for pixel values <100 (background), assign a value of 0
        end
    end
end

% More efficient alternative method to create CBF maps
CBF=6000*(lambda/T1app)*(delta_M./(2*ctrl_av)).*(ctrl_av>100);

% Display the CBF maps
figure(2)
imagesc(CBF, [0 60]); % [0 60]  sets the scale to be between 0 and 60
                      % so 0=black and 60=white
colormap(gray); colorbar % gray scale again, with a scale bar

figure(3)
imagesc(CBF, [0 60]);
colormap(hot); colorbar  % slightly more interesting colour scale
                         % try playing around with others to see how they look

% Save the CBF maps as a jpeg image
saveas(gcf, 'CBF_map', 'jpg'); % For you to include in your lab book!