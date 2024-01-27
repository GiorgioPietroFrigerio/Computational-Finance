%% Black-Litterman model
%% Views
% we first select the companies belonging to the 
% the specific sectors we are interested in 

numAssets = size(LogRet, 2);

% Industrial sector
IndustrialCompanies    = strcmp(table_sectors.Sector, 'Industrials');
IndustrialCompanyIndex = find(IndustrialCompanies);
len1 = length(IndustrialCompanyIndex);

% Material sector
MaterialCompanies    = strcmp(table_sectors.Sector, 'Materials');
MaterialCompanyIndex = find(MaterialCompanies);
len2 = length(MaterialCompanyIndex);

% Information technology and Consumer staples
TechCompanies    = strcmp(table_sectors.Sector, 'Information Technology');
TechCompanyIndex = find(TechCompanies);

ConsumerCompanies    = strcmp(table_sectors.Sector, 'Consumer Staples');
ConsumerCompanyIndex = find(ConsumerCompanies);

% Inizialization and allocation of the view distribution parameters

len   = len1+len2+1; %total number of views(the last view is only one line)
tau   = 1/length(LogRet);
P     = zeros(len, numAssets);
q     = zeros(len, 1);
omega = zeros(len,1);

% first view
for i=1:len1
P(i,IndustrialCompanyIndex(i)) = 1;
end
q(1:len1) = 0.03;

% second view
for i=len1+1:len1+len2
P(i,MaterialCompanyIndex(i-len1)) = 1;
end
q(len1+1:len1+len2) = 0.05;

% third view
%for a comparison view, the sum on the row must equal zero ("A guide to Black_Litterman Model" by Thomas M. Idzorek),
%so we perform a normalization on both sectors
P(len,TechCompanies) = 1/length(TechCompanyIndex); 
P(len,ConsumerCompanies) = -1/length(ConsumerCompanyIndex);
q(len) = 0.07; 

%% View distribution

%computing variances of the views
for i = 1:len
omega(i) = tau.*P(i,:)*CovMatrix*P(i, :)';
end
Omega = diag(omega);

%from daily to annualized values
bizyear2bizday = 1/252;
q = q*bizyear2bizday;
Omega = Omega*bizyear2bizday;

% Plot views distribution
X_views = mvnrnd(q, Omega, 200);
histogram(X_views(:, 1),15)

%% market implied ret

%market capitalization weight vector of assets
wMkt = table_mkt_cap.MarketCap/sum(table_mkt_cap.MarketCap);
%we set the risk aversion coefficient
lambda = 1.2;

%prior distribution parameters
mu_mkt = lambda.*CovMatrix*wMkt;
C = tau.*CovMatrix;

%plot prior distribution
X = mvnrnd(mu_mkt, C, 200);
histogram(X(:,1),15)
%% Black Litterman
%finally we compute the posterior distribution with Bayesian statistics

%posterior distribution parameters
muBL  = inv(inv(C)+ P'*inv(Omega)*P)*(P'*inv(Omega)*q + inv(C)*mu_mkt);
covBL = inv(P'*inv(Omega)*P + inv(C));

table(names',mu_mkt*252, muBL*252, 'VariableNames', ["Asset Names", "Prior Belief of Exp Ret", "BL ExpRet"]);

% posterior distribution
XBL = mvnrnd(muBL, covBL, 200);
histogram(XBL)
%% Portfolio frontier, Ptf I, Ptf L
%we predict the ptf's andfind the efficient frontier under the new
%parameters
p_bl = Portfolio('NumAssets',numAssets, 'Name', 'MV with BL');
p_bl = setAssetMoments(p_bl, muBL, (covBL + CovMatrix));
p_bl = setDefaultConstraints(p_bl);
weights_bl = estimateFrontier(p_bl, 100);
[ptfMVP_BL_Risk, ptfMVP_BL_Retn] = estimatePortMoments(p_bl, weights_bl);
                                                  
% Minimum variance portfolio under B&L - Portfolio I
[min_vol_bl, indexMV_bl] = min(ptfMVP_BL_Risk); 
Port_I = weights_bl(:,indexMV_bl);
[vol_MVP_BL, Ret_MVP_BL] = estimatePortMoments(p_bl, Port_I);

% Max Sharpe ratio Portfolio - Portfolio L
Port_L = estimateMaxSharpeRatio(p_bl, 'Method', 'iterative');
[vol_Sharpe_BL, Ret_Sharpe_BL] = estimatePortMoments(p_bl, Port_L);                                     

%% Plot
f = figure();
plot(ptfMVP_BL_Risk, ptfMVP_BL_Retn, 'LineWidth', 2);
hold on;
grid on;
plot(vol_MVP_BL, Ret_MVP_BL, 'o', 'MarkerSize', 8, 'LineWidth', 2);
plot(vol_Sharpe_BL, Ret_Sharpe_BL, '*', 'MarkerSize', 8, 'LineWidth', 2);
title('Black Litterman efficient Portfolio Frontier');
ylabel('Expected Return');
xlabel('Volatility');
legend('Portfolio Frontier', 'MVP','Max Sharpe', 'Location','best');
%% exposure of MSRP (confrontation)

%we get a list of all sectors
asset_sectors = table_sectors.Sector;
sectors_list  = unique(table_sectors.Sector);

sector_weights_Sharpe    = zeros(size(unique(asset_sectors)));
sector_weights_Sharpe_BL = zeros(size(unique(asset_sectors)));

%sector weights
for i = 1:length(unique(asset_sectors))
    assets_in_sector = strcmp(asset_sectors, sectors_list(i));
    sector_weights_Sharpe_BL(i) = sum(Port_L(assets_in_sector));
    sector_weights_Sharpe(i) = sum(Port_B(assets_in_sector)); 
end

% Generate pie charts for Portfolio MVP with BL and MVP
figure; 
num_labels = length(unique(asset_sectors));
colors = parula(num_labels);

subplot(1, 2, 1); 
pie_data_1 = pie(sector_weights_Sharpe);
colormap(colors);

for i = 1:numel(pie_data_1)/2
    pie_data_1(2*i-1).FaceColor = colors(i,:);
end
title('Max Sharpe');

textObjs_1 = findobj(pie_data_1, 'Type', 'text');
for i = 1:numel(textObjs_1)
    textObjs_1(i).Visible = 'off';
end

subplot(1, 2, 2); 
pie_data_2 = pie(sector_weights_Sharpe_BL);
colormap(colors); 

for i = 1:numel(pie_data_2)/2
    pie_data_2(2*i-1).FaceColor = colors(i,:);
end
title('Max Sharpe B-L');

textObjs_2 = findobj(pie_data_2, 'Type', 'text');
for i = 1:numel(textObjs_2)
    textObjs_2(i).Visible = 'off';
end

% Create a single legend for both pie charts
legend(unique(asset_sectors), 'Orientation', 'vertical', 'Location', 'southoutside');

%% Plot of the 2 frontiers
%let's confront the previous frontier with the one under B-L


f = figure();
% frontier with ptf A and B
plot(ptfMVP_BL_Risk, ptfMVP_BL_Retn, 'LineWidth', 2);%bl frontier
hold on;
grid on;
plot(vol_MVP_BL, Ret_MVP_BL, 'o', 'MarkerSize', 8, 'LineWidth', 2);%bl mvp
plot(vol_Sharpe_BL, Ret_Sharpe_BL, '*', 'MarkerSize', 8, 'LineWidth', 2);%bl msrp

%new frontier with ptf I and L
plot(pfMVP_Risk, pfMVP_Retn, 'LineWidth', 2);%frontier
plot(vol_MVP, Ret_MVP, 'o', 'MarkerSize', 8, 'LineWidth', 2);%mvp
plot(vol_Sharpe, Ret_Sharpe, '*', 'MarkerSize', 8, 'LineWidth', 2); %msrp
title('Black Litterman efficient Portfolio Frontier');
ylabel('Expected Return');
xlabel('Volatility');
legend('Portfolio Frontier BL', 'MVP BL','Max Sharpe BL',...
    'Portfolio Frontier', 'MVP','Max Sharpe','Location','best');