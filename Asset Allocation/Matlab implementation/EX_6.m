%% PCA 

k = 10; % number of principal components 
[factorLoading, factorRetn, latent] = pca(LogRet, 'NumComponents', k); % performs the PCA 

% Total Variance 
ToTVar = sum(latent);

% Explained Variance 
ExplainedVar = latent(1:k)/ToTVar;

% Cumulative Explained Variance 
n_list = 1:10;
CumExplainedVar = cumsum(ExplainedVar); 

% plot
figure
bar(n_list, ExplainedVar);
title('Percentage of Explained Variances for each principal component')
xlabel('Pincipal Components');
ylabel('Percentage of Explained Variance');

% plot 2
figure 
plot(n_list, CumExplainedVar, 'm')
title('Total Percentage of Explained Variances for the first n-components')
hold on
scatter(n_list, CumExplainedVar, 'magenta', 'filled')
grid on
xlabel('Total number of Principal Components')
ylabel('Percentage of Explained Variances')

% reconstruct asset returns
covarFactor      = cov(factorRetn);
reconReturn      = factorRetn*factorLoading' + ExpRet;
unexplainedRetn  = LogRet - reconReturn;
unexplainedCovar = diag(cov(unexplainedRetn));
D                = diag(unexplainedCovar);

%% Optimization max(Ret) under 2 constraints (Standard + Volatility Constraint)

% Function to be optimized 
func = @(x) - ExpRet*x;

% Non Linear Constraints 
non_lin_cons = @(x) nonLinCon_PCA(x, factorLoading, covarFactor, D);

% Standard Constraints 
x0  = rand(size(LogRet,2),1);   % Starting Point 
x0  = x0./sum(x0);              % Normalization   
lb  = zeros(1, size(LogRet,2)); % Lower Bound
ub  = ones(1, size(LogRet,2));  % Upper Bound 
Aeq = ones(1, size(LogRet,2));  % Aeq constraint (according to fmincon sintax)
beq = 1;                        % beq constraint (according to fmincon sintax)

% Optimization 
options = optimoptions('fmincon', 'MaxFunctionEvaluations', 16000);
[Port_P, fval] = fmincon(func, x0, [], [], Aeq, beq, lb, ub, non_lin_cons, options);


