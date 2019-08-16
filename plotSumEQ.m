function plotSumEQ(catalog, decIndex)
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
%
% decIndex - indicate plotting decimation
%       (1) YEAR
%       (2) MONTH
%       (3) DAY
%       (4) HOUR

%% Create date indexing arrays
% dec - array containing temporal ID for each Date/H/M/S in the study 
% period in accordance for decimation specified above.
dates = unique(datenum(catalog{:, 1:3}));

% decCatalog - array containing temporal IDs for each earthquake in the 
% study catalog in accordance with decimation specified above.
datesCatalog = datenum(catalog{:, 1:3});

% decEQ - cell array with length equal to number of for each Date/H/M/S in 
% study period, where each cell contains an array containing the indicies  
% of all the earthquakes which occured that day.
datesEQ = cell(length(dates), 1);

for i = 1:length(dates)
    for j = 1:length(datesCatalog)
        if dates(i) == datesCatalog(j)
            datesEQ{i} = [datesEQ{i} j];
        else 
            continue;
        end
    end
end


%% Generate plot x-axis ticks and labels
if decIndex == 1 
    % Find year range
    years = catalog{end,1} - catalog{1,1};
    % Initialize arrays
    xLabels = strings(years+1, 1);
    xTicks = zeros(years+1, 1);
    % Create labels and ticks
    for i = 0:years
        xLabels(i+1) = datestr([(catalog{1,1} + i) catalog{1,2:3} 0 0 0], 'yyyy');
        xTicks(i+1) = datenum([(catalog{1,1} + i) catalog{1,2:3} 0 0 0]);
    end
    % Set x-axis label
    xName = 'Year';
    
elseif decIndex == 2
    % Find month range
    dateDiff = catalog{end,1:2} - catalog{1,1:2};
    months = dateDiff(1)*12 + dateDiff(2);
    
    % Initialize arrays
    xLabels = strings(months+1, 1);
    xTicks = zeros(months+1, 1);
    % Create labels and ticks
    yr = 0;
    mo = 0;
    for i = 0:months
        if mo < 12 % want to restart indexing once k = 12
            xLabels(i+1) = datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) catalog{1,3} 0 0 0], 'mmm. yyyy');
            xTicks(i+1) = datenum([(catalog{1,1}+yr) (catalog{1,2} + mo) catalog{1,3} 0 0 0]);
            mo = mo + 1;
        else
            yr = yr + 1;
            mo = 0;
            xLabels(i+1) = datestr([(catalog{1,1}+yr) (catalog{1,2} + mo) catalog{1,3} 0 0 0], 'mmm. yyyy');
            xTicks(i+1) = datenum([(catalog{1,1}+yr) (catalog{1,2} + mo) catalog{1,3} 0 0 0]);
            mo = mo + 1;
        end
    end
    % Set x-axis label
    xName = 'Month';
    
elseif decIndex == 3
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
    monthDays = [31 28 31 30 31 30 31 31 30 31 30 31];
    
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
end


for i = 1:length(dates)
    quakenum(i) = sum( datesCatalog <= dates(i));
end
%% Plot cumulative number of earthquakes occured with respect to time
plot(dates, quakenum)

grid on
xlabel(xName)
xticks(xTicks)
xticklabels(xLabels);
ylabel('Number of Earthquakes')
axis([xTicks(1) xTicks(end) 0 max(quakenum)])


end