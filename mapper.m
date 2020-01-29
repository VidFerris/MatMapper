function G = mapper( inData, lensFunc, clustFunc, bucketNum, lensOverl, plotBool)
%mapperND Performs the mapper algorithm.
%   mapperND is an implementation of the Mapper algorithm in native MATLAB.
%   It has been designed to be as general as possible, needing only a lens
%   function and a clustering function as its inputs.
%
%   The Mapper algorithm was originally described in:
%       Topological Methods for the Analysis of High Dimensional Data Sets
%       and 3D Object Recognition,
%       Gurjeet Singh, Facundo Mémoli, and Gunnar Carlsson.
%       https://research.math.osu.edu/tgda/mapperPBG.pdf
%
%   This particular implementation of Mapper was written by David Ferris:
%       d.ferris@uq.edu.au
%
% Inputs:
%   inData    - Input data.
%   lensFunc  - Filter function which returns reals when applied to inData.
%       (lensFunc takes one input, inData, and returns an array.
%           This real array is of the same height as inData, but of
%           arbitrary (potentially variable) width. This should be able to
%           handle any kind of array. (Cell, tall, GPU, etc.)
%   clustFunc - Cluster function to group members of inData.
%       (clustFunc takes a subset of inData and returns an array of equal
%        height containing cluster labels.)
%   bucketNum - Array containing information about the desired ranges,
%               which can be in one of several ways.
%           Implicit Definitions:
%               [10 5 3] would use 10, 5, and 3 buckets along the
%               first three dimensions of an input lens function.
%
%   lensOverl - Percentage overlap between lensFunc buckets (0 to 1). This
%               only applies to implicitly defined ranges. (Default 0.5.)
%   plotBool  - Boolean as to whether to plot.
%
%
% Options:
%   maxDimension    - Maximum dimension of calculated simplexes. (Def: 1)

%% TODO:
%   Objects which only occupy a single layer with no inter-layer
%   connections are always removed, since the graph is represented as an
%   adjacency matrix - if there are no adjacencies, then the node does not
%   exist.
%
%   The simplify operation can completely remove nodes via self-absorption,
%   as a single node is not contained within an array.
%
%   Use highlight function in graph rather than drawing a line/scatter.

%% Step 0: Apply defaults.
if(isempty(bucketNum))
    warning('No buckets input; returning empty graph.')
    G = graph;
    return;
end



%% Step 1: Apply lensFunc to inData.
% We want to know each point's value when passed through the lens.

heights = feval(lensFunc,inData);

%% Step 2: Define lensBuckets and record inData indexes in each bucket.
% First, find

%   buckets   - Array containing information about the desired ranges,
%               which can be in one of several ways.
%           Implicit Definitions:
%               [10 5 3] would use 10, 5, and 3 buckets along the
%               first three dimensions of an input lens function.
%               {10 5 3} would use buckets of size 10, 5, and 3 along the
%               first three dimensions.
%           Explicit Definitions:
%               {[1,3;2,4;3,5],[2,7;5,8]} would use buckets in the first
%               dimension from 1 to 3, 2 to 4, and 3 to 5, while using
%               buckets in the second dimension from 2 to 7 and 5 to 8.

%disp(heights);
assignin('base','heights',heights);
ranges = max(heights)-min(heights);
if(ranges==0)
    ranges = 1;
end
%disp(ranges);

%TODO: Check if implicit. (Currently assumes [] implicit usage.)

bucketWidths = ranges./bucketNum;
bucketWider = bucketWidths.*(1+lensOverl);
bucketStart = min(heights);%-bucketWidths*lensOverl/2;




nOverlaps = bucketNum-1;

range = ranges;
% intervals = 5
% overlap = .1
interval_length = (ranges)./(bucketNum-(nOverlaps).*lensOverl);
step_size = interval_length.*(1-lensOverl);

assignin('base','interval_length',interval_length);
assignin('base','step_size',step_size);





if(length(bucketNum)==1)
    buckets  = cell(bucketNum,1);
    clusters = cell(bucketNum,1);
    off      = 1;
else
    buckets  = cell(prod(bucketNum),1);
    clusters = cell(prod(bucketNum),1);
    off      = ones(size(bucketNum));
end

%Loop through every index.
%For implicit, this is through
index = zeros(size(bucketNum));
lindex = 1;
%When dimension N changes, offset by N-1.
%offsetMag = [0 0.5];
offsetMag = [0 0];
done = false;
while(~done)
    %Get current offset.
    %offset = rem(index,2).*offsetMag;
    %offset = circshift(offset,1);
    %disp(index);
    %disp(offset);
    
    %Get bounding range.
    lowerBounds = bucketStart + index.*step_size;% + offset.*bucketWidths;
    upperBounds = lowerBounds + interval_length;
    
    %disp(lowerBounds);
    %disp(upperBounds);
    
    assignin('base','lowerBounds',lowerBounds);
    assignin('base','upperBounds',upperBounds);
    
    %(heights(:,1)>=lowerBounds)&(heights(:,1)<=upperBounds)
    %region = pts(rem(find((heights(:,1)>=lowerBounds)&(heights(:,1)<=upperBounds)),length(heights)),:);
    
    condSatisfy = heights<=upperBounds&heights>=lowerBounds;
    condOut = ones(size(condSatisfy,1),1);
    for i = 1:size(condSatisfy,2)
        condOut = condOut&condSatisfy(:,i);
    end
    condInd = find(condOut);
    %scatter3(region2(:,1),region2(:,2),region2(:,3));
    %disp(index);
    %disp(off);
    
    %Make linear index.
    buckets{lindex} = condInd;
    
    assignin('base','condOut',condOut);
    assignin('base','condInd',condInd);
    assignin('base','index',index);
    assignin('base','off',off);
    assignin('base','buckets',buckets);
    
    %If there are more than 2 points, cluster.
    %TODO: Handle zero points.
    if(length(buckets{lindex})>2)
        %Simply suppress the "Missing data removed" warning.
        warning('off','stats:clusterdata:MissingDataRemoved')
        clusters{lindex} = feval(clustFunc,inData(buckets{lindex},:));
        warning('on','stats:clusterdata:MissingDataRemoved')
    elseif(length(buckets{lindex})==1)
        clusters{lindex} = 1;
    end
    
    
    %Cycle to the next one.
    index(1)=index(1)+1;
    lindex = lindex +1;
    for i=1:length(index)
        if(index(i)==bucketNum(i))
            index(i)=0;
            if(i==length(index))
                done = true;
            else
                index(i+1)=index(i+1)+1;
            end
        end
    end
end


%% Step 3: Generate graph.
E = [];
W = [];
offsets = zeros(prod(bucketNum));
N = cell(0);
M = cell(0);

curOffset=0;
prevOffset=0;
index = zeros(size(bucketNum));
%Construct graph.
for i=1:prod(bucketNum)
    %Call each vertex by its layer in the first index and number in second
    if(~isempty(clusters{i}))
        numNodes = max(clusters{i});
    else
        numNodes = 0;
    end
    
    if(i>1)
        prevOffset = curOffset;
        if(~isempty(clusters{i-1}))
            curOffset = prevOffset+max(clusters{i-1});
        else
            curOffset = prevOffset;
        end
    end
    offsets(i)=curOffset;
    
    %Cycle through; for each dimension greater than 0, check adjacency with
    %the previous bucket/clusters along that dimension.
    %disp(i);
    %disp(index);
    
    %Also need to consider combinations of adjacencies, to fully construct.
    %disp(length(index));
    possibleValues = getPossibleValueArray(length(index),lensOverl);
    validDists     = sqrt(sum(abs(possibleValues),2));
    
    for dimInd = 1:length(index)
        possibleValues(:,dimInd)=prod(bucketNum(1:dimInd-1))*possibleValues(:,dimInd);
    end
    
    validOffsets = sum(possibleValues,2);
    validDists   = validDists(validOffsets<0);
    validOffsets = validOffsets(validOffsets<0);
    
    %disp(validOffsets);
    validDists    = validDists(validOffsets>-i);
    usefulOffsets = validOffsets(validOffsets>-i);
    %Find corresponding offset values.
    
    for offsetInd = 1:length(usefulOffsets)
        prevInd = i+usefulOffsets(offsetInd);
        for j=1:numNodes
            for k=1:max(clusters{prevInd})
                %if(sections{i,2})
                %Find out if (i-1,j) and (i,k) share any points.
                ptsj = buckets{i}(clusters{i}==j);
                ptsk = buckets{prevInd}(clusters{prevInd}==k);
                if(~isempty(intersect(ptsj,ptsk)))
                    %disp('entered');
                    %disp([i,j,k,prevOffset+k,curOffset+j]);
                    E = [E;offsets(prevInd)+k,curOffset+j];
                    W = [W;validDists(offsetInd)];
                    %W = [W;length(intersect(ptsj,ptsk))/min(length(ptsj),length(ptsk))];
                end
            end
        end
    end
    
    
    
    %Index which points in our cloud belong to which nodes.
    %(This makes it easier to invert later.)
    for j=1:numNodes
        N{curOffset+j} = buckets{i}(clusters{i}==j);
        M{curOffset+j} = length(N{curOffset+j});
    end
    
    index(1)=index(1)+1;
    for k=1:length(index)
        if(index(k)==bucketNum(k))
            index(k)=0;
            if(k==length(index))
                done = true;
            else
                index(k+1)=index(k+1)+1;
            end
        end
    end
end

M=cell2mat(M);
%disp(W);


%Ensure that all nodes exist in the final graph when constructed as edge
%matrix by including irrelevant self-connectivity.
E = [E;[1:length(N);1:length(N)]'];
W = [W;zeros(length(N),1)];
G = graph(E(:,1),E(:,2),W,'omitselfloops');

%G = graph(E(:,1),E(:,2),W);

assignin('base','inData',inData);

%Get positions from means of each node.
PXYZ = zeros(length(N),size(inData,2));
for i=1:length(N)
    PXYZ(i,:) = mean(inData(N{i},:),1);
end

assignin('base','PXYZ',PXYZ);


%% Step 5: If plotting, construct plots.
if(plotBool&&(size(inData,2)==2||size(inData,2)==3))
    subplot(2,1,1);
    cla
    hold on;
    if(size(inData,2)==2)
        scatter(inData(:,1),inData(:,2),'.');
        daspect([1 1 1]);
        pbaspect([1 1 1]);
    elseif(size(inData,2)==3)
        scatter3(inData(:,1),inData(:,2),inData(:,3),'.');
        daspect([1 1 1]);
        pbaspect([1 1 1]);
    end
    subplot(2,1,2);
    cla
    
    
    %Get positions from means of each node.
    PXYZ = zeros(length(N),size(inData,2));
    for i=1:length(N)
        PXYZ(i,:) = mean(inData(N{i},:),1);
    end
    
    assignin('base','PXYZ',PXYZ);
    
    %graphPlot = plot(G,'Layout','force3','Iterations',300);
    if(size(inData,2)==2)
        graphPlot = plot(G,'Layout','force','XStart',PXYZ(:,1),'YStart',PXYZ(:,2),'Iterations',0);
    elseif(size(inData,2)==3)
        graphPlot = plot(G,'Layout','force3','XStart',PXYZ(:,1),'YStart',PXYZ(:,2),'ZStart',PXYZ(:,3),'Iterations',0);
    end
    %graphPlot = graphDraw(G,3);
    daspect([1 1 1]);
    pbaspect([1 1 1]);
    %graphPlot = plot(G,'Layout','force','Iterations',500,'NodeLabel',{},'MarkerSize',(M/max(M))*10);
    hold on;
    assignin('base','graphPlot',graphPlot);
    assignin('base','selHigh',0);
    assignin('base','inData',inData);
    
    %Once the graph function is created, create an update function to go back.
    dcm_obj = datacursormode(gcf);
    %dcm_obj.UpdateFcn = @(obj,event_obj)cursorMove(obj,event_obj,G.Nodes);
    set(dcm_obj,'UpdateFcn',@cursorMove);
    
    
    
    %When a plot is rotated, rotate the other plot to match.
    if(size(inData,2)==3)
        r3d_obj = rotate3d(gcf);
        set(r3d_obj,'ActionPreCallback',@rotationStart);
        set(r3d_obj,'ActionPostCallback',@rotationStop);
    end
    
else
    
end
%outputGraph = 0;

%% Step 6: Assigning values in base for update function.
assignin('base','heights',heights);
assignin('base','buckets',buckets);
assignin('base','clusters',clusters);
assignin('base','G',G);
assignin('base','E',E);
assignin('base','W',W);
assignin('base','N',N);
assignin('base','M',M);

end

%% Functions to synchronise cursor position and orientation of plots.

function output_txt = cursorMove(~,event_obj)
% ~            Currently not used (empty)
% event_obj    Object containing event data structure
% output_txt   Data cursor text
pos = get(event_obj,'Position');
tar = get(event_obj,'Target');
%disp(pos);
assignin('base','tar',tar);
assignin('base','pos',pos);
tarClass = class(tar);
if(strcmp(tarClass,'matlab.graphics.chart.primitive.Scatter'))
    %If on scatter, plot within graph.
    ind = find(tar.XData == pos(1) & tar.YData == pos(2), 1);
    output_txt = {['Point ' num2str(ind)],'Redrawing in Graph...'};
    
    
    %Find and print a list of all nodes in plot containing this point
    indArr = [];
    N = evalin('base','N');
    
    for ind2=1:length(N)
        if(~isempty(find(N{ind2}==ind)))
            indArr = [indArr,ind2];
        end
    end
    %disp(indArr);
    
    subplot(2,1,2);
    
    graphPlot = evalin('base','graphPlot');
    selHigh = evalin('base','selHigh');
    if(selHigh~=0)
        delete(selHigh);
    end
    selHigh = plot3(graphPlot.XData(indArr),graphPlot.YData(indArr),graphPlot.ZData(indArr),'Color','r','LineWidth',5,'Marker','.','MarkerSize',30);
    assignin('base','selHigh',selHigh);
    
    subplot(2,1,1);
    
elseif(strcmp(tarClass,'matlab.graphics.chart.primitive.GraphPlot'))
    %If on graph, plot within scatter.
    
    ind = find(tar.XData == pos(1) & tar.YData == pos(2), 1);
    
    %draw index section as scatter
    subplot(2,1,1);
    N = evalin('base','N');
    inData = evalin('base','inData');
    selHigh = evalin('base','selHigh');
    if(selHigh~=0)
        delete(selHigh);
    end
    hold on;
    if(size(inData,2)==3)
        selHigh = scatter3(inData(N{ind},1),inData(N{ind},2),inData(N{ind},3),'MarkerEdgeColor','r');
    elseif(size(inData,2)==2)
        selHigh = scatter(inData(N{ind},1),inData(N{ind},2),'MarkerEdgeColor','r');
    end
    assignin('base','selHigh',selHigh);
    subplot(2,1,2);
    output_txt = {['Node ' num2str(ind)],'Redrawing in Scatter...'};
end
%disp(NodeProperties);
end

function rotationStart(obj, event_obj)
%Start rotation timer task.
[az,el] = view;
assignin('base','az',az);
assignin('base','el',el);

rotTimer = timer('TimerFcn',@(~,~)rotationTimerTask(),'ExecutionMode','fixedDelay','Period',0.01);
start(rotTimer);
assignin('base','rotTimer',rotTimer);
end

function rotationStop(obj, event_obj)
%End rotation timer task.

rotTimer = evalin('base','rotTimer');
stop(rotTimer);
delete(rotTimer);
rotationTimerTask();

end

function rotationTimerTask()
%TODO: Don't change if if rotation has not changed.

az = evalin('base','az');
el = evalin('base','el');

%[az,el] = view;
subplot(2,1,1);
[az1,el1] = view;
subplot(2,1,2);
[az2,el2] = view;

if(az1~=az||el1~=el)
    assignin('base','az',az1);
    assignin('base','el',el1);
    subplot(2,1,2);
    view(az1,el1);
elseif(az2~=az||el2~=el)
    assignin('base','az',az2);
    assignin('base','el',el2);
    subplot(2,1,1);
    view(az2,el2);
end


end

function [ possibleValues ] = getPossibleValueArray( numDimensions, lensOverlap)
%GETPOSSIBLEVALUEARRAY Summary of this function goes here
%   Detailed explanation goes here

%If only one lensOverlap value, then it applies to all dimensions.
if(length(lensOverlap)~=numDimensions)
    lensOverlap = lensOverlap(1)*ones(numDimensions,1);
end

numOverlaps = ((ceil(1./(1-lensOverlap))*2)+1);

%Preallocate array space.
possibleValues = zeros(numDimensions,prod(numOverlaps));
%Assign first row.
possibleValues(1,:) = mod((0:((prod(numOverlaps))-1)),numOverlaps(1))-floor(numOverlaps(1)/2);

for dimInd = 2:numDimensions
    possibleValues(dimInd,:) = floor((mod((0:((prod(numOverlaps))-1))/prod(numOverlaps(1:(dimInd-1))),numOverlaps(dimInd))-floor(numOverlaps(dimInd)/2))');
end

possibleValues = possibleValues';

end

