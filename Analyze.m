
% Specify time period
startDate = [2017 01 01 0 0 0];
endDate = [2017 2 01 0 0 0];

% FIX THIS LATER
% Manually input map bounds
%mapBounds = [-119.054748576353 -118.680103123546 37.4490960101984 37.7716900143681];
mapBounds = [min(masterCatalog{:,3}) max(masterCatalog{:,3}) min(masterCatalog{:,2}) max(masterCatalog{:,2})];

% Create shapes
calderaPlot

% Load master NCEDC catalog from .csv in working directory
ncedc = 'ncedc_dd_01012010_05152019.csv';
masterCatalog = readtable(ncedc);

% Create temporary catalog for given dates and coordinates
catalogMap = createCatalog(masterCatalog, startDate, endDate, mapBounds);

% Generate map for given dates
figure;
fig = figure;
set(fig, 'Units','normalized')
set(fig,'position',[0 0 1 1])
%plotEQ(catalogMap{:,8}, catalogMap{:,7}, [], mapBounds, caldera, RD);
plotEQ(catalogMap, mapBounds, caldera, RD, [])

% Get two coordinates from map for bounding box
disp('Select two points and press return')
[px,py] = getpts;
coordinates = [min(px) max(px) min(py) max(py)];
close(fig)

newBounds = coordinates + [-0.02 0.02 -0.01 0.01];

% Create custom catalog for given dates and coordinates
catalog = createCatalog(masterCatalog, startDate, endDate, coordinates);
disp('Custom catalog generated')


%% Make plots
fig = figure;
set(fig, 'Units','normalized')
set(fig,'position',[0 0 1 1])
hold on

% Map
subplot(2,2,1)
plotEQ(catalog, newBounds, caldera, RD, [])

% Swath of events
subplot(2,2,2)
swathEQ(catalog, newBounds, 3)

% Magnitude-frequency
subplot(2,2,3)
plotMagFreq(catalog)

% Time-magnitude
subplot(2,2,4)
plotTimeMag(catalog, 2)


%% Make movie
