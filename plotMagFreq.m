function plotMagFreq(catalog)
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

magIndex = 0:0.1:(round(max(catalog{:, 5}),1) + 0.1);

distribution = zeros(length(magIndex), 2);

for i = 1:length(magIndex)
    distribution(i, 1) = magIndex(i);
    distribution(i, 2) = sum(round(catalog{:,5}, 1) == round(magIndex(i),1));
end

% NEED TO FILTER OUT ZERO VALUES FOR # OF EARTHQUAKES
maxIt = length(distribution(:,1));
i = 1;

while i <= maxIt
    if distribution(i, 2) == 0
        if i == 1
            distribution = distribution(i+1:end, :);
            maxIt = maxIt - 1;
        else
            distribution = distribution([1:(i-1) (i+1):end], :);
            maxIt = maxIt - 1;
        end
    elseif abs(distribution(i, 2)) > 0
        i = i + 1;
    end
end

semilogy(distribution(:,1), distribution(:,2), '*k')
hold on
grid on
xlabel('Magnitude M_w')
ylabel('Number of Earthquakes')
axis([0 magIndex(end)+0.15 0 max(distribution(:, 2))+max(distribution(:, 2))*0.05])


end

