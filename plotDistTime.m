%function plotDistTime(catalog, date1, date2)
% Make plot of distance of EQS from main shock vs time; 
% compare to diffusion rate (Darcy-esque); need permeability (ask Michael) 
% and compare numbers in order of mag sense

% Choose start date
date1 = datenum([2016 12 14 0 0 0]);
date2 = datenum([2017 01 14 0 0 0]);

% Select mainshock
mainShock = catalog((catalog{:,5} == max(catalog{:,5})), :);

% Create temporary catalog of all earthquakes occuring after a certain date.
tempCatalog = catalog( (datenum([catalog{:,1}]) ) >= (datenum(date1)) & (datenum([catalog{:,1}]) <= (datenum(date2))), :);

numDates = zeros(height(tempCatalog),1);
distEQ = zeros(height(tempCatalog),1);
dZ = zeros(height(tempCatalog),1);

for i = 1:height(tempCatalog)
    numDates(i) = datenum([catalog{i,1}]);
    distEQ(i) = pointsDistance([mainShock{1,2} tempCatalog{i,2}], [mainShock{1,3} tempCatalog{i,3}], [mainShock{1,4} tempCatalog{i,4}]);
    dZ(i) =  mainShock{1,4} - tempCatalog{i,4};
end
%{
% Create ticks
% Find day range
    yr = 0;
    mo = 0;
    dy = 0;
    days = daysact(datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) catalog{1,3:6}], 'mm/dd/yyyy'), datestr([(catalog{end,1}+yr) (catalog{end,2} + mo) catalog{end,3:6}], 'mm/dd/yyyy'));
    % Initialize arrays
    xLabels = strings(days+1, 1);
    xTicks = zeros(days+1, 1);
    % Create labels and ticks
    
    % Create month-days array
    monthDays = [31 29 31 30 31 30 31 31 30 31 30 31];
    
    for i = 0:days % temporal index (days in plot period)
        if mo < 12 % want to restart indexing once k = 12
            if dy < monthDays(mo + 1) % want to restart indexing once dy = last day of the month
                xLabels(i+1) = datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0], 'mm/dd');
                xTicks(i+1) = datenum([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0]);
                dy = dy + 1;
            else
                mo = mo + 1;
                dy = 0;
                xLabels(i+1) = datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0], 'mm/dd');
                xTicks(i+1) = datenum([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0]);
                dy = dy + 1;
            end
            
        else
            yr = yr + 1;
            mo = 0;
            xLabels(i+1) = datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0], 'mm/dd');
            xTicks(i+1) = datenum([(catalog{1,1}+yr) (catalog{1,2} + mo) (catalog{1,3} + dy) 0 0 0]);
            mo = mo + 1;
            dy = dy + 1;
        end
    end
    
    % Cut out labels
    weekIndex = 0;
    for i = 1:length(xLabels)
        if floor(weekIndex/7) == weekIndex/7  
            weekIndex = weekIndex + 1;
        else
            xLabels(i) = "";
            weekIndex = weekIndex + 1;
        end
    end
        
    % Set x-axis label
    xName = 'Date';

%}
% Create figure
figure; 
hold on
grid on
scatter(numDates, distEQ)
scatter(datenum(mainShock{1,1}), 0, '*r')
xlabel('Date')
xticks(datenum(["12/14/2016" "12/21/2016" "12/28/2016" "1/4/2017" "1/11/2017" "1/18/2017" "1/25/2017" "2/01/2017"]))
%xticklabels(xLabels)
xticklabels(["12/14/2016" "12/21/2016" "12/28/2016" "1/4/2017" "1/11/2017" "1/18/2017" "1/25/2017" "2/01/2017"])
ylabel('Distance from main event (km)')
axis([date1 date2 0 10])

% Plot Shapiro et al. 1997 model for outward propagation of earthquakes 
% from a small initial source zone (here, a 'fluid injection point')

% Model: r <= sqrt(4*pi*D*t) where D = diffusivity (m/s^2)

t_days = linspace(date1, date2, 500)';
t_sec = linspace(0, date2 - date1, 500)' * 24 * 60 * 60;
r = zeros(length(t_sec), 6);

for i = 1:length(t_sec)
    D = 0.5; % m/s^2
    r(i,1) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
    D = 1.0; % m/s^2
    r(i,2) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
    D = 2.0; % m/s^2
    r(i,3) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
    D = 5.0; % m/s^2
    r(i,4) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
    D = 10.0;
    r(i,5) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
    D = 20.0;
    r(i,6) = sqrt(4 * pi * D * t_sec(i)) * 10^-3;
end

plot(t_days, r(:,1), '-', t_days, r(:,2), '-', t_days, r(:,3), '-', t_days, r(:,4), '-', t_days, r(:,5), '-', t_days, r(:,6), '-')
legend("Earthquakes", "Main event", "D = 0.5 m/s^2", "D = 1.0 m/s^2", "D = 2.0 m/s^2", "D = 5.0 m/s^2", "D = 10.0 m/s^2", "D = 20.0 m/s^2", 'Location', 'southeast')

%{
% How many days are in study period?
%{
totalDays = date2 - date1;

mainShock = catalog((catalog{:,10} == max(catalog{:,10})), :);

avgDist = zeros(length(1:totalDays),1);

for i = 1:totalDays
   % Create temporary catalog of all earthquakes occuring after a certain
   % date.
   tempCatalog = catalog( (datenum([catalog{:,1} catalog{:,2} catalog{:,3}]) <= (datenum(date1) + i - 1) ), :);
   
   % Loop through temporary catalog to calculate the distance from each
   % aftershock event to the mainshock. Start with empty distance sum.
   totalDist = 0;
   
   for j = 1:length(tempCatalog{:,1})
                             % pointsDistance([lat1           lat2            ], [long1          long2           ], [depth1          depth2           ])
       totalDist = totalDist + pointsDistance([mainShock{1,7} tempCatalog{j,7}], [mainShock{1,8} tempCatalog{j,8}], [mainShock{1,10} tempCatalog{j,10}]);
  
   end
   
   avgDist(i) = totalDist/length(tempCatalog{:,1});
   
end
%}

% How many hours are in study period?
totalHours = (date2 - date1) * 24;

mainShock = catalog((catalog{:,10} == max(catalog{:,10})), :);

avgDist = zeros(length(1:totalHours),1);


for i = 1:totalHours
   % Create temporary catalog of all earthquakes occuring after a certain
   % date.
   tempCatalog = catalog( (datenum([catalog{:,1} catalog{:,2} catalog{:,3} catalog{:,4} catalog{:,5} catalog{:,6}]) <= (datenum(date1) + i/24 - 1/24) ), :);
   
   % Loop through temporary catalog to calculate the distance from each
   % aftershock event to the mainshock. Start with empty distance sum.
   totalDist = 0;
   for j = 1:length(tempCatalog{:,1})
                             % pointsDistance([lat1           lat2            ], [long1          long2           ], [depth1          depth2           ])
       totalDist = totalDist + pointsDistance([mainShock{1,7} tempCatalog{j,7}], [mainShock{1,8} tempCatalog{j,8}], [mainShock{1,10} tempCatalog{j,10}]);
   end
   avgDist(i) = totalDist/length(tempCatalog{:,1}); 
end
%}

%end