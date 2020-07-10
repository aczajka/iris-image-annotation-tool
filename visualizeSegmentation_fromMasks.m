clear all

DIR_RAW = './data-raw/';
DIR_RESULTS = './data-results/';

files = dir([DIR_RAW '*.png']);
SAMPLES = length(files);

file = fopen('v1-to-correct.txt','w+');

for s=1:SAMPLES
    
    s
    
    fileNameBMP = files(s).name;
    fileNameMask = [fileNameBMP(1:end-4) '_Mask.bmp'];
    
    img = imread([DIR_RAW fileNameBMP]);
    maskVis = imread([DIR_RESULTS fileNameMask]);
    img(:,:,1) = img(:,:,1)+0.5*maskVis;
    img(:,:,3) = img(:,:,3)+0.5*maskVis;
    
    imagesc(img);
    axis equal
    set(gca,'YDir','reverse')
    
    str = input('','s');
    
    if isempty(str)
        fprintf('%s is ok\n',fileNameBMP)
    else
        fprintf('%s to be CORRECTED\n',fileNameBMP);
        fprintf(file,'%s\n',fileNameBMP);
    end
    
end
fclose(file);