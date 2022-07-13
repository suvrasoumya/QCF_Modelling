% AMERICAN OPTION PRICING \\ Delta-Gamma Hedging
 
clc
clear all
close all
 
%% AMERICAN OPTION PRICING
 
sigma = 0.3; % volatility of the underlying asset
r = 0.03; % risk free return
T = 2; % time to maturity
S_0 = 100; % price of the underlying asset 
K = 100;
 
Number_of_Intervals = 500; % As this value goes to infinity, binomial converges to brownian 
Delta = 1/Number_of_Intervals; 
time = (0:Delta:T); % time set
 
Stock_Price = nan(length(time),length(time)); 
 
Stock_Price(1,1) = S_0;
 
for t = 2:length(time)
    
   Stock_Price(1:t-1,t) = Stock_Price(1:t-1,t-1)*exp( (r-0.5*(sigma^2))*Delta + sqrt(Delta) ); 
   Stock_Price(t,t) =  Stock_Price(t-1,t-1)*exp( (r-0.5*(sigma^2))*Delta - sqrt(Delta) );
    
end
 
% Backward Induction
 
American_Put_Value = nan(length(time),length(time)); 
American_Put_Value(:,end) = max( K - Stock_Price(:,end) , 0 );
 
for t = (length(time)-1):-1:1
   
    American_Put_Value(1:t,t) = max (  ...
                       K - Stock_Price(1:t,t) , ... 
        exp(-r*Delta)*( .5* American_Put_Value(1:t,t+1) +  .5* American_Put_Value(2:t+1,t+1) ) ... 
                                        );
   
end
 
American_Put_Price = American_Put_Value(1,1);
[call_delta, not_used] = blsprice( S_0, K, r, T, sigma, 0); % the last argument is dividend yield which we ignore 
  
 
%% Example 1 : Delta Heding
 
% Parameters for call option
 
sigma = 0.3; % volatility of the underlying asset
r = 0.03; % risk free return
K = 1000; % strike price
T = 2; % time to maturity
S_0 = 1100; % price of the underlying asset 
Number_of_Stocks = 1000;
 
% Step 1 find the price and delta of the option
 
[call_price, not_used] = blsprice( S_0, K, r, T, sigma, 0); % the last argument is dividend yield which we ignore 
[call_delta, not_used] = blsdelta( S_0, K, r, T, sigma, 0); % the last argument is dividend yield which we ignore 
 
% Step 2 solve the system of equation 
% 1 * x + call_delta * y = 0
% S_0 * x + call_price*y = S_0 * Number_of_Stocks 
 
A = [1 call_delta
     1100 call_price];
 
B = [0 1100*1000]';
X = A \ B;
 
% Step 3 reblance your portfolio
 
Number_of_Stocks_Delta_Hedged = X(1);
Number_of_Calls_Delta_Hedged = X(2);
 
% Value comparison
 
Lower_Bound_Stock_Price = S_0 - 200;
Upper_Bound_Stock_Price = S_0 + 200;
 
Possible_Stock_Prices = (Lower_Bound_Stock_Price:1:Upper_Bound_Stock_Price);
 
Value_Unhedged = Possible_Stock_Prices*Number_of_Stocks;
[Call_Prices_Vector, not_used] = blsprice( Possible_Stock_Prices, K, r, T, sigma, 0);
Value_Delta_Hedged = Possible_Stock_Prices*Number_of_Stocks_Delta_Hedged ...
                       +  Call_Prices_Vector*Number_of_Calls_Delta_Hedged;
                   
figure(1)
plot(Possible_Stock_Prices,Value_Unhedged,'r')
hold on
plot(Possible_Stock_Prices,Value_Delta_Hedged)
xlabel('Stock Value')
ylabel('Portfolio Value')
legend('Unhedged','Delta-Hedged')
title('Unhedged VS Delta_Hedged')
 
%% Example 2 : Delta Gamma Hedging
 
% Different Parameters for Put option
 
K_for_put = 700; % strike price
T_for_put = 1.5; % time to maturity
 
% Step 1 find the price, delta, gamma of the option
 
call_gamma = blsgamma( S_0, K, r, T, sigma, 0); % the last argument is dividend yield which we ignore 
 
[not_used, put_price] = blsprice( S_0, K_for_put, r, T_for_put, sigma, 0); % the last argument is dividend yield which we ignore 
[not_used, put_delta] = blsdelta( S_0, K_for_put, r, T_for_put, sigma, 0); % the last argument is dividend yield which we ignore 
put_gamma = blsgamma( S_0, K_for_put, r, T_for_put, sigma, 0); % the last argument is dividend yield which we ignore 
 
% Step 2 solve the system of equation 
% 1 * x + call_delta * y + put_delta * z= 0
% 0 * x + call_gamma * y + put_gamma * z= 0
% S_0 * x + call_price * y + put_price * z = S_0 * Number_of_Stocks 
 
A = [1 call_delta put_delta
     0 call_gamma put_gamma
     1100 call_price put_price];
 
B = [0 0 1100*1000]';
X = A \ B;
 
% Step 3 reblance your portfolio
 
Number_of_Stocks_DeltaGamma_Hedged = X(1);
Number_of_Calls_DeltaGamma_Hedged = X(2);
Number_of_Puts_DeltaGamma_Hedged = X(3);
 
% Value comparison
 
[not_used, Put_Prices_Vector] = blsprice( Possible_Stock_Prices, K_for_put, r, T_for_put, sigma, 0);
Value_DeltaGamma_Hedged = Possible_Stock_Prices*Number_of_Stocks_DeltaGamma_Hedged ...
                       +  Call_Prices_Vector*Number_of_Calls_DeltaGamma_Hedged ...
                       +  Put_Prices_Vector*Number_of_Puts_DeltaGamma_Hedged;
                   
figure(2)
plot(Possible_Stock_Prices,Value_Unhedged,'r')
hold on
plot(Possible_Stock_Prices,Value_Delta_Hedged,'k')
hold on
plot(Possible_Stock_Prices,Value_DeltaGamma_Hedged)
xlabel('Stock Value')
ylabel('Portfolio Value')
legend('Unhedged','Delta-Hedged','DeltaGamma-Hedged')
title('Unhedged VS Delta_Hedged VS DeltaGamma_Hedged')
 
 
 
%% Dynamic Delta-Hedging
 
dt_choice = [1/12 1/52 1/252];
T_Maturity_Call = 2;
T = 1;
mu = 0.05;
sigma = 0.25;
r = 0.03;
F = 100;
N_Simulation = 10;
K = 100;
 
for dt_choice_index = 1:length(dt_choice)
   
    dt = dt_choice(dt_choice_index);
    Time = (0:dt:T);
    Time_To_Maturity = T_Maturity_Call - Time;
    
    dW = sqrt(dt)*randn(length(Time)-1,N_Simulation); 
    %dW = sqrt(dt)*(-1+2*( rand(length(Time)-1,N_Simulation) > 0.5)); 
    
    Initial_Stock_Price = log(F)*ones(1,N_Simulation);
    Log_Stcok_Price_Diff = ( mu - 0.5*(sigma^2) )*dt*ones( length(Time)-1 ,N_Simulation ) ... % drift term
                           + sigma*dW ; % NOTE THAT YOU ARE SIMULATING UNDER P!!!!
    
    temp = [Initial_Stock_Price; Log_Stcok_Price_Diff]; % first row is log(S_0) and the rest is d(log(S_t))
    Log_Stock_Price = cumsum(temp);
    Stock_Price = exp(Log_Stock_Price);
    
    [Call_Price,not_used] = blsprice(Stock_Price, K, r, (Time_To_Maturity')*ones(1,N_Simulation), sigma, 0);
    [Call_Delta,not_used] = blsdelta(Stock_Price, K, r, (Time_To_Maturity')*ones(1,N_Simulation), sigma, 0);
            
    subplot(length(dt_choice),1,dt_choice_index)
    Value_of_Portfolio_Delta_Hedged = nan(size(Stock_Price,1),size(Stock_Price,2));
    Value_of_Portfolio_Delta_Hedged(1,:) = Stock_Price(1,:);
    
    for i = 1:N_Simulation       
        for dt_index = 1:(length(Time)-1)
           
            Value_of_Portfolio_This_Period = Value_of_Portfolio_Delta_Hedged(dt_index,i);
            Stock_Price_This_Period = Stock_Price(dt_index,i);
            Call_Price_This_Period = Call_Price(dt_index,i);
            Call_Delta_This_Period = Call_Delta(dt_index,i);
            
            A = [Stock_Price_This_Period Call_Price_This_Period
                 1                       Call_Delta_This_Period];
            B = [Value_of_Portfolio_This_Period
                 0];
            Solution = A \ B;
            Number_of_Stocks = Solution(1);
            Number_of_Calls = Solution(2);
 
            Stock_Price_Next_Period = Stock_Price( dt_index+1 ,i);
            Call_Price_Next_Period = Call_Price( dt_index+1 ,i);
            Value_of_Portfolio_Next_Period = Stock_Price_Next_Period*Number_of_Stocks + Call_Price_Next_Period*Number_of_Calls;
            Value_of_Portfolio_Delta_Hedged( dt_index+1 ,i) = Value_of_Portfolio_Next_Period;
            
        end
    end
    
    for i = 1:N_Simulation
    
        plot( Time , Value_of_Portfolio_Delta_Hedged(:,i))
        hold on    
        plot( Time , F*exp(r*Time), 'r', 'LineWidth', 2);
        axis([0 1 80 120])
        
    end
    
    xlabel('Time')
    ylabel('Value of Delta Hedged Portfolio')
    if dt == 1/12
        title('Monthly Rebalancing')
    elseif dt == 1/52
        title('Weekly Rebalancing')
    elseif dt == 1/252
        title('Daily Rebalancing')
    end
    
    hold off
    
end


