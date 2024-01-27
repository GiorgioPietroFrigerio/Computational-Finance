%% Robust frontier

% number of simulations
N = 50;            

% weights initialization 
weights_MVP_matrix        = zeros(size(LogRet,2), N);
weights_sharpe_matrix     = zeros(size(LogRet,2), N);
weights_MVP_con_matrix    = zeros(size(LogRet,2), N);
weights_sharpe_con_matrix = zeros(size(LogRet,2), N);

for n = 1 : N
    R = mvnrnd(ExpRet, CovMatrix, length(LogRet));
    NewExpRet = mean(R);
    NewCov = cov(R);
    Psim = setAssetMoments(p, NewExpRet, NewCov);
    Psim_con = setAssetMoments(p_con, NewExpRet, NewCov);
    w_sim = estimateFrontier(Psim, 100);
    w_sim_con = estimateFrontier(Psim_con, 100);
    [pf_riskSim, pf_RetSim] = estimatePortMoments(Psim, w_sim);
    [pf_riskSim_con, pf_RetSim_con] = estimatePortMoments(Psim_con, w_sim_con);
    [vol_MVP_rob, indexMV_rob] = min(pf_riskSim);
    weights_MVP_rob = w_sim(:,indexMV_rob);
    weights_MVP_matrix(:, n) = weights_MVP_rob;
    [vol_MVP_con_rob, indexMV_con_rob] = min(pf_riskSim_con);
    weights_MVP_con_rob = w_sim_con(:,indexMV_con_rob);
    weights_MVP_con_matrix(:, n) = weights_MVP_con_rob;
    weights_Sharpe_rob = estimateMaxSharpeRatio(Psim, 'Method', 'iterative');
    weights_Sharpe_con_rob = estimateMaxSharpeRatio(Psim_con, 'Method', 'iterative');
    weights_sharpe_matrix(:, n) = weights_Sharpe_rob;
    weights_sharpe_con_matrix(:, n) = weights_Sharpe_con_rob;
end

% Minimum variance portfolio - Portfolio E
Port_E = mean(weights_MVP_matrix, 2);

% Minimum variance portfolio - Portfolio F
Port_F = mean(weights_MVP_con_matrix, 2);

% Max Sharpe ratio Portfolio - Portfolio G
Port_G = mean(weights_sharpe_matrix, 2);

% Max Sharpe ratio Portfolio - Portfolio H
Port_H = mean(weights_sharpe_con_matrix, 2);
