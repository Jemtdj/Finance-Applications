%% Derivatives Assignment 1 %%

%% Question 1
% Bootstrapping method
% Obtaining zero coupon discount factors

% Importing bond data from spreadsheet
[num,hdr,raw] = xlsread('Bond Data.xlsx');

%%%% Coupon Matrix %%%% 
% will be a 10x10 matrix because the longest maturity coupon
% has a total of 10 coupon payments. All other bonds that have a shorter
% maturity will have 0 values in the remaining spaces of their respective
% vector to complete the square matrix 

% Semi-annual coupon payment for respective bonds
coupay = num(3,:)./2;

% Number of coupon payments for respective bonds
% value is multiplied by 2 because coupon is semi-annual
numcpay = num(2,:)*2;

% Cash-flow matrix for all bonds
CFMat = zeros(10);

for i = 1:length(num(1,:))
    CFMat(i,1:length(repmat(coupay(1,i),1,numcpay(1,i)))) = repmat(coupay(1,i),1,numcpay(1,i));
    CFMat(i,numcpay(1,i)) = CFMat(i,numcpay(1,i)) + 100;
end

%%%% Price Vector  %%%%
BidPrice = num(4,:);
AskPrice = num(5,:);

%%%% Zero Discount Factors %%%%
BidZDF = inv(CFMat)*BidPrice';
AskZDF = inv(CFMat)*AskPrice';

% Part 1A
fprintf('The 5 year ask discount factor is %4.4f. \n', AskZDF(10,1)); 
% Ans: A, 0.7708

% Part 1B
p1b = ((1/BidZDF(4,1))^(1/4)-1)*2;
fprintf('The 2-year bid implied USD risk-free rate is %4.4f. \n', p1b);
% Ans: E, 4.27%

% Part 1C
% Bid price of a 3 year US Government bond paying a coupon of 5%
% semiannually is equal to: 
CF_5p_3yr = repmat(5/2,1,6);
CF_5p_3yr(1,6) = 102.5;
Bidp_CF_5p_3yr = CF_5p_3yr * BidZDF(1:6,1);
fprintf('The bid price of a 3 year US Government bond is %4.4f. \n', Bidp_CF_5p_3yr);
% Ans: C, 101.3899

% Part 1D
% LIBOR Swap Rate
% Valuation of swap equation
syms x
eqn = (100*((x/2)*sum(AskZDF(1:6,1))-(1-AskZDF(6,1)))) == 0;
swaprate = eval(solve(eqn,x));
fprintf('The quoted swap rate will be less than or equal to %4.6f. \n', swaprate);
% Ans: A, <= 4.48075%

% Ans is either A or C depending on whether Bid or Ask is used

%% Question 2

%{
syms th0 th1 th2 lambd

lsqnonlin

th0 = 0.0754;
th1 = -0.0453;
th2 = 0;
lamb = 3;

pmodel = []
NS_ZDF = []
for t = 1:10
    r = th0 + (th1+th2)*((1-exp(-(t/lamb)))/(t/lamb)) - (th2*exp(-(t/lamb)));
    NS_ZDF(t,1) = exp(-r*t);
end

NS_Price = CFMat * NS_ZDF;
sum((NS_Price - BidPrice').^2);

r = (x(1) + (x(2)+x(3))*((1-exp(-(t/x(4))))./(t/x(4))) - (x(3)*exp(-(t/x(4)))));
%}

t = linspace(1,10,10);
x0 =[0.0754,-0.0453,0,3];
fun = @(x)(CFMat * exp(-(x(1) + (x(2)+x(3))*((1-exp(-(t/x(4))))./(t/x(4))) - (x(3)*exp(-(t/x(4))))).*t)')-BidPrice';
options = optimset('MaxFunEvals',1000000,'TolFun',1e-30, 'TolX',1e-30, 'MaxIter', 1000000); 
x = lsqnonlin(fun,x0,[],[],options);

NS_ZDF = exp(-(x(1) + (x(2)+x(3))*((1-exp(-(t/x(4))))./(t/x(4))) - (x(3)*exp(-(t/x(4))))).*t);
NS_ZDF = NS_ZDF';

plot(BidZDF)

% x = [0.0372   -0.0202   -0.0184    3.1758]

% Part 2A
NS_Bidp_CF_5p_3yr = CF_5p_3yr * NS_ZDF(1:6,1);
% Output: 101.2660
% Ans: D, 101.2657

% Part 2B 
syms x
eqn = (100*((x/2)*sum(NS_ZDF(1:6,1))-(1-NS_ZDF(6,1)))) == 0;
swaprate = eval(solve(eqn,x));
fprintf('The quoted swap rate will be less than or equal to %4.6f. \n', swaprate);
% Ans: C, <= 4.52446%
