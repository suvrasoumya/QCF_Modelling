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

%% prob that stock is above and stays above $220 during fifth month and tenth month

count_event1= prod(paths([151:181],:) > 220);
count_event2 = prod(paths([301:331],:) > 220);

%%

count_combined_event = count_event1.*count_event2;
prob_full_event = sum(count_combined_event)/nTrials

