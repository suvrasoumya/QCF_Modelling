%% what are stock parameters?
stock = 100;
sigma = 0.4;
rate = 0.05;
%%
%% option parameters
T = 2;
strike = 100;
%%
%% create GBM
dynamics = gbm(rate, sigma, 'StartState', stock);
%% Simulate GBM
steps = 100;
nTrials = 200;
s = simulate(dynamics, steps, 'nTrials',nTrials,'DeltaTime',T/steps);
s = squeeze(s);
%% plot paths!
plot([0:T/steps:T],s);

%% calculate final stock price for each sim.
final_stock_price = s(end,:)';

%% price a European call.

call_price = exp(-rate*T)... 
    * mean(max(final_stock_price - strike,0));

%% price a European put.

put_price = exp(-rate*T)... 
    * mean(max(-final_stock_price + strike,0));

%% price a Log contract

log_contract_price = exp(-rate*T)... 
    * mean(log(final_stock_price));

%% price a square contract.

square_contract_price = exp(-rate*T)... 
    * mean(final_stock_price.^2);

%% price a square-root contract.

root_contract_price = exp(-rate*T)... 
    * mean(sqrt(final_stock_price));

%% price a forward starter!
forward_starter_price = exp(-rate*T)... 
* mean(max(s(end,:)- s(51,:),0));

%% price asian..average price call strike 100.
asian_call_price = exp(-rate*T)... 
* mean(max(mean(s)-100,0)');

%% Price cash barrier pays $75 if the 
%% stock crosses $110
cash_barrier_price = exp(-rate*T)... 
* mean((max(s) > 120) * 75) 