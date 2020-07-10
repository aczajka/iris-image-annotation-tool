clear all
close all

DIR_RAW = './data-raw/';
DIR_RESULTS = './data-results/';

STATE_FILE = 'savedState.mat';
imfiles = dir([DIR_RAW '*.png']);

% -> uncomment lines commented below if you need to stop and continue after a break
if (exist(STATE_FILE,'file'))
     load(STATE_FILE)
else
    lastI = 0;
end
% <-

disp(['Starting from file #' num2str(lastI+1) ' (' imfiles(lastI+1).name ')'])

for i=lastI+1:length(imfiles)
    
    fileNameBMP = imfiles(i).name;
    fileNamePupil = [DIR_RESULTS fileNameBMP(1:end-4) '_Pupil.txt'];
    fileNameIris = [DIR_RESULTS fileNameBMP(1:end-4) '_Iris.txt'];
    fileNameLowerEyelid = [DIR_RESULTS fileNameBMP(1:end-4) '_LowerEyelid.txt'];
    fileNameUpperEyelid = [DIR_RESULTS fileNameBMP(1:end-4) '_UpperEyelid.txt'];
    fileNameUpperCorners = [DIR_RESULTS fileNameBMP(1:end-4) '_Corners.txt'];
    fileNameMask = [DIR_RESULTS fileNameBMP(1:end-4) '_Mask.bmp'];
    
    stopTheMusic = manualSegmGUI(...
        [DIR_RAW fileNameBMP],...
        fileNamePupil,...
        fileNameIris,...
        fileNameLowerEyelid,...
        fileNameUpperEyelid,...
        fileNameUpperCorners,...
        fileNameMask);
    
    if (stopTheMusic)
        break
    else
        lastI = i;
        save(STATE_FILE,'lastI');
    end
    
end