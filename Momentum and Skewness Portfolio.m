clear all
close all
clc
load('assignment2016.mat')

%% Data Initialisation
%Reshape returns and market cap data into 6306x16150 matrix (6306 days, 16150 stocks) 
reshape_ret = reshape(data(:,4), 6306, 16150);
reshape_cap = reshape(data(:,3), 6306, 16150);
reshape_date = reshape(data(:,2), 6306, 16150);
dates = reshape_date(:,1);
 
% Converting daily returns to monthly returns
% Monthly returns estimated by taking the sum of daily log returns
fts = fints(dates,reshape_ret, '', 'd');
mretfts = tomonthly(fts, 'CalcMethod', 'CumSum');
Monthly_Return = fts2mat(mretfts);

% Converting log returns to simple returns over the working sample period
Simple_Monthly_Return = exp(Monthly_Return(14:300,:)) - 1;
 
% Converting daily market cap to monthly market cap
% Monthly market cap estimated by taking the simple average over the month
MCfts = fints(dates,reshape_cap, '', 'd');
mmcfts = tomonthly(MCfts, 'CalcMethod', 'SimpAvg');
Monthly_MarketCap = fts2mat(mmcfts);
 
%Read the Fama and the Breakpoints
ME_Breakpoints=csvread('ME_Breakpoints.csv',1,1);
%Momentum_Factor=csvread('F-F_Momentum_Factor.csv',14,1,[14 1 1093 1]);
 
%Multiply ME breakpoints by 1,000,000 to compare them with the market cap
ME_Breakpoints_New= ME_Breakpoints*1000000;
% ME breakpoints over the data sample period
ME_BP = ME_Breakpoints_New(770:1069,:);
 
 

%% Portfolio construction- Traditional Momentum - Equal Weighting
clear all
close all
clc
load('assignment2016.mat')
% Go back to Data Initialisation

Cum_Return = zeros(287,16150);
for j = 1:16150
    for i = 14:300
Cum_Return(i-13,j) = sum(Monthly_Return([i-13:i-2],j));
    end
end
% Sort according to Cumulative Returns in descending order
traditional_index = zeros(287,16150);
traditional_location= zeros(287,16150);
traditional_sorted_index= zeros(287,16150);
%Get the relevant market caps
MarketCap= ME_BP(14:300,:);

for k= 1:287 %for each month  
%Fix ME_Breakpoint at 10% right now. For different percentile, just put
%ME_BP(k,5 or 7 or ... or 21) for 20%, 30%,...,respectively
traditional_location1=find(Monthly_MarketCap(k,:) > ME_BP(k,3)); %check for month i, for each stock whether its cum return is above BP
traditional_location(k,1:length(traditional_location1)) = traditional_location1; 
[~,traditional_index1] = sort(Cum_Return(k,:),'descend');
traditional_index(k,:) = traditional_index1; % in index (without 1!), the indices of stock based on cum. returns are sorted
traditional_sorted_index1=intersect(traditional_index1,traditional_location1,'stable');
traditional_sorted_index(k,1:length(traditional_sorted_index1)) = traditional_sorted_index1; %in sorted_index (without 1!) we got the intersection of matrix, location and index) 
end

%Get the number of viable stocks of each month
traditional_length = zeros(287,1);
for k= 1:287
    for j= 1:16150
if (traditional_sorted_index(k,j) > 0)
    traditional_length(k,1) = traditional_length(k,1) + 1;
end
    end
end

% get number of the 10% of the viable stocks 
length_new= round(traditional_length ./ 10);
portfolio = zeros(287,1);

for k = 1:287  
portfolio(k,1) = mean(Monthly_Return(traditional_sorted_index(k,1:length_new(k))))- mean(Monthly_Return(traditional_sorted_index(k,traditional_length(k)-length_new(k):traditional_length(k))));
%or was it cumulative return?
end

% Statistics
Risk_Free_Rate = zeros(287,1)
Sharpe_Ratio = zeros(287,1)
%First assume rf
Risk_Free_Rate = 0.25

for k= 1:287
Sharpe_Ratio(k)= compute_sharpe(k, Portfolio, Risk_Free_Rate);
end
    
%% Portfolio construction- Traditional Momentum - Value Weighting
Cum_Return = zeros(287,16150);
for j = 1:16150
    for i = 14:300
Cum_Return(i-13,j) = sum(Monthly_Return([i-13:i-2],j));
    end
end
% Sort according to Cumulative Returns in descending order
index = zeros(287,16150);
location= zeros(287,16150);
sorted_index= zeros(287,16150);
%Get the relevant market caps
MarketCap= Monthly_MarketCap(14:300,:);

for k= 1:287 %for each month  
%Fix ME_Breakpoint at 10% right now. For different percentile, just put
%ME_BP(k,5 or 7 or ... or 21) for 20%, 30%,...,respectively
location1=find(~isnan(MarketCap(k,:)) &  MarketCap(k,:) > ME_BP(k,3)); %check for month i, for each stock whether its cum return is above BP
location(k,1:length(location1)) = location1; 
[~,index1] = sort(Cum_Return(k,:),'descend');
index(k,:) = index1; % in index (without 1!), the indices of stock based on cum. returns are sorted
sorted_index1=intersect(index1,location1,'stable');
sorted_index(k,1:length(sorted_index1)) = sorted_index1; %in sorted_index (without 1!) we got the intersection of matrix, location and index) 
end

%Get the number of viable stocks of each month
length = zeros(287,1);
for k= 1:287
    for j= 1:16150
if (sorted_index(k,j) > 0)
    length(k,1) = length(k,1) + 1;
end
    end
end

% get number of the 10% of the viable stocks 
length_new= round(length ./ 10);

%Get Total Market Cap
Total_MarketCap= zeros(287,1);

for k = 1:287  
Total_MarketCap(k) = sum(MarketCap(k,sorted_index(k,1:length_new(k))))+ sum(MarketCap(k,sorted_index(k,length(k)-length_new(k):length(k))));
end

% Calculate Portfolio Return
portfolio = zeros(287,1);
for k = 1:287  
portfolio(k) = sum((MarketCap(k,sorted_index(k,1:length_new(k)))/Total_MarketCap(k)).*Monthly_Return(k,sorted_index(k,1:length_new(k))))- sum((MarketCap(k,sorted_index(k,length(k)-length_new(k):length(k)))/Total_MarketCap(k)).*(Monthly_Return(k,sorted_index(k,length(k)-length_new(k):length(k)))));
end


%% Skewness Enhanced Momentum - Equal Weighting

dateind = month(dates);
skewmax = [];
cmpdret = reshape_ret(2,:);

for i = 2:6305
    if dateind(i,1) == dateind(i+1,1)
        cmpdret = nanmax(cmpdret,reshape_ret(i+1,:));
        if i == 6305
            skewmax = vertcat(skewmax, cmpdret);
        end
    elseif dateind(i,1) ~= dateind(i+1,1)
        skewmax = vertcat(skewmax, cmpdret);
        cmpdret = reshape_ret(i+1,:);
    end
end

% Skewness measure over the working sample period
Skew = skewmax(13:299,:);



% Sort according to Cumulative Returns in descending order
index = zeros(287,16150);
location= zeros(287,16150);
sorted_index= zeros(287,16150);
%Get the relevant market caps
MarketCap= Monthly_MarketCap(14:300,:);

for k= 1:287 %for each month  
%Fix ME_Breakpoint at 10% right now. For different percentile, just put
%ME_BP(k,5 or 7 or ... or 21) for 20%, 30%,...,respectively
location1=find(~isnan(MarketCap(k,:)) &  MarketCap(k,:) > ME_BP(k,3)); %check for month i, for each stock whether its cum return is above BP
location(k,1:length(location1)) = location1; 
[~,index1] = sort(Skew(k,:),'ascend');
index(k,:) = index1; % in index (without 1!), the indices of stock based on cum. returns are sorted
sorted_index1=intersect(index1,location1,'stable');
sorted_index(k,1:length(sorted_index1)) = sorted_index1; %in sorted_index (without 1!) we got the intersection of matrix, location and index) 
end

%Get the number of viable stocks of each month
skewness_length = zeros(287,1);
for k= 1:287
    for j= 1:16150
if (sorted_index(k,j) > 0)
    skewness_length(k,1) = skewness_length(k,1) + 1;
end
    end
end

% get number of the 10% of the viable stocks 
%length_new= round(skewness_length ./ 10);
portfolio = zeros(287,1);

%Finding index for common stocks between Traditional Momentum and Skewness Enchanced
% portfolio for Winner and Loser deciles
% get number of the 10% of the viable stocks 
length_new= round(traditional_length ./ 10);

win_cmn_stocks = zeros(287,16150);
los_cmn_stocks = zeros(287,16150);

% 2nd and 4th line is wrong
for k = 1:287
    win_cmn_tmp = intersect(traditional_sorted_index(k,1:length_new(k)),sorted_index(k,1:length_new(k)),'stable');
    win_cmn_stocks(k,1:traditional_length(win_cmn_tmp)) = win_cmn_tmp;
    los_cmn_tmp = intersect(traditional_sorted_index(k,length(k)-length_new(k):length(k)),sorted_index(k,length(k)-length_new(k):length(k)),'stable');
    los_cmn_stocks(k,1:length(los_cmn_tmp)) = los_cmn_tmp;
end


% Computing Portfolio returns: Equally Weighted Portfolio

sk_pft_return = zeros(287,1);

 % Equally Weighted Portfolio
for k = 1:287
sk_pft_return(k,1) = mean(Simple_Monthly_Return(k,nonzeros(win_cmn_stocks(k,:)))) - mean(Simple_Monthly_Return(k,nonzeros(los_cmn_stocks(k,:))));
end

%% Skewness Enhanced Momentum - Value Weighting


        Total_MC= zeros(287,1);
    for k = 1:287  
        Total_MC(k,1) = sum(MarketCap(k,nonzeros(win_cmn_stocks(k,:)))) + sum(MarketCap(k,nonzeros(los_cmn_stocks(k,:))));
    end

    for k = 1:287  
        sk_pft_return(k,1) = sum(MarketCap(k,nonzeros(win_cmn_stocks(k,:)))/Total_MC(k).*Simple_Monthly_Return(k,nonzeros(win_cmn_stocks(k,:)))) - sum(MarketCap(k,nonzeros(los_cmn_stocks(k,:)))/Total_MC(k).*Simple_Monthly_Return(k,nonzeros(los_cmn_stocks(k,:))));
    end
