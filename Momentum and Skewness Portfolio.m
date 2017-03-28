%% Reshaping and preparing initial dataset
load('assignment2016.mat');
% Only taking daily returns data from the dataset
dailypermno = reshape(data(:,1),[6306,16150]);
dailydates = reshape(data(:,2),[6306,16150]);
dailymarketcap = reshape(data(:,3),[6306,16150]);
dailyret = reshape(data(:,4),[6306,16150]);
dates = unique(dailydates);

% Converting daily returns to monthly returns
% Monthly returns estimated by taking the sum of daily log returns
fts = fints(dates,dailyret, '', 'd');
mretfts = tomonthly(fts, 'CalcMethod', 'CumSum');
monret = fts2mat(mretfts);
% Converting log returns to simple returns
simmonret = exp(monret) - 1;
% Converting daily market cap to monthly market cap
% Monthly market cap estimated by taking the simple average over the month
MCfts = fints(dates,dailymarketcap, '', 'd');
mmcfts = tomonthly(MCfts, 'CalcMethod', 'SimpAvg');
monmc = fts2mat(mmcfts);

% Multiplying ME Breakpoints dataset by 1 million for appropriate
% comparison with sample data
MEbp = MEBreakpoints * 1000000;
% ME breakpoints over the data sample period
ME = MEbp(770:1069,:);

% Dividing FF factors by 100 because already expressed in percentages
FFf = FFMomentumFactor(:,2) / 100;
% FF momentum factors over the data sample period
FF = FFf(757:1056,:);

%% Size Effect Portfolios
% Determining the stocks that below the ME breakpoint for respective
% deciles from the 10% up to 100%
% S1; Portfolio with stocks that are larger than bottom decile (10%)
% S10; Portfolio with stocks larger than top decile (100%)
% ignoring first 13 rows due to formation period
monmcs = monmc(14:300,:);
S1 = monmcs > repmat(ME(14:300,4),1,16150);
S2 = monmcs > repmat(ME(14:300,6),1,16150);
S3 = monmcs > repmat(ME(14:300,8),1,16150);
S4 = monmcs > repmat(ME(14:300,10),1,16150);
S5 = monmcs > repmat(ME(14:300,12),1,16150);
S6 = monmcs > repmat(ME(14:300,14),1,16150);
S7 = monmcs > repmat(ME(14:300,16),1,16150);
S8 = monmcs > repmat(ME(14:300,18),1,16150);
S9 = monmcs > repmat(ME(14:300,20),1,16150);
S10 = monmcs > repmat(ME(14:300,22),1,16150);

%% Traditional Momentum Portfolio Construction
% 20 portfolios, accounting for size effect, 10 equal, 10 value weighted

% Calculating 12-month cumulative return and ignoring 13th month return
k = movsum(monret,[11,0],1,'omitnan');
cmpdret = k(12:298,:);
% Cutting corresponding 287 month sample period from simple monthly returns
spmonret = simmonret(14:300,:);

%%%% Portfolio construction
% Applying size constraint filter
TMPS1cumret = S1.*cmpdret; 
TMPS2cumret = S2.*cmpdret;
TMPS3cumret = S3.*cmpdret;
TMPS4cumret = S4.*cmpdret;
TMPS5cumret = S5.*cmpdret;  
TMPS6cumret = S6.*cmpdret;
TMPS7cumret = S7.*cmpdret;
TMPS8cumret = S8.*cmpdret;
TMPS9cumret = S9.*cmpdret;
TMPS10cumret = S10.*cmpdret;

% Sorting filtered cumulative returns
[sortedTMPS1cumret, IS1] = sort(TMPS1cumret,2,'descend'); 
[sortedTMPS2cumret, IS2] = sort(TMPS2cumret,2,'descend');
[sortedTMPS3cumret, IS3] = sort(TMPS3cumret,2,'descend');
[sortedTMPS4cumret, IS4] = sort(TMPS4cumret,2,'descend');
[sortedTMPS5cumret, IS5] = sort(TMPS5cumret,2,'descend');
[sortedTMPS6cumret, IS6] = sort(TMPS6cumret,2,'descend');
[sortedTMPS7cumret, IS7] = sort(TMPS7cumret,2,'descend');
[sortedTMPS8cumret, IS8] = sort(TMPS8cumret,2,'descend');
[sortedTMPS9cumret, IS9] = sort(TMPS9cumret,2,'descend');
[sortedTMPS10cumret, IS10] = sort(TMPS10cumret,2,'descend');

% Loop to resort mon ret according to cum ret to get working ret set
for r = 1:size(cmpdret,1) 
   wspmonretS1(r,:) = spmonret(r,IS1(r,:));
   wspmonretS2(r,:) = spmonret(r,IS2(r,:));
   wspmonretS3(r,:) = spmonret(r,IS3(r,:));
   wspmonretS4(r,:) = spmonret(r,IS4(r,:));
   wspmonretS5(r,:) = spmonret(r,IS5(r,:));
   wspmonretS6(r,:) = spmonret(r,IS6(r,:));
   wspmonretS7(r,:) = spmonret(r,IS7(r,:));
   wspmonretS8(r,:) = spmonret(r,IS8(r,:));
   wspmonretS9(r,:) = spmonret(r,IS9(r,:));
   wspmonretS10(r,:) = spmonret(r,IS10(r,:));
end

% Winner and Loser simple mon rets deciles for respective size effects
WinTMPS1 = wspmonretS1(:,1:1615); % top decile
LosTMPS1 = wspmonretS1(:,14536:16150); % bottom decile
WinTMPS2 = wspmonretS2(:,1:1615);
LosTMPS2 = wspmonretS2(:,14536:16150);
WinTMPS3 = wspmonretS3(:,1:1615);
LosTMPS3 = wspmonretS3(:,14536:16150);
WinTMPS4 = wspmonretS4(:,1:1615);
LosTMPS4 = wspmonretS4(:,14536:16150);
WinTMPS5 = wspmonretS5(:,1:1615);
LosTMPS5 = wspmonretS5(:,14536:16150);
WinTMPS6 = wspmonretS6(:,1:1615);
LosTMPS6 = wspmonretS6(:,14536:16150);
WinTMPS7 = wspmonretS7(:,1:1615);
LosTMPS7 = wspmonretS7(:,14536:16150);
WinTMPS8 = wspmonretS8(:,1:1615);
LosTMPS8 = wspmonretS8(:,14536:16150);
WinTMPS9 = wspmonretS9(:,1:1615);
LosTMPS9 = wspmonretS9(:,14536:16150);
WinTMPS10 = wspmonretS10(:,1:1615);
LosTMPS10 = wspmonretS10(:,14536:16150);

%%% Equally Weighted
% Sort size effects to compute number of long and short securities each
% period
for r = 1:size(cmpdret,1) 
   mpewS1(r,:) = S1(r,IS1(r,:));
   mpewS2(r,:) = S2(r,IS2(r,:));
   mpewS3(r,:) = S3(r,IS3(r,:));
   mpewS4(r,:) = S4(r,IS4(r,:));
   mpewS5(r,:) = S5(r,IS5(r,:));
   mpewS6(r,:) = S6(r,IS6(r,:));
   mpewS7(r,:) = S7(r,IS7(r,:));
   mpewS8(r,:) = S8(r,IS8(r,:));
   mpewS9(r,:) = S9(r,IS9(r,:));
   mpewS10(r,:) = S10(r,IS10(r,:));
end

% Calculating no. of securities for each period in Win & Los portfolios
ewWinTMPS1 = mpewS1(:,1:1615); % top decile
ewLosTMPS1 = mpewS1(:,14536:16150); % bottom decile
ewWinTMPS2 = mpewS2(:,1:1615);
ewLosTMPS2 = mpewS2(:,14536:16150);
ewWinTMPS3 = mpewS3(:,1:1615);
ewLosTMPS3 = mpewS3(:,14536:16150);
ewWinTMPS4 = mpewS4(:,1:1615);
ewLosTMPS4 = mpewS4(:,14536:16150);
ewWinTMPS5 = mpewS5(:,1:1615);
ewLosTMPS5 = mpewS5(:,14536:16150);
ewWinTMPS6 = mpewS6(:,1:1615);
ewLosTMPS6 = mpewS6(:,14536:16150);
ewWinTMPS7 = mpewS7(:,1:1615);
ewLosTMPS7 = mpewS7(:,14536:16150);
ewWinTMPS8 = mpewS8(:,1:1615);
ewLosTMPS8 = mpewS8(:,14536:16150);
ewWinTMPS9 = mpewS9(:,1:1615);
ewLosTMPS9 = mpewS9(:,14536:16150);
ewWinTMPS10 = mpewS10(:,1:1615);
ewLosTMPS10 = mpewS10(:,14536:16150);

% Knocking out returns for securities that are filtered out
ewfWinS1 = ewWinTMPS1.*WinTMPS1;
ewfLosS1 = ewLosTMPS1.*LosTMPS1;
ewfWinS2 = ewWinTMPS2.*WinTMPS2;
ewfLosS2 = ewLosTMPS2.*LosTMPS2;
ewfWinS3 = ewWinTMPS3.*WinTMPS3;
ewfLosS3 = ewLosTMPS3.*LosTMPS3;
ewfWinS4 = ewWinTMPS4.*WinTMPS4;
ewfLosS4 = ewLosTMPS4.*LosTMPS4;
ewfWinS5 = ewWinTMPS5.*WinTMPS5;
ewfLosS5 = ewLosTMPS5.*LosTMPS5;
ewfWinS6 = ewWinTMPS6.*WinTMPS6;
ewfLosS6 = ewLosTMPS6.*LosTMPS6;
ewfWinS7 = ewWinTMPS7.*WinTMPS7;
ewfLosS7 = ewLosTMPS7.*LosTMPS7;
ewfWinS8 = ewWinTMPS8.*WinTMPS8;
ewfLosS8 = ewLosTMPS8.*LosTMPS8;
ewfWinS9 = ewWinTMPS9.*WinTMPS9;
ewfLosS9 = ewLosTMPS9.*LosTMPS9;
ewfWinS10 = ewWinTMPS10.*WinTMPS10;
ewfLosS10 = ewLosTMPS10.*LosTMPS10;

% Computing Returns for Equally weights Momentum Portfolio
% Note here that the S10 portfolio throws a funny result because there
% exist very little stocks that are above the 100% ME breakpoint
ewTMPS1 = sum(ewfWinS1,2)./sum(ewfWinS1~=0,2) - sum(ewfLosS1,2)./sum(ewfLosS1~=0,2); % '-' because short losers
ewTMPS2 = sum(ewfWinS2,2)./sum(ewfWinS2~=0,2) - sum(ewfLosS2,2)./sum(ewfLosS2~=0,2);
ewTMPS3 = sum(ewfWinS3,2)./sum(ewfWinS3~=0,2) - sum(ewfLosS3,2)./sum(ewfLosS3~=0,2);
ewTMPS4 = sum(ewfWinS4,2)./sum(ewfWinS4~=0,2) - sum(ewfLosS4,2)./sum(ewfLosS4~=0,2);
ewTMPS5 = sum(ewfWinS5,2)./sum(ewfWinS5~=0,2) - sum(ewfLosS5,2)./sum(ewfLosS5~=0,2);
ewTMPS6 = sum(ewfWinS6,2)./sum(ewfWinS6~=0,2) - sum(ewfLosS6,2)./sum(ewfLosS6~=0,2);
ewTMPS7 = sum(ewfWinS7,2)./sum(ewfWinS7~=0,2) - sum(ewfLosS7,2)./sum(ewfLosS7~=0,2);
ewTMPS8 = sum(ewfWinS8,2)./sum(ewfWinS8~=0,2) - sum(ewfLosS8,2)./sum(ewfLosS8~=0,2);
ewTMPS9 = sum(ewfWinS9,2)./sum(ewfWinS9~=0,2) - sum(ewfLosS9,2)./sum(ewfLosS9~=0,2);
ewTMPS10 = sum(ewfWinS10,2)./sum(ewfWinS10~=0,2) - sum(ewfLosS10,2)./sum(ewfLosS10~=0,2);

plot(ewTMPS10);
plot(cumprod(ewTMPS10+1));

%%% Value Weighted
% Applying size constraint for the market capitalization
TMPS1mc = S1.*monmcs;
TMPS2mc = S2.*monmcs;
TMPS3mc = S3.*monmcs;
TMPS4mc = S4.*monmcs;
TMPS5mc = S5.*monmcs;
TMPS6mc = S6.*monmcs;
TMPS7mc = S7.*monmcs;
TMPS8mc = S8.*monmcs;
TMPS9mc = S9.*monmcs;
TMPS10mc = S10.*monmcs;

for r = 1:size(cmpdret,1)
   sortTMPS1mc(r,:) = TMPS1mc(r,IS1(r,:));
   sortTMPS2mc(r,:) = TMPS2mc(r,IS2(r,:));
   sortTMPS3mc(r,:) = TMPS3mc(r,IS3(r,:));
   sortTMPS4mc(r,:) = TMPS4mc(r,IS4(r,:));
   sortTMPS5mc(r,:) = TMPS5mc(r,IS5(r,:));
   sortTMPS6mc(r,:) = TMPS6mc(r,IS6(r,:));
   sortTMPS7mc(r,:) = TMPS7mc(r,IS7(r,:));
   sortTMPS8mc(r,:) = TMPS8mc(r,IS8(r,:));
   sortTMPS9mc(r,:) = TMPS9mc(r,IS9(r,:));
   sortTMPS10mc(r,:) = TMPS10mc(r,IS10(r,:));
end

% calculating respective weights 
WinTMPS1vw = sortTMPS1mc(:,1:1615); % top decile market caps
LosTMPS1vw = sortTMPS1mc(:,14536:16150); % btm decile market caps
WinTMPS1wgt = WinTMPS1vw./repmat(sum(WinTMPS1vw,2,'omitnan'),1,1615); % respective top decile weights
LosTMPS1wgt = LosTMPS1vw./repmat(sum(LosTMPS1vw,2,'omitnan'),1,1615); % respective btm decile weights

WinTMPS2vw = sortTMPS2mc(:,1:1615); 
LosTMPS2vw = sortTMPS2mc(:,14536:16150); 
WinTMPS2wgt = WinTMPS2vw./repmat(sum(WinTMPS2vw,2,'omitnan'),1,1615); 
LosTMPS2wgt = LosTMPS2vw./repmat(sum(LosTMPS2vw,2,'omitnan'),1,1615); 

WinTMPS3vw = sortTMPS3mc(:,1:1615); 
LosTMPS3vw = sortTMPS3mc(:,14536:16150); 
WinTMPS3wgt = WinTMPS3vw./repmat(sum(WinTMPS3vw,2,'omitnan'),1,1615); 
LosTMPS3wgt = LosTMPS3vw./repmat(sum(LosTMPS3vw,2,'omitnan'),1,1615); 

WinTMPS4vw = sortTMPS4mc(:,1:1615); 
LosTMPS4vw = sortTMPS4mc(:,14536:16150); 
WinTMPS4wgt = WinTMPS4vw./repmat(sum(WinTMPS4vw,2,'omitnan'),1,1615); 
LosTMPS4wgt = LosTMPS4vw./repmat(sum(LosTMPS4vw,2,'omitnan'),1,1615); 

WinTMPS5vw = sortTMPS5mc(:,1:1615); 
LosTMPS5vw = sortTMPS5mc(:,14536:16150); 
WinTMPS5wgt = WinTMPS5vw./repmat(sum(WinTMPS5vw,2,'omitnan'),1,1615); 
LosTMPS5wgt = LosTMPS5vw./repmat(sum(LosTMPS5vw,2,'omitnan'),1,1615); 

WinTMPS6vw = sortTMPS6mc(:,1:1615); 
LosTMPS6vw = sortTMPS6mc(:,14536:16150); 
WinTMPS6wgt = WinTMPS6vw./repmat(sum(WinTMPS6vw,2,'omitnan'),1,1615); 
LosTMPS6wgt = LosTMPS6vw./repmat(sum(LosTMPS6vw,2,'omitnan'),1,1615); 

WinTMPS7vw = sortTMPS7mc(:,1:1615); 
LosTMPS7vw = sortTMPS7mc(:,14536:16150); 
WinTMPS7wgt = WinTMPS7vw./repmat(sum(WinTMPS7vw,2,'omitnan'),1,1615); 
LosTMPS7wgt = LosTMPS7vw./repmat(sum(LosTMPS7vw,2,'omitnan'),1,1615); 

WinTMPS8vw = sortTMPS8mc(:,1:1615); 
LosTMPS8vw = sortTMPS8mc(:,14536:16150); 
WinTMPS8wgt = WinTMPS8vw./repmat(sum(WinTMPS8vw,2,'omitnan'),1,1615); 
LosTMPS8wgt = LosTMPS8vw./repmat(sum(LosTMPS8vw,2,'omitnan'),1,1615); 

WinTMPS9vw = sortTMPS9mc(:,1:1615); 
LosTMPS9vw = sortTMPS9mc(:,14536:16150); 
WinTMPS9wgt = WinTMPS9vw./repmat(sum(WinTMPS9vw,2,'omitnan'),1,1615); 
LosTMPS9wgt = LosTMPS9vw./repmat(sum(LosTMPS9vw,2,'omitnan'),1,1615); 

WinTMPS10vw = sortTMPS10mc(:,1:1615);
LosTMPS10vw = sortTMPS10mc(:,14536:16150); 
WinTMPS10wgt = WinTMPS10vw./repmat(sum(WinTMPS10vw,2,'omitnan'),1,1615); 
LosTMPS10wgt = LosTMPS10vw./repmat(sum(LosTMPS10vw,2,'omitnan'),1,1615);

% Value weighted Portfolio Returns
vwTMPS1 = sum(WinTMPS1wgt.*WinTMPS1,2,'omitnan') - sum(LosTMPS1wgt.*LosTMPS1,2,'omitnan');
vwTMPS2 = sum(WinTMPS2wgt.*WinTMPS2,2,'omitnan') - sum(LosTMPS2wgt.*LosTMPS2,2,'omitnan');
vwTMPS3 = sum(WinTMPS3wgt.*WinTMPS3,2,'omitnan') - sum(LosTMPS3wgt.*LosTMPS3,2,'omitnan');
vwTMPS4 = sum(WinTMPS4wgt.*WinTMPS4,2,'omitnan') - sum(LosTMPS4wgt.*LosTMPS4,2,'omitnan');
vwTMPS5 = sum(WinTMPS5wgt.*WinTMPS5,2,'omitnan') - sum(LosTMPS5wgt.*LosTMPS5,2,'omitnan');
vwTMPS6 = sum(WinTMPS6wgt.*WinTMPS6,2,'omitnan') - sum(LosTMPS6wgt.*LosTMPS6,2,'omitnan');
vwTMPS7 = sum(WinTMPS7wgt.*WinTMPS7,2,'omitnan') - sum(LosTMPS7wgt.*LosTMPS7,2,'omitnan');
vwTMPS8 = sum(WinTMPS8wgt.*WinTMPS8,2,'omitnan') - sum(LosTMPS8wgt.*LosTMPS8,2,'omitnan');
vwTMPS9 = sum(WinTMPS9wgt.*WinTMPS9,2,'omitnan') - sum(LosTMPS9wgt.*LosTMPS9,2,'omitnan');
vwTMPS10 = sum(WinTMPS10wgt.*WinTMPS10,2,'omitnan') - sum(LosTMPS10wgt.*LosTMPS10,2,'omitnan');

%{
double

plot(vwTMPS9)

plot(cumprod(vwTMPS1+1));

location = find(~isnan(monmcs) & monmcs > repmat(ME(14:300,4),1,16150));
[~,index] = sort(cmpdret,2,'descend');
sorted_index = intersect(index,location,'stable');
%}

%% Skewness-Enhanced Momentum Construction

% Calculating the Skew Max Variable over the entire sample period
dateind = month(dates);
skewmax = [];
cmpdret = dailyret(2,:);

for i = 2:6305
    if dateind(i,1) == dateind(i+1,1)
        cmpdret = nanmax(cmpdret,dailyret(i+1,:));
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

% Applying size constraint filter
SMS1 = S1.*spskewmax;
SMS2 = S2.*spskewmax;
SMS3 = S3.*spskewmax;
SMS4 = S4.*spskewmax;
SMS5 = S5.*spskewmax;
SMS6 = S6.*spskewmax;
SMS7 = S7.*spskewmax;
SMS8 = S8.*spskewmax;
SMS9 = S9.*spskewmax;
SMS10 = S10.*spskewmax;

% Sorting Skewness measures for filtered securities
[srtSMS1, SIS1] = sort(SMS1,2,'ascend');
[srtSMS2, SIS2] = sort(SMS2,2,'ascend');
[srtSMS3, SIS3] = sort(SMS3,2,'ascend');
[srtSMS4, SIS4] = sort(SMS4,2,'ascend');
[srtSMS5, SIS5] = sort(SMS5,2,'ascend');
[srtSMS6, SIS6] = sort(SMS6,2,'ascend');
[srtSMS7, SIS7] = sort(SMS7,2,'ascend');
[srtSMS8, SIS8] = sort(SMS8,2,'ascend');
[srtSMS9, SIS9] = sort(SMS9,2,'ascend');
[srtSMS10, SIS10] = sort(SMS10,2,'ascend');

% Identifying the PermNo. for respective portfolios
% Initializing PermNo. matrix over the working sample period
wsppermno = dailypermno(1:287,:);

% Applying filter for size constraint on PermNo.
pnSMS1 = S1.*wsppermno;
pnSMS2 = S2.*wsppermno;
pnSMS3 = S3.*wsppermno;
pnSMS4 = S4.*wsppermno;
pnSMS5 = S5.*wsppermno;
pnSMS6 = S6.*wsppermno;
pnSMS7 = S7.*wsppermno;
pnSMS8 = S8.*wsppermno;
pnSMS9 = S9.*wsppermno;
pnSMS10 = S10.*wsppermno;

% Sorting PermNo. according to sorted Skew Max index and Momentum index
for r = 1:size(wsppermno,1)
   % Perm No. for Skew Max Index
   pnSMS1(r,:) = pnSMS1(r,SIS1(r,:));
   pnSMS2(r,:) = pnSMS2(r,SIS2(r,:));
   pnSMS3(r,:) = pnSMS3(r,SIS3(r,:));
   pnSMS4(r,:) = pnSMS4(r,SIS4(r,:));
   pnSMS5(r,:) = pnSMS5(r,SIS5(r,:));
   pnSMS6(r,:) = pnSMS6(r,SIS6(r,:));
   pnSMS7(r,:) = pnSMS7(r,SIS7(r,:));
   pnSMS8(r,:) = pnSMS8(r,SIS8(r,:));
   pnSMS9(r,:) = pnSMS9(r,SIS9(r,:));
   pnSMS10(r,:) = pnSMS10(r,SIS10(r,:));
   % Perm No. for Momentum Index
   pnMS1(r,:) = pnSMS1(r,IS1(r,:));
   pnMS2(r,:) = pnSMS2(r,IS2(r,:));
   pnMS3(r,:) = pnSMS3(r,IS3(r,:));
   pnMS4(r,:) = pnSMS4(r,IS4(r,:));
   pnMS5(r,:) = pnSMS5(r,IS5(r,:));
   pnMS6(r,:) = pnSMS6(r,IS6(r,:));
   pnMS7(r,:) = pnSMS7(r,IS7(r,:));
   pnMS8(r,:) = pnSMS8(r,IS8(r,:));
   pnMS9(r,:) = pnSMS9(r,IS9(r,:));
   pnMS10(r,:) = pnSMS10(r,IS10(r,:));
end

% Perm No. Winner and Loser portfolios for Skew Max Index
WpnSMS1 = pnSMS1(:,1:1615);
LpnSMS1 = pnSMS1(:,14536:16150);

% Perm No. Winner and Loser portfolio for Momentum Index
WpnMS1 = pnMS1(:,1:1615);
LpnMS1 = pnMS1(:,14536:16150);

% Finding the common stocks for the Winner and Loser portfolios over the
% sample period of 287 months
C = []
for i = 1:size(WpnSMS1,1)
    n = intersect(WpnSMS1(i,:),WpnMS1(i,:));
    n = padarray(n,[0 1615-size(n,2)],'post');
    C = vertcat(C,n);
end

%% Portfolio Performance Measures and Summary Statistics

%%% Evolving Sharpe Ratios
% Initialsing risk-free rate data over the working sample period, dividing
% by 100 to transform the data into comparable percentage form
% Risk-free rate obtained from Fama French Data Library
% http://mba.tuck.dartmouth.edu/pages/faculty/ken.french/data_library.html
rf = FFResearchDataFactors(:,5)/100;

% Computing evolving sharpe ratios for the respective portfolios
%   Traditional Momentum Portfolio: Equally Weighted Portfolios
SR_ewTMPS1 = (ewTMPS1 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS2 = (ewTMPS2 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS3 = (ewTMPS3 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS4 = (ewTMPS4 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS5 = (ewTMPS5 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS6 = (ewTMPS6 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS7 = (ewTMPS7 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS8 = (ewTMPS8 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS9 = (ewTMPS9 - rf)./repmat(std(ewTMPS1),287,1);
SR_ewTMPS10 = (ewTMPS10 - rf)./repmat(std(ewTMPS1),287,1);
%   Traditional Momentum Portfolio: Value Weighted Portfolio
SR_vwTMPS1 = (vwTMPS1 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS2 = (vwTMPS2 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS3 = (vwTMPS3 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS4 = (vwTMPS4 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS5 = (vwTMPS5 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS6 = (vwTMPS6 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS7 = (vwTMPS7 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS8 = (vwTMPS8 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS9 = (vwTMPS9 - rf)./repmat(std(ewTMPS1),287,1);
SR_vwTMPS10 = (vwTMPS10 - rf)./repmat(std(ewTMPS1),287,1);
%   Skewness Enchanced Portfolio: Equally Weighted Portfolio

%   Skewness Enhanced Portfolio: Value Weighted Portfolio



%%% Maximum Drawdown
%   Traditional Momentum Portfolio: Equally Weighted Portfolios
MDD_ewTMPS1 = maxdrawdown(cumprod(ewTMPS1+1));
MDD_ewTMPS2 = maxdrawdown(cumprod(ewTMPS2+1));
MDD_ewTMPS3 = maxdrawdown(cumprod(ewTMPS3+1));
MDD_ewTMPS4 = maxdrawdown(cumprod(ewTMPS4+1));
MDD_ewTMPS5 = maxdrawdown(cumprod(ewTMPS5+1));
MDD_ewTMPS6 = maxdrawdown(cumprod(ewTMPS6+1));
MDD_ewTMPS7 = maxdrawdown(cumprod(ewTMPS7+1));
MDD_ewTMPS8 = maxdrawdown(cumprod(ewTMPS8+1));
MDD_ewTMPS9 = maxdrawdown(cumprod(ewTMPS9+1));
MDD_ewTMPS10 = maxdrawdown(cumprod(ewTMPS10+1));
%   Traditional Momentum Portfolio: Value Weighted Portfolio
MDD_vwTMPS1 = maxdrawdown(cumprod(vwTMPS1+1));
MDD_vwTMPS2 = maxdrawdown(cumprod(vwTMPS2+1));
MDD_vwTMPS3 = maxdrawdown(cumprod(vwTMPS3+1));
MDD_vwTMPS4 = maxdrawdown(cumprod(vwTMPS4+1));
MDD_vwTMPS5 = maxdrawdown(cumprod(vwTMPS5+1));
MDD_vwTMPS6 = maxdrawdown(cumprod(vwTMPS6+1));
MDD_vwTMPS7 = maxdrawdown(cumprod(vwTMPS7+1));
MDD_vwTMPS8 = maxdrawdown(cumprod(vwTMPS8+1));
MDD_vwTMPS9 = maxdrawdown(cumprod(vwTMPS9+1));
MDD_vwTMPS10 = maxdrawdown(cumprod(vwTMPS10+1));

%%% Plot of cumulative returns for all portfolios


%%% t-ratios
% Initialising Market Risk Premium Factor, dividing by 100 to express in
% percentage form
ERP = FFResearchDataFactors(:,2)/100;
t = fitlm(ERP,ewTMPS1-rf)



plot(cumprod(ewTMPS1+1));
maxdrawdown(ewTMPS1);
