function market_prices = get_Market_Prices(F0, strike, r, tenor, vol)

% function which computes the market prices starting from an implied
% volatility surface with certain strikes and tenors
%
% INPUT: 
% F0:          Initial Underlying Price 
% strike:      Vector of strikes 
% r:           Vector of zero-rates
% tenor:       Vector of tenors 
% vol:         Implied volatility surface
%
% OUTPUT: 
% black_price: Black prices surface 

market_prices = zeros(length(tenor), length(strike));

for i = 1:length(tenor)
    market_prices(i,:) = blkprice(F0, strike, r(i), tenor(i), vol(i,:))';
end

market_prices = market_prices(:);

end