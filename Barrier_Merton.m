%% Merton asset data

AssetPrice = 100;
Rate = 0.03;
Sigma = 0.10;
JumpMean = 0.03;
JumpVol = 0.08;       
JumpFreq = 10;
            
mertonObj = merton(Rate,Sigma,JumpFreq,JumpMean,JumpVol,...
'StartState',AssetPrice)

%% Simulate stock prices with merton
DeltaTime = 1/360;
nTrials = 20000;
steps = 360*2;
t = simulate(mertonObj,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);

paths_jump = nan(steps+1, nTrials);
for j = 1:nTrials
    for i = 1:steps+1
       paths_jump(i,j) = t(i,1,j);
    end
end

%% price a rebate barrier option



