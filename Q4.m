%%
AssetPrice = 200;
Rate = 0.04;
Sigma = 0.20;
JumpMean = 0.8;
JumpVol = 0.3;
JumpFreq = 5;

merton_dynamics = merton(Rate,Sigma,JumpFreq,JumpMean,JumpVol,...
    'StartState',AssetPrice);
%% Simulate stock prices with merton
time =1;
DeltaTime = 1/360;
nTrials = 20000;
steps = time/DeltaTime;
t = simulate(merton_dynamics,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);
t = squeeze(t);

paths_jump = t;


%%
timing = nan(nTrials,1)';
payoffs = nan(nTrials,1)';
%aux = [max(t([1:60],j)) > 225 ;ones(1,nTrials)];

for j = 1:nTrials
    find = true;
    for i = 1:60
        if t(i,j) > 225
            timing(j)=i;
            payoffs(j) = 1000;
            find =false;
            break
        end
    end
    if find
        for i = steps-60:steps
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
payoffs = (timing ~= steps)*1000;
price_rebate = mean(exp(-Rate*timing/360).*...
    payoffs)
%%

second_barrier = nan(1, nTrials);

for j = 1:nTrials
    first_barrier(1,j) = max(t([1:60],j)) > 225;
    
    second_barrier(1,j) = max(t([end-60:end],j)) > 225;
end
%%
price = exp(-Rate*time)* mean(days_satisfied)

