clear;
close all;
clc;

%% Import the Data from DataFREEX.xlsx
Data
today = datenum(2023, 11, 4);

%% Calibration on the 2025 French option prices: Point (3)
calibration_2025

%% Pricing of the option at Point (4)
path_dependent_option_pricing

%% Calibration on the 2025 and 2027 French option prices: Point (5)
calibration_2025_2027

%% Pricing of the option at Point (6)
basket_option_pricing

%% Calibration on the 2027 French option prices only
calibration_2027

%% Alternative pricing of the option at Point (6)
basket_option_pricing_alternative
