% Swap prices
F0 = xlsread('DataFREEX.xlsx', 1, 'D1:D21');

% black implied volatilities for 2025 and 2027 French options
vol_2025    = xlsread('DataFREEX.xlsx', 2, 'C2:W8' );
vol_2027    = xlsread('DataFREEX.xlsx', 3, 'C2:W12');

% strikes for 2025 and 2027 French options
strike_2025 = xlsread('DataFREEX.xlsx', 2, 'C1:W1' );
strike_2027 = xlsread('DataFREEX.xlsx', 3, 'C1:W1' );

% tenors for 2025 and 2027 French options
tenor_2025  = xlsread('DataFREEX.xlsx', 2, 'B2:B8' );
tenor_2027  = xlsread('DataFREEX.xlsx', 3, 'B2:B12');

% Discount Factors 
dates       = xlsread('DataFREEX.xlsx', 4, 'A1:T1', 'basic') + 693960; % Excel Issues
B           = xlsread('DataFREEX.xlsx', 4, 'A2:T2' );
