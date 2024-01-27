%%% Calibration of the 2025 options %%%

%% From implied vols to Market (Black) prices 

% compute the maturities
maturities_2025 = arrayfun(@(x) addtodate(today, x, 'month'), 1:length(tenor_2025))';

% compute the discounts and the zero rates 
year_frac = yearfrac(today, dates, 3); % act/365 convention 
r         = - log(B)./year_frac;
r_2025    = interp1(year_frac, r, tenor_2025);
disc_2025 = exp(-r_2025.*tenor_2025);


% initial swap price
F0_2025 = F0(17);

% Market Prices (Black)
market_prices_2025 = get_Market_Prices(F0_2025, strike_2025, r_2025, tenor_2025, vol_2025);

%% Model Prices

% Discretization Parameters 
Npow = 12;
A    = 400;

% Model Parameters p, using the following conventions:
% sigma  = p(1);
% theta  = p(2);
% k      = p(3);
% Y      = p(4);

% Model Prices 
model_prices_2025 = @(p) get_Model_Prices(F0_2025, strike_2025, disc_2025, ...
                                         tenor_2025, p, Npow, A);

%% Calibration 

%  starting point
p0 = [0.19, 0.001, 2.4, 3];

% constraints 
NONLCON = @(p) nonLinCon(p); % for  fmincon 

% distance notions
distance_fmin = @(p) sum(sum(abs(model_prices_2025(p) - market_prices_2025))) ...
                       + (p(4)^2*p(1)^2*p(3) + 2*p(4)*p(2)*p(3) - 1 > 0)*1e16 ...
                       + (p(1) < 0)*1e16 + (p(3) < 0)*1e16; % fmincon/fminsearch
distance_lsq  = @(p) model_prices_2025(p) - market_prices_2025; % lsqnonlin               

% fminsearch
tic
params1_2025 = fminsearch(distance_fmin, p0);
t1_2025 = toc;

% lsqnonlin
tic
params2_2025 = lsqnonlin(distance_lsq, p0);
t2_2025 = toc;

% fmincon
tic
params3_2025 = fmincon(distance_fmin, p0, [], [], [], [], [0, -20, 0, -20], [], NONLCON);
t3_2025 = toc;

% RMSEs 
N  = numel(market_prices_2025);
rmse1 = sqrt(1/N * sum(sum((model_prices_2025(params1_2025) - market_prices_2025).^2)));
rmse2 = sqrt(1/N * sum(sum((model_prices_2025(params2_2025) - market_prices_2025).^2)));
rmse3 = sqrt(1/N * sum(sum((model_prices_2025(params3_2025) - market_prices_2025).^2)));

% print the results
disp('Results: ')
disp(' ')
disp('________________________________________________')
disp('fminsearch parameters: ')
disp(params1_2025)
disp('fminsearch elapsed time: ')
disp(t1_2025)
disp('fminsearch RMSE: ')
disp(rmse1)
disp('________________________________________________')
disp('lsqnonlin parameters: ')
disp(params2_2025)
disp('lsqnonlin elapsed time: ')
disp(t2_2025)
disp('lsqnonlin RMSE: ')
disp(rmse2)
disp('________________________________________________')
disp('fmincon parameters: ')
disp(params3_2025)
disp('fmincon elapsed time: ')
disp(t3_2025)
disp('fmincon RMSE: ')
disp(rmse3)



% Genetic Algorithm 
% distance_ga = @(p) sum(sum(abs(model_prices_2025(p) - market_prices_2025)));
% NONLCON = @(p) nonLinCon(p);
% tic
% [params_ga, err_ga] = ga(distance_ga, 4, [], [], [], [], [], [], NONLCON);
% t_ga = toc;
% rmse_ga = sqrt(1/N * sum(sum((model_prices_2025(params_ga) - market_prices_2025).^2)));
% disp('________________________________________________')
% disp('GA parameters: ')
% disp(params_ga)
% disp('GA elapsed time: ')
% disp(t_ga)
% disp('fmincon RMSE: ')
% disp(rmse_ga)
% disp('________________________________________________')









