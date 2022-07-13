%% Clear
clear

%% data
stock = 200;
sigma = 0.2;
rate = 0.04;
T = 1;
steps = 360*T;

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

path_merton = t;

%% simulate gbm with drift equal risk free
gbm_dynamics = gbm(rate, sigma, 'StartState', stock);

%% simulated
nTrials = 20000;
t = simulate(gbm_dynamics, steps, 'DeltaTime', DeltaTime, 'nTrials', nTrials);
squeeze(t);

paths_gbm = t;

% paths_gbm = nan(steps+1, nTrials);
% for i = 1:steps+1
%     for j = 1: nTrials
%         paths_gbm(i, j) = t(i,1,j);
%     end
% end

%% plot!
%plot(paths);

%% Calculating gbm and merton price

price_gbm = occupation_price(paths_gbm,rate, nTrials)

price_merton = occupation_price(path_merton,rate, nTrials)


%% Creating the function to compute price of complex barrier derivative

function price_complex = occupation_price(path,rate, nTrials)

%% constructing the payoff
maturity = 361;

% First to ascertain paths where we have conditions to get stock delivered
% at maturity (i.e. satisfies 2nd condition - crosses in last 60 days)
payoffs_temp = path(maturity,:).*(max(path([301:361],:))>225);

% To ascertain paths that qualify for rebate leg of the option
payoffs_1= 1000* (max(path([1:61],:))>225);

% Constructing the final payoff with both the optionality conditions
nullify_rebate_leg = (payoffs_1 == 0);
payoffs = payoffs_temp.*nullify_rebate_leg + payoffs_1;

timing = 360*ones(nTrials,1)';
aux = [(path([1:61],:) > 225)];

%% payoff timing!

for i = 1:nTrials
    if sum(aux(:,i)) > 0
        timing(i)=min(find(aux(:,i)==1));
    end
end

%% find price of derivative

price_complex = mean(exp(-rate*timing/360).*payoffs);

end


