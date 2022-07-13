%% data
stock = 100;
sigma = 0.1;
rate = 0.03;
T = 2;
steps = 360*2;

%% simulate gbm with drift equal risk free
mod = gbm(rate, sigma, 'StartState', stock);

%% simulated
nTrials = 20000;
s = simulate(mod, steps,...
 'DeltaTime', T/steps, 'nTrials', nTrials);
squeeze(s);
paths = nan(steps+1, nTrials);
for i = 1:steps+1
    for j = 1: nTrials
        paths(i, j) = s(i,1,j);
    end
end

%% calculating probability that stock crosses
%% $120 during the first year.
count_event = max(paths([1:361],:) >120);
%%
prob_event = sum(count_event)/nTrials

%% pricing a barrier
strike = 110;
maturity = 361;
price = exp(-rate*1)*mean(max(paths([1:361],:) >120).*... 
max(paths(maturity,:)-strike,0))