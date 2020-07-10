% manualSegmGUI(...
%       fileNameBMP,...
%       fileNamePupil,...
%       fileNameIris,...
%       fileNameLowerEyelid,...
%       fileNameUpperEyelid,...
%       fileNameUpperCorners,...
%       fileNameMask);
%
% Manual iris segmentation by curve fitting. Once the input image appears,
% press the button:
%
%  'p' for pupil,
%  'i' for iris,
%  'u' for upper eyelid,
%  'l' for lower eyelid,
%  'm' for manual mask annotation,
%  'c' for corners.
%
% Use a mouse to select as many points as you like (minimum 3 to have a
% unique curve fitting result, and typicaly 5-10 is fine). Press
% 'enter/return' to accept the selection. Curve fitted to the selected
% points should appear. You can repeat each selection for each curve in any
% time (the order is irrelevant).
%
% fileNameBMP:          name of input image file
% fileNamePupil:        name of file with pupil points
% fileNameIris:         name of file with iris points
% fileNameLowerEyelid:  name of file with lower eyelid points
% fileNameUpperEyelid:  name of file with upper eyelid points
% fileNameUpperCorners: name of file with corner points
% fileNameMask:         name of file with binary mask
%
% __________________________________________________________________
% Adam Czajka, March 09, 2017, http://zbum.ia.pw.edu.pl/EN/node/37

function stopTheMusic = manualSegmGUI(...
    fileNameBMP,...
    fileNamePupil,...
    fileNameIris,...
    fileNameLowerEyelid,...
    fileNameUpperEyelid,...
    fileNameUpperCorners,...
    fileNameMask)

% set the variables
upperEyelidPoints = [];
lowerEyelidPoints = [];
innerBoundaryPoints = [];
outerBoundaryPoints = [];
cornerPoints = [];
stopTheMusic = false;

doWhile = true;
texts.date = '';
texts.data = '';
texts.x = 55;
texts.y = 10;

showMask = false;
img = imread(fileNameBMP);
imSize = size(img);
manualMask = uint8(zeros(size(img,1),size(img,2)));
[xm,ym] = meshgrid(1:size(img,2),1:size(img,1));
clear img

eraserR = 12;

while (doWhile)
    
    errorFound = false;
    errorMessage = [];
    
    % show what we have in the moment
    showIris(...
        fileNameBMP,...
        innerBoundaryPoints,...
        outerBoundaryPoints,...
        upperEyelidPoints,...
        lowerEyelidPoints,...
        cornerPoints,...
        manualMask,...
        showMask,0,...
        texts);
    
    % read screen action
    [x1,y1,b] = ginputc(1,'color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false);
    
    if (b == 112) % 'p' pressed -> pupil
        showMask = false;
        texts.data = 'PUPIL';
        innerBoundaryPoints = [];
        locAct(1:3) = 0;
        
        % show what we have in the moment
        showIris(...
            fileNameBMP,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            cornerPoints,...
            manualMask,...
            showMask,0,...
            texts);
        
        [x,y] = ginputc('color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false);
        innerBoundaryPoints(1,:) = x;
        innerBoundaryPoints(2,:) = y;
        texts.data = '';
    end
    
    if (b == 105) % 'i' pressed -> iris
        showMask = false;
        texts.data = 'IRIS';
        outerBoundaryPoints = [];
        locAct(4:6) = 0;
        
        % show what we have in the moment
        showIris(...
            fileNameBMP,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            cornerPoints,...
            manualMask,...
            showMask,0,...
            texts);
        
        [x,y] = ginputc('color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false);
        outerBoundaryPoints(1,:) = x;
        outerBoundaryPoints(2,:) = y;
        texts.data = '';
    end
    
    if (b == 117) % 'u' pressed -> upper eyelid
        showMask = false;
        texts.data = 'UPPER eyelid';
        upperEyelidPoints = [];
        
        % show what we have in the moment
        showIris(...
            fileNameBMP,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            cornerPoints,...
            manualMask,...
            showMask,0,...
            texts);
        
        [x,y] = ginputc('color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false);
        
        upperEyelidPoints(1,:) = x;
        upperEyelidPoints(2,:) = y;
        texts.data = '';
    end
    
    if (b == 108) % 'l' pressed -> lower eyelid
        showMask = false;
        texts.data = 'LOWER eyelid';
        lowerEyelidPoints = [];
        
        % show what we have in the moment
        showIris(...
            fileNameBMP,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            cornerPoints,...
            manualMask,...
            showMask,0,...
            texts);
        
        [x y] = ginputc('color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false);
        lowerEyelidPoints(1,:) = x;
        lowerEyelidPoints(2,:) = y;
        texts.data = '';
    end
    
    if (b == 99) % 'c' pressed -> corners
        showMask = false;
        texts.data = 'CORNERS';
        cornerPoints = [];
        
        % show what we have in the moment
        showIris(...
            fileNameBMP,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            cornerPoints,...
            manualMask,...
            showMask,0,...
            texts);
        
        [x y] = ginputc('color','g','linewidth',2,'ShowPoints',true,'ConnectPoints',false)
        cornerPoints(1,:) = x;
        cornerPoints(2,:) = y;
        texts.data = '';
    end
    
    if (b == 109) % 'm' pressed -> occlusions
        % toggle the mode
        showMask = true;
        texts.data = 'MASK';
        
        doStuff = true;
        while (doStuff)
            showIris(...
                fileNameBMP,...
                innerBoundaryPoints,...
                outerBoundaryPoints,...
                upperEyelidPoints,...
                lowerEyelidPoints,...
                cornerPoints,...
                manualMask,...
                showMask,eraserR,...
                texts);
            
            [x y b2] = ginput(1);
            if (b2 == 1) % brush
                r = sqrt((xm-x).^2+(ym-y).^2);
                manualMask(find(r<=eraserR)) = 255;
            elseif (b2 == 3) % eraser
                r = sqrt((xm-x).^2+(ym-y).^2);
                manualMask(find(r<=eraserR)) = 0;
            elseif (b2 == 43) % increase the mask size
                eraserR = eraserR + 1;
            elseif (b2 == 45) % decrease the mask size
                eraserR = max(1,eraserR - 1);
            else
                doStuff = false;
            end
        end
        showMask = false;
        texts.data = '';
    end
    
    
    if (b == 115) % 's' pressed -> save the results
        
        % inner boundary points
        fid = fopen(fileNamePupil,'w');
        for i=1:max(size(innerBoundaryPoints))
            fprintf(fid,'%i ',uint16(round(innerBoundaryPoints(1,i))));
        end
        fprintf(fid,'\n');
        for i=1:max(size(innerBoundaryPoints))
            fprintf(fid,'%i ',uint16(round(innerBoundaryPoints(2,i))));
        end
        
        [message,~] = ferror(fid);
        if (~isempty(message))
            errorFound = true;
            errorMessage = [errorMessage ' fileNamePupil: ' message];
        end
        fclose(fid);
        
        % outer boundary points:
        fid = fopen(fileNameIris,'w');
        for i=1:max(size(outerBoundaryPoints))
            fprintf(fid,'%i ',uint16(round(outerBoundaryPoints(1,i))));
        end
        fprintf(fid,'\n');
        for i=1:max(size(outerBoundaryPoints))
            fprintf(fid,'%i ',uint16(round(outerBoundaryPoints(2,i))));
        end
        
        [message,~] = ferror(fid);
        if (~isempty(message))
            errorFound = true;
            errorMessage = [errorMessage ' fileNameIris: ' message];
        end
        fclose(fid);
        
        % upper eyelid points:
        fid = fopen(fileNameUpperEyelid,'w');
        for i=1:max(size(upperEyelidPoints))
            fprintf(fid,'%i ',uint16(round(upperEyelidPoints(1,i))));
        end
        fprintf(fid,'\n');
        for i=1:max(size(upperEyelidPoints))
            fprintf(fid,'%i ',uint16(round(upperEyelidPoints(2,i))));
        end
        
        [message,~] = ferror(fid);
        if (~isempty(message))
            errorFound = true;
            errorMessage = [errorMessage ' fileNameUpperEyelid: ' message];
        end
        fclose(fid);
        
        
        % lower eyelid points
        fid = fopen(fileNameLowerEyelid,'w');
        for i=1:max(size(lowerEyelidPoints))
            fprintf(fid,'%i ',uint16(round(lowerEyelidPoints(1,i))));
        end
        fprintf(fid,'\n');
        for i=1:max(size(lowerEyelidPoints))
            fprintf(fid,'%i ',uint16(round(lowerEyelidPoints(2,i))));
        end
        
        [message,~] = ferror(fid);
        if (~isempty(message))
            errorFound = true;
            errorMessage = [errorMessage ' fileNameLowerEyelid: ' message];
        end
        fclose(fid);
        
        % corners
        fid = fopen(fileNameUpperCorners,'w');
        for i=1:max(size(cornerPoints))
            fprintf(fid,'%i ',uint16(round(cornerPoints(1,i))));
        end
        fprintf(fid,'\n');
        for i=1:max(size(cornerPoints))
            fprintf(fid,'%i ',uint16(round(cornerPoints(2,i))));
        end
        
        [message,~] = ferror(fid);
        if (~isempty(message))
            errorFound = true;
            errorMessage = [errorMessage ' cornerPoints: ' message];
        end
        fclose(fid);
        
        
        % binary mask
        finalMask = cartesianMask(...
            imSize,...
            innerBoundaryPoints,...
            outerBoundaryPoints,...
            upperEyelidPoints,...
            lowerEyelidPoints,...
            manualMask);
        imwrite(uint8(255-finalMask),fileNameMask);
        
        if (errorFound)
            set(text(11,56,message,'Color','blue'),'FontSize',14);
            set(text(10,55,message,'Color','white'),'FontSize',14);
        else
            set(text(11,56,'Segmentation results saved','Color','blue'),'FontSize',14);
            set(text(10,55,'Segmentation results saved','Color','white'),'FontSize',14);
        end
        
        % ... and stop the music
        doWhile = false;
    end
    
    if (b == 113) % 'q' pressed -> stop the music
        stopTheMusic = true;
        doWhile = false;
    end
    
end


