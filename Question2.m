%% Clear
clear

%% data
stock = 200;
sigma = 0.2;
rate = 0.04;
T = 2;
steps = 360*2;

%% simulate gbm with drift equal risk free
mod = gbm(rate, sigma, 'StartState', stock);


%% simulated
nTrials = 20000;
s = simulate(mod, steps, 'DeltaTime', T/steps, 'nTrials', nTrials);
squeeze(s);
paths = nan(steps+1, nTrials);
for i = 1:steps+1
    for j = 1: nTrials
        paths(i, j) = s(i,1,j);
    end
end

%% plot!
%plot(paths);

%% No of days the stock is above 225 and below 230 in 2 year horizon = Dollar value of payoff

count_event1 = sum(paths(:,:) >= 225 & paths(:,:) <= 230);

%% Calculating price of the option

price_occupation_time = exp(-rate*T)*sum(count_event1)/nTrials

