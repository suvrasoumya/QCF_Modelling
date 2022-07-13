%% import call strikes and prices
calls = [0.77 397; 0.43,398; 0.22,399; 0.1,300];
%% import put strikes and prices
puts = [0.3 393; 0.46,394; 0.73,395; 1.08,396];
%% stock data time data
stock = 396;
T = 10/360;      %assuming 10 days to expiry
rate = 0.04;

%% calculating Implied Vol
a= [calls blsimpv(stock, calls(:,2), rate , T, calls(:,1), 'Yield',0.03,'Limit', 0.5,'Class', {'Call'})];

%% imp vol from puts
b=[puts blsimpv(stock, puts(:,2), rate, T, puts(:,1), 'Yield',0.03,'Limit', 0.5,'Class', {'Put'})];

%%
c= [b ; a];
%% plot and see vol smile
disp('Assuming 10 days to expiry')
plot(c(:,2),c(:,3))