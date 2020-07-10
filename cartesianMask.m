function maskOut = cartesianMask(...
    imSize,...
    innerBoundaryPoints,...
    outerBoundaryPoints,...
    upperEyelidPoints,...
    lowerEyelidPoints,...
    manualMask)

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


maskOut = manualMask;

% mask everyting that is above the upper eyelid
if ~isempty(upperEyelidCurveP)
    for x = 1:imSize(2)
        for y = 1:imSize(1)
            if ( y <= x*x*upperEyelidCurveP(1)+x*upperEyelidCurveP(2)+upperEyelidCurveP(3) )
                maskOut(y,x) = 255;
            end
        end
    end
end

% mask everyting that is below the lower eyelid
if ~isempty(lowerEyelidCurveP)
    for x = 1:imSize(2)
        for y = 1:imSize(1)
            if ( y >= x*x*lowerEyelidCurveP(1)+x*lowerEyelidCurveP(2)+lowerEyelidCurveP(3) )
                maskOut(y,x) = 255;
            end
        end
    end
end

% mask everyting that is outside the outer boundary
if (segmParamsCirc(4)>0 && segmParamsCirc(5)>0)
    for x = 1:imSize(2)
        for y = 1:imSize(1)
            if ( (y-segmParamsCirc(5))^2 + (x-segmParamsCirc(4))^2 >= segmParamsCirc(6)^2 )
                maskOut(y,x) = 255;
            end
        end
    end
end

% mask everyting that is inside the inner boundary
if (segmParamsCirc(1)>0 && segmParamsCirc(2)>0)
    for x = 1:imSize(2)
        for y = 1:imSize(1)
            if ( (y-segmParamsCirc(2))^2 + (x-segmParamsCirc(1))^2 <= segmParamsCirc(3)^2 )
                maskOut(y,x) = 255;
            end
        end
    end
end


