%%
clear
clc
%%
AssetPrice = 200;
Rate = 0.04;
Sigma = 0.20;
JumpMean = 0.8;
JumpVol = 0.3;
JumpFreq = 5;

merton_dynamics = merton(Rate,Sigma,JumpFreq,JumpMean,JumpVol,...
    'StartState',AssetPrice);
gbm_dynamics = gbm(Rate, Sigma, 'StartState', AssetPrice);
%% Simulate stock prices with merton
time =1;
DeltaTime = 1/360;
nTrials = 20000;
steps = time/DeltaTime;
t_merton = simulate(merton_dynamics,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);
t_merton = squeeze(t_merton);

price_merton = occupation_price(t_merton,Rate)

t_gbm = simulate(gbm_dynamics,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);
t_gbm = squeeze(t_gbm);

price_gbm = occupation_price(t_gbm,Rate)

%%
function price_rebate = occupation_price(t,Rate)

[steps nTrials] = size(t,[1,2]);
timing = nan(nTrials,1)';
payoffs = nan(nTrials,1)';
%aux = [max(t([1:60],j)) > 225 ;ones(1,nTrials)];

for j = 1:nTrials
    find = true;
    for i = 1:61
        if t(i,j) > 225
            timing(j)=i;
            payoffs(j) = 1000;
            find =false;
            break
        end
    end
    if find
        for i = 301:361
            if t(i,j) > 225
                payoffs(j) = t(end,j);
                timing(j)=steps;
                find =false;
                break
            end
        end
    end
    if find
        payoffs(j) =0;
        timing(j)=steps;
    end
end


%% find price of rebate barrier

price_rebate = mean(exp(-Rate*timing/360).*...
    payoffs);

end
