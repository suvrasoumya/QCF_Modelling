%% what are stock parameters?
stock = 110;
sigma = 0.2;
rate = 0.1;
%%
%% option parameters
T = 2;
% strike = 100;
%%
%% create GBM
dynamics = gbm(rate, sigma, 'StartState', stock);
%% Simulate GBM
steps = 100
nTrials = 10000
s = simulate(dynamics, steps, 'nTrials',nTrials,'DeltaTime',T/steps);
s = squeeze(s);
%% plot paths!
plot([0:T/steps:T],s);

c = s[101]