function [distance] = pointsDistance(latitudes, longitudes, depths)

% First, calculate conversion factors from lat/long to ground distance in
% km.
lat2km = (pi * 6378) / 180;
long2km = (pi * 6378 * cosd( (latitudes(1) + latitudes(2)) / 2)) / 180;

% Calculate distance between points in x, y, and z directions
dx = (longitudes(1) - longitudes(2)) * long2km;
dy = (latitudes(1) - latitudes(2)) * lat2km;
dz = depths(1) - depths(2);

% Find total distance between points
distance = sqrt(dx^2 + dy^2 + dz^2);

end
