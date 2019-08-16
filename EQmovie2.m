% Generate map feature polygons
calderaPlot

% Load NCEDC Earthquake catalog
% ************************************************************************
% Give name of catalog file, i.e. 'ncedc_dd_01012010_04232019.csv'
% ************************************************************************
ncedc = 'ncedc_dd_01011997_01011999.csv';
catalog = readtable(ncedc);

% catalog - earthquake catalog following NCEDC format: 
%       (1) YEAR 
%       (2) MONTH
%       (3) DAY
%       (4) HOUR 
%       (5) MINUTE 
%       (6) SECOND
%       (7) LAT 
%       (8) LON 
%       (9) DEPTH 
%      (10) MAGNITUDE

disp('Catalog loaded')


%% Find indicies of EQs which occurred in between given dates
% ************************************************************************
% Date format:
% date = [year month day hour min sec]
% ************************************************************************

% Set start and end dates
startDate = [1997 11 01 0 0 0];
endDate = [1998 03 01 0 0 0];

% Convert start and end dates to serial numbers
numStart = datenum(startDate);
numEnd = datenum(endDate);

% Create separate column array containing serial number dates for the 
% whole catalog
numDates = datenum(catalog{:,1});

% Create index for events that occur between startDate and endDate
index1 = find(numDates(:) >= numStart);
index2 = find(numDates(:) <= numEnd);
index = [index1(1):index2(end)]';

% Generate new catalog of EQs that occur between startDate and endDate
catalogNew = catalog(index,:);
datesNew = numDates(index);


%% Generate an index hierarchy 
% ************************************************************************
% Indicate decimation indexing below:
% 3 - day
% 4 - hour
% 5 - minute
% 6 - second
  decIndex = 3;
% ************************************************************************
% Already indexed catalog?
  SKIP = 0;
% ************************************************************************


if SKIP == 0
% Find how many days, hours, minutes, and seconds are in the given period
totalDay = numEnd - numStart;
totalHour = totalDay * 24;
totalMin = totalHour * 60;
totalSec = totalMin * 60;

if decIndex == 3 % per day

    % Set decimation (number of time steps to be used)
    dec = totalDay;

    % Create time steps from specified decimation
    decSteps = linspace(numStart, numEnd, dec)';
    
    % Create cell array containing all events occuring before each decimation
    % step (day, hour, min) in 'decSteps'
    decEQ = cell(dec, 1);
    
    for i = 1:dec
        for j = 1:height(catalogNew)
            if datesNew(j) <= decSteps(i)
                decEQ{i} = [decEQ{i} j];
            end
        end
    end
    
    if sum(decEQ{1}) < 1
       while sum(decEQ{1}) < 1
           decEQ = decEQ(2:end); 
       end
    end
    
elseif decIndex == 4 % per hour
    
    % Set decimation (number of time steps to be used)
    dec = totalHour;
    
    % Create time steps from specified decimation
    decSteps = linspace(numStart, numEnd, dec)';

    % Create cell array containing all events occuring before each decimation
    % step (day, hour, min) in 'decSteps'
    decEQ = cell(dec, 1);

    for i = 1:dec
        for j = 1:height(catalogNew)
            if datesNew(j) <= decSteps(i)
                decEQ{i} = [decEQ{i} j];
            end
        end
    end
    
    if sum(decEQ{1}) < 1
        while sum(decEQ{1}) < 1
            decEQ = decEQ(2:end);
        end
    end
    
    
elseif decIndex == 5 % per minute
    
    % Set decimation (number of time steps to be used)
    dec = totalMin/5;
    
    % Create time steps from specified decimation
    decSteps = linspace(numStart, numEnd, dec)';
    
    % Create cell array containing all events occuring before each decimation
    % step (day, hour, min) in 'decSteps'
    decEQ = cell(dec, 1);
    
    for i = 1:dec
        for j = 1:height(catalogNew)
            if datesNew(j) <= decSteps(i)
                decEQ{i} = [decEQ{i} j];
            end
        end
    end
    
    if sum(decEQ{1}) < 1
        while sum(decEQ{1}) < 1
            decEQ = decEQ(2:end);
            decSteps = decSteps(2:end);
        end
    end

end

end
disp('Catalog indexed')

%% Generate MATLAB movie file(s)

% Zoom in to LVC
minlat = min(caldera(:,1)) - 0.;
maxlat = max(caldera(:,1)) + 0.01;
minlong = min(caldera(:,2)) - 0.01;
maxlong = max(caldera(:,2)) + 0.01;
%mapBounds = [minlong maxlong minlat maxlat];
mapBounds = [-119.075 -118.675 37.475 37.8];

% Initiate MATLAB movie file(s)
ax = gca;
ax.NextPlot = 'replaceChildren';
loops = length(decEQ);
clear movieMapEW
movieMapEW(loops) = struct('cdata',[], 'colormap', []);
clear movie3D
movie3D(loops) = struct('cdata',[], 'colormap', []);

% Establish figure
fig = figure;
set(fig, 'Units','normalized')
set(fig,'position',[0 0 1 1])

% Map view and one swath (N-S or E-W)
for i = 1:loops
    
    subplot(1,2,1)
    plotEQ(catalogNew(decEQ{i},:), mapBounds, caldera, RD, []) 
    disp(i)
    
    timeStamp = datestr(decSteps(i), 'yyyy-mm-dd HH:MM:SS');
    title(timeStamp)
    colorbar
    c = colorbar;
    c.Ticks = [0 1];

    tick1 = datestr(decSteps(1), 'yyyy-mm-dd HH:MM:SS');
    tick2 = datestr(decSteps(i), 'yyyy-mm-dd HH:MM:SS');

    c.TickLabels = {tick2, tick1};
    
    subplot(1,2,2) 
    swathEQ(catalogNew(decEQ{i}, :), mapBounds, 3)
    
    drawnow
    movieMapEW(i) = getframe(fig);
    clf
end

% 3D
%{
for i = 1:loops
    %subIndex = 1:decEQ{i};
    subIndex = 1:i;
    
    plotEQ3D(catalog_new(subIndex,:), mapBounds, caldera, RD, [], 25, 15)    
 
    drawnow
    movie3D(i) = getframe(fig);
    clf
end
%}
