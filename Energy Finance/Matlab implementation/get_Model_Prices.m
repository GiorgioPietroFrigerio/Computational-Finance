function model_prices = get_Model_Prices(F0, strike, disc, ...
                                         tenor, p, Npow, A)

% function which computes the model prices starting from an implied
% volatility surface with certain strikes and tenors
%
% INPUT: 
% F0:          Initial Underlying Price 
% strike:      Vector of strikes 
% disc:        Vector of discount factors
% tenor:       Vector of tenors 
% p:           Model Parameters
% Npow:        Discretization Parameter
% A:           Discretization Parameter
%
% OUTPUT: 
% black_price: Black prices surface 

model_prices = zeros(length(tenor), length(strike));

for i = 1:length(tenor)
    model_prices(i,:) = FFT_CM_Call_NIG(strike, tenor(i), F0, disc(i), p, Npow, A);
end

model_prices = model_prices(:);

end