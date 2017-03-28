%% Question 1 %%
% this function grabs 1-day returns for all stocks from the .att file
% creats a superset matrix of all stocks over the sample period

% creating anchor index for securities
Anch_ID = fopen(fullfile('AxiomaRiskModels-FlatFiles','2011','11','AXUS2-MH.20111101.att'));
formatSpec = '%s %s %s %f32 %f32 %f32 %f32 %f32 %f32';
Anch_data = textscan(Anch_ID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 5);
Anch_SecID_Ret = Anch_data{1};
Anch_Ret = zeros(length(Anch_SecID_Ret),1);

% PARSING THROUGH .att FILE
% loop to create superset of cross-sectional returns over sample period
tic
for year = 2011:2016
    for month = 1:12
        for day = 1:31
            file = ['AXUS2-MH.' num2str(year) num2str(month, '%02i') num2str(day, '%02i') '.att'];
            fileID = fopen(fullfile('AxiomaRiskModels-FlatFiles', num2str(year), num2str(month, '%02i'), file));
            if fileID == -1
                continue
            end
            Cret_data = textscan(fileID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 5);
            % Comparing securities
            SecID = Cret_data{1};
            % Adding new securities if any, otherwise list constant
            Anch_SecID_Ret = vertcat(Anch_SecID_Ret, SecID(~ismember(SecID,Anch_SecID_Ret)));
            % Cross-sectional stock returns
            SecRet = Cret_data{7};
            % Initialising cross-sectional returns to zero before
            % replacing with actual mapped return values
            Anch_Ret = padarray(Anch_Ret, [size(Anch_SecID_Ret,1) - size(Anch_Ret,1) 1], 'post');
            % adding the current returns to the corresponding Sec ID
            % missing Sec ID for current array is left as 0      
            Anch_Ret(ismember(Anch_SecID_Ret, SecID), end) = SecRet;
            % closing opened file to free up memory
            fclose(fileID);
        end
    end
end
toc

% cleaning returns
% 0 values = NaN
% winzorising returns
% knocking out out values greater and lesser than the 5% quantile
Clean_Ret = Anch_Ret(:,2:1275);
Clean_Ret(Clean_Ret == 0) = NaN;
alpha = 0.05;
data_min = quantile(Clean_Ret, alpha);
data_max = quantile(Clean_Ret, 1-alpha);
Clean_Ret(Clean_Ret < data_min) = NaN;
Clean_Ret(Clean_Ret > data_max) = NaN;

% calculating descriptive time-series statistics
% QNS: should we take weighted average?
Avg_Ret = mean(Clean_Ret, 1, 'omitnan');
Med_Ret = median(Clean_Ret, 1, 'omitnan');
Std_Ret = std(Clean_Ret, 1, 'omitnan'); 

% time-series plots for cross-sectional summary statistics
figure

subplot(3,1,1)
plot(Avg_Ret);
title('Simple Average Returns Time-Plot');
xlabel('Years')
ylabel('Returns')

subplot(3,1,2)
plot(Med_Ret);
title('Median Average Returns Time-Plot');
xlabel('Years')
ylabel('Returns')

subplot(3,1,3)
plot(Std_Ret);
title('Standard Deviation Average Returns Time-Plot');
xlabel('Years')
ylabel('Returns')

%% Question 2 %% 
% computing the univariate and multivariate regression for style factors

% creating anchor index for securities
Anch_ID = fopen(fullfile('AxiomaRiskModels-FlatFiles','2011','11','AXUS2-MH.20111101.exp'));
formatSpec = '%s %f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32 %f32 %*[^\n]';
Anch_data = textscan(Anch_ID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 4);
Anch_SecID_Exp = Anch_data{1};
% anchor index for 10 style factors exposures
Anch_Exp_Value = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_Levg = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_Grth = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_Size = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_MktSen = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_Liq = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_STM = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_MTM = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_ERS = zeros(length(Anch_SecID_Exp),1);
Anch_Exp_Vol = zeros(length(Anch_SecID_Exp),1);

% PARSING THROUGH .exp FILE
% importing and creating matrix of stock specific style exposures 
tic
for year = 2011:2016
    for month = 1:12
        for day = 1:31
            file = ['AXUS2-MH.' num2str(year) num2str(month, '%02i') num2str(day, '%02i') '.exp'];
            fileID = fopen(fullfile('AxiomaRiskModels-FlatFiles', num2str(year), num2str(month, '%02i'), file));
            if fileID == -1
                continue
            end
            Cret_data = textscan(fileID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 4);
            % Comparing securities
            SecID = Cret_data{1};
            % Adding new securities if any, otherwise list constant
            Anch_SecID_Exp = vertcat(Anch_SecID_Exp, SecID(~ismember(SecID,Anch_SecID_Exp)));
            % Cross-sectional stock specific style factor exposures
            Value = Cret_data{2};
            Levg = Cret_data{3};
            Grth = Cret_data{4};
            Size = Cret_data{5};
            MktSen = Cret_data{6};
            Liq = Cret_data{7};
            STM = Cret_data{8};
            MTM = Cret_data{9};
            ERS = Cret_data{10};
            Vol = Cret_data{11};
            % Initialising cross-sectional exposures to zero before
            % replacing with actual mapped return values
            Anch_Exp_Value = padarray(Anch_Exp_Value, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Value,1) 1], 'post');  
            Anch_Exp_Levg = padarray(Anch_Exp_Levg, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Levg,1) 1], 'post');  
            Anch_Exp_Grth = padarray(Anch_Exp_Grth, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Grth,1) 1], 'post');
            Anch_Exp_Size = padarray(Anch_Exp_Size, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Size,1) 1], 'post');            
            Anch_Exp_MktSen = padarray(Anch_Exp_MktSen, [size(Anch_SecID_Exp,1) - size(Anch_Exp_MktSen,1) 1], 'post');   
            Anch_Exp_Liq = padarray(Anch_Exp_Liq, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Liq,1) 1], 'post');    
            Anch_Exp_STM = padarray(Anch_Exp_STM, [size(Anch_SecID_Exp,1) - size(Anch_Exp_STM,1) 1], 'post');          
            Anch_Exp_MTM = padarray(Anch_Exp_MTM, [size(Anch_SecID_Exp,1) - size(Anch_Exp_MTM,1) 1], 'post');         
            Anch_Exp_ERS = padarray(Anch_Exp_ERS, [size(Anch_SecID_Exp,1) - size(Anch_Exp_ERS,1) 1], 'post');    
            Anch_Exp_Vol = padarray(Anch_Exp_Vol, [size(Anch_SecID_Exp,1) - size(Anch_Exp_Vol,1) 1], 'post');
            % adding the current exposures to the corresponding Sec ID
            % missing Sec ID for current array is left as 0
            Anch_Exp_Value(ismember(Anch_SecID_Exp,SecID),end) = Value;
            Anch_Exp_Levg(ismember(Anch_SecID_Exp,SecID),end) = Levg;
            Anch_Exp_Grth(ismember(Anch_SecID_Exp,SecID),end) = Grth;
            Anch_Exp_Size(ismember(Anch_SecID_Exp,SecID),end) = Size;
            Anch_Exp_MktSen(ismember(Anch_SecID_Exp,SecID),end) = MktSen;
            Anch_Exp_Liq(ismember(Anch_SecID_Exp,SecID),end) = Liq;
            Anch_Exp_STM(ismember(Anch_SecID_Exp,SecID),end) = STM;
            Anch_Exp_MTM(ismember(Anch_SecID_Exp,SecID),end) = MTM;
            Anch_Exp_ERS(ismember(Anch_SecID_Exp,SecID),end) = ERS;
            Anch_Exp_Vol(ismember(Anch_SecID_Exp,SecID),end) = Vol;
            % closing opened file to free up memory
            fclose(fileID);
        end
    end
end
toc

% return matrix of common securities without winzorisation
% this matrix is taken to measure the goodness of fit for Axioma's risk
% model by taking the conservative approach that they did not conduct
% winzorisation because we simply do not have that knowledge that they did

% return matrix of common securities with winzorisation for our own model
testret = Clean_Ret(ismember(Anch_SecID_Exp, Anch_SecID_Ret),:);

% regressing next day actual stock returns on today's stock exposures
% i will remain the same because the 1st column of the Anch Exp matrices
% are just zeros, thus i will be the first day current day's exposure
% univariate factor returns
uni_facret = zeros(10,1273);
for i = 2:1274
    uni_facret(1,i-1) = mvregress(Anch_Exp_Value(:,i), testret(:,i));
    uni_facret(2,i-1) = mvregress(Anch_Exp_Levg(:,i), testret(:,i));
    uni_facret(3,i-1) = mvregress(Anch_Exp_Grth(:,i), testret(:,i));
    uni_facret(4,i-1) = mvregress(Anch_Exp_Size(:,i), testret(:,i));
    uni_facret(5,i-1) = mvregress(Anch_Exp_MktSen(:,i), testret(:,i));
    uni_facret(6,i-1) = mvregress(Anch_Exp_Liq(:,i), testret(:,i));
    uni_facret(7,i-1) = mvregress(Anch_Exp_STM(:,i), testret(:,i));
    uni_facret(8,i-1) = mvregress(Anch_Exp_MTM(:,i), testret(:,i));
    uni_facret(9,i-1) = mvregress(Anch_Exp_ERS(:,i), testret(:,i));
    uni_facret(10,i-1) = mvregress(Anch_Exp_Vol(:,i), testret(:,i));
end

% multivariate factor returns
mul_facret = zeros(10,1273);
for i = 2:1274
    X = [Anch_Exp_Value(:,i) Anch_Exp_Levg(:,i) Anch_Exp_Grth(:,i) Anch_Exp_Size(:,i) Anch_Exp_MktSen(:,i) Anch_Exp_Liq(:,i) Anch_Exp_STM(:,i) Anch_Exp_MTM(:,i) Anch_Exp_ERS(:,i) Anch_Exp_Vol(:,i)];
    mul_facret(:,i-1) = mvregress(X, testret(:,i));
end

% alpha factors, calculate first two moments
alpfac = zeros(10,4);
alpfac(:,1) = mean(uni_facret,2);
alpfac(:,2) = std(uni_facret,0,2);
alpfac(:,3) = mean(mul_facret,2);
alpfac(:,4) = std(mul_facret,0,2);
%%%% comments: none of them are alpha factors. both univariate and
%%%% multivariate style factors. None have volatility that is = 0. 

%% Question 3 %% 

% creating anchor index for securities
Anch_ID = fopen(fullfile('AxiomaRiskModels-FlatFiles','2011','11','AXUS2-MH.20111101.rsk'));
formatSpec = '%s %f32 %f32 %s %s %f32 %f32 %f32';
Anch_data = textscan(Anch_ID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 5);
Anch_SecID_Rsk = Anch_data{1};
Anch_SSRet = zeros(length(Anch_SecID_Rsk),1);

% PARSING THROUGH .rsk FILE
% Picking up the stock-specific returns from Axioma files
tic
for year = 2011:2016
    for month = 1:12
        for day = 1:31
            file = ['AXUS2-MH.' num2str(year) num2str(month, '%02i') num2str(day, '%02i') '.rsk'];
            fileID = fopen(fullfile('AxiomaRiskModels-FlatFiles', num2str(year), num2str(month, '%02i'), file));
            if fileID == -1
                continue
            end
            Cret_data = textscan(fileID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 5);
            % Comparing securities
            SecID = Cret_data{1};
            % Adding new securities if any, otherwise list constant
            Anch_SecID_Rsk = vertcat(Anch_SecID_Rsk, SecID(~ismember(SecID,Anch_SecID_Rsk)));
            % Cross-sectional stock returns
            SSRet = Cret_data{7};
            % Initialising cross-sectional returns to zero before
            % replacing with actual mapped return values
            Anch_SSRet = padarray(Anch_SSRet, [size(Anch_SecID_Rsk,1) - size(Anch_SSRet,1) 1], 'post');
            % adding the current returns to the corresponding Sec ID
            % missing Sec ID for current array is left as 0      
            Anch_SSRet(ismember(Anch_SecID_Rsk, SecID), end) = SSRet;
            % closing opened file to free up memory
            fclose(fileID);
        end
    end
end
toc

% Matrix of total returns of the common securities between the .rsk and
% .att files
q3_cmn_ret = Anch_Ret(ismember(Anch_SecID_Rsk, Anch_SecID_Ret),:);
q3_cmn_ret = q3_cmn_ret(:,2:end);

% Cleaning the data
% converting 0 values to NaN in the stock-specific returns from Axioma
Anch_SSRet(Anch_SSRet == 0) = NaN;
q3_cmn_ret(q3_cmn_ret == 0) = NaN;
% alpha set at 5%
% winzorising dataset for stock-specific returns
data_min = quantile(Anch_SSRet, alpha);
data_max = quantile(Anch_SSRet, 1-alpha);
Anch_SSRet(Anch_SSRet < data_min) = NaN;
Anch_SSRet(Anch_SSRet > data_max) = NaN;
% winzorising dataset for actual total returns
data_min = quantile(q3_cmn_ret, alpha);
data_max = quantile(q3_cmn_ret, 1-alpha);
q3_cmn_ret(q3_cmn_ret < data_min) = NaN;
q3_cmn_ret(q3_cmn_ret > data_max) = NaN;

% some R2 are negative, this is because the for some of the stocks
% residuals are non-Nan values while the y variables are NaN values 
% computing R^2 over sample period for multivariate regression
r2 = 1 - (var(Anch_SSRet(:,2:end), 1, 'omitnan') ./ var(q3_cmn_ret, 1, 'omitnan')); 

% plotting the R^2 plot
plot(r2);
title('Axioma Risk Model R^2 Plot');
xlabel('Years')
ylabel('R-Square')


%% Question 4 %%

% computing the variance-covariance matrix for uni and multivariate
% over the entire sample period
cov_uni_fac = cov(uni_facret');
cov_mul_fac = cov(mul_facret');

% Creating a rolling window period of covariance matrices
% Window Size = 22 trading days
wdw = 22;

% Rolling Cov Matrices - uni Factor
cov_uni_fac_time = zeros(10,10,round((size(uni_facret,2)-wdw)/wdw));
for i = 1:round((size(uni_facret,2)-wdw)/wdw) 
    if i == 1
    cov_uni_fac_time(:,:,i) = cov((uni_facret(:,i:(i+wdw-1))'));    
    else 
    cov_uni_fac_time(:,:,i) = cov((uni_facret(:,((i-1)*wdw+1):(i*wdw))'));        
    end
end 

% Rolling Cov Matrices - multi Factor
cov_mul_fac_time = zeros(10,10,round((size(mul_facret,2)-wdw)/wdw));
for i = 1:round((size(mul_facret,2)-wdw)/wdw)
    if i == 1
    cov_mul_fac_time(:,:,i) = cov((mul_facret(:,i:(i+wdw-1))'));    
    else 
    cov_mul_fac_time(:,:,i) = cov((mul_facret(:,((i-1)*wdw+1):(i*wdw))'));        
    end
end


% Computing R-squares for unique covariances and variances for each back to
% back month over the entire sample period
% We use this blunt method to see if the covariances and variances change
% significantly over time. If the R-squares dip significantly, that means
% that the covariances have changed significantly between each month, vice
% versa

% Univariate Coveriances R-squares
uni_cov_vec = zeros(55*size(cov_uni_fac_time,3),1); 
for i = 1:(size(cov_uni_fac_time,3)) 
    A = zeros(10,10);
    for g = 1:10;
        for f = 1:g;
            A(g,f) = cov_uni_fac_time(g,f,i);
        end
    end
    A = A(A~=0);
    if i == 1; 
       uni_cov_vec(i:i+54,1) = A(:,1);
    else    
       uni_cov_vec((55*(i-1)+1):((55*(i-1))+55),1) = A(:);
    end
end
array2table(uni_cov_vec);
wnd = 1;
reg_out_uni = zeros(round(56,0),1);

for i = 1:(size(reg_out_uni,1))

    if i == 1
    md1 =  fitlm( uni_cov_vec( i:i+( (wnd*55) -1 ) ), ... 
        uni_cov_vec( ( i + (i*55*wnd)):( (i*55*wnd) + (i*55*wnd) ) ) );    
    else    
    md1 =  fitlm( uni_cov_vec( (wnd*55*(i-1)+1):( (wnd*55*(i-1)+1)+( (wnd*55) -1 ) )), ... 
           uni_cov_vec( (wnd*55*i+1): ( (wnd*55*i+1)+ (wnd*55)-1 ) ) );
    end
    reg_out_uni(i,1) = md1.Rsquared.ordinary;    
    
end

% plotting the R^2s for the rolling Univariate Cov
plot(reg_out_uni);

% Multivariate Covariances R-squares
mul_cov_vec = zeros(55*size(cov_mul_fac_time,3),1); 
for i = 1:(size(cov_mul_fac_time,3)) 
    A = zeros(10,10);
    for g = 1:10;
        for f = 1:g;
            A(g,f) = cov_mul_fac_time(g,f,i);
        end
    end
    A = A(A~=0);
    if i == 1; 
       mul_cov_vec(i:i+54,1) = A(:,1);
    else    
       mul_cov_vec((55*(i-1)+1):((55*(i-1))+55),1) = A(:);
    end
end
array2table(mul_cov_vec);
wnd = 1;
reg_out_mul = zeros(56,1);

for i = 1:(size(reg_out_mul,1))

    if i == 1
    md1 =  fitlm( mul_cov_vec( i:i+( (wnd*55) -1 ) ), ... 
        mul_cov_vec( ( i + (i*55*wnd)):( (i*55*wnd) + (i*55*wnd) ) ) );    
    else    
    md1 =  fitlm( mul_cov_vec( (wnd*55*(i-1)+1):( (wnd*55*(i-1)+1)+( (wnd*55) -1 ) )), ... 
           mul_cov_vec( (wnd*55*i+1): ( (wnd*55*i+1)+ (wnd*55)-1 ) ) );
    end
    reg_out_mul(i,1) = md1.Rsquared.ordinary;    
    
end 
plot(reg_out_mul);

% Comparing the covariances between the Univariate and Multivariate factor returns 
diff_mul_uni_cov = abs(mul_cov_vec - uni_cov_vec);
mat_diff = zeros(56,1);
for i = 1:((size(mul_cov_vec,1)/55)-1)
    if i == 1 
    mat_diff(i,1) = sum(diff_mul_uni_cov(i:55,1));        
    else
    mat_diff(i,1) = sum(diff_mul_uni_cov( ( (i*55)+1 ) : (i*55)+55),1);      
    end     
end    

plot(mat_diff);

%% Question 5 %%

% creating anchor index for securities
Anch_ID = fopen(fullfile('AxiomaRiskModels-FlatFiles','2011','11','AXUS2-MH.20111101.ret'));
formatSpec = '%s %f32 %f32';
Anch_data = textscan(Anch_ID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 3);
Anch_SecID_Facret = Anch_data{1};
Anch_Ax_Facret = zeros(length(Anch_SecID_Facret),1);

% PARSING THROUGH .ret FILE
% Picking up factor returns from Axioma files
tic
for year = 2011:2016
    for month = 1:12
        for day = 1:31
            file = ['AXUS2-MH.' num2str(year) num2str(month, '%02i') num2str(day, '%02i') '.ret'];
            fileID = fopen(fullfile('AxiomaRiskModels-FlatFiles', num2str(year), num2str(month, '%02i'), file));
            if fileID == -1
                continue
            end
            Cret_data = textscan(fileID, formatSpec, 'Delimiter', '|', 'EmptyValue', NaN, 'HeaderLines', 3);
            % Comparing securities
            SecID = Cret_data{1};
            % Adding new securities if any, otherwise list constant
            Anch_SecID_Facret = vertcat(Anch_SecID_Facret, SecID(~ismember(SecID,Anch_SecID_Facret)));
            % Cross-sectional stock returns
            Facret = Cret_data{2};
            % Initialising cross-sectional returns to zero before
            % replacing with actual mapped return values
            Anch_Ax_Facret = padarray(Anch_Ax_Facret, [size(Anch_SecID_Facret,1) - size(Anch_Ax_Facret,1) 1], 'post');
            % adding the current returns to the corresponding Sec ID
            % missing Sec ID for current array is left as 0      
            Anch_Ax_Facret(ismember(Anch_SecID_Facret, SecID), end) = Facret;
            % closing opened file to free up memory
            fclose(fileID);
        end
    end
end
toc

% Filtering for Axioma style factors and outputting filtered matrix
% In order:
% Exchange Rate Sensitivity, Growth, Leverage, Market Sensitivity, Med-Term
% Momentum, Short-Term Momentum, Size, Value, Volatility
Anch_SecID_Facret = Anch_SecID_Facret([27,31,45,47,50,52,66,67,75,76],:);
Anch_Ax_Facret = Anch_Ax_Facret([27,31,45,47,50,52,66,67,75,76],:);
Anch_Ax_Facret = Anch_Ax_Facret(:,2:end);

% Creating a portfolio with a unit exposure to 'Growth Factor' only
% this essentially means having a 100% weight in the Growth factor and 0
% weights in all other factors. The portfolio's expected volatility
% would just reduce to the variance (or standard deviation) of the factor
% returns for Growth over the entire sample period given the assumption
% that we had infinite ability to diversity other effects.

% We calculate both portfolio volatility for a rolling window and the
% entire sample period

% Rolling window
pft_vol_rw = [];
for i = 1:length(Anch_Ax_Facret)-22
    pft_vol_rw(i) = std(Anch_Ax_Facret(2,i:i+22));
end

% Portfolio volatility for the entire sample period
pft_vol = std(Anch_Ax_Facret(2,:));

% Now that we know the portfolio volatilty, and given the infinite ability
% to diversify our portfolio using other factors, we set the quasi portolio
% Sharpe Ratio as the objective that will be maximised because by doing so, 
% we simultaneously maximise return and minimize volatility. And we now 
% remove the constraint of 0 weights in other groups while maintaining the 
% unit weight in the Growth factor to reduce the portfolio volatility

% Rolling Covariance matrices for Axioma Factor Returns
Ax_Facret_Cov = [];
for i = 1:length(Anch_Ax_Facret)-22
    Ax_Facret_Cov(:,:,i) = cov(Anch_Ax_Facret(:,i:i+21)');
end

% Computing optimal combination for rolling period over sample period
% Initialising output matrices
q5_w = [];
q5_pvar = [];
% Initialising boundary conditions and startvalues for the optimzation func
w0 = ones(10,1)*(1/10);
Aeq = ones(1,10);
beq = 1;
% Maintaining unit exposure to Growth factor throughout time
lb = [-Inf; 1; -Inf; -Inf; -Inf; -Inf; -Inf; -Inf; -Inf; -Inf]; 
ub = [+Inf; 1; +Inf; +Inf; +Inf; +Inf; +Inf; +Inf; +Inf; +Inf]; 
options = optimset('Display', 'off');

% Calculating rolling optimal portfolio combination with unit exposure to
% growth
for i = 1:length(Anch_Ax_Facret)-22
    [q5_w(:,i), q5_pvar(i)] = fmincon(@(w)pft_var(w, Ax_Facret_Cov(:,:,i)), w0, [], [], Aeq, beq, lb, ub, [], options);
end

% Calculating Cov Matrix for entire sample period
Ax_Facret_FullCov = cov(Anch_Ax_Facret');

% Optimal weights for entire sample period
[q5_full_w, q5_full_pvar] = fmincon(@(w)pft_var(w, Ax_Facret_FullCov), w0, [], [], Aeq, beq, lb, ub, [], options);

% Plots
% Portfolio Optimal Combination
plot(q5_w');
title('Portfolio Optimal Weight Combination over time');
xlabel('Time');
ylabel('% of Factor Held');
% Portfolio Standard Deviation vs Growth Factor Standard Deviation
plot(pft_vol_rw);
hold
plot(q5_pvar);
title('Portfolio Volatility: Optimal Portfolio vs. Growth only Portfolio');
ylabel('Portfolio Standard Deviation');
xlabel('Time');

%% Question 6 %% 

% Creating the best combination
% Computing optimal combination for rolling period over sample period
% Initialising output matrices
q6_w = [];
q6_pft_sr = [];
% Realistic boundaries
lb = [-2; -2; -2; -2; -2; -2; -2; -2; -2; -2]; 
ub = [+2; +2; +2; +2; +2; +2; +2; +2; +2; +2]; 

% Calculating rolling optimal portfolio combination with no constraint on
% respective exposures
for i = 1:length(Anch_Ax_Facret)-22
    [q6_w(:,i), q6_pft_sr(i)] = fmincon(@(w)-pft_sr(w, Anch_Ax_Facret(:,i+22), Ax_Facret_Cov(:,:,i)), w0, [], [], Aeq, beq, lb, ub, [], options);
end

% plotting weights for quasi sharpe ratio
plot(-q6_pft_sr);
title('Optimal Portfolio Sharpe Ratio');
ylabel('Quasi Sharpe Ratio');
xlabel('Time');

% calculating the portfolio returns for this strategy over the period
q6_pft_ret = zeros(1,1251);
for i = 1:1251
    q6_pft_ret(i) = q6_w(:,i)' * Anch_Ax_Facret(:,i+23);
end
% calculating portfolio cumulative returns
q6_pft_cumret = cumprod((q6_pft_ret ./ 100) + 1, 2);
% Performance Measures
% Equity Curve
plot(q6_pft_cumret);
% Quasi Sharpe Ratio
q6_pft_Fullsr = mean(q6_pft_ret) / std(q6_pft_ret);

% Computing the static optimal combination over the entire sample period
[q6_full_w, q6_stat_sr] = fmincon(@(w)-pft_sr(w, mean(Anch_Ax_Facret, 2), Ax_Facret_FullCov), w0, [], [], Aeq, beq, lb, ub, [], options);


%% Question 7 %% 

% Factor: Valmentum 
% Looking for stocks with high exposure to Value and Momentum so that they
% exhibit both cheap characteristics that are expected to increase toward
% the future.
% We assign a value of 10 to stocks with a unit exposure greater than that
% of 90% of the cross section for both style factors and 1 to stocks that
% have unit exposure of less than 10% of the cross section 

% Generating exposures for Value and Momentum factors
ValTum_Val_Exp = ones(size(Anch_Exp_Value(:,2:end)));
ValTum_MTM_Exp = ones(size(Anch_Exp_MTM(:,2:end)));
ValTum_STM_Exp = ones(size(Anch_Exp_STM(:,2:end)));
% Computing the daily ranked conditional exposures of Valmentum (Med) factor
for i = 1:-0.1:0.1
    A = Anch_Exp_Value(:,2:end) <= repmat(quantile(Anch_Exp_Value(:,2:end), i, 1), [length(Anch_Exp_Value) 1]) & Anch_Exp_Value(:,2:end) > repmat(quantile(Anch_Exp_Value(:,2:end), i-0.1, 1), [length(Anch_Exp_Value) 1]);
    B = Anch_Exp_MTM(:,2:end) <= repmat(quantile(Anch_Exp_MTM(:,2:end), i, 1), [length(Anch_Exp_MTM) 1]) & Anch_Exp_MTM(:,2:end) > repmat(quantile(Anch_Exp_MTM(:,2:end), i-0.1, 1), [length(Anch_Exp_MTM) 1]);
    C = Anch_Exp_STM(:,2:end) <= repmat(quantile(Anch_Exp_STM(:,2:end), i, 1), [length(Anch_Exp_STM) 1]) & Anch_Exp_STM(:,2:end) > repmat(quantile(Anch_Exp_STM(:,2:end), i-0.1, 1), [length(Anch_Exp_STM) 1]);
    A = double(A);
    B = double(B);
    C = double(C);
    ValTum_Val_Exp(A==1) = i*10;
    ValTum_MTM_Exp(B==1) = i*10;
    ValTum_STM_Exp(C==1) = i*10;
end 
% Finally computing the Valmentum Factor
ValTum_Exp = ValTum_Val_Exp + ValTum_MTM_Exp;
ValTum_Shr_Exp = ValTum_Val_Exp + ValTum_STM_Exp;
% Normalizing Valmentum Exposures
ValTum_NormExp = zscore(ValTum_Exp);
ValTum_NormShrExp = zscore(ValTum_Shr_Exp);

% Regressing the Valentum Factors in the Multivariate regression to obtain
% Valentum factor returns
Val_mul_facret = zeros(11,1273);
Val_shr_mul_facret = zeros(11,1273);
for i = 2:1274
    X = [Anch_Exp_Value(:,i) Anch_Exp_Levg(:,i) Anch_Exp_Grth(:,i) Anch_Exp_Size(:,i) Anch_Exp_MktSen(:,i) Anch_Exp_Liq(:,i) Anch_Exp_STM(:,i) Anch_Exp_MTM(:,i) Anch_Exp_ERS(:,i) Anch_Exp_Vol(:,i), ValTum_NormExp(:,i-1)];
    Val_mul_facret(:,i-1) = mvregress(X, testret(:,i));
    X2 = [Anch_Exp_Value(:,i) Anch_Exp_Levg(:,i) Anch_Exp_Grth(:,i) Anch_Exp_Size(:,i) Anch_Exp_MktSen(:,i) Anch_Exp_Liq(:,i) Anch_Exp_STM(:,i) Anch_Exp_MTM(:,i) Anch_Exp_ERS(:,i) Anch_Exp_Vol(:,i), ValTum_NormShrExp(:,i-1)];
    Val_shr_mul_facret(:,i-1) = mvregress(X2, testret(:,1));
end
% Valentum Factor Returns
% Med-MTM and Short-MTM
ValTum_Facret = Val_mul_facret(11,:);
ValTum_Shr_Facret = Val_shr_mul_facret(11,:);

% Information Coefficient for Valentum Factor
Val_IC = zeros(1,1273);
Val_shrIC = zeros(1,1273);
for i = 1:1273
    covc = nancov(testret(:,i), ValTum_NormExp(:,i));
    Val_IC(1,i) = covc(2,1) / (std(testret(:,i), 'omitnan') * std(ValTum_NormExp(:,i), 'omitnan'));
    covc = nancov(testret(:,i), ValTum_NormShrExp(:,i));
    Val_shrIC(1,i) = covc(2,1) / (std(testret(:,i), 'omitnan') * std(ValTum_NormShrExp(:,i), 'omitnan'));
end
% Plot for Valentum Information Coefficient
% Val-Med Momentum Factor
plot(Val_IC);
title('Valentum (Med) Factor Information Coefficient');
xlabel('Time');
ylabel('Information Coefficient');
% Val-Short Momentum Factor
plot(Val_shrIC);
title('Valentum (Short) Factor Information Coefficient');
xlabel('Time');
ylabel('Information Coefficient');

% Regressing Stock Specific Returns on the Valentum Normalised Exposures
% 1st Row: R Squared
% 2nd Row: Factor Return
% 3rd Row: Standard Error
% 4th Row: t-Stat
% 5th Row: p-Value
q7_mdl_stats = zeros(5,1273);
q7_mdl_shr_stats = zeros(5,1273);
for i = 3:1274
    mdl = fitlm(ValTum_NormExp(:,i-2),Anch_SSRet(:,i));
    q7_mdl_stats(1,i-2) = mdl.Rsquared.Ordinary;
    q7_mdl_stats(2:5,i-2) = table2array(mdl.Coefficients(2,:));
    mdl2 = fitlm(ValTum_NormShrExp(:,i-2),Anch_SSRet(:,i));
    q7_mdl_shr_stats(1,i-2) = mdl2.Rsquared.Ordinary;
    q7_mdl_shr_stats(2:5,i-2) = table2array(mdl2.Coefficients(2,:));
end

% plotting the R-squared over time
% Val-Med Momentum Factor
plot(q7_mdl_stats(1,:));
% Val-Shrt Momentum Factor
plot(q7_mdl_shr_stats(1,:));

% In-sample characteristics
% Val-Med Momentum Factor
plot(ValTum_Facret);
mean(ValTum_Facret)
std(ValTum_Facret)
% Val-Shrt Momentum Factor
plot(ValTum_Shr_Facret);
mean(ValTum_Shr_Facret)
std(ValTum_Shr_Facret)

