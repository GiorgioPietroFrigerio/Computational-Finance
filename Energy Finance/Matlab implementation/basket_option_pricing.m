% Pricing of the basket option

%% Parameters
Strike_2027   = 300;
ttm_2027_no_business = 1;
maturity_2027 = busdate(addtodate(today - 1,ttm_2027_no_business,'year'));
ttm_2027 = yearfrac(today,maturity_2027,3); % act/365 convention

% single set of parameters
sigma_2027 = params2_2027(1);
theta_2027 = params2_2027(2);
k_2027 = params2_2027(3);
Y_2027 = params2_2027(4);
Npow = 18;
A = 1000;

%% Closed formula pricing 
r_ttm_2027 = interp1(year_frac, r, ttm_2027);
B_ttm_2027 = exp(-r_ttm_2027.*ttm_2027);
Price_2027_closed = FFT_CM_Call_NIG(Strike_2027, ttm_2027, max(F0_2025,F0_2027), B_ttm_2027, params2_2027, Npow, A);

%% Monte Carlo simulation

% Monte Carlo parameters
seed = 4;
rng(seed);
N_MC = 1e06;
N_discr = 100;

% Inverse Gaussian parameters
time_step = ttm_2027/N_discr;
time_vector = time_step:time_step:ttm_2027;
mu = time_step;
lambda = time_step^2/k_2027;

% Simulating independent inverse Gaussian random variables
g = randn(N_MC,N_discr);  % gaussian 
chi = g.^2;               % chi squared
u = rand(N_MC,N_discr);   % uniform  
delta_s = mu + mu^2.*chi/(2*lambda) - mu/(2*lambda).*sqrt(4*mu*lambda.*chi + mu^2*chi.^2);
delta_s = delta_s.*(u <= mu./(delta_s + mu)) + mu^2./delta_s.*(u > mu./(delta_s + mu));    % inverse gaussian

% Simulating NIG
N = randn(N_MC,N_discr); % gaussian distribution
delta_J = sigma_2027.*N.*sqrt(delta_s) + theta_2027*delta_s;
J = cumsum(delta_J,2);

% Drift
drift = -1/k_2027*(1 - sqrt(1 - 2*Y_2027*theta_2027*k_2027 - Y_2027^2*sigma_2027^2*k_2027))*time_vector;

% Evolution of the swap
F_2027 = max(F0_2025,F0_2027)*exp(drift + Y_2027*J);

%% Monte Carlo pricing
Payoff_2027 = max(F_2027(:,end) - Strike_2027,0);
[Price_2027_MC,~,CI_2027,~] = normfit(B_ttm_2027*Payoff_2027);

