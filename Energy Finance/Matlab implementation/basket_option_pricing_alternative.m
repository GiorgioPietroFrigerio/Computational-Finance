% Alternative pricing of the basket option

%% 2 sets of parameters

% first swap parameters
sigma_2025 = params2_2025(1);
theta_2025 = params2_2025(2);
k_2025 = params2_2025(3);
Y_2025 = params2_2025(4);

% second swap parameters
sigma_2027 = params2_2027_alternative(1);
theta_2027 = params2_2027_alternative(2);
k_2027 = params2_2027_alternative(3);
Y_2027 = params2_2027_alternative(4);

%% Monte Carlo simulation

% Monte Carlo parameters
seed = 4;
rng(seed);
N_MC = 1e06;
N_discr = 100;

% Inverse Gaussian parameters
lambda_1 = time_step^2/k_2025;
lambda_2 = time_step^2/k_2027;

% Simulating independent inverse Gaussian random variables
g_1 = randn(N_MC,N_discr);  % gaussian 
g_2 = randn(N_MC,N_discr);  % gaussian 
chi_1 = g_1.^2;             % chi squared
chi_2 = g_2.^2;             % chi squared
u_1 = rand(N_MC,N_discr);   % uniform  
u_2 = rand(N_MC,N_discr);   % uniform 
delta_s_1 = mu + mu^2.*chi_1/(2*lambda_1) - mu/(2*lambda_1).*sqrt(4*mu*lambda_1.*chi_1 + mu^2*chi_1.^2);
delta_s_2 = mu + mu^2.*chi_2/(2*lambda_2) - mu/(2*lambda_2).*sqrt(4*mu*lambda_2.*chi_2 + mu^2*chi_2.^2);
delta_s_1 = delta_s_1.*(u_1 <= mu./(delta_s_1 + mu)) + mu^2./delta_s_1.*(u_1 > mu./(delta_s_1 + mu)); % inverse gaussian
delta_s_2 = delta_s_2.*(u_2 <= mu./(delta_s_2 + mu)) + mu^2./delta_s_2.*(u_2 > mu./(delta_s_2 + mu)); % inverse gaussian

% Simulating NIG
N_1 = randn(N_MC,N_discr); % gaussian distribution
N_2 = randn(N_MC,N_discr); % gaussian distribution
delta_J_1 = sigma_2025.*N_1.*sqrt(delta_s_1) + theta_2025*delta_s_1;
delta_J_1_AV = -sigma_2025.*N_1.*sqrt(delta_s_1) + theta_2025*delta_s_1;
delta_J_2 = sigma_2027.*N_2.*sqrt(delta_s_2) + theta_2027*delta_s_2;
delta_J_2_AV = -sigma_2027.*N_2.*sqrt(delta_s_2) + theta_2027*delta_s_2;
J_1 = cumsum(delta_J_1,2);
J_1_AV = cumsum(delta_J_1_AV,2);
J_2 = cumsum(delta_J_2,2);
J_2_AV = cumsum(delta_J_2_AV,2);

% Drift
drift_1 = -1/k_2025*(1 - sqrt(1 - 2*Y_2025*theta_2025*k_2025 - Y_2025^2*sigma_2025^2*k_2025))*time_vector;
drift_2 = -1/k_2027*(1 - sqrt(1 - 2*Y_2027*theta_2027*k_2027 - Y_2027^2*sigma_2027^2*k_2027))*time_vector;

% Evolution of the swaps
F_2025 = F0_2025*exp(drift_1 + Y_2025*J_1);
F_2025_AV = F0_2025*exp(drift_1 + Y_2025*J_1_AV);
F_2027 = F0_2027*exp(drift_2 + Y_2027*J_2);
F_2027_AV = F0_2027*exp(drift_2 + Y_2027*J_2_AV);

%% Monte Carlo pricing 
Payoff_2027_alternative = max(max(F_2025(:,end),F_2027(:,end)) - Strike_2027,0);
Payoff_2027_alternative_AV = max(max(F_2025_AV(:,end),F_2027_AV(:,end)) - Strike_2027,0);
[Price_2027_MC_alternative,~,CI_2027_alternative,~] = normfit(B_ttm_2027*(Payoff_2027_alternative + Payoff_2027_alternative_AV)/2);