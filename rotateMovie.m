
% Generate map feature polygons
calderaPlot

% Load NCEDC Earthquake catalog
% ************************************************************************
% Give name of catalog file, i.e. 'ncedc_dd_01012010_04232019.csv'
% ************************************************************************
ncedc = 'ncedc_dd_01012010_04232019.csv';
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
%      (10) MAGNImovi

%% Find indicies of EQs which occurred in between given dates

% Jan 2015 and Jan 2019
%index1 = (find(catalog{:,1} == 2015 & catalog{:,2} == 1 & catalog{:,3} == 1));
%index2 = (find(catalog{:,1} == 2019 & catalog{:,2} == 1 & catalog{:,3} == 1));
%index = index1(1):index2(end);

index1 = (find(catalog{:,1} == 2015 & catalog{:,2} == 1 & catalog{:,3} == 1));
index2 = (find(catalog{:,1} == 2019 & catalog{:,2} == 4 & catalog{:,3} == 22));
index = index1(1):index2(end);

% Catalog of EQs which occurred between period specified above
catalog_new = catalog(index,:);


%% Generate an index hierarchy for plotting each all earthquakes that occur on the same day
% ************************************************************************
% Indicate decimation indexing below:
% 3 - day
% 4 - hour
% 5 - minute
% 6 - second
% ************************************************************************
decIndex = 3;

% OLD DECIMATION indexing (up to individual days)
%{
% dec - array containing temporal ID for each Date/H/M/S in the study 
% period in accordance for decimation specified above.
dec = unique(datenum(catalog_new{:, 1:3}));

% decCatalog - array containing temporal IDs for each earthquake in the 
% study catalog in accordance with decimation specified above.
decCatalog = datenum(catalog_new{:, 1:3});

% decEQ - cell array with length equal to number of for each Date/H/M/S in 
% study period, where each cell contains an array containing the indicies  
% of all the earthquakes which occured that day.
decEQ = cell(length(dec), 1);

for i = 1:length(dec)
    for j = 1:length(decCatalog)
        if dec(i) == decCatalog(j)
            decEQ{i} = [decEQ{i} j];
        else 
            continue;
        end
    end
end
%}


if decIndex == 3
    % use old format
    dec = unique(datenum(catalog_new{:, 1:decIndex}));
    decCatalog = datenum(catalog_new{:, 1:decIndex});
    decEQ = cell(length(dec), 1);
    for i = 1:length(dec)
        for j = 1:length(decCatalog)
            if dec(i) == decCatalog(j)
                decEQ{i} = [decEQ{i} j];
            else 
                continue;
            end
        end
    end
    
elseif decIndex == 4 % Decimate by hours
    %catalog_new{:, decIndex+1:decIndex+2} = 0;
    dec = 1:length(catalog_new{:,1});
    decEQ = dec;
    
elseif decIndex == 5
    disp('minute decimation not available')
elseif decIndex == 6
    disp('second decimation not available')
else
    disp('decIndex must be 3, 4, 5, or 6')
end

%{
% dec - array containing temporal ID for each Date/H/M/S in the study 
% period in accordance with decimation specified above.
dec = unique(datenum(catalog_new{:, 1:decIndex}));

% decCatalog - array containing temporal IDs for each earthquake in the 
% study catalog in accordance with decimation specified above.
decCatalog = datenum(catalog_new{:, 1:decIndex});

% decEQ - cell array with length equal to number of for each Date/H/M/S in 
% study period, where each cell contains an array containing the indicies  
% of all the earthquakes which occured that day.
decEQ = cell(length(dec), 1);

for i = 1:length(dec)
    for j = 1:length(decCatalog)
        if dec(i) == decCatalog(j)
            decEQ{i} = [decEQ{i} j];
        else 
            continue;
        end
    end
end
%}


% Zoom in to LVC
minlat = min(caldera(:,1)) - 0.;
maxlat = max(caldera(:,1)) + 0.01;
minlong = min(caldera(:,2)) - 0.01;
maxlong = max(caldera(:,2)) + 0.01;
%mapBounds = [minlong maxlong minlat maxlat];
mapBounds = [-119.075 -118.675 37.475 37.8];

ax = gca;
ax.NextPlot = 'replaceChildren';
loops = length(dec);
movieRotate(loops) = struct('cdata',[], 'colormap', []);

% Create movie file
LVCmovie = VideoWriter('LVCEarthquakes.avi', 'Uncompressed AVI');
LVCmovie.FrameRate = 100;  % Default 30
open(LVCmovie);

fig = figure;
set(fig, 'Units','normalized')
set(fig,'position',[0 0 0.5 1])

az = 0;

for i = 1:loops
    subIndex = 1:decEQ{i};
    subIndex = 1:i;
    
    plotEQ3D(catalog_new(subIndex,:), mapBounds, caldera, RD, [], 25, 15)  
    az = az + 0.3;
    view(az, 20)
    
    drawnow
    movieRotate(i) = getframe(fig);
    clf
end
