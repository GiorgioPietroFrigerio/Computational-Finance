%% Efficient frontier under standard constraints

p = Portfolio('AssetList', names);
p = setDefaultConstraints(p);
Port_moments = estimateAssetMoments(p, LogRet, 'missingdata', false);
weights = estimateFrontier(Port_moments, 100);
[pfMVP_Risk, pfMVP_Retn] = estimatePortMoments(Port_moments, weights);

% Minimum variance portfolio - Portfolio A
[min_vol, indexMV] = min(pfMVP_Risk); 
Port_A = weights(:,indexMV);
[vol_MVP, Ret_MVP] = estimatePortMoments(Port_moments, Port_A);

% Max Sharpe ratio Portfolio - Portfolio B
p = setAssetMoments(p, ExpRet, CovMatrix);
Port_B = estimateMaxSharpeRatio(p, 'Method', 'iterative');
[vol_Sharpe, Ret_Sharpe] = estimatePortMoments(Port_moments, Port_B); 

% Display results
f = figure();
plot(pfMVP_Risk, pfMVP_Retn, 'LineWidth', 2);
hold on;
grid on;
plot(vol_MVP, Ret_MVP, 'o', 'MarkerSize', 8, 'LineWidth', 2);
plot(vol_Sharpe, Ret_Sharpe, '*', 'MarkerSize', 8, 'LineWidth', 2);
title('Efficient Portfolio Frontier');
ylabel('Expected Return');
xlabel('Volatility');
legend('Portfolio Frontier', 'MVP','Max Sharpe', 'Location','best');
