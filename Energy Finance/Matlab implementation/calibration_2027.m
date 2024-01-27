%%% Calibration of the 2027 options %%%

%% From implied vols to Market (Black) prices 

% compute the maturities
maturities_2027 = arrayfun(@(x) addtodate(today, x, 'month'), 1:length(tenor_2027))';

% compute the discounts and the zero rates 
r_2027    = interp1(year_frac, r, tenor_2027);
disc_2027 = exp(-r_2027.*tenor_2027);

% initial swap price
F0_2027 = F0(19);

% Market Prices(Black)
market_prices_2027 = get_Market_Prices(F0_2027, strike_2027, r_2027, tenor_2027, vol_2027);

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
model_prices_2027 = @(p) get_Model_Prices(F0_2027, strike_2027, disc_2027, ...
                                         tenor_2027, p, Npow, A);

%% Calibration

%  starting point
p0 = [0.19, 0.001, 2.4, 3];

% constraints 
NONLCON = @(p) nonLinCon(p); % for  fmincon 

% distance notions
distance_fmin = @(p) sum(sum(abs(model_prices_2027(p) - market_prices_2027))) ...
                    + (p(4)^2*p(1)^2*p(3) + 2*p(4)*p(2)*p(3) - 1 > 0)*1e16 ... 
                    + (p(1) < 0)*1e16 + (p(3) < 0)*1e16; % fmincon/fminsearch;
distance_lsq = @(p) model_prices_2027(p) - market_prices_2027;
                 
% fminsearch                
tic
params1_2027_alternative = fminsearch(distance_fmin, p0);
t1_2027 = toc;

% lsqnonlin
options = optimset('MaxFunEval', 10000); % otherwise it stops prematurely 
tic
params2_2027_alternative = lsqnonlin(distance_lsq, p0, [], [], options);
t2_2027 = toc;

% RMSEs 
N  = numel(market_prices_2027);
rmse1 = sqrt( 1/N * sum(sum((model_prices_2027(params1_2027_alternative) - market_prices_2027).^2)) );
rmse2 = sqrt( 1/N * sum(sum((model_prices_2027(params2_2027_alternative) - market_prices_2027).^2)) );

% print the results
disp('Results: ')
disp(' ')
disp('________________________________________________')
disp('fminsearch parameters: ')
disp(params1_2027_alternative)
disp('fminsearch elapsed time: ')
disp(t1_2025)
disp('fminsearch RMSE: ')
disp(rmse1)
disp('________________________________________________')
disp('lsqnonlin parameters: ')
disp(params2_2027_alternative)
disp('lsqnonlin elapsed time: ')
disp(t2_2025)
disp('lsqnonlin RMSE: ')
disp(rmse2)
