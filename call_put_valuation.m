% n steps  CRR binomial tree pricing method for American and European Options

% clean and clear the screen
clc;
clear;

% presetting parameters 
steps = 500; %number of steps used in Binomial tree
sigma = 0.3;  % volatility
T = 2; % Total years
deltat = T/steps; % one step time
R = 0.03; % Risk free return (continuous compound)
D = 0; % dividend rate
s0 = 100; % stock price at time 0
K = 100; % option strike price

% calculated parameters
u = exp(sigma*sqrt(deltat)); %s_(t+1) up = u*st
d = exp(-sigma*sqrt(deltat));  % s_(t+1) down = d*st
% ud = 1
r = exp(R*deltat);
p = ( exp((R-D)*deltat)-d)/(u-d); % p for up 1-p for down

% calculating last layer of nodes for stock_price
stock_price = ones(steps+1,1)*s0;
%%
for i=1:(steps+1)
  stock_price(i) = stock_price(i)*(u^(i-1))*(d^(steps+1-i));
end
%%
% last step nodes value for European / American  * Call / Put
Eu_call1 = max(0, stock_price-K);
Am_call = max(0, stock_price-K);
Eu_put1 = max(0, -stock_price+K);
Am_put = max(0, -stock_price+K);

% Iterating Calculation of the options value
for i=steps:-1:1
    for j=1:i
        % use temp for easier calculation
        % display(Am_call);
        display(j)
        temp1 = max((1-p)*Am_call(j) + p*Am_call(j+1),0);
        temp2 = s0*(u^(j-1))*(d^(i-j))-K;
        temp3 = max((1-p)*Am_put(j) + p*Am_put(j+1),0);
        temp4 = -s0*(u^(j-1))*(d^(i-j))+K;
        
        Am_call(j) = max(temp1/r, temp2);
        Eu_call1(j) = max((1-p)*Eu_call1(j) + p*Eu_call1(j+1),0)/r;
        Am_put(j) = max(temp3/r, temp4);
        Eu_put1(j) =  max((1-p)*Eu_put1(j) + p*Eu_put1(j+1),0)/r;
    end
end

% explicit valuation method for European Options
Eu_call2 = 0;
for i=0:steps
    Eu_call2 =   Eu_call2 + nchoosek(steps,i)*(p^i)*((1-p)^(steps-i))*max(0,s0 *(u^i)*(d^(steps-i))-K);
end
Eu_call2 = Eu_call2/r^steps;

Eu_put2 = 0;
for i=0:steps
    Eu_put2=   Eu_put2 + nchoosek(steps,i)*(p^i)*((1-p)^(steps-i))*max(0,K -s0 *(u^i)*(d^(steps-i)));
end
Eu_put2= Eu_put2/r^steps;