function [catalog] = createCatalog(masterCatalog, startDate, endDate, coordinates)
% catalog - earthquake catalog following NCEDC format: 
%       (1) YEAR/MONTH/DAY HOUR:MINUTE:SECOND
%       (2) LAT
%       (3) LON
%       (4) DEPTH 
%       (5) MAGNITUDE 
%
% dates - two row date vector formatted: 
%     (:,1) YEAR 
%     (:,2) MONTH
%     (:,3) DAY
%     (:,4) HOUR 
%     (:,5) MINUTE 
%     (:,6) SECOND
%
% coordinates - bounding area for catalog
%       (1) MIN LONGITUDE
%       (2) MAX LONGITUDE
%       (3) MIN LATITUDE
%       (4) MAX LATITUDE
% Set start and end dates


% Convert start and end dates to serial numbers
numStart = datenum(startDate);
numEnd = datenum(endDate);

% Create separate column array containing serial number dates for the 
% whole catalog
numDates = datenum(masterCatalog{:,1});

% Create index for events that occur between startDate and endDate
index1 = find(numDates(:) >= numStart);
index2 = find(numDates(:) <= numEnd);

indexDates = [index1(1):index2(end)]';


% Catalog of EQs which occurred between period specified above
catalogTemp = masterCatalog(indexDates,:);

% Remove events outside of bounding box
indexBox = find(catalogTemp{:,3} >= coordinates(1) & catalogTemp{:,3} <= coordinates(2) & catalogTemp{:,2} >= coordinates(3) & catalogTemp{:,2} <= coordinates(4));

% Catalog of EQs which occurred between period specified above and are
% within the bounding box specified.
catalog = catalogTemp(indexBox,:);

end