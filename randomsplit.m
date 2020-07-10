clear all

DIR_IN = './data-raw/';

DIRS_OUT(1).name = './data-raw-aidan/';
DIRS_OUT(2).name = './data-raw-adam/';
DIRS_OUT(3).name = './data-raw-andrey/';

IMAGES = dir([DIR_IN '*.bmp']);
PERM = randperm(length(IMAGES));
ONE_SET = 220;

for f=1:length(DIRS_OUT)
    
    for i=(f-1)*ONE_SET+1:min(length(IMAGES),f*ONE_SET)
        movefile([DIR_IN IMAGES(PERM(i)).name],[DIRS_OUT(f).name IMAGES(PERM(i)).name]);
    end
    
end