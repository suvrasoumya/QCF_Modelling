%% Clear
clear
% clc

%% stock data
stock1 = 100;
stock2 = 100;
 
%% create return and sigma
%% matrices
Return = diag([0.03 0.01]);
Sigma = [0.2 0.4; 0.30 0.24];
 
%% 2-dimentional
correlation = [1 0.2; 0.2 1];
stocks = gbm(Return, Sigma,...
    'StartState' ,[100; 100],...
'correlation', correlation);
 
%% simulations!
DeltaTime = 1/360;
nobs = 360;
nTrials = 20;
ss = simulate(stocks,nobs, ...
    'DeltaTime', DeltaTime,...
    'nTrials', nTrials);
 
%% extract stocks
s1 = squeeze(ss(:,1,:));
s2 = squeeze(ss(:,2,:));