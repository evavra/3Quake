%% Load Long Valley Caldrea EQ data from Waldauser via NCEDC (updated 2018)
ncedc_dd_2018 = 'ncedc_dd_2018.12.08.csv';
catalog = readtable(ncedc_dd_2018);


% Find indicies of EQs which occurred in between Jan 2015 and Jan 2019
index = (find(catalog{:,1} >= 2018));

% Catalog of EQs which occurred between Jan 2015 and Jan 2019
catalog_new = catalog(index,:);

% Find indicies of EQs which occurred between Jan 2015 and Jan 2019
%index_sep = (find(catalog_2014{:,2} >= 9));

% Catalog of EQs which occurred between Jan 2015 and Jan 2019
%catalog_sep2014 = catalog_2014(index_sep,:);

writetable(catalog_new, 'catalog_jan2017-jan2019.csv')


%% Plot all events, color-coded by time

% create time index
cmp = (parula(numel(catalog_new{:, 3})));

figure;
hold on
scatter3(catalog_new{:,6}, catalog_new{:,5}, -catalog_new{:,7}, 4, cmp, 'filled')

% Plot Mammoth Mountain
scatter3(-119.026241562, 37.6250408332, 0, '*k')

xlabel('Longitude')
ylabel('Latidude')
zlabel('Depth (km)')
grid on
pbaspect([1 0.75 0.5])
plot(caldera(:,2), caldera(:,1), 'k')
%plot(ResDome(:,2), ResDome(:,1), 'k')
view(0,0)

% Color bar settings

colorbar
c = colorbar;
c.Ticks = linspace(0,1,3);
c.TickLabels = {'Jan. 2017', 'Jan., 2018', 'Jan., 2019'};


% Zoom in to LVC
minlat = min(caldera(:,1)) - 0.01;
maxlat = max(caldera(:,1)) + 0.01;
minlong = min(caldera(:,2)) - 0.01;
maxlong = max(caldera(:,2)) + 0.01;
axis([minlong  maxlong minlat maxlat -30 0])

%% Plot all events color-coded magnitude

figure;
hold on

M1lat = catalog_new{(catalog_new{:,8} < 2), 5};
M1long = catalog_new{(catalog_new{:,8} < 2), 6};
M1z =  -catalog_new{(catalog_new{:,8} < 2), 7};

M2lat = catalog_new{(catalog_new{:,8} >= 2 & catalog_new{:,8} < 3), 5};
M2long = catalog_new{(catalog_new{:,8} >= 2 & catalog_new{:,8} < 3), 6};
M2z =  -catalog_new{(catalog_new{:,8} >= 2 & catalog_new{:,8} < 3), 7};

M3lat = catalog_new{(catalog_new{:,8} >= 3), 5};
M3long = catalog_new{(catalog_new{:,8} >= 3), 6};
M3z =  -catalog_new{(catalog_new{:,8} >= 3), 7};


scatter3(M1long, M1lat, M1z, 5, 'MarkerEdgeColor', cmp(end/2,:))
scatter3(M2long, M2lat, M2z, 25, 'MarkerEdgeColor', [0 .2 1])
scatter3(M3long, M3lat, M3z, 75, 'k')


% Plot Mammoth Mountain
scatter3(-119.026241562, 37.6250408332, 0, '*k')

xlabel('Longitude')
ylabel('Latidude')
zlabel('Depth (km)')
grid on
pbaspect([1 0.75 0.5])
plot(caldera(:,2), caldera(:,1), 'k')
view(0,0)

% Color bar settings
%{
%colorbar
%c = colorbar;
%c.Ticks = linspace(0,1,2);
%c.TickLabels = {'January 1, 2015', 'January 1, 2019'};
%}

% Zoom in to LVC
minlat = min(caldera(:,1)) - 0.01;
maxlat = max(caldera(:,1)) + 0.01;
minlong = min(caldera(:,2)) - 0.01;
maxlong = max(caldera(:,2)) + 0.01;
axis([minlong  maxlong minlat maxlat -30 0])

%}


