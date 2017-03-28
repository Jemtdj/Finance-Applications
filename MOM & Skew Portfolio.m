% Loading data files
% Stock Returns data
load('assignment2016.mat');
% Fama and French ME Breakpoints
ME_Breakpoints = csvread('ME_Breakpoints.csv',1,1);
% Fama and French Momentum Factors
FF_Momentum = csvread('F-F_Momentum_Factor.csv',770,0,[770 0 1069 1]);
% Fama and French Factors and Risk-free Rate
FF_Factors = csvread('F-F_Research_Data_Factors.csv',766,0,[766 0 1065 4]);

%% Initialising Data

% Reshaping data
dailypermno = reshape(data(:,1),[6306,16150]);
dailydates = reshape(data(:,2),[6306,16150]);
dailymarketcap = reshape(data(:,3),[6306,16150]);
dailyret = reshape(data(:,4),[6306,16150]);
dates = unique(dailydates);
mdates = (datetime(1991,2,1):calmonths(1):datetime(2014,12,31))';

% Converting daily returns to monthly returns
% Monthly returns estimated by taking the sum of daily log returns
fts = fints(dates,dailyret, '', 'd');
mretfts = tomonthly(fts, 'CalcMethod', 'CumSum');
MonRet = fts2mat(mretfts);
% Converting log returns to simple returns over the working sample period
SimpMonRet = exp(MonRet(14:300,:)) - 1;
% Converting daily market cap to monthly market cap
% Monthly market cap estimated by taking the simple average over the month
MCfts = fints(dates,dailymarketcap, '', 'd');
mmcfts = tomonthly(MCfts, 'CalcMethod', 'SimpAvg');
MonMC = fts2mat(mmcfts);

% Multiplying ME Breakpoints dataset by 1 million for appropriate
% comparison with sample data
MEbp = ME_Breakpoints(770:1069,:) * 1000000;

% Dividing FF factors by 100 because already expressed in percentages
% FF momentum factors over the data sample period
FFm = FF_Momentum(14:300,2) / 100;

%% Portfolio Construction: Traditional Momentum

% Calculating 12-month cumulative return and ignoring 13th month return
MS = movsum(MonRet,[11,0],1,'omitnan');
CumRet = MS(12:298,:);

% Obtaining Relevant ME Breakpoint and Monthly Market Cap over working sample period
spMEbp = horzcat(MEbp(14:300,:),zeros(287,1));
spMonMC = MonMC(14:300,:);

% Filtering stocks for Cumulative Returns and Computing the respective index
% 100% decile ME breakpoint is not relevant because then we would
% effectively be excluding all stocks in the entire universe
tm_sorted_1 = sortindex(spMonMC,spMEbp,22,CumRet,'CumRet');
tm_sorted_2 = sortindex(spMonMC,spMEbp,3,CumRet,'CumRet');
tm_sorted_3 = sortindex(spMonMC,spMEbp,5,CumRet,'CumRet');
tm_sorted_4 = sortindex(spMonMC,spMEbp,7,CumRet,'CumRet');
tm_sorted_5 = sortindex(spMonMC,spMEbp,9,CumRet,'CumRet');
tm_sorted_6 = sortindex(spMonMC,spMEbp,11,CumRet,'CumRet');
tm_sorted_7 = sortindex(spMonMC,spMEbp,13,CumRet,'CumRet');
tm_sorted_8 = sortindex(spMonMC,spMEbp,15,CumRet,'CumRet');
tm_sorted_9 = sortindex(spMonMC,spMEbp,17,CumRet,'CumRet');
tm_sorted_10 = sortindex(spMonMC,spMEbp,19,CumRet,'CumRet');

% Computing the total number of filtered stocks each month
tm_length_1 = nofilteredstocks(tm_sorted_1);
tm_length_2 = nofilteredstocks(tm_sorted_2);
tm_length_3 = nofilteredstocks(tm_sorted_3);
tm_length_4 = nofilteredstocks(tm_sorted_4);
tm_length_5 = nofilteredstocks(tm_sorted_5);
tm_length_6 = nofilteredstocks(tm_sorted_6);
tm_length_7 = nofilteredstocks(tm_sorted_7);
tm_length_8 = nofilteredstocks(tm_sorted_8);
tm_length_9 = nofilteredstocks(tm_sorted_9);
tm_length_10 = nofilteredstocks(tm_sorted_10);

% Computing Portfolio returns: Equally Weighted Portfolio
ew_pft_1 = pft_return(tm_sorted_1,tm_length_1,SimpMonRet,spMonMC,'EW');
ew_pft_2 = pft_return(tm_sorted_2,tm_length_2,SimpMonRet,spMonMC,'EW');
ew_pft_3 = pft_return(tm_sorted_3,tm_length_3,SimpMonRet,spMonMC,'EW');
ew_pft_4 = pft_return(tm_sorted_4,tm_length_4,SimpMonRet,spMonMC,'EW');
ew_pft_5 = pft_return(tm_sorted_5,tm_length_5,SimpMonRet,spMonMC,'EW');
ew_pft_6 = pft_return(tm_sorted_6,tm_length_6,SimpMonRet,spMonMC,'EW');
ew_pft_7 = pft_return(tm_sorted_7,tm_length_7,SimpMonRet,spMonMC,'EW');
ew_pft_8 = pft_return(tm_sorted_8,tm_length_8,SimpMonRet,spMonMC,'EW');
ew_pft_9 = pft_return(tm_sorted_9,tm_length_9,SimpMonRet,spMonMC,'EW');
ew_pft_10 = pft_return(tm_sorted_10,tm_length_10,SimpMonRet,spMonMC,'EW');

% Computing Portfolio returns: Value Weighted Portfolio
vw_pft_1 = pft_return(tm_sorted_1,tm_length_1,SimpMonRet,spMonMC,'VW');
vw_pft_2 = pft_return(tm_sorted_2,tm_length_2,SimpMonRet,spMonMC,'VW');
vw_pft_3 = pft_return(tm_sorted_3,tm_length_3,SimpMonRet,spMonMC,'VW');
vw_pft_4 = pft_return(tm_sorted_4,tm_length_4,SimpMonRet,spMonMC,'VW');
vw_pft_5 = pft_return(tm_sorted_5,tm_length_5,SimpMonRet,spMonMC,'VW');
vw_pft_6 = pft_return(tm_sorted_6,tm_length_6,SimpMonRet,spMonMC,'VW');
vw_pft_7 = pft_return(tm_sorted_7,tm_length_7,SimpMonRet,spMonMC,'VW');
vw_pft_8 = pft_return(tm_sorted_8,tm_length_8,SimpMonRet,spMonMC,'VW');
vw_pft_9 = pft_return(tm_sorted_9,tm_length_9,SimpMonRet,spMonMC,'VW');
vw_pft_10 = pft_return(tm_sorted_10,tm_length_10,SimpMonRet,spMonMC,'VW');

%% Portfolio Construction: Skewness Enchanced Momentum

% Calculating the Skew Max Variable over the entire sample period
dateind = month(dates);
skewmax = [];
cmpdret = dailyret(2,:);

for i = 2:6305
    if dateind(i,1) == dateind(i+1,1)
        cmpdret = max(cmpdret,dailyret(i+1,:),'omitnan');
        if i == 6305
            skewmax = vertcat(skewmax, cmpdret);
        end
    elseif dateind(i,1) ~= dateind(i+1,1)
        skewmax = vertcat(skewmax, cmpdret);
        cmpdret = dailyret(i+1,:);
    end
end

% Skewness measure over the working sample period
spskewmax = skewmax(13:299,:);

% Filtering stocks for Skewness Measure and Computing the respective index
sm_sorted_1 = sortindex(spMonMC,spMEbp,22,spskewmax,'Skew');
sm_sorted_2 = sortindex(spMonMC,spMEbp,3,spskewmax,'Skew');
sm_sorted_3 = sortindex(spMonMC,spMEbp,5,spskewmax,'Skew');
sm_sorted_4 = sortindex(spMonMC,spMEbp,7,spskewmax,'Skew');
sm_sorted_5 = sortindex(spMonMC,spMEbp,9,spskewmax,'Skew');
sm_sorted_6 = sortindex(spMonMC,spMEbp,11,spskewmax,'Skew');
sm_sorted_7 = sortindex(spMonMC,spMEbp,13,spskewmax,'Skew');
sm_sorted_8 = sortindex(spMonMC,spMEbp,15,spskewmax,'Skew');
sm_sorted_9 = sortindex(spMonMC,spMEbp,17,spskewmax,'Skew');
sm_sorted_10 = sortindex(spMonMC,spMEbp,19,spskewmax,'Skew');

% Computing the total number of filtered stocks each month
sm_length_1 = nofilteredstocks(sm_sorted_1);
sm_length_2 = nofilteredstocks(sm_sorted_2);
sm_length_3 = nofilteredstocks(sm_sorted_3);
sm_length_4 = nofilteredstocks(sm_sorted_4);
sm_length_5 = nofilteredstocks(sm_sorted_5);
sm_length_6 = nofilteredstocks(sm_sorted_6);
sm_length_7 = nofilteredstocks(sm_sorted_7);
sm_length_8 = nofilteredstocks(sm_sorted_8);
sm_length_9 = nofilteredstocks(sm_sorted_9);
sm_length_10 = nofilteredstocks(sm_sorted_10);

% Finding index for common stocks between Traditional Momentum and Skewness Enchanced
% portfolio for Winner and Loser deciles
[Win_SK_1,Los_SK_1] = CommonStocksIndex(tm_length_1,tm_sorted_1,sm_length_1,sm_sorted_1);
[Win_SK_2,Los_SK_2] = CommonStocksIndex(tm_length_2,tm_sorted_2,sm_length_2,sm_sorted_2);
[Win_SK_3,Los_SK_3] = CommonStocksIndex(tm_length_3,tm_sorted_3,sm_length_3,sm_sorted_3);
[Win_SK_4,Los_SK_4] = CommonStocksIndex(tm_length_4,tm_sorted_4,sm_length_4,sm_sorted_4);
[Win_SK_5,Los_SK_5] = CommonStocksIndex(tm_length_5,tm_sorted_5,sm_length_5,sm_sorted_5);
[Win_SK_6,Los_SK_6] = CommonStocksIndex(tm_length_6,tm_sorted_6,sm_length_6,sm_sorted_6);
[Win_SK_7,Los_SK_7] = CommonStocksIndex(tm_length_7,tm_sorted_7,sm_length_7,sm_sorted_7);
[Win_SK_8,Los_SK_8] = CommonStocksIndex(tm_length_8,tm_sorted_8,sm_length_8,sm_sorted_8);
[Win_SK_9,Los_SK_9] = CommonStocksIndex(tm_length_9,tm_sorted_9,sm_length_9,sm_sorted_9);
[Win_SK_10,Los_SK_10] = CommonStocksIndex(tm_length_10,tm_sorted_10,sm_length_10,sm_sorted_10);

% Computing Portfolio returns: Equally Weighted Portfolio
% There are still returns in the portfolio but need to replace NaN values
% with 1
ew_skpft_1 = sk_pft_return(Win_SK_1,Los_SK_1,SimpMonRet,spMonMC,'EW');
ew_skpft_2 = sk_pft_return(Win_SK_2,Los_SK_2,SimpMonRet,spMonMC,'EW');
ew_skpft_3 = sk_pft_return(Win_SK_3,Los_SK_3,SimpMonRet,spMonMC,'EW');
ew_skpft_4 = sk_pft_return(Win_SK_4,Los_SK_4,SimpMonRet,spMonMC,'EW');
ew_skpft_5 = sk_pft_return(Win_SK_5,Los_SK_5,SimpMonRet,spMonMC,'EW');
ew_skpft_6 = sk_pft_return(Win_SK_6,Los_SK_6,SimpMonRet,spMonMC,'EW');
ew_skpft_7 = sk_pft_return(Win_SK_7,Los_SK_7,SimpMonRet,spMonMC,'EW');
ew_skpft_8 = sk_pft_return(Win_SK_8,Los_SK_8,SimpMonRet,spMonMC,'EW');
ew_skpft_9 = sk_pft_return(Win_SK_9,Los_SK_9,SimpMonRet,spMonMC,'EW');
ew_skpft_10 = sk_pft_return(Win_SK_10,Los_SK_10,SimpMonRet,spMonMC,'EW');

% Computing Portfolio returns: Value Weighted Portfolio
% When the value weighted portfolio is + it gives the right results
vw_skpft_1 = sk_pft_return(Win_SK_1,Los_SK_1,SimpMonRet,spMonMC,'VW');
vw_skpft_2 = sk_pft_return(Win_SK_2,Los_SK_2,SimpMonRet,spMonMC,'VW');
vw_skpft_3 = sk_pft_return(Win_SK_3,Los_SK_3,SimpMonRet,spMonMC,'VW');
vw_skpft_4 = sk_pft_return(Win_SK_4,Los_SK_4,SimpMonRet,spMonMC,'VW');
vw_skpft_5 = sk_pft_return(Win_SK_5,Los_SK_5,SimpMonRet,spMonMC,'VW');
vw_skpft_6 = sk_pft_return(Win_SK_6,Los_SK_6,SimpMonRet,spMonMC,'VW');
vw_skpft_7 = sk_pft_return(Win_SK_7,Los_SK_7,SimpMonRet,spMonMC,'VW');
vw_skpft_8 = sk_pft_return(Win_SK_8,Los_SK_8,SimpMonRet,spMonMC,'VW');
vw_skpft_9 = sk_pft_return(Win_SK_9,Los_SK_9,SimpMonRet,spMonMC,'VW');
vw_skpft_10 = sk_pft_return(Win_SK_10,Los_SK_10,SimpMonRet,spMonMC,'VW');

% Changing Nan values into 0 for skewness portfolios
ew_skpft_1(isnan(ew_skpft_1)) = 0;
ew_skpft_2(isnan(ew_skpft_2)) = 0;
ew_skpft_3(isnan(ew_skpft_3)) = 0;
ew_skpft_4(isnan(ew_skpft_4)) = 0;
ew_skpft_5(isnan(ew_skpft_5)) = 0;
ew_skpft_6(isnan(ew_skpft_6)) = 0;
ew_skpft_7(isnan(ew_skpft_7)) = 0;
ew_skpft_8(isnan(ew_skpft_8)) = 0;
ew_skpft_9(isnan(ew_skpft_9)) = 0;
ew_skpft_10(isnan(ew_skpft_10)) = 0;

vw_skpft_1(isnan(vw_skpft_1)) = 0;
vw_skpft_2(isnan(vw_skpft_2)) = 0;
vw_skpft_3(isnan(vw_skpft_3)) = 0;
vw_skpft_4(isnan(vw_skpft_4)) = 0;
vw_skpft_5(isnan(vw_skpft_5)) = 0;
vw_skpft_6(isnan(vw_skpft_6)) = 0;
vw_skpft_7(isnan(vw_skpft_7)) = 0;
vw_skpft_8(isnan(vw_skpft_8)) = 0;
vw_skpft_9(isnan(vw_skpft_9)) = 0;
vw_skpft_10(isnan(vw_skpft_10)) = 0;

%% Portfolio Performance Measures

%%% Portfolio Return %%%
% Traditional Momentum Portfolio: Equally Weighted
r_ew_pft_1 = mean(ew_pft_1);
r_ew_pft_2 = mean(ew_pft_2);
r_ew_pft_3 = mean(ew_pft_3);
r_ew_pft_4 = mean(ew_pft_4);
r_ew_pft_5 = mean(ew_pft_5);
r_ew_pft_6 = mean(ew_pft_6);
r_ew_pft_7 = mean(ew_pft_7);
r_ew_pft_8 = mean(ew_pft_8);
r_ew_pft_9 = mean(ew_pft_9);
r_ew_pft_10 = mean(ew_pft_10);
Ret_TM_EW = [r_ew_pft_1;r_ew_pft_2;r_ew_pft_3;r_ew_pft_4;r_ew_pft_5;r_ew_pft_6;r_ew_pft_7;r_ew_pft_8;r_ew_pft_9;r_ew_pft_10];
% Traditional Momentum Portfolio: Value Weighted
r_vw_pft_1 = mean(vw_pft_1);
r_vw_pft_2 = mean(vw_pft_2);
r_vw_pft_3 = mean(vw_pft_3);
r_vw_pft_4 = mean(vw_pft_4);
r_vw_pft_5 = mean(vw_pft_5);
r_vw_pft_6 = mean(vw_pft_6);
r_vw_pft_7 = mean(vw_pft_7);
r_vw_pft_8 = mean(vw_pft_8);
r_vw_pft_9 = mean(vw_pft_9);
r_vw_pft_10 = mean(vw_pft_10);
Ret_TM_VW = [r_vw_pft_1;r_vw_pft_2;r_vw_pft_3;r_vw_pft_4;r_vw_pft_5;r_vw_pft_6;r_vw_pft_7;r_vw_pft_8;r_vw_pft_9;r_vw_pft_10];
% Skewness Enhanced Momentum Portfolio: Equally Weighted
r_ew_skpft_1 = mean(ew_skpft_1);
r_ew_skpft_2 = mean(ew_skpft_2);
r_ew_skpft_3 = mean(ew_skpft_3);
r_ew_skpft_4 = mean(ew_skpft_4);
r_ew_skpft_5 = mean(ew_skpft_5);
r_ew_skpft_6 = mean(ew_skpft_6);
r_ew_skpft_7 = mean(ew_skpft_7);
r_ew_skpft_8 = mean(ew_skpft_8);
r_ew_skpft_9 = mean(ew_skpft_9);
r_ew_skpft_10 = mean(ew_skpft_10);
Ret_SM_EW = [r_ew_skpft_1;r_ew_skpft_2;r_ew_skpft_3;r_ew_skpft_4;r_ew_skpft_5;r_ew_skpft_6;r_ew_skpft_7;r_ew_skpft_8;r_ew_skpft_9;r_ew_skpft_10];
% Skewness Enhanced Momentum Portfolio: Value Weighted
r_vw_skpft_1 = mean(vw_skpft_1);
r_vw_skpft_2 = mean(vw_skpft_2);
r_vw_skpft_3 = mean(vw_skpft_3);
r_vw_skpft_4 = mean(vw_skpft_4);
r_vw_skpft_5 = mean(vw_skpft_5);
r_vw_skpft_6 = mean(vw_skpft_6);
r_vw_skpft_7 = mean(vw_skpft_7);
r_vw_skpft_8 = mean(vw_skpft_8);
r_vw_skpft_9 = mean(vw_skpft_9);
r_vw_skpft_10 = mean(vw_skpft_10);
Ret_SM_VW = [r_vw_skpft_1;r_vw_skpft_2;r_vw_skpft_3;r_vw_skpft_4;r_vw_skpft_5;r_vw_skpft_6;r_vw_skpft_7;r_vw_skpft_8;r_vw_skpft_9;r_vw_skpft_10];

%%% Portfolio Volatility %%%
% Traditional Momentum Portfolio: Equally Weighted
sd_ew_pft_1 = std(ew_pft_1);
sd_ew_pft_2 = std(ew_pft_2);
sd_ew_pft_3 = std(ew_pft_3);
sd_ew_pft_4 = std(ew_pft_4);
sd_ew_pft_5 = std(ew_pft_5);
sd_ew_pft_6 = std(ew_pft_6);
sd_ew_pft_7 = std(ew_pft_7);
sd_ew_pft_8 = std(ew_pft_8);
sd_ew_pft_9 = std(ew_pft_9);
sd_ew_pft_10 = std(ew_pft_10);
Vol_TM_EW = [sd_ew_pft_1;sd_ew_pft_2;sd_ew_pft_3;sd_ew_pft_4;sd_ew_pft_5;sd_ew_pft_6;sd_ew_pft_7;sd_ew_pft_8;sd_ew_pft_9;sd_ew_pft_10];
% Traditional Momentum Portfolio: Value Weighted
sd_vw_pft_1 = std(vw_pft_1);
sd_vw_pft_2 = std(vw_pft_2);
sd_vw_pft_3 = std(vw_pft_3);
sd_vw_pft_4 = std(vw_pft_4);
sd_vw_pft_5 = std(vw_pft_5);
sd_vw_pft_6 = std(vw_pft_6);
sd_vw_pft_7 = std(vw_pft_7);
sd_vw_pft_8 = std(vw_pft_8);
sd_vw_pft_9 = std(vw_pft_9);
sd_vw_pft_10 = std(vw_pft_10);
Vol_TM_VW = [sd_vw_pft_1;sd_vw_pft_2;sd_vw_pft_3;sd_vw_pft_4;sd_vw_pft_5;sd_vw_pft_6;sd_vw_pft_7;sd_vw_pft_8;sd_vw_pft_9;sd_vw_pft_10];
% Skewness Enhanced Momentum Portfolio: Equally Weighted
sd_ew_skpft_1 = std(ew_skpft_1);
sd_ew_skpft_2 = std(ew_skpft_2);
sd_ew_skpft_3 = std(ew_skpft_3);
sd_ew_skpft_4 = std(ew_skpft_4);
sd_ew_skpft_5 = std(ew_skpft_5);
sd_ew_skpft_6 = std(ew_skpft_6);
sd_ew_skpft_7 = std(ew_skpft_7);
sd_ew_skpft_8 = std(ew_skpft_8);
sd_ew_skpft_9 = std(ew_skpft_9);
sd_ew_skpft_10 = std(ew_skpft_10);
Vol_SM_EW = [sd_ew_skpft_1;sd_ew_skpft_2;sd_ew_skpft_3;sd_ew_skpft_4;sd_ew_skpft_5;sd_ew_skpft_6;sd_ew_skpft_7;sd_ew_skpft_8;sd_ew_skpft_9;sd_ew_skpft_10];
% Skewness Enhanced Momentum Portfolio: Value Weighted
sd_vw_skpft_1 = std(vw_skpft_1);
sd_vw_skpft_2 = std(vw_skpft_2);
sd_vw_skpft_3 = std(vw_skpft_3);
sd_vw_skpft_4 = std(vw_skpft_4);
sd_vw_skpft_5 = std(vw_skpft_5);
sd_vw_skpft_6 = std(vw_skpft_6);
sd_vw_skpft_7 = std(vw_skpft_7);
sd_vw_skpft_8 = std(vw_skpft_8);
sd_vw_skpft_9 = std(vw_skpft_9);
sd_vw_skpft_10 = std(vw_skpft_10);
Vol_SM_VW = [sd_vw_skpft_1;sd_vw_skpft_2;sd_vw_skpft_3;sd_vw_skpft_4;sd_vw_skpft_5;sd_vw_skpft_6;sd_vw_skpft_7;sd_vw_skpft_8;sd_vw_skpft_9;sd_vw_skpft_10];

%%% Evolving Sharpe Ratio %%%
% Initialising 1-month risk-free rate
% Taking the 12th root of the data because rates are quoted at annualised
% rate
rf = ((FF_Factors(14:300,5)./100)+1).^(1/12)-1;
% Traditional Momentum Portfolio: Equally Weighted
sr_ew_pft_1 = (ew_pft_1 - rf)./std(ew_pft_1);
sr_ew_pft_2 = (ew_pft_2 - rf)./std(ew_pft_2);
sr_ew_pft_3 = (ew_pft_3 - rf)./std(ew_pft_3);
sr_ew_pft_4 = (ew_pft_4 - rf)./std(ew_pft_4);
sr_ew_pft_5 = (ew_pft_5 - rf)./std(ew_pft_5);
sr_ew_pft_6 = (ew_pft_6 - rf)./std(ew_pft_6);
sr_ew_pft_7 = (ew_pft_7 - rf)./std(ew_pft_7);
sr_ew_pft_8 = (ew_pft_8 - rf)./std(ew_pft_8);
sr_ew_pft_9 = (ew_pft_9 - rf)./std(ew_pft_9);
sr_ew_pft_10 = (ew_pft_10 - rf)./std(ew_pft_10);
% Traditional Momentum Portfolio: Value Weighted
sr_vw_pft_1 = (vw_pft_1 - rf)./std(vw_pft_1);
sr_vw_pft_2 = (vw_pft_2 - rf)./std(vw_pft_2);
sr_vw_pft_3 = (vw_pft_3 - rf)./std(vw_pft_3);
sr_vw_pft_4 = (vw_pft_4 - rf)./std(vw_pft_4);
sr_vw_pft_5 = (vw_pft_5 - rf)./std(vw_pft_5);
sr_vw_pft_6 = (vw_pft_6 - rf)./std(vw_pft_6);
sr_vw_pft_7 = (vw_pft_7 - rf)./std(vw_pft_7);
sr_vw_pft_8 = (vw_pft_8 - rf)./std(vw_pft_8);
sr_vw_pft_9 = (vw_pft_9 - rf)./std(vw_pft_9);
sr_vw_pft_10 = (vw_pft_10 - rf)./std(vw_pft_10);
% Skewness Enhanced Momentum Portfolio: Equally Weighted
sr_ew_skpft_1 = (ew_skpft_1 - rf)./std(ew_skpft_1);
sr_ew_skpft_2 = (ew_skpft_2 - rf)./std(ew_skpft_2);
sr_ew_skpft_3 = (ew_skpft_3 - rf)./std(ew_skpft_3);
sr_ew_skpft_4 = (ew_skpft_4 - rf)./std(ew_skpft_4);
sr_ew_skpft_5 = (ew_skpft_5 - rf)./std(ew_skpft_5);
sr_ew_skpft_6 = (ew_skpft_6 - rf)./std(ew_skpft_6);
sr_ew_skpft_7 = (ew_skpft_7 - rf)./std(ew_skpft_7);
sr_ew_skpft_8 = (ew_skpft_8 - rf)./std(ew_skpft_8);
sr_ew_skpft_9 = (ew_skpft_9 - rf)./std(ew_skpft_9);
sr_ew_skpft_10 = (ew_skpft_10 - rf)./std(ew_skpft_10);
% Skewness Enhanced Momentum Portfolio: Value Weighted
sr_vw_skpft_1 = (vw_skpft_1 - rf)./std(vw_skpft_1);
sr_vw_skpft_2 = (vw_skpft_2 - rf)./std(vw_skpft_2);
sr_vw_skpft_3 = (vw_skpft_3 - rf)./std(vw_skpft_3);
sr_vw_skpft_4 = (vw_skpft_4 - rf)./std(vw_skpft_4);
sr_vw_skpft_5 = (vw_skpft_5 - rf)./std(vw_skpft_5);
sr_vw_skpft_6 = (vw_skpft_6 - rf)./std(vw_skpft_6);
sr_vw_skpft_7 = (vw_skpft_7 - rf)./std(vw_skpft_7);
sr_vw_skpft_8 = (vw_skpft_8 - rf)./std(vw_skpft_8);
sr_vw_skpft_9 = (vw_skpft_9 - rf)./std(vw_skpft_9);
sr_vw_skpft_10 = (vw_skpft_10 - rf)./std(vw_skpft_10);

%%% Sharpe Ratios %%%
% Traditional Momentum Portfolio: Equally Weighted
msr_ew_pft_1 = (r_ew_pft_1 - mean(rf))./std(ew_pft_1);
msr_ew_pft_2 = (r_ew_pft_2 - mean(rf))./std(ew_pft_2);
msr_ew_pft_3 = (r_ew_pft_3 - mean(rf))./std(ew_pft_3);
msr_ew_pft_4 = (r_ew_pft_4 - mean(rf))./std(ew_pft_4);
msr_ew_pft_5 = (r_ew_pft_5 - mean(rf))./std(ew_pft_5);
msr_ew_pft_6 = (r_ew_pft_6 - mean(rf))./std(ew_pft_6);
msr_ew_pft_7 = (r_ew_pft_7 - mean(rf))./std(ew_pft_7);
msr_ew_pft_8 = (r_ew_pft_8 - mean(rf))./std(ew_pft_8);
msr_ew_pft_9 = (r_ew_pft_9 - mean(rf))./std(ew_pft_9);
msr_ew_pft_10 = (r_ew_pft_10 - mean(rf))./std(ew_pft_10);
SR_TM_EW = [msr_ew_pft_1;msr_ew_pft_2;msr_ew_pft_3;msr_ew_pft_4;msr_ew_pft_5;msr_ew_pft_6;msr_ew_pft_7;msr_ew_pft_8;msr_ew_pft_9;msr_ew_pft_10];
% Traditional Momentum Portfolio: Value Weighted
msr_vw_pft_1 = (r_vw_pft_1 - mean(rf))./std(vw_pft_1);
msr_vw_pft_2 = (r_vw_pft_2 - mean(rf))./std(vw_pft_2);
msr_vw_pft_3 = (r_vw_pft_3 - mean(rf))./std(vw_pft_3);
msr_vw_pft_4 = (r_vw_pft_4 - mean(rf))./std(vw_pft_4);
msr_vw_pft_5 = (r_vw_pft_5 - mean(rf))./std(vw_pft_5);
msr_vw_pft_6 = (r_vw_pft_6 - mean(rf))./std(vw_pft_6);
msr_vw_pft_7 = (r_vw_pft_7 - mean(rf))./std(vw_pft_7);
msr_vw_pft_8 = (r_vw_pft_8 - mean(rf))./std(vw_pft_8);
msr_vw_pft_9 = (r_vw_pft_9 - mean(rf))./std(vw_pft_9);
msr_vw_pft_10 = (r_vw_pft_10 - mean(rf))./std(vw_pft_10);
SR_TM_VW = [msr_vw_pft_1;msr_vw_pft_2;msr_vw_pft_3;msr_vw_pft_4;msr_vw_pft_5;msr_vw_pft_6;msr_vw_pft_7;msr_vw_pft_8;msr_vw_pft_9;msr_vw_pft_10];
% Skewness Enhanced Momentum Portfolio: Equally Weighted
msr_ew_skpft_1 = (r_ew_skpft_1 - mean(rf))./std(ew_skpft_1);
msr_ew_skpft_2 = (r_ew_skpft_2 - mean(rf))./std(ew_skpft_2);
msr_ew_skpft_3 = (r_ew_skpft_3 - mean(rf))./std(ew_skpft_3);
msr_ew_skpft_4 = (r_ew_skpft_4 - mean(rf))./std(ew_skpft_4);
msr_ew_skpft_5 = (r_ew_skpft_5 - mean(rf))./std(ew_skpft_5);
msr_ew_skpft_6 = (r_ew_skpft_6 - mean(rf))./std(ew_skpft_6);
msr_ew_skpft_7 = (r_ew_skpft_7 - mean(rf))./std(ew_skpft_7);
msr_ew_skpft_8 = (r_ew_skpft_8 - mean(rf))./std(ew_skpft_8);
msr_ew_skpft_9 = (r_ew_skpft_9 - mean(rf))./std(ew_skpft_9);
msr_ew_skpft_10 = (r_ew_skpft_10 - mean(rf))./std(ew_skpft_10);
SR_SM_EW = [msr_ew_skpft_1;msr_ew_skpft_2;msr_ew_skpft_3;msr_ew_skpft_4;msr_ew_skpft_5;msr_ew_skpft_6;msr_ew_skpft_7;msr_ew_skpft_8;msr_ew_skpft_9;msr_ew_skpft_10];
% Skewness Enhanced Momentum Portfolio: Value Weighted
msr_vw_skpft_1 = (r_vw_skpft_1 - mean(rf))./std(vw_skpft_1);
msr_vw_skpft_2 = (r_vw_skpft_2 - mean(rf))./std(vw_skpft_2);
msr_vw_skpft_3 = (r_vw_skpft_3 - mean(rf))./std(vw_skpft_3);
msr_vw_skpft_4 = (r_vw_skpft_4 - mean(rf))./std(vw_skpft_4);
msr_vw_skpft_5 = (r_vw_skpft_5 - mean(rf))./std(vw_skpft_5);
msr_vw_skpft_6 = (r_vw_skpft_6 - mean(rf))./std(vw_skpft_6);
msr_vw_skpft_7 = (r_vw_skpft_7 - mean(rf))./std(vw_skpft_7);
msr_vw_skpft_8 = (r_vw_skpft_8 - mean(rf))./std(vw_skpft_8);
msr_vw_skpft_9 = (r_vw_skpft_9 - mean(rf))./std(vw_skpft_9);
msr_vw_skpft_10 = (r_vw_skpft_10 - mean(rf))./std(vw_skpft_10);
SR_SM_VW = [msr_vw_skpft_1;msr_vw_skpft_2;msr_vw_skpft_3;msr_vw_skpft_4;msr_vw_skpft_5;msr_vw_skpft_6;msr_vw_skpft_7;msr_vw_skpft_8;msr_vw_skpft_9;msr_vw_skpft_10];

%%% t-ratios %%%
% Initialising Market Risk Premium Factor, dividing by 100 to express in
% percentage form
ERP = FF_Factors(14:300,2)./100;
% Traditional Momentum Portfolio: Equally Weighted 
tr_ew_pft_1 = tstat(ew_pft_1,ERP,rf);
tr_ew_pft_2 = tstat(ew_pft_2,ERP,rf);
tr_ew_pft_3 = tstat(ew_pft_3,ERP,rf);
tr_ew_pft_4 = tstat(ew_pft_4,ERP,rf);
tr_ew_pft_5 = tstat(ew_pft_5,ERP,rf);
tr_ew_pft_6 = tstat(ew_pft_6,ERP,rf);
tr_ew_pft_7 = tstat(ew_pft_7,ERP,rf);
tr_ew_pft_8 = tstat(ew_pft_8,ERP,rf);
tr_ew_pft_9 = tstat(ew_pft_9,ERP,rf);
tr_ew_pft_10 = tstat(ew_pft_10,ERP,rf);
TR_TM_EW = [tr_ew_pft_1;tr_ew_pft_2;tr_ew_pft_3;tr_ew_pft_4;tr_ew_pft_5;tr_ew_pft_6;tr_ew_pft_7;tr_ew_pft_8;tr_ew_pft_9;tr_ew_pft_10];
% Traditional Momentum Portfolio: Value Weighted
tr_vw_pft_1 = tstat(vw_pft_1,ERP,rf);
tr_vw_pft_2 = tstat(vw_pft_2,ERP,rf);
tr_vw_pft_3 = tstat(vw_pft_3,ERP,rf);
tr_vw_pft_4 = tstat(vw_pft_4,ERP,rf);
tr_vw_pft_5 = tstat(vw_pft_5,ERP,rf);
tr_vw_pft_6 = tstat(vw_pft_6,ERP,rf);
tr_vw_pft_7 = tstat(vw_pft_7,ERP,rf);
tr_vw_pft_8 = tstat(vw_pft_8,ERP,rf);
tr_vw_pft_9 = tstat(vw_pft_9,ERP,rf);
tr_vw_pft_10 = tstat(vw_pft_10,ERP,rf);
TR_TM_VW = [tr_vw_pft_1;tr_vw_pft_2;tr_vw_pft_3;tr_vw_pft_4;tr_vw_pft_5;tr_vw_pft_6;tr_vw_pft_7;tr_vw_pft_8;tr_vw_pft_9;tr_vw_pft_10];
% Skewness Enhanced Momentum Portfolio: Equally Weighted
tr_ew_skpft_1 = tstat(ew_skpft_1,ERP,rf);
tr_ew_skpft_2 = tstat(ew_skpft_2,ERP,rf);
tr_ew_skpft_3 = tstat(ew_skpft_3,ERP,rf);
tr_ew_skpft_4 = tstat(ew_skpft_4,ERP,rf);
tr_ew_skpft_5 = tstat(ew_skpft_5,ERP,rf);
tr_ew_skpft_6 = tstat(ew_skpft_6,ERP,rf);
tr_ew_skpft_7 = tstat(ew_skpft_7,ERP,rf);
tr_ew_skpft_8 = tstat(ew_skpft_8,ERP,rf);
tr_ew_skpft_9 = tstat(ew_skpft_9,ERP,rf);
tr_ew_skpft_10 = tstat(ew_skpft_10,ERP,rf);
TR_SM_EW = [tr_ew_skpft_1;tr_ew_skpft_2;tr_ew_skpft_3;tr_ew_skpft_4;tr_ew_skpft_5;tr_ew_skpft_6;tr_ew_skpft_7;tr_ew_skpft_8;tr_ew_skpft_9;tr_ew_skpft_10];
% Skewness Enhanced Momentum Portfolio: Value Weighted
tr_vw_skpft_1 = tstat(vw_skpft_1,ERP,rf);
tr_vw_skpft_2 = tstat(vw_skpft_2,ERP,rf);
tr_vw_skpft_3 = tstat(vw_skpft_3,ERP,rf);
tr_vw_skpft_4 = tstat(vw_skpft_4,ERP,rf);
tr_vw_skpft_5 = tstat(vw_skpft_5,ERP,rf);
tr_vw_skpft_6 = tstat(vw_skpft_6,ERP,rf);
tr_vw_skpft_7 = tstat(vw_skpft_7,ERP,rf);
tr_vw_skpft_8 = tstat(vw_skpft_8,ERP,rf);
tr_vw_skpft_9 = tstat(vw_skpft_9,ERP,rf);
tr_vw_skpft_10 = tstat(vw_skpft_10,ERP,rf);
TR_SM_VW = [tr_vw_skpft_1;tr_vw_skpft_2;tr_vw_skpft_3;tr_vw_skpft_4;tr_vw_skpft_5;tr_vw_skpft_6;tr_vw_skpft_7;tr_vw_skpft_8;tr_vw_skpft_9;tr_vw_skpft_10];

%%% Max Drawdown %%%
% Traditional Momentum Portfolio: Equally Weighted 
MDD_ew_pft_1 = maxdrawdown(cumprod(ew_pft_1+1));
MDD_ew_pft_2 = maxdrawdown(cumprod(ew_pft_2+1));
MDD_ew_pft_3 = maxdrawdown(cumprod(ew_pft_3+1));
MDD_ew_pft_4 = maxdrawdown(cumprod(ew_pft_4+1));
MDD_ew_pft_5 = maxdrawdown(cumprod(ew_pft_5+1));
MDD_ew_pft_6 = maxdrawdown(cumprod(ew_pft_6+1));
MDD_ew_pft_7 = maxdrawdown(cumprod(ew_pft_7+1));
MDD_ew_pft_8 = maxdrawdown(cumprod(ew_pft_8+1));
MDD_ew_pft_9 = maxdrawdown(cumprod(ew_pft_9+1));
MDD_ew_pft_10 = maxdrawdown(cumprod(ew_pft_10+1));
MDD_TM_EW = [MDD_ew_pft_1;MDD_ew_pft_2;MDD_ew_pft_3;MDD_ew_pft_4;MDD_ew_pft_5;MDD_ew_pft_6;MDD_ew_pft_7;MDD_ew_pft_8;MDD_ew_pft_9;MDD_ew_pft_10];
% Traditional Momentum Portfolio: Value Weighted
MDD_vw_pft_1 = maxdrawdown(cumprod(vw_pft_1+1));
MDD_vw_pft_2 = maxdrawdown(cumprod(vw_pft_2+1));
MDD_vw_pft_3 = maxdrawdown(cumprod(vw_pft_3+1));
MDD_vw_pft_4 = maxdrawdown(cumprod(vw_pft_4+1));
MDD_vw_pft_5 = maxdrawdown(cumprod(vw_pft_5+1));
MDD_vw_pft_6 = maxdrawdown(cumprod(vw_pft_6+1));
MDD_vw_pft_7 = maxdrawdown(cumprod(vw_pft_7+1));
MDD_vw_pft_8 = maxdrawdown(cumprod(vw_pft_8+1));
MDD_vw_pft_9 = maxdrawdown(cumprod(vw_pft_9+1));
MDD_vw_pft_10 = maxdrawdown(cumprod(vw_pft_10+1));
MDD_TM_VW = [MDD_vw_pft_1;MDD_vw_pft_2;MDD_vw_pft_3;MDD_vw_pft_4;MDD_vw_pft_5;MDD_vw_pft_6;MDD_vw_pft_7;MDD_vw_pft_8;MDD_vw_pft_9;MDD_vw_pft_10];
% Skewness Enhanced Momentum Portfolio: Equally Weighted
MDD_ew_skpft_1 = maxdrawdown(cumprod(ew_skpft_1+1));
MDD_ew_skpft_2 = maxdrawdown(cumprod(ew_skpft_2+1));
MDD_ew_skpft_3 = maxdrawdown(cumprod(ew_skpft_3+1));
MDD_ew_skpft_4 = maxdrawdown(cumprod(ew_skpft_4+1));
MDD_ew_skpft_5 = maxdrawdown(cumprod(ew_skpft_5+1));
MDD_ew_skpft_6 = maxdrawdown(cumprod(ew_skpft_6+1));
MDD_ew_skpft_7 = maxdrawdown(cumprod(ew_skpft_7+1));
MDD_ew_skpft_8 = maxdrawdown(cumprod(ew_skpft_8+1));
MDD_ew_skpft_9 = maxdrawdown(cumprod(ew_skpft_9+1));
MDD_ew_skpft_10 = maxdrawdown(cumprod(ew_skpft_10+1));
MDD_SM_EW = [MDD_ew_skpft_1;MDD_ew_skpft_2;MDD_ew_skpft_3;MDD_ew_skpft_4;MDD_ew_skpft_5;MDD_ew_skpft_6;MDD_ew_skpft_7;MDD_ew_skpft_8;MDD_ew_skpft_9;MDD_ew_skpft_10];
% Skewness Enhanced Momentum Portfolio: Value Weighted
MDD_vw_skpft_1 = maxdrawdown(cumprod(vw_skpft_1+1));
MDD_vw_skpft_2 = maxdrawdown(cumprod(vw_skpft_2+1));
MDD_vw_skpft_3 = maxdrawdown(cumprod(vw_skpft_3+1));
MDD_vw_skpft_4 = maxdrawdown(cumprod(vw_skpft_4+1));
MDD_vw_skpft_5 = maxdrawdown(cumprod(vw_skpft_5+1));
MDD_vw_skpft_6 = maxdrawdown(cumprod(vw_skpft_6+1));
MDD_vw_skpft_7 = maxdrawdown(cumprod(vw_skpft_7+1));
MDD_vw_skpft_8 = maxdrawdown(cumprod(vw_skpft_8+1));
MDD_vw_skpft_9 = maxdrawdown(cumprod(vw_skpft_9+1));
MDD_vw_skpft_10 = maxdrawdown(cumprod(vw_skpft_10+1));
MDD_SM_VW = [MDD_vw_skpft_1;MDD_vw_skpft_2;MDD_vw_skpft_3;MDD_vw_skpft_4;MDD_vw_skpft_5;MDD_vw_skpft_6;MDD_vw_skpft_7;MDD_vw_skpft_8;MDD_vw_skpft_9;MDD_vw_skpft_10];

%%% Portfolio Turnover %%%
% Traditional Momentum Portfolio
tm_turnover_1 = turnover(tm_sorted_1,tm_length_1,Win_SK_1,Los_SK_1,'TM');
tm_turnover_2 = turnover(tm_sorted_2,tm_length_2,Win_SK_2,Los_SK_2,'TM');
tm_turnover_3 = turnover(tm_sorted_3,tm_length_3,Win_SK_3,Los_SK_3,'TM');
tm_turnover_4 = turnover(tm_sorted_4,tm_length_4,Win_SK_4,Los_SK_4,'TM');
tm_turnover_5 = turnover(tm_sorted_5,tm_length_5,Win_SK_5,Los_SK_5,'TM');
tm_turnover_6 = turnover(tm_sorted_6,tm_length_6,Win_SK_6,Los_SK_6,'TM');
tm_turnover_7 = turnover(tm_sorted_7,tm_length_7,Win_SK_7,Los_SK_7,'TM');
tm_turnover_8 = turnover(tm_sorted_8,tm_length_8,Win_SK_8,Los_SK_8,'TM');
tm_turnover_9 = turnover(tm_sorted_9,tm_length_9,Win_SK_9,Los_SK_9,'TM');
tm_turnover_10 = turnover(tm_sorted_10,tm_length_10,Win_SK_10,Los_SK_10,'TM');
TM_Turnover = [tm_turnover_1;tm_turnover_2;tm_turnover_3;tm_turnover_4;tm_turnover_5;tm_turnover_6;tm_turnover_7;tm_turnover_8;tm_turnover_9;tm_turnover_10];
% Skewness Enhanced Momentum Portfolio
sm_turnover_1 = turnover(sm_sorted_1,tm_length_1,Win_SK_1,Los_SK_1,'SM');
sm_turnover_2 = turnover(sm_sorted_2,tm_length_2,Win_SK_2,Los_SK_2,'SM');
sm_turnover_3 = turnover(sm_sorted_3,tm_length_3,Win_SK_3,Los_SK_3,'SM');
sm_turnover_4 = turnover(sm_sorted_4,tm_length_4,Win_SK_4,Los_SK_4,'SM');
sm_turnover_5 = turnover(sm_sorted_5,tm_length_5,Win_SK_5,Los_SK_5,'SM');
sm_turnover_6 = turnover(sm_sorted_6,tm_length_6,Win_SK_6,Los_SK_6,'SM');
sm_turnover_7 = turnover(sm_sorted_7,tm_length_7,Win_SK_7,Los_SK_7,'SM');
sm_turnover_8 = turnover(sm_sorted_8,tm_length_8,Win_SK_8,Los_SK_8,'SM');
sm_turnover_9 = turnover(sm_sorted_9,tm_length_9,Win_SK_9,Los_SK_9,'SM');
sm_turnover_10 = turnover(sm_sorted_10,tm_length_10,Win_SK_10,Los_SK_10,'SM');
SM_Turnover = [sm_turnover_1;sm_turnover_2;sm_turnover_3;sm_turnover_4;sm_turnover_5;sm_turnover_6;sm_turnover_7;sm_turnover_8;sm_turnover_9;sm_turnover_10];

%%% Average number of Stocks %%%
% Traditional Momentum Portfolio
avgs_tm_pft_1 = avgstocks(tm_length_1);
avgs_tm_pft_2 = avgstocks(tm_length_2);
avgs_tm_pft_3 = avgstocks(tm_length_3);
avgs_tm_pft_4 = avgstocks(tm_length_4);
avgs_tm_pft_5 = avgstocks(tm_length_5);
avgs_tm_pft_6 = avgstocks(tm_length_6);
avgs_tm_pft_7 = avgstocks(tm_length_7);
avgs_tm_pft_8 = avgstocks(tm_length_8);
avgs_tm_pft_9 = avgstocks(tm_length_9);
avgs_tm_pft_10 = avgstocks(tm_length_10);
Avg_Stks_TM = [avgs_tm_pft_1;avgs_tm_pft_2;avgs_tm_pft_3;avgs_tm_pft_4;avgs_tm_pft_5;avgs_tm_pft_6;avgs_tm_pft_7;avgs_tm_pft_8;avgs_tm_pft_9;avgs_tm_pft_10];
% Skewness Enhanced Momentum Portfolio
avgs_sm_pft_1 = skavgstocks(Win_SK_1,Los_SK_1);
avgs_sm_pft_2 = skavgstocks(Win_SK_2,Los_SK_2);
avgs_sm_pft_3 = skavgstocks(Win_SK_3,Los_SK_3);
avgs_sm_pft_4 = skavgstocks(Win_SK_4,Los_SK_4);
avgs_sm_pft_5 = skavgstocks(Win_SK_5,Los_SK_5);
avgs_sm_pft_6 = skavgstocks(Win_SK_6,Los_SK_6);
avgs_sm_pft_7 = skavgstocks(Win_SK_7,Los_SK_7);
avgs_sm_pft_8 = skavgstocks(Win_SK_8,Los_SK_8);
avgs_sm_pft_9 = skavgstocks(Win_SK_9,Los_SK_9);
avgs_sm_pft_10 = skavgstocks(Win_SK_10,Los_SK_10);
Avg_Stks_SM = [avgs_sm_pft_1;avgs_sm_pft_2;avgs_sm_pft_3;avgs_sm_pft_4;avgs_sm_pft_5;avgs_sm_pft_6;avgs_sm_pft_7;avgs_sm_pft_8;avgs_sm_pft_9;avgs_sm_pft_10];

%%% Table of Data %%%
Portfolio = {'1';'2';'3';'4';'5';'6';'7';'8';'9';'10'};
T = table(Ret_TM_EW,Ret_TM_VW,Ret_SM_EW,Ret_SM_VW,Vol_TM_EW,Vol_TM_VW,Vol_SM_EW,Vol_SM_VW,SR_TM_EW,SR_TM_VW,SR_SM_EW,SR_SM_VW,TR_TM_EW,TR_TM_VW,TR_SM_EW,TR_SM_VW,MDD_TM_EW,MDD_TM_VW,MDD_SM_EW,MDD_SM_VW,TM_Turnover,SM_Turnover,Avg_Stks_TM,Avg_Stks_SM,'RowNames',Portfolio);
disp(T)
writetable(T,'Summary Statistics.xls');

%%% Plot of Evloving Sharpe Ratios %%%
figure 
% Without size effect
subplot(3,1,1)
plot(mdates,sr_ew_pft_1,mdates,sr_vw_pft_1,mdates,sr_ew_skpft_1,mdates,sr_vw_skpft_1);
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest');
title('Comparative Plot of Evolving Sharpe Ratios: No Size Effect');
xlabel('Years')
ylabel('Sharpe Ratio')
% Small size effect
subplot(3,1,2)
plot(mdates,sr_ew_pft_2,mdates,sr_vw_pft_2,mdates,sr_ew_skpft_2,mdates,sr_vw_skpft_2);
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest')
title('Comparative Plot of Evolving Sharpe Ratios: Small Size Effect');
xlabel('Years')
ylabel('Sharpe Ratio')
% Large size effect
subplot(3,1,3)
plot(mdates,sr_ew_pft_5,mdates,sr_vw_pft_5,mdates,sr_ew_skpft_5,mdates,sr_vw_skpft_5);
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest')
title('Comparative Plot of Evolving Sharpe Ratios: Large Size Effect');
xlabel('Years')
ylabel('Sharpe Ratio')

%%% Plot of Cumulative Returns %%%
figure
% Without size effect
subplot(3,1,1)
plot(mdates,cumprod(ew_pft_1+1),mdates,cumprod(vw_pft_1+1),mdates,cumprod(ew_skpft_1+1),mdates,cumprod(vw_skpft_1+1));
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest');
title('Comparative Plot of Cumulative Returns: No Size Effect');
xlabel('Years')
ylabel('Returns')
ylim([0 30])
% Small size effect
subplot(3,1,2)
plot(mdates,cumprod(ew_pft_2+1),mdates,cumprod(vw_pft_2+1),mdates,cumprod(ew_skpft_2+1),mdates,cumprod(vw_skpft_2+1));
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest')
title('Comparative Plot of Cumulative Returns: Small Size Effect')
xlabel('Years')
ylabel('Returns')
ylim([0 25])
% Large size effect
subplot(3,1,3)
plot(mdates,cumprod(ew_pft_6+1),mdates,cumprod(vw_pft_6+1),mdates,cumprod(ew_skpft_6+1),mdates,cumprod(vw_skpft_6+1));
legend('Momentum: Equally Weighted','Momentum: Value Weighted','Skewness: Equally Weighted','Skewness: Value Weighted','Location','northwest')
title('Comparative Plot of Cumulative Returns: Large Size Effect')
xlabel('Years')
ylabel('Returns')
ylim([0 25])

%% Carhart Four-Factor Model Regression
% Initialising SMB and HML factors
% 4 factors: ERP, SMB, HML, FFm
% Dependent Variable: Portfolio Excess Returns
SMB = FF_Factors(14:300,3)./100;
HML = FF_Factors(14:300,4)./100;

% Traditional Momentum Portfolio: Equally Weighted
ffm_ew_pft_1 = Carhart4FM(ew_pft_1,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_2 = Carhart4FM(ew_pft_2,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_3 = Carhart4FM(ew_pft_3,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_4 = Carhart4FM(ew_pft_4,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_5 = Carhart4FM(ew_pft_5,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_6 = Carhart4FM(ew_pft_6,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_7 = Carhart4FM(ew_pft_7,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_8 = Carhart4FM(ew_pft_8,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_9 = Carhart4FM(ew_pft_9,ERP,SMB,HML,FFm,rf);
ffm_ew_pft_10 = Carhart4FM(ew_pft_10,ERP,SMB,HML,FFm,rf);
% Traditional Momentum Portfolio: Value Weighted
ffm_vw_pft_1 = Carhart4FM(vw_pft_1,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_2 = Carhart4FM(vw_pft_2,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_3 = Carhart4FM(vw_pft_3,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_4 = Carhart4FM(vw_pft_4,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_5 = Carhart4FM(vw_pft_5,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_6 = Carhart4FM(vw_pft_6,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_7 = Carhart4FM(vw_pft_7,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_8 = Carhart4FM(vw_pft_8,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_9 = Carhart4FM(vw_pft_9,ERP,SMB,HML,FFm,rf);
ffm_vw_pft_10 = Carhart4FM(vw_pft_10,ERP,SMB,HML,FFm,rf);
% Skewness Enhanced Momentum Portfolio: Equally Weighted
ffm_ew_skpft_1 = Carhart4FM(ew_skpft_1,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_2 = Carhart4FM(ew_skpft_2,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_3 = Carhart4FM(ew_skpft_3,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_4 = Carhart4FM(ew_skpft_4,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_5 = Carhart4FM(ew_skpft_5,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_6 = Carhart4FM(ew_skpft_6,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_7 = Carhart4FM(ew_skpft_7,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_8 = Carhart4FM(ew_skpft_8,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_9 = Carhart4FM(ew_skpft_9,ERP,SMB,HML,FFm,rf);
ffm_ew_skpft_10 = Carhart4FM(ew_skpft_10,ERP,SMB,HML,FFm,rf);
% Skewness Enhanced Momentum Portfolio: Value Weighted
ffm_vw_skpft_1 = Carhart4FM(vw_skpft_1,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_2 = Carhart4FM(vw_skpft_2,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_3 = Carhart4FM(vw_skpft_3,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_4 = Carhart4FM(vw_skpft_4,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_5 = Carhart4FM(vw_skpft_5,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_6 = Carhart4FM(vw_skpft_6,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_7 = Carhart4FM(vw_skpft_7,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_8 = Carhart4FM(vw_skpft_8,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_9 = Carhart4FM(vw_skpft_9,ERP,SMB,HML,FFm,rf);
ffm_vw_skpft_10 = Carhart4FM(vw_skpft_10,ERP,SMB,HML,FFm,rf);


writetable(ffm_ew_pft_1,'Summary Statistics.xls','Sheet',2,'Range','A1');
writetable(ffm_ew_pft_2,'Summary Statistics.xls','Sheet',2,'Range','A8');
writetable(ffm_ew_pft_3,'Summary Statistics.xls','Sheet',2,'Range','A15');
writetable(ffm_ew_pft_4,'Summary Statistics.xls','Sheet',2,'Range','A22');
writetable(ffm_ew_pft_5,'Summary Statistics.xls','Sheet',2,'Range','A29');
writetable(ffm_ew_pft_6,'Summary Statistics.xls','Sheet',2,'Range','A36');
writetable(ffm_ew_pft_7,'Summary Statistics.xls','Sheet',2,'Range','A43');
writetable(ffm_ew_pft_8,'Summary Statistics.xls','Sheet',2,'Range','A50');
writetable(ffm_ew_pft_9,'Summary Statistics.xls','Sheet',2,'Range','A57');
writetable(ffm_ew_pft_10,'Summary Statistics.xls','Sheet',2,'Range','A63');

writetable(ffm_vw_pft_1,'Summary Statistics.xls','Sheet',2,'Range','F1');
writetable(ffm_vw_pft_2,'Summary Statistics.xls','Sheet',2,'Range','F8');
writetable(ffm_vw_pft_3,'Summary Statistics.xls','Sheet',2,'Range','F15');
writetable(ffm_vw_pft_4,'Summary Statistics.xls','Sheet',2,'Range','F22');
writetable(ffm_vw_pft_5,'Summary Statistics.xls','Sheet',2,'Range','F29');
writetable(ffm_vw_pft_6,'Summary Statistics.xls','Sheet',2,'Range','F36');
writetable(ffm_vw_pft_7,'Summary Statistics.xls','Sheet',2,'Range','F43');
writetable(ffm_vw_pft_8,'Summary Statistics.xls','Sheet',2,'Range','F50');
writetable(ffm_vw_pft_9,'Summary Statistics.xls','Sheet',2,'Range','F57');
writetable(ffm_vw_pft_10,'Summary Statistics.xls','Sheet',2,'Range','F63');

writetable(ffm_ew_skpft_1,'Summary Statistics.xls','Sheet',2,'Range','K1');
writetable(ffm_ew_skpft_2,'Summary Statistics.xls','Sheet',2,'Range','K8');
writetable(ffm_ew_skpft_3,'Summary Statistics.xls','Sheet',2,'Range','K15');
writetable(ffm_ew_skpft_4,'Summary Statistics.xls','Sheet',2,'Range','K22');
writetable(ffm_ew_skpft_5,'Summary Statistics.xls','Sheet',2,'Range','K29');
writetable(ffm_ew_skpft_6,'Summary Statistics.xls','Sheet',2,'Range','K36');
writetable(ffm_ew_skpft_7,'Summary Statistics.xls','Sheet',2,'Range','K43');
writetable(ffm_ew_skpft_8,'Summary Statistics.xls','Sheet',2,'Range','K50');
writetable(ffm_ew_skpft_9,'Summary Statistics.xls','Sheet',2,'Range','K57');
writetable(ffm_ew_skpft_10,'Summary Statistics.xls','Sheet',2,'Range','K63');

writetable(ffm_vw_skpft_1,'Summary Statistics.xls','Sheet',2,'Range','P1');
writetable(ffm_vw_skpft_2,'Summary Statistics.xls','Sheet',2,'Range','P8');
writetable(ffm_vw_skpft_3,'Summary Statistics.xls','Sheet',2,'Range','P15');
writetable(ffm_vw_skpft_4,'Summary Statistics.xls','Sheet',2,'Range','P22');
writetable(ffm_vw_skpft_5,'Summary Statistics.xls','Sheet',2,'Range','P29');
writetable(ffm_vw_skpft_6,'Summary Statistics.xls','Sheet',2,'Range','P36');
writetable(ffm_vw_skpft_7,'Summary Statistics.xls','Sheet',2,'Range','P43');
writetable(ffm_vw_skpft_8,'Summary Statistics.xls','Sheet',2,'Range','P50');
writetable(ffm_vw_skpft_9,'Summary Statistics.xls','Sheet',2,'Range','P57');
writetable(ffm_vw_skpft_10,'Summary Statistics.xls','Sheet',2,'Range','P63');


%% All Plots 
plot(mdates,cumprod(ew_pft_1+1),mdates,cumprod(ew_pft_2+1),mdates,cumprod(ew_pft_3+1),mdates,cumprod(ew_pft_4+1),mdates,cumprod(ew_pft_5+1),mdates,cumprod(ew_pft_6+1),mdates,cumprod(ew_pft_7+1),mdates,cumprod(ew_pft_8+1),mdates,cumprod(ew_pft_9+1),mdates,cumprod(ew_pft_10+1));
legend('Port. 1','Port. 2','Port. 3','Port. 4','Port. 5','Port. 6','Port. 7','Port. 8','Port. 9','Port. 10','location','northwest');
title('Traditional Momentum: Equally Weighted');
xlabel('Years')
ylabel('Returns')

plot(mdates,cumprod(vw_pft_1+1),mdates,cumprod(vw_pft_2+1),mdates,cumprod(vw_pft_3+1),mdates,cumprod(vw_pft_4+1),mdates,cumprod(vw_pft_5+1),mdates,cumprod(vw_pft_6+1),mdates,cumprod(vw_pft_7+1),mdates,cumprod(vw_pft_8+1),mdates,cumprod(vw_pft_9+1),mdates,cumprod(vw_pft_10+1));
legend('Port. 1','Port. 2','Port. 3','Port. 4','Port. 5','Port. 6','Port. 7','Port. 8','Port. 9','Port. 10','location','northwest');
title('Traditional Momentum: Value Weighted');
xlabel('Years')
ylabel('Returns')
ylim([0 15])

plot(mdates,cumprod(ew_skpft_1+1),mdates,cumprod(ew_skpft_2+1),mdates,cumprod(ew_skpft_3+1),mdates,cumprod(ew_skpft_4+1),mdates,cumprod(ew_skpft_5+1),mdates,cumprod(ew_skpft_6+1),mdates,cumprod(ew_skpft_7+1),mdates,cumprod(ew_skpft_8+1),mdates,cumprod(ew_skpft_9+1),mdates,cumprod(ew_skpft_10+1));
legend('Port. 1','Port. 2','Port. 3','Port. 4','Port. 5','Port. 6','Port. 7','Port. 8','Port. 9','Port. 10','location','northwest');
title('Skewness Enhanced Momentum: Equally Weighted');
xlabel('Years')
ylabel('Returns')

plot(mdates,cumprod(vw_skpft_1+1),mdates,cumprod(vw_skpft_2+1),mdates,cumprod(vw_skpft_3+1),mdates,cumprod(vw_skpft_4+1),mdates,cumprod(vw_skpft_5+1),mdates,cumprod(vw_skpft_6+1),mdates,cumprod(vw_skpft_7+1),mdates,cumprod(vw_skpft_8+1),mdates,cumprod(vw_skpft_9+1),mdates,cumprod(vw_skpft_10+1));
legend('Port. 1','Port. 2','Port. 3','Port. 4','Port. 5','Port. 6','Port. 7','Port. 8','Port. 9','Port. 10','location','northwest');
title('Skewness Enhanced Momentum: Value Weighted');
xlabel('Years')
ylabel('Returns')
ylim([0 25])



