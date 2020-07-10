% showIrisEyelids(img,locAct,upperEyelidPoints,lowerEyelidPoints)
%
% Visualization of manual segmentation. Used with manualSegmGUI(...)
%
% __________________________________________________________________
% Adam Czajka, March 09, 2017, http://zbum.ia.pw.edu.pl/EN/node/37

function showIris(...
    fileNameBMP,...
    innerBoundaryPoints,...
    outerBoundaryPoints,...
    upperEyelidPoints,...
    lowerEyelidPoints,...
    cornerPoints,...
    manualMask,...
    showMask,...
    eraserR,...
    texts)


%% Read the image
img = imread(fileNameBMP);
if (ndims(img) == 3)
    img = rgb2gray(img(:,:,1:3));
end
[imSize(1),imSize(2)] = size(img);


%% Image enhancement -- if needed 
% Gamma correction:
% img = uint8(gamma_correction(img,[0 255],[0 255],0.6));
% CLAHE:
img = adapthisteq(img,'clipLimit',0.01,'Distribution','uniform');


%% do the approximations
segmParamsCirc = -ones(1,6);
upperEyelidCurveP = [];
lowerEyelidCurveP = [];

% pupil / iris
if ~isempty(innerBoundaryPoints)
    [segmParamsCirc(1),segmParamsCirc(2),segmParamsCirc(3)] = circfit(innerBoundaryPoints(1,:),innerBoundaryPoints(2,:));
end
if ~isempty(outerBoundaryPoints)
    [segmParamsCirc(4),segmParamsCirc(5),segmParamsCirc(6)] = circfit(outerBoundaryPoints(1,:),outerBoundaryPoints(2,:));
end

% eyelids
if ~isempty(upperEyelidPoints)
    upperEyelidCurveP = polyfit(upperEyelidPoints(1,:),upperEyelidPoints(2,:),2);
end
if ~isempty(lowerEyelidPoints)
    lowerEyelidCurveP = polyfit(lowerEyelidPoints(1,:),lowerEyelidPoints(2,:),2);
end

if (segmParamsCirc(6)<=0) p = 256;
else p = segmParamsCirc(6);
end
t = linspace(0,2*pi,round(2*pi*p));
cs = [cos(t);sin(t)];


%% calculate the current mask

% add manual mask
maskVis = uint8(zeros(size(img,1),size(img,2)));

if (showMask)
    maskVis = cartesianMask(...
        imSize,...
        innerBoundaryPoints,...
        outerBoundaryPoints,...
        upperEyelidPoints,...
        lowerEyelidPoints,...
        manualMask);
end


%% plot iris image and the mask
figure(1)
hold on
cla(1)

img3 = uint8(255*ones(size(img,1),size(img,2),3));
img3(:,:,1) = uint8(img)+maskVis;
img3(:,:,2) = uint8(img);
img3(:,:,3) = uint8(img)+maskVis;

imagesc(img3);
axis equal

set(gca,'YDir','reverse')

% show the eraser size
circf(60,100,eraserR,'y');

%% display the name of file being processed
set(text(12,22,fileNameBMP,'Color','w'),'FontSize',20);
set(text(10,20,fileNameBMP,'Color','k'),'FontSize',20);
set(text(texts.y+2,texts.x+2,texts.data,'Color','w'),'FontSize',20);
set(text(texts.y,texts.x+1,texts.data,'Color','k'),'FontSize',20);

%% plot curves if no mask is displayed
if (~showMask)
    
    %% plot inner boundary
    if (segmParamsCirc(1)>0 && segmParamsCirc(2)>0)
        plot(segmParamsCirc(1),segmParamsCirc(2),'y+');
        set(plot(segmParamsCirc(1)+segmParamsCirc(3)*cs(1,:),segmParamsCirc(2)+segmParamsCirc(3)*cs(2,:)),'LineWidth',2,'Color','y')
        
        for i=1:length(innerBoundaryPoints)
            set(plot(innerBoundaryPoints(1,:),innerBoundaryPoints(2,:),'y.'),'MarkerSize',30);
        end
        
    end
    
    %% plot outer boundary
    if (segmParamsCirc(4)>0 && segmParamsCirc(5)>0)
        plot(segmParamsCirc(4),segmParamsCirc(5),'bo');
        set(plot(segmParamsCirc(4)+segmParamsCirc(6)*cs(1,:),segmParamsCirc(5)+segmParamsCirc(6)*cs(2,:)),'LineWidth',2,'Color','b')
        for i=1:length(outerBoundaryPoints)
            set(plot(outerBoundaryPoints(1,:),outerBoundaryPoints(2,:),'b.'),'MarkerSize',30);
        end
    end
    
    %% plot the upper eyelid
    if ~isempty(upperEyelidPoints)
        
        % selected points:
        for i=1:length(upperEyelidPoints)
            set(plot(upperEyelidPoints(1,:),upperEyelidPoints(2,:),'r.'),'MarkerSize',30);
        end
        
        % approximation:
        for x=1:imSize(2)
            yU(x) = upperEyelidCurveP(3)+x*upperEyelidCurveP(2)+upperEyelidCurveP(1)*x^2;
        end
        
        % plot only within the screen:
        yy = (yU <= imSize(1)) & (yU > 0);
        yU = yU(yy);
        
        set(plot(find(yy),yU,'r-'),'LineWidth',2);
    end
    
    %% plot the lower eyelid
    if ~isempty(lowerEyelidPoints)
        
        % points:
        for i=1:length(lowerEyelidPoints)
            set(plot(lowerEyelidPoints(1,:),lowerEyelidPoints(2,:),'r.'),'MarkerSize',30);
        end
        
        % approximation:
        for x=1:imSize(2)
            yL(x) = lowerEyelidCurveP(3)+x*lowerEyelidCurveP(2)+lowerEyelidCurveP(1)*x^2;
        end
        
        % plot only within the screen:
        yy = (yL <= imSize(1)) & (yL > 0);
        yL = yL(yy);
        
        set(plot(find(yy),yL,'r-'),'LineWidth',2);
        
    end
    
    
    %% plot corner points
    if ~isempty(cornerPoints)
        
        for i=1:length(cornerPoints)
            set(plot(cornerPoints(1,:),cornerPoints(2,:),'gd'),'MarkerSize',12);
        end
        
    end
    
end

%% show texts

% acquisition date
if ~isempty(texts.date)
    
    year = texts.date(1);
    month = texts.date(2);
    day = texts.date(3);
    hour = texts.date(4);
    minute = texts.date(5);
    second = texts.date(6);
    
    set(text(11,51,['Acquisition time:  ' ...
        num2str(month) '/' num2str(day) '/' num2str(year) '  |  ' num2str(hour) ':' num2str(minute,'%02d') ':' num2str(second,'%02d')],...
        'Color','blue'),'FontSize',16);
    set(text(10,50,['Acquisition time:  ' ...
        num2str(month) '/' num2str(day) '/' num2str(year) '  |  ' num2str(hour) ':' num2str(minute,'%02d') ':' num2str(second,'%02d')],...
        'Color','white'),'FontSize',16);
end

hold off