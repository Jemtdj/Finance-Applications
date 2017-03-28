
%% Question 1 %%

%% PART 1 %%%%
% importing csv data file
% extracting numeric price data to 2641 x 30 matrix
[num,txt,raw] = xlsread('equity_dataset_30.csv', 'equity_dataset_30');
px_mat = xlsread('equity_dataset_30.csv', 'equity_dataset_30');

%% PART 2 %%%%
% calculating log returns of stocks
ret_mat = diff(log(px_mat));

%% PART 3 %%%%
% splitting sample period into "training" and "testing" period
% Dates are slightly different from CW guidelines due to trading days

% date serial number
dates = raw(2:end,1);
DateNumber = datenum(dates,'dd/MM/yyyy');

% For loop to parse through csv file to index benchmark dates
for i = 1:length(dates)
    if (strcmp(dates(i,1),'03/01/2005') == 1)
        Trnpstrt = i;
    elseif (strcmp(dates(i,1),'31/12/2012') == 1)
        Trnpend = i;
    elseif (strcmp(dates(i,1),'02/01/2013') == 1)
        Testpstrt = i;
    elseif (strcmp(dates(i,1),'30/06/2015') == 1)
        Testpend = i;
    end
end

% Index points deduct 1 to account for the ommission of the first row when
% calculating log returns
% In-Sample Training Dataset returns
ret_mat_is = ret_mat(Trnpstrt:Trnpend-1,:);
% Out-of-Sample Testing Dataset returns
ret_mat_os = ret_mat(Testpstrt-1:Testpend-1,:);

%% PART 4 %%%%
% Historical daily average returns of each stock
avgret = mean(ret_mat_is);
IS_hadr = avgret'
% Historical covariance matrix
IS_hcovm = cov(ret_mat_is);

%% PART 5 %%%%
% Initialising parameters for the various portfolios
% assuming a risk-free rate of 3%
N = length(IS_hadr); % Length of In-Sample period
Aeq = ones(1,N); % Initialising the weights for the portfolio
beq = 1; % Total sum of weights have to equal to 1

% suppressing optimization message
opts = optimset('Display', 'off');

% Benchmark Portfolio: Equally weighted portfolio
w0 = ones(N,1)*(1/N);

% Portfolio 1: Maximize Sharpe Ratio (Short-Selling)
[w1, fval] = fmincon(@(w)-com_sr(w, IS_hadr, IS_hcovm), w0, [], [], Aeq, beq, [], [], [], opts);
% Computing Portfolio 1 Sharpe Ratio
sr1 = com_sr(w1, IS_hadr, IS_hcovm);
fprintf('The maximized Sharpe Ratio is %.4f.\n', sr1);


% Portfolio 2: Maximize Sharpe Ratio (No Short-selling)
% no short-selling constraint, weights have to be greater than 0
lb = zeros(1,N);
[w2, fval] = fmincon(@(w)-com_sr(w, IS_hadr, IS_hcovm), w0, [], [], Aeq, beq, lb, [], [], opts);
% Computing Portfolio 2 Sharpe Ratio
sr2 = com_sr(w2, IS_hadr, IS_hcovm);
fprintf('The maximized Sharpe Ratio is %.4f.\n', sr2);


% Portfolio 3: Minimize Portfolio Variance (Short-Selling)
% constraint: sum of weights is 1eee
% Aeq = ones(N,1)' technically supposed to be a transposed matrix
w3 = fmincon(@(w)com_pvar(w, IS_hcovm), w0, [], [], Aeq, beq, [], [], [], opts);

%% PART 6 %%%%
% Converting dates for both In-Sample and Out-Sample periods for Equity
% Curve plots

% Getting dates for Equity Curve Plot
% In-Sample dates +2 because the first date is ommitted from calculating
% returns over the period
IS_dates = raw(Trnpstrt+2:Trnpend+1,1),'dd/MM/yyyy';
OS_dates = raw(Testpstrt+1:Testpend+1,1),'dd/MM/yyyy';

% Converting In-Sample and Out-Sample dates into array format for plot
IS_dates_plot = datetime(IS_dates);
OS_dates_plot = datetime(OS_dates);

% Portfolio returns for In-Sample period
ret_is_w0 = (w0' * ret_mat_is')';
ret_is_w1 = (w1' * ret_mat_is')';
ret_is_w2 = (w2' * ret_mat_is')';
ret_is_w3 = (w3' * ret_mat_is')';

% Cumulative returns for portfolios In-Sample period
% Using log10 scale to enable comparison across portfolios
Ec_is_w0 = log10(cumprod(1+ret_is_w0));
Ec_is_w1 = log10(cumprod(1+ret_is_w1));
Ec_is_w2 = log10(cumprod(1+ret_is_w2)); 
Ec_is_w3 = log10(cumprod(1+ret_is_w3));

% Equity Curve Plot
plot(IS_dates_plot, Ec_is_w0, IS_dates_plot, Ec_is_w1, IS_dates_plot, Ec_is_w2, IS_dates_plot, Ec_is_w3);
legend('Benchmark Portfolio', 'Portfolio 1: Max SR w/ SS', 'Portfolio 2: Max SR w/o SS', 'Portfolio 3: Min Pvar', 'Location', 'northwest');
title('In-Sample Period Daily Returns: Backtest');
xlabel('Years')
ylabel('Returns (%)')

% Calculating Cumulative Average Return (CAR)
% Annualizing over 8 years
car_is_w0 = ((Ec_is_w0(end,1)/Ec_is_w0(1,1))^(1/8) - 1)*100;
car_is_w1 = ((Ec_is_w1(end,1)/Ec_is_w1(1,1))^(1/8) - 1)*100;
car_is_w2 = ((Ec_is_w2(end,1)/Ec_is_w2(1,1))^(1/8) - 1)*100;
car_is_w3 = ((Ec_is_w3(end,1)/Ec_is_w3(1,1))^(1/8) - 1)*100;
fprintf('Average Annual Return Over 8 Years for the respective portfolios from Benchmark to Portfolio 4 is %.4f, %.4f, %.4f, %.4f \n', car_is_w0, car_is_w1, car_is_w2, car_is_w3)
% Answers
% Benchmark: 8.2927%
% Portfolio 1: 133.3902%
% Portfolio 2: 119.3902%
% Portfolio 3: 122.9143%

% Calculating Annualized Sharpe Ratio
% Benchmark Portfolio
anl_ret_is_w0 = mean(ret_is_w0) * 252;
anl_std_is_w0 = std(ret_is_w0) * sqrt(252);
sr_is_w0 = (anl_ret_is_w0 - 0.03) / anl_std_is_w0;
% Portfolio 1
anl_ret_is_w1 = mean(ret_is_w1) * 252;
anl_std_is_w1 = std(ret_is_w1) * sqrt(252);
sr_is_w1 = (anl_ret_is_w1 - 0.03) / anl_std_is_w1;
% Portfolio 2
anl_ret_is_w2 = mean(ret_is_w2) * 252;
anl_std_is_w2 = std(ret_is_w2) * sqrt(252);
sr_is_w2 = (anl_ret_is_w2 - 0.03) / anl_std_is_w2;
% Portfolio 3
anl_ret_is_w3 = mean(ret_is_w3) * 252;
anl_std_is_w3 = std(ret_is_w3) * sqrt(252);
sr_is_w3 = (anl_ret_is_w3 - 0.03) / anl_std_is_w3;
fprintf('Annualized Sharpe Ratio Over 8 Years for the respective portfolios from Benchmark to Portfolio 4 is %.4f, %.4f, %.4f, %.4f \n', sr_is_w0, sr_is_w1, sr_is_w2, sr_is_w3)
% Answers
% Benchmark: 0.0073
% Portfolio 1: 1.6786
% Portfolio 2: 0.7360
% Portfolio 3: 0.5873


%% PART 7 %%%%

% Portfolio returns for Out-of-Sample period
ret_os_w0 = (w0' * ret_mat_os')';
ret_os_w1 = (w1' * ret_mat_os')';
ret_os_w2 = (w2' * ret_mat_os')';
ret_os_w3 = (w3' * ret_mat_os')';

% Cumulative returns for portfolios Out-of-Sample period
% Using log10 scale to enable comparison across portfolios
Ec_os_w0 = log10(cumprod(1+ret_os_w0));
Ec_os_w1 = log10(cumprod(1+ret_os_w1));
Ec_os_w2 = log10(cumprod(1+ret_os_w2));
Ec_os_w3 = log10(cumprod(1+ret_os_w3));

% Equity Curve Plot
plot(OS_dates_plot, Ec_os_w0, OS_dates_plot, Ec_os_w1, OS_dates_plot, Ec_os_w2, OS_dates_plot, Ec_os_w3);
legend('Benchmark Portfolio', 'Portfolio 1: Max SR w/ SS', 'Portfolio 2: Max SR w/o SS', 'Portfolio 3: Min Pvar', 'Location', 'southwest');
title('Out-Sample Period Daily Returns: Backtest');
xlabel('Years');
ylabel('Returns (%)');
ylim([-0.4,0.3]);

% Calculating Cumulative Average Return (CAR)
% Annualizing over 2.5 years
car_os_w0 = ((Ec_os_w0(end,1)/Ec_os_w0(1,1))^(1/2.5) - 1)*100;
car_os_w1 = ((Ec_os_w1(end,1)/Ec_os_w1(1,1))^(1/2.5) - 1)*100;
car_os_w2 = ((Ec_os_w2(end,1)/Ec_os_w2(1,1))^(1/2.5) - 1)*100;
car_os_w3 = ((Ec_os_w3(end,1)/Ec_os_w3(1,1))^(1/2.5) - 1)*100;
fprintf('Average Annual Return Over 2.5 Years for the respective portfolios from Benchmark to Portfolio 4 is %.4f, %.4f, %.4f, %.4f \n', car_os_w0, car_os_w1, car_os_w2, car_os_w3)
% Answers
% Benchmark: 188.7264%
% Portfolio 1: -19.3188%
% Portfolio 2: 182.1080%
% Portfolio 3: 132.7828%

% Calculating Annualized Sharpe Ratio
% Benchmark Portfolio
anl_ret_os_w0 = mean(ret_os_w0) * 252;
anl_std_os_w0 = std(ret_os_w0) * sqrt(252);
sr_os_w0 = (anl_ret_os_w0 - 0.03) / anl_std_os_w0;
% Portfolio 1
anl_ret_os_w1 = mean(ret_os_w1) * 252;
anl_std_os_w1 = std(ret_os_w1) * sqrt(252);
sr_os_w1 = (anl_ret_os_w1 - 0.03) / anl_std_os_w1;
% Portfolio 2
anl_ret_os_w2 = mean(ret_os_w2) * 252;
anl_std_os_w2 = std(ret_os_w2) * sqrt(252);
sr_os_w2 = (anl_ret_os_w2 - 0.03) / anl_std_os_w2;
% Portfolio 3
anl_ret_os_w3 = mean(ret_os_w3) * 252;
anl_std_os_w3 = std(ret_os_w3) * sqrt(252);
sr_os_w3 = (anl_ret_os_w3 - 0.03) / anl_std_os_w3;
fprintf('Annualized Sharpe Ratio Over 2.5 Years for the respective portfolios from Benchmark to Portfolio 4 is %.4f, %.4f, %.4f, %.4f \n', sr_os_w0, sr_os_w1, sr_os_w2, sr_os_w3)
% Answers
% Benchmark: 1.1179
% Portfolio 1: -0.3517
% Portfolio 2: 1.0477
% Portfolio 3: 0.3967

% Multiple plot for visual comparison
% Enlarge plot window for optimal illustration
figure

subplot(2,1,1)
plot(IS_dates_plot, Ec_is_w0, IS_dates_plot, Ec_is_w1, IS_dates_plot, Ec_is_w2, IS_dates_plot, Ec_is_w3);
legend('Benchmark Portfolio', 'Portfolio 1: Max SR w/ SS', 'Portfolio 2: Max SR w/o SS', 'Portfolio 3: Min Pvar', 'Location', 'northwestoutside');
title('In-Sample Period Daily Returns: Backtest');
xlabel('Years')
ylabel('Returns (%)')

subplot(2,1,2)
plot(OS_dates_plot, Ec_os_w0, OS_dates_plot, Ec_os_w1, OS_dates_plot, Ec_os_w2, OS_dates_plot, Ec_os_w3);
legend('Benchmark Portfolio', 'Portfolio 1: Max SR w/ SS', 'Portfolio 2: Max SR w/o SS', 'Portfolio 3: Min Pvar', 'Location', 'northwestoutside');
title('Out-Sample Period Daily Returns: Backtest');
xlabel('Years');
ylabel('Returns (%)');
ylim([-0.4,0.3]);


% Comments
% We can see that from using the optimised weights in the In-Sample Period
% for the Out-Sample period, all portfolios except for Portfolio 1
% outperforms. Portfolio 1 underperforms drastically when using the
% In-Sample optimised weights when backtested with the Out-Sample daily
% returns. This goes to show the importance of rebalancing portfolios
% because of the crucial factor that the covariance matrix of the
% respective securities under the study will change over time. The
% structure of the market and the fundamentals of the portfolio securities
% in the first 8 years of the study may not necessarily be a good
% representation of what it is like in the subsequent 2.5 years. Therefore,
% we are able to see that by contrasting the portfolio results in both
% samples, we are able to infer this key takeaway. 



%% Question 2 %%
clear all
clc

%%% Stock & Option parameters %%%
S0 = 100; % Value of the underlying at time 0
K = 100; % Strike price (Option exercise price)
T = 1;   % Maturity
mu = 0.15; % Stock price mean
r = 0.1; % Risk free interest rate
sigma = 0.3; % Volatility

%% PART 1 %%%%
% Simulating price paths for stock using Geometric Brownian Motion

%%% Simulation Parameters %%%
dt = 1/252; 
T = 1; 
tgrid = 0: dt: T;
N = length(tgrid);
S = zeros(1,N);

% Simulate random number epsilon 
eps = randn(1,N);
% Simulating stock price for the stock over a year (252 days)
S = S0*exp((mu-0.5*(sigma^2))*tgrid+sigma*sqrt(tgrid).*eps);
plot(tgrid,S)
title('Stock price over a year');
ylabel('Stock price ($)');
xlabel('Years (deci)');

%% PART 2 %%%%
% Calculating Option Prices: Monte Carlo Simulation
% Simulating the stock price using Monte Carlo Simulation
% Under the log-normal distribution for the random variable

%%% Monte-Carlo Method Parameters %%%
M = 10000000; % Number of Monte-Carlo trials
eps = randn(M,1); % Random variable for MCS
%%% Use final values to compute %%%
S_MCS = exp(log(S0*exp((mu-0.5*(sigma^2))+sigma.*eps)));

opt_call = max(S_MCS-K,0); % Evaluate the Call options
opt_put = max(K-S_MCS,0); % Evaluate the Put options
option_vals = [opt_call opt_put]; % Distribution of all call & put values
present_vals = exp(-r*T)*option_vals; % Discounting distribution values under r-n assumption to obtain present values
opts = mean(present_vals); % Taking average of the distribution of present values

% Displaying prices of Call and Put Option
display('call_value, put_value')
display(opts)

% Simulated answers as of 24 Oct 2016 23:34
% Call Value = 20.3984
% Put Value = 5.7511

%% PART 3 %%%%
% Calculating Option Prices: Black Scholes Formula

% Calling the Black-Scholes function to calculate the price of a Call and
% Put option
CallPrice = bs_price(S0, K, T, r, sigma, 'Call');
PutPrice = bs_price(S0, K, T, r, sigma, 'Put');

% Displaying Price of Call and Put option
fprintf('\n The Price of a European Call is : %8.2f \n' ,CallPrice);
fprintf('\n The Price of a European Put is : %8.2f \n'  ,PutPrice);

% Answers
% Call Value = 16.73
% Put Value = 7.22

% Comments
% The option prices for the Monte Carlo Simulation (MCS) and the Black
% Scholes (BS) formula differ quite substantially. However, theoretically, 
% if we increase the number of trials in the Monte Carlo Simulation, we 
% should expect to see that the prices for the MCS converge to that of the 
% BS formula. 