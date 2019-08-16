function [up, down] = plotFM(catalog, mapBounds, shape1, shape2, shape3)
% plotEQ - Plots given earthquake locations from given latitude and 
% longitude coordinates and labels current year.

% catalog:
% 1. Network ID
% 2. Station code
% 3. Latitude
% 4. Longitude
% 5. Channel 
% 6. P-wave first motion direction (up (U) or down (D))

% Convert long to positive east
for i = 1:length([catalog{:,4}])
    catalog{i,4} = catalog{i,4};
end

%% Sort into up and down groups

% Count number of up and down stations
numUP = sum([catalog{:,6}] == 'U');
numDown = sum([catalog{:,6}] == 'D');

% initiate indicies and arrays
up = cell(numUP, 6);
down = cell(numDown, 6);

iUp = 1;
iDown = 1;

% Sort
for i = 1:size(catalog)
    if catalog{i,6} == 'U'
        up(iUp,1) = catalog(i,1);
        up(iUp,2) = catalog(i,2);
        up(iUp,3) = catalog(i,3);
        up(iUp,4) = catalog(i,4);
        up(iUp,5) = catalog(i,5);
        up(iUp,6) = catalog(i,6);
        iUp = iUp + 1;
    elseif catalog{i,6} == 'D'
        down(iDown,1) = catalog(i,1);
        down(iDown,2) = catalog(i,2);
        down(iDown,3) = catalog(i,3);
        down(iDown,4) = catalog(i,4);
        down(iDown,5) = catalog(i,5);
        down(iDown,6) = catalog(i,6);
        iDown = iDown + 1;
    else
        disp(i)
        error('First motion data bad format')
    end
end
    

% Assume figure has already been established
hold on
grid on


% Generate plots
scatter([up{:,4}], [up{:,3}], 'bo')
text([up{:,4}], [up{:,3}], string(up(:,2)),'VerticalAlignment','bottom','HorizontalAlignment','right')

scatter([down{:,4}], [down{:,3}], 'ro')
text([down{:,4}], [down{:,3}], string(down(:,2)),'VerticalAlignment','bottom','HorizontalAlignment','right')


if length(shape1) > 1
    plot(shape1(:, 2), shape1(:, 1), 'k')
end

if length(shape2) > 1
    plot(shape2(:, 2), shape2(:, 1), '.k', 'markersize', 2)
end

if length(shape3) > 1
    plot(shape3(:, 2), shape3(:, 1), '-k')
end

scatter(-119.033338, 37.630687, 100,'^k')
scatter(-118.925, 37.638, 100,'*')


% Figure settings
xlabel('Longitude')
ylabel('Latidude')
daspect([1.2 1 12])
pbaspect([2 1 1])
%axis(mapBounds)
%axis([-119.5 -118.5 37 38])

legend('Up', 'Down')




hold off

end