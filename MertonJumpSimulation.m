%% Merton asset data

AssetPrice = 100;
Rate = 0.03;
Sigma = 0.10;
JumpMean = 0.03;
JumpVol = 0.08;       
JumpFreq = 10;
            
            merton_dynamics = merton(Rate,Sigma,JumpFreq,JumpMean,JumpVol,...
                'StartState',AssetPrice)

            
%% Simulate stock prices with gbm
DeltaTime = 1/360;
nTrials = 20000;
steps = 360*2
gbm_dynamics = gbm(Rate,Sigma, 'StartState', AssetPrice);
s = simulate(gbm_dynamics,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);
s = squeeze(s);
paths_gbm = s;

%%

%paths_gbm = nan(steps+1, nTrials);
%for j = 1:nTrials
%    for i = 1:steps+1
%       paths_gbm(i,j) = s(i,1,j);
%    end
%end

            
            
%% Simulate stock prices with merton
DeltaTime = 1/360;
nTrials = 20000;
steps = 360*2;
t = simulate(merton_dynamics,steps,...
    'DeltaTime', DeltaTime, 'nTrials', nTrials);
t = squeeze(t);

paths_jump = t;

%%
%paths_jump = nan(steps+1, nTrials);
%for j = 1:nTrials
 %   for i = 1:steps+1
  %     paths_jump(i,j) = t(i,1,j);
   % end
%end

%% plot the paths

% plot(paths_jump);

%% price a call using gbm
strike = 100;
price_gbm = exp(-Rate*1)* mean(max(paths_gbm(361,:)- strike,0));




%% price a call using merton jumps
strike = 100;
price_jump = exp(-Rate*1)* mean(max(paths_jump(361,:)- strike,0));
