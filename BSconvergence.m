%% create a stock tree
asset = 100;
sigma = 0.4;
rate = 0.05;
strike= 100;
time = 2;
dt = 0.5;
call_price = NaN(50,1);
put_price = NaN(50,1);
[stock, put] = binprice(asset, strike,rate, time, dt, sigma, 0);
[stock call] = binprice(asset, strike,rate, time, dt, sigma, 1);

%% use 100 increase tree steps
for i = 1:100
    [a, b] = binprice(asset, strike,rate, time, time/i, sigma, 1);
    call_price(i) = b(1,1);
    [a, d] = binprice(asset, strike,rate, time, time/i, sigma, 0);
    put_price(i) = d(1,1);
end
%% plot and see!
plot(call_price);
%%

%% plot and see!
plot(put_price);
%%

%% converging to what?
[c, p] = blsprice(asset,strike,rate,time,sigma);
%%

%%  call prices
plot([1:i],call_price);
hold on;
plot([1:i], c*ones(i,1));
%%

%%  put prices
plot([1:i],put_price);
hold on;
plot([1:i], p*ones(i,1));
%%
