%% import call strikes and prices
%% import put strikes and prices
clear

%% stock data time data
stock = 119;
T = 0.25;
rate = 0.02

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
