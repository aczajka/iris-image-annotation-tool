clear all

%% folders and files ...
DIR_RAW = './data-raw/';
DIR_RESULTS = './data-results/';

files = dir([DIR_RAW '*.png']);
SAMPLES = length(files);

showMask = false;
img = imread([DIR_RAW files(1).name]);
imSize = size(img);
manualMask = uint8(zeros(size(img,1),size(img,2)));
clear img
texts.date = '';
texts.data = '';
texts.x = 55;
texts.y = 10;

%% go through the CSV metadata and show samples that match the selection
for s=195:SAMPLES
    
    fileNameBMP = files(s).name
    fileNamePupil = [DIR_RESULTS fileNameBMP(1:end-4) '_Pupil.txt'];
    fileNameIris = [DIR_RESULTS fileNameBMP(1:end-4) '_Iris.txt'];
    fileNameLowerEyelid = [DIR_RESULTS fileNameBMP(1:end-4) '_LowerEyelid.txt'];
    fileNameUpperEyelid = [DIR_RESULTS fileNameBMP(1:end-4) '_UpperEyelid.txt'];
    fileNameCorners = [DIR_RESULTS fileNameBMP(1:end-4) '_Corners.txt'];
    fileNameMask = [DIR_RESULTS fileNameBMP(1:end-4) '_Mask.bmp'];
        
    %% read the pupil and iris segmentation results
    loc = dlmread(fileNamePupil);
    innerBoundaryPoints = loc;
    
    loc = dlmread(fileNameIris);
    outerBoundaryPoints = loc;
    
    %% read eyelids
    upperEyelidPoints = load(fileNameUpperEyelid);
    lowerEyelidPoints = load(fileNameLowerEyelid);
    
    %% read corners
    cornerPoints = load(fileNameCorners);
    
    %% and show what we have
    showIris(...
        [DIR_RAW fileNameBMP],...
        innerBoundaryPoints,...
        outerBoundaryPoints,...
        upperEyelidPoints,...
        lowerEyelidPoints,...
        cornerPoints,...
        manualMask,...
        showMask,0,...
        texts);
    
    pause
    
end
