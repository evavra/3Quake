function plotEQ(catalog, mapBounds, shape1, shape2, shape3)
% plotEQ - Plots given earthquake locations from given latitude and 
% longitude coordinates and labels current year.

% Generate temporal color map
cmp = flip(parula(numel(catalog{:,1})));

% Assume figure has already been established
hold on
grid on

% Look for M 3.0+ events
EQ3 = catalog((catalog{:, 5} >= 3 & catalog{:, 5} < 4), :);
% Look for M 4.0+ events
EQ4 = catalog((catalog{:, 5} >= 4), :);

% Generate plots
scatter(catalog{:,3}, catalog{:,2}, 5, cmp, 'filled')

if size(EQ3,1) > 0
    scatter(EQ3{:,3}, EQ3{:,2}, 30, 'ro')
end

if size(EQ4,1) > 0
    scatter(EQ4{:,3}, EQ4{:,2}, 300, 'ro')
end

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

% Figure settings
xlabel('Longitude')
ylabel('Latidude')
zlabel('Depth (km)')
daspect([1.2 1 12])
axis(mapBounds)


% Color bar settings
%colorbar
%c = colorbar;
%c.Ticks = [0 1];

%tick1 = datestr([catalog{1,1}],'yyyy-mm-dd HH:MM:SS');
%tick2 = datestr([catalog{end,1}],'yyyy-mm-dd HH:MM:SS');

%c.TickLabels = {tick2, tick1};

hold off

end