function swathEQ(catalog, mapBounds, xAxis)
% swathEQ - Plots cross-sectional swath determined by input mapBounds along 
% a specified axis.

% Inputs:
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
% swathBounds - four element array containing minimum and maximum latitude
% and longitude coordinates for swath. Format [minlong maxlong minlat maxlat]
% month - month
% xAxis - specify index of x-axis data (latitude or longitude)
% shape - N/A


% Generate color time-dependence
cmp = flip(parula(numel(catalog{:,1})));

% Define x-axis data; will either be latitude or longitude 
xData = catalog{:, xAxis};

hold on
grid on

% Look for M 3.0+ events
EQ3 = catalog((catalog{:, 5} >= 3), :);
xData3 = xData((catalog{:, 5} >= 3), :);

% Look for M 4.0+ events
EQ4 = catalog((catalog{:, 5} >= 4), :);
xData4 = xData((catalog{:, 5} >= 4), :);

% Generate plots
scatter(xData, -catalog{:, 4}, 5, cmp, 'filled')

if size(EQ3,1) > 0
    scatter(xData3, EQ3{:,4}, 30, 'ro')
end

if size(EQ4,1) > 0
    scatter(xData4, EQ4{:,4}, 300, 'ro')
end

scatter(-119.033338, 0, 100,'^k')


% Figure settings
if xAxis == 2
    xName = 'Latitude';
    xLim = mapBounds(3:4);
elseif xAxis == 3
    xName = 'Longitude';
    xLim = mapBounds(1:2);
else
    xName = [];
    xLim = [];
    disp('xAxis must be 2 (latitude) or 3 (longitude)')
end

xlabel(xName)
ylabel('Depth (km)')
%daspect([1 15 1])
axis([xLim -10 0])

% Color bar settings
colorbar
c = colorbar;
c.Ticks = [0 1];

tick1 = datestr([catalog{1,1}],'mm/dd/yyyy');
tick2 = datestr([catalog{end,1}],'mm/dd/yyyy');

c.TickLabels = {tick2, tick1};
hold off

end

