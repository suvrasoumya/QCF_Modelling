%% Covered call probabilistic analysis
 
%% Get all prices and future prices
stock_price = 20;
stock_prices_future = [40 20 12]';
bond_price = 90;
bond_prices_future = [100 100 100]';
 
%% get returns
stock_returns = (stock_prices_future - stock_price)/stock_price;
bond_returns = (bond_prices_future - bond_price)/bond_price;
 
 
%% expected profits
 
expected_profit_stock = mean(stock_prices_future - stock_price);
expected_profit_bond = 10;
 
%% expected returns
expected_stock_return = mean(stock_returns);
 
%% define the function to maximize
 
f = -[expected_profit_stock expected_profit_bond];
    
%% constraints 
%% Budget constraint
A = [20 90];
b = 50000;
lb = [0,0];
%ub = [ inf,inf , 5000, 5000];
 
%% solve linear program maximizing expected profit
 
[x fval]= linprog(f, A, b, [], [],lb, []);
 
%% what is expected profit?
expected_profit =  - f *x;
 
%% compute cost of portfolio
cost = x' * [stock_price; bond_price];
 
 
%% computation of Risk
 
portfolio_prices_future = x' * [stock_prices_future ...
    bond_prices_future]';
 
portfolio_returns = (portfolio_prices_future- cost)/cost;
mu = mean(portfolio_returns);
sigma = std(portfolio_returns);
 
%% calculate sharpe!
sharpe = mu/sigma;

