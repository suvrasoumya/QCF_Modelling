%% Clear
clear

%% data
stock = 200;
sigma = 0.2;
rate = 0.04;
T = 2;
steps = 360*2;

JumpMean = 0.8;
JumpVol = 0.3;       
JumpFreq = 5;
            
merton_dynamics = merton(rate,sigma,JumpFreq,JumpMean,JumpVol,'StartState',stock);

%% Simulate stock prices with merton
DeltaTime = 1/360;
nTrials = 20000;
steps = 360*2;
t = simulate(merton_dynamics,steps,'DeltaTime', DeltaTime, 'nTrials', nTrials);
t = squeeze(t);

paths_jump = t;



%% plot!
%plot(paths);

%% No of days the stock is above 225 and below 230 in 2 year horizon = Dollar value of payoff

count_event1 = sum(paths_jump(:,:) >= 225 & paths_jump(:,:) <= 230);

%% Calculating price of the option

price = exp(-rate*T)*sum(count_event1)/nTrials



