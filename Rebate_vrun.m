%% Rebate barrier options

%% Stock and other details
stock = 200;
sigma = 0.2;
rate = 0.04;

%% simulate using gbm
dynamics = gbm(rate, sigma ,'StartState', stock);
steps = 360*1;
nTrials = 20000;  
DeltaTime = 1/360;
s = simulate(dynamics, steps, 'nTrials',nTrials,'DeltaTime',DeltaTime);
s = squeeze(s);
%%
%% cash or nothing payoffs
payoffs = 1000* (max(s([1:61],:)) > 225);
timing = nan(nTrials,1)';
aux = [(s([1:61],:) > 225) ;ones(1,nTrials)];
%% payoff timing!

for i = 1:nTrials
     timing(i)=min(find(aux(:,i)==1));
end


%% find price of rebate barrier

price_barrier = mean(exp(-rate*timing/360) .* payoffs) + exp(-rate*1)*mean((max(s([301:361],:)) > 225 & timing > 61) .* s(361,:))

%% Merton asset data

AssetPrice = 200;
Rate = 0.04;
Sigma = 0.2;
JumpMean = 0.8;
JumpVol = 0.3;       
JumpFreq = 5;
            
mertonObj = merton(Rate,Sigma,JumpFreq,JumpMean,JumpVol,...
'StartState',AssetPrice)

%% Simulate stock prices with merton
DeltaTime = 1/360;
nTrials = 20000;
steps = 360*1;
t = simulate(mertonObj,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);

paths_jump = nan(steps+1, nTrials);
for j = 1:nTrials
    for i = 1:steps+1
       paths_jump(i,j) = t(i,1,j);
    end
end

%%
%% cash or nothing payoffs
payoffs_jump = 1000* (max(t([1:61],:)) > 225);
timing_jump = nan(nTrials,1)';
aux_jump = [(t([1:61],:) > 225) ;ones(1,nTrials)];
%% payoff timing!

for i = 1:nTrials
     timing_jump(i)=min(find(aux_jump(:,i)==1));
end
%% price a rebate barrier option


price_barrier_jump = mean(exp(-Rate*timing_jump/360) .* payoffs_jump) + exp(-Rate*1)*mean((max(t([301:361],:)) > 225 & timing_jump > 61)  .* t(361,:))


