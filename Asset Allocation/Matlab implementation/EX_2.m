%% Efficient frontier under additional constraints

% introduce portfolio objects
p_con = Portfolio('AssetList', names);
p_con = setDefaultConstraints(p_con);

% Communication Services weights > 12%
fun_CS   = @(x) strcmpi(x, {'Communication Services'});
logic_CS = cellfun(fun_CS, table_sectors.Sector, 'UniformOutput', false);
logic_CS = double(cell2mat(logic_CS));

% Utilities weights < 10%
fun_U   = @(x) strcmpi(x, {'Utilities'});
logic_U = cellfun(fun_U, table_sectors.Sector, 'UniformOutput', false);
logic_U = double(cell2mat(logic_U));

% weights of companies belonging to sectors composed by less than 5 companies = 0
n = length(table_sectors.Sector);
A_eq = zeros(1,n);
for i = 1 : n
    count = 0;
    for j = 1 : n
        count = count + strcmpi(table_sectors.Sector(i), table_sectors.Sector(j));
    end 
    
    A_eq(i) = (count >= 5);
end

A_ineq = [-logic_CS'; logic_U'];
b_ineq = [-0.12 ; 0.10];
p_con  = setInequality(p_con, A_ineq, b_ineq);
p_con  = setEquality(p_con, A_eq, 1);

Port_moments_con = estimateAssetMoments(p_con, LogRet, 'missingdata', false);
weights_con = estimateFrontier(Port_moments_con, 100);
[pfMVP_Risk_con, pfMVP_Retn_con] = estimatePortMoments(Port_moments_con, weights_con);

% Minimum variance portfolio - Portfolio C
[min_vol_con, indexMV_con] = min(pfMVP_Risk_con); 
Port_C = weights_con(:,indexMV_con);
[vol_MVP_con, Ret_MVP_con] = estimatePortMoments(Port_moments_con, Port_C);

% Max Sharpe ratio Portfolio - Portfolio D
p_con = setAssetMoments(p_con, ExpRet, CovMatrix);
Port_D = estimateMaxSharpeRatio(p_con, 'Method', 'iterative');
[vol_Sharpe_con, Ret_Sharpe_con] = estimatePortMoments(Port_moments_con, Port_D); 

% Display results
h = figure();
plot(pfMVP_Risk_con, pfMVP_Retn_con, 'LineWidth', 2);
hold on;
grid on;
plot(vol_MVP_con, Ret_MVP_con, 'o', 'MarkerSize', 8, 'LineWidth', 2);
plot(vol_Sharpe_con, Ret_Sharpe_con, '*', 'MarkerSize', 8, 'LineWidth', 2);
title('Efficient Portfolio Frontier - additional constraints');
ylabel('Expected Return');
xlabel('Volatility');
legend('Portfolio Frontier', 'MVP','Max Sharpe', 'Location','best');

