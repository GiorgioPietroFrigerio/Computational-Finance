%% Maximum Expected Shortfall - modified Sharpe Ratio portfolio

alpha = 0.95;
fun   = @(x) - getModifiedSharpeRatio(x, LogRet, alpha);

% standard constraints
x0  = rand(size(LogRet,2),1);   % Starting Point 
x0  = x0./sum(x0);              % Normalization   
lb  = zeros(1, size(LogRet,2)); % Lower Bound
ub  = ones(1, size(LogRet,2));  % Upper Bound 
Aeq = ones(1, size(LogRet,2));  % Aeq constraint (according to fmincon sintax)
beq = 1;                        % beq constraint (according to fmincon sintax)

% optimization 
options = optimoptions('fmincon', 'MaxFunctionEvaluations', 16000);
Port_Q  = fmincon(fun, x0, [], [], Aeq, beq, lb, ub, [], options);
