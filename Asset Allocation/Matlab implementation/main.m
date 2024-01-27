clc
clear
close all
seed = 0;
rng(seed);

%% Part A -> In sample computations
%% Upload data
prices_file  = 'prices_fin.xlsx';
table_prices = readtable(prices_file);

sector_file   = 'sectors_fin.xlsx';
table_sectors = readtable(sector_file);

market_cap_file = 'market_cap_fin';
table_mkt_cap   = readtable(market_cap_file);

%% Transform prices from table to timetable
dt     = table_prices(:,1).Variables;
prices = table_prices(:,2:end).Variables;
names  = table_prices.Properties.VariableNames(2:end);

myPrice_dt = array2timetable(prices, 'RowTimes', dt, 'VariableNames', names);

%% Selection of a subset of Dates -> Training set
start_date = datetime('11/05/2021', 'InputFormat', 'dd/MM/yyyy'); 
end_date   = datetime('11/05/2022', 'InputFormat', 'dd/MM/yyyy');

rng = timerange(start_date, end_date, 'closed'); 
subsample = myPrice_dt(rng, :);

% prices and dates on the training set
prices_val = subsample.Variables;
dates      = subsample.Time;

%% Compute returns on the training set
LogRet    = tick2ret(prices_val, 'Method', 'Continuous');
ExpRet    = mean(LogRet);
CovMatrix = cov(LogRet);

%% 1 - Efficient frontier under standard constraints
EX_1;

%% 2 - Efficient frontier under additional constraints
EX_2;

%% 3 - Robust frontier
EX_3

%% 4 - Black-Litterman model
EX_4;

%% 5 - Maximum diversified and maximum entropy portfolios
EX_5;

%% 6 - PCA
EX_6;

%% 7 - Maximum Expected Shortfall-modified Sharpe Ratio portfolio
EX_7;

%% 8 - In sample performance and risk metrics
% Equally Weighted Portfolio
Port_EW = ones(length(Port_Q),1)/length(Port_Q);

% return on the training set
ret = prices_val(2:end,:)./prices_val(1:end-1,:);

EX_8;

%% Part B -> out of sample performance and risk metrics
%% Selection of a subset of Dates -> Test set on which we compare performances
start_date_test = datetime('12/05/2022', 'InputFormat', 'dd/MM/yyyy'); 
end_date_test   = datetime('12/05/2023', 'InputFormat', 'dd/MM/yyyy');

rng_test = timerange(start_date_test, end_date_test, 'closed'); 
subsample_test = myPrice_dt(rng_test, :);

% prices and dates of the test set
prices_val_test = subsample_test.Variables;
dates_test = subsample_test.Time;

% returns on the test set
ret_test = prices_val_test(2:end,:)./prices_val_test(1:end-1,:);

% log returns on the test set
LogRet_test = tick2ret(prices_val_test, 'Method', 'Continuous');

%% comparison for Part B
Part_B;
