%% Load currect EQ data from Waldauser via NCEDC (updated 2018)
ncedc = 'ncedc_dd_01012010_07102019.csv';
catalog = readtable(ncedc, 'HeaderLines', 13);

% Make catalog index
n = length(catalog{:,1}); 

% The purpose of this script is to identify earthquake swarms given an
% earthquake catalog. Earthquake swarms are defined as a series of
% earthquakes that are physically and temporally clustered. We will develop
% a general query system based on the modulation of these two general 
% parameters as applicable to given geologic cases.

%% Sort by time

% Convert dates to serial number
EQdates = datenum(catalog{:, 1});
dates = min(floor(EQdates)):max(floor(EQdates));
EQs_per_day = zeros(length(dates),1);

for i = 1:length(dates)
    EQs_per_day(i) = sum(floor(EQdates) == dates(i));
end

% Plot earthquakes per day over catalog period
%{
ticks = [datenum('01/01/1980'); datenum('01/01/1985'); datenum('01/01/1990'); datenum('01/01/1995'); datenum('01/01/2000'); datenum('01/01/2005'); datenum('01/01/2010'); datenum('01/01/2015'); datenum('01/01/2020')];
%{
figure;
subplot(2,1,1)
hold on
grid on
grid minor
bar(dates, EQs_per_day, 'FaceColor', [0 0 0], 'EdgeColor',[0 0 0], 'LineWidth', 0.5)
xlabel('Year')
ylabel('Earthquakes per day')
xticks(ticks)
xticklabels(1980:5:2020)
%yticks([0 10 50 100 150 200 250])
axis([ticks(1) ticks(end) 0 max(EQs_per_day)])
plot([0 ticks(end)], [20 20], 'r-')
%}

figure;
hold on
grid on
grid minor
bar(dates, EQs_norm, 'FaceColor', [0 0 0], 'EdgeColor',[0 0 0], 'LineWidth', 0.5)
xlabel('Year')
ylabel('Earthquakes per day')
xticks(ticks)
xticklabels(1980:5:2020)
axis([ticks(1) ticks(end) 0 max(EQs_norm)])
%plot([0 ticks(end)], [20 20], 'r-')


%{
subplot(2,1,2)
hold on
grid on
grid minor
bar(dates, EQs_norm, 'FaceColor', [0 0 0], 'EdgeColor',[0 0 0], 'LineWidth', 0.5)
xlabel('Year')
ylabel('Earthquakes per day')
xticks(ticks)
xticklabels(1980:5:2020)
yticks([0 10 50 100 150 200 250])
axis([ticks(1) ticks(end) 0 40])
plot([0 ticks(end)], [40 40], 'r-')
plot([datenum('2016/08/13') datenum('2016/08/21')], [10 10], '.')
%}
%}

%% Create ticks and labels
ticks = [datenum('01/01/2015');
         datenum('04/01/2015');
         datenum('07/01/2015');
         datenum('10/01/2015');
         datenum('01/01/2016');
         datenum('04/01/2016');
         datenum('07/01/2016');
         datenum('10/01/2016');
         datenum('01/01/2017');
         datenum('04/01/2017');
         datenum('07/01/2017');
         datenum('10/01/2017');
         datenum('01/01/2018');
         datenum('04/01/2018');
         datenum('07/01/2018');
         datenum('10/01/2018');
         datenum('01/01/2019');
         datenum('04/01/2019');
         datenum('07/01/2019');
         datenum('10/01/2019')];
     
labels = ["01/2015"
          "04/2015"
          "07/2015"
          "10/2015"
          "01/2016"
          "04/2016"
          "07/2016"
          "10/2016"
          "01/2017"
          "04/2017"
          "07/2017"
          "10/2017"
          "01/2018"
          "04/2018"
          "07/2018"
          "10/2018"
          "01/2019"
          "04/2019"
          "07/2019"
          "10/2019"];

          
       
% Sum earthquakes prior to indexed date         
% for i = 1:length(dates)
%     quakenum(i) = sum( EQdates <= dates(i));
% end

%% Plot cumulative number of earthquakes occured with respect to time
%{
figure;
subplot(3,1,1)
plot(dates, quakenum)
axis([ datenum('01/01/2015') datenum('01/01/2019') 0 2.5*10^4])
pbaspect([5 1 1])

grid on
xticks(ticks)
xticklabels([]);
ylabel('Number of Earthquakes')
%}

%% Plot earthquakes per calendar day
figure;
subplot(2,1,1)
bar(dates, EQs_per_day, 'FaceColor', [0 0 0], 'EdgeColor',[0 0 0], 'LineWidth', 0.5)
axis([ datenum(2015, 1, 1) datenum(2019, 10, 1) 0 300])
pbaspect([5 1 1])

grid on
xticks(ticks)
xticklabels(labels)

ylabel('Number of Earthquakes')


%% Plot magnitudes
subplot(2,1,2)

% Find M 2.0+
EQ2 = catalog((catalog{:, 5} >= 2), :);
EQ2dates = EQdates((catalog{:, 5} >= 2), :);

% Find M 3.0+
EQ3 = catalog((catalog{:, 5} >= 3), :);
EQ3dates = EQdates((catalog{:, 5} >= 3), :);

hold on
grid on
plot(EQ2dates, EQ2{:, 5}, '.', 'MarkerSize', 10)
plot(EQ3dates, EQ3{:, 5}, '.', 'MarkerSize', 10)
xlabel('Year')
ylabel('Magnitude')
xticks(ticks)
xticklabels(labels)
yticks(2:0.5:7)
axis([ datenum('01/01/2015') datenum('10/01/2019') 2 5])
pbaspect([5 1 1])