function [xTicks, xLabels] = createXTicks(dates)

%% UNFINISHED
%{
% ----------------------------------------------------------------------- %
% Description:
% Generate x-axis ticks and labels for a given range of dates

% Input:
% dates - array containing 2+ dates converted to serial number format  
% using 'datenum'.

% Output:
% xTicks - x-axis tick mark locations
% xLabels - string labels for xTicks
% ----------------------------------------------------------------------- %

% Check for input format errors in 'dates'.

% 1. More than one date
if length(dates) == 1
    error('More than one date is required')
    
% 2. Make sure dates are numbers
elseif class(dates) ~= 'double'
    error('Array must contain serial number dates in double format')
end

% Now, we begin to create ticks and labels.
% First, find number of days in oservation period.
totalDays = dates(end) - dates(1);

% From the total number of days, determine the appropriate tick decimation.


if 1 < totalDays <= 2
%	-> label 


% totalDays <= 10 days
elseif totalDays <= 10

% 10 days < totalDays <= 30 days
elseif 10 < totalDays <= 30  
%	-> label every week with daily ticks

% 30 days < totalDays <= two months
elseif 30 < totalDays <= 62  
%	-> label every week with weekly ticks

% 2 months < totalDays <= 4 months
elseif 60 < totalDays <= 123
%	-> label every other week with weekly ticks

% 4 months < totalDays <= 8 months
elseif 123 < totalDays <= 245
%	-> label every month with biweekly ticks

% 8 months < totalDays <= 2 years
elseif 245 < totalDays <= 731
%	-> label every other month with monthly ticks

% 2 years < totalDays < 4 years
elseif 731 < totalDays <= 1462
%   -> label every six months with ticks every six months

% 4 years < totalDays < 10 years
elseif 1462 < totalDays <= 3652
%   -> label every year with yearly ticks


end


%% OLD CODE

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