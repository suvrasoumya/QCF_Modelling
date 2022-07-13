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

%% plot!
%plot(paths);

%% prob that stock is below $110 is first 3 months
%% and above $120 in the next 3 months.

count_event1= prod(paths([1:91],:) < 110);
count_event2 = prod(paths([91:181],:) > 105);

%%

count_combined_event = count_event1.*...
    count_event2;
prob_full_event = sum(count_combined_event)/nTrials

