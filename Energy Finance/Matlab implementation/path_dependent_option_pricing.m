% Pricing of the path dependent option

%% Parameters
Strike_2025   = 300;
ttm_2025_no_business = 1;
maturity_2025 = busdate(addtodate(today - 1,ttm_2025_no_business,'year'));
ttm_2025 = yearfrac(today,maturity_2025,3); % act/365 convention
sigma_2025  = params2_2025(1);
theta_2025  = params2_2025(2);
k_2025      = params2_2025(3);
Y_2025      = params2_2025(4);

%% MC Simulation

% Monte Carlo parameters
seed = 4;
rng(seed);
N_MC = 1e06;
N_discr = 100;

% Inverse Gaussian parameters
time_step = ttm_2025/N_discr;
time_vector = time_step:time_step:ttm_2025;
mu = time_step;
lambda = time_step^2/k_2025;

% Simulating independent inverse Gaussian random variables
g = randn(N_MC,N_discr);  % gaussian 
chi = g.^2;               % chi squared
u = rand(N_MC,N_discr);   % uniform  
delta_s = mu + mu^2.*chi/(2*lambda) - mu/(2*lambda).*sqrt(4*mu*lambda.*chi + mu^2*chi.^2);
delta_s = delta_s.*(u <= mu./(delta_s + mu)) + mu^2./delta_s.*(u > mu./(delta_s + mu)); % inverse gaussian

% Simulating NIG
N = randn(N_MC,N_discr); % gaussian distribution
delta_J = sigma_2025.*N.*sqrt(delta_s) + theta_2025*delta_s;
delta_J_AV = -sigma_2025.*N.*sqrt(delta_s) + theta_2025*delta_s;
J = cumsum(delta_J,2);
J_AV = cumsum(delta_J_AV,2);

% Drift
drift = -1/k_2025*(1 - sqrt(1 - 2*Y_2025*theta_2025*k_2025 - Y_2025^2*sigma_2025^2*k_2025))*time_vector;

% Evolution of the swap
F_2025 = F0_2025*exp(drift + Y_2025*J);
F_2025_AV = F0_2025*exp(drift + Y_2025*J_AV);

%% Pricing
F_2025_max = max(F_2025,[],2);
F_2025_max_AV = max(F_2025_AV,[],2);
Payoff_2025 = max(F_2025_max - Strike_2025,0);
Payoff_2025_AV = max(F_2025_max_AV - Strike_2025,0);
r_ttm_2025 = interp1(year_frac, r, ttm_2025);
B_ttm_2025 = exp(-r_ttm_2025.*ttm_2025);
[Price_2025,~,CI_2025,~] = normfit(B_ttm_2025*(Payoff_2025 + Payoff_2025_AV)/2);
