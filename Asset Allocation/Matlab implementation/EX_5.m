%% Maximum diversified and maximum entropy portfolios

% Find indices of assets belonging to the sector 'Materials' and 'Energy'
MaterialsIndices = strcmp(table_sectors.Sector, 'Materials');
EnergyIndices    = strcmp(table_sectors.Sector, 'Energy');

%% Specify constraints
options = optimoptions(@fmincon,'MaxFunctionEvaluations', 1e8);

% Initial conditions
w_0 = ones(101, 1)/101;

% Standard constraints
A   = [];
b   = [];
Aeq = ones(1, 101);
beq = 1;
lb  = zeros(101, 1);
ub  = ones(101, 1);

% Additional constraints on companies in the 
% sectors 'Materials' or 'Energy'
lb(MaterialsIndices) = 0.003;
ub(MaterialsIndices) = 0.01;

lb(EnergyIndices) = 0.001;
ub(EnergyIndices) = 0.03;

%% Compute portfolios
% Maximum Entropy portfolio - Portfolio N
Port_N = fmincon(@(x) - getEntropy(x, CovMatrix), w_0, A, b, Aeq, beq, lb, ub, [], options);

% Maximum Diversified portfolio - Portfolio M
Port_M = fmincon(@(x) - log(getDR(x, CovMatrix)), w_0, A, b, Aeq, beq, lb, ub, [], options);

