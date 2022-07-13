%% Clear
clear

%% import call strikes and prices

% please put the input file in the same folder as source code for xlsread to work
% without changing source folder

% reading the excel file for raw data
 [float, str, total] = xlsread('Test 2 Implied Volatility Data');

% getting prices for specific range
calls = float(1:4,2:3);
puts = float(5:end,1:2);

puts = float(1:4,2:3);
calls = float(5:end,1:2);
v = puts(:, 1);
puts(:, 1) = puts(:, 2);
puts(:, 2) = v;

%% stock data time data
stock = 396;
T = 10/360;
rate = 0.04;

%% calculating Implied Vol
a= [calls blsimpv(stock, calls(:,2), ...
rate , T, calls(:,1), ...
'Yield',0.03,'Limit', 0.5,'Class', {'Call'})];


%% imp vol from puts
b=[puts blsimpv(stock, puts(:,2), ...
rate, T, puts(:,1), ...
'Yield',0.03,'Limit', 0.5,'Class', {'Put'})];

c= [b ; a];
%% plot and see vol smile
plot(c(:,2),c(:,3))
