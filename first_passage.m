%% exit time computation
% clear
% clc
%% basic data
%% stock data
stock1 = 0;
return1 = 0;
sigma1 = 1;
 
stock2 = 0;
return2 = 0;
sigma2 = 1;
 
%% create return and sigma
%% matrices
Return = [return1 ;return2];
Sigma = diag([sigma1 sigma2]);
 
%% 2-dimentional gbm
correlation = [1 0.5; 0.5 1];
stocks = bm(Return, Sigma,...
    'StartState' ,[stock1; stock2],...
'correlation', correlation);
%% simulations!
DeltaTime = 1/360;
nobs = 360;
nTrials = 20000;
ss = simulate(stocks,nobs, ...
    'DeltaTime', DeltaTime,...
    'nTrials', nTrials);
 
%% extract stocks
s1 = squeeze(ss(:,1,:));
s2 = squeeze(ss(:,2,:));
 
%% see plot
tt = [s1(:,1) s2(:,1)]; 
scatter(tt(:,1),tt(:,2));
 
%% distance computing and min time
dist = sqrt(s1.^2 + s2.^2);
time = [(dist > 1);ones(1,nTrials)];
for i = 1: nobs+2
firstpassage(i) = mod(min(find(time(:,i)==1)),362);
end
firstpassage = firstpassage';

