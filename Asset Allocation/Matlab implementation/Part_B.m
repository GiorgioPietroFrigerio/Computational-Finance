%% Out of sample performance and risk metrics

[evolution_EW, annRet_EW, annVol_EW, Sharpe_EW, MaxDD_EW, Calmar_EW, Entropy_EW, DR_EW] = get_metrics(Port_EW, ret_test, LogRet_test);

[evolution_A, annRet_A, annVol_A, Sharpe_A, MaxDD_A, Calmar_A, Entropy_A, DR_A] = get_metrics(Port_A, ret_test, LogRet_test);
[evolution_B, annRet_B, annVol_B, Sharpe_B, MaxDD_B, Calmar_B, Entropy_B, DR_B] = get_metrics(Port_B, ret_test, LogRet_test);
[evolution_C, annRet_C, annVol_C, Sharpe_C, MaxDD_C, Calmar_C, Entropy_C, DR_C] = get_metrics(Port_C, ret_test, LogRet_test);
[evolution_D, annRet_D, annVol_D, Sharpe_D, MaxDD_D, Calmar_D, Entropy_D, DR_D] = get_metrics(Port_D, ret_test, LogRet_test);
[evolution_E, annRet_E, annVol_E, Sharpe_E, MaxDD_E, Calmar_E, Entropy_E, DR_E] = get_metrics(Port_E, ret_test, LogRet_test);
[evolution_F, annRet_F, annVol_F, Sharpe_F, MaxDD_F, Calmar_F, Entropy_F, DR_F] = get_metrics(Port_F, ret_test, LogRet_test);
[evolution_G, annRet_G, annVol_G, Sharpe_G, MaxDD_G, Calmar_G, Entropy_G, DR_G] = get_metrics(Port_G, ret_test, LogRet_test);
[evolution_H, annRet_H, annVol_H, Sharpe_H, MaxDD_H, Calmar_H, Entropy_H, DR_H] = get_metrics(Port_H, ret_test, LogRet_test);
[evolution_I, annRet_I, annVol_I, Sharpe_I, MaxDD_I, Calmar_I, Entropy_I, DR_I] = get_metrics(Port_I, ret_test, LogRet_test);
[evolution_L, annRet_L, annVol_L, Sharpe_L, MaxDD_L, Calmar_L, Entropy_L, DR_L] = get_metrics(Port_L, ret_test, LogRet_test);
[evolution_M, annRet_M, annVol_M, Sharpe_M, MaxDD_M, Calmar_M, Entropy_M, DR_M] = get_metrics(Port_M, ret_test, LogRet_test);
[evolution_N, annRet_N, annVol_N, Sharpe_N, MaxDD_N, Calmar_N, Entropy_N, DR_N] = get_metrics(Port_N, ret_test, LogRet_test);
[evolution_P, annRet_P, annVol_P, Sharpe_P, MaxDD_P, Calmar_P, Entropy_P, DR_P] = get_metrics(Port_P, ret_test, LogRet_test);
[evolution_Q, annRet_Q, annVol_Q, Sharpe_Q, MaxDD_Q, Calmar_Q, Entropy_Q, DR_Q] = get_metrics(Port_Q, ret_test, LogRet_test);

% TABLE
metrics_EW = [annRet_EW; annVol_EW; Sharpe_EW; MaxDD_EW; Calmar_EW; Entropy_EW; DR_EW];
metrics_A = [annRet_A; annVol_A; Sharpe_A; MaxDD_A; Calmar_A; Entropy_A; DR_A];
metrics_B = [annRet_B; annVol_B; Sharpe_B; MaxDD_B; Calmar_B; Entropy_B; DR_B];
metrics_C = [annRet_C; annVol_C; Sharpe_C; MaxDD_C; Calmar_C; Entropy_C; DR_C];
metrics_D = [annRet_D; annVol_D; Sharpe_D; MaxDD_D; Calmar_D; Entropy_D; DR_D];
metrics_E = [annRet_E; annVol_E; Sharpe_E; MaxDD_E; Calmar_E; Entropy_E; DR_E];
metrics_F = [annRet_F; annVol_F; Sharpe_F; MaxDD_F; Calmar_F; Entropy_F; DR_F];
metrics_G = [annRet_G; annVol_G; Sharpe_G; MaxDD_G; Calmar_G; Entropy_G; DR_G];
metrics_H = [annRet_H; annVol_H; Sharpe_H; MaxDD_H; Calmar_H; Entropy_H; DR_H];
metrics_I = [annRet_I; annVol_I; Sharpe_I; MaxDD_I; Calmar_I; Entropy_I; DR_I];
metrics_L = [annRet_L; annVol_L; Sharpe_L; MaxDD_L; Calmar_L; Entropy_L; DR_L];
metrics_M = [annRet_M; annVol_M; Sharpe_M; MaxDD_M; Calmar_M; Entropy_M; DR_M];
metrics_N = [annRet_N; annVol_N; Sharpe_N; MaxDD_N; Calmar_N; Entropy_N; DR_N];
metrics_P = [annRet_P; annVol_P; Sharpe_P; MaxDD_P; Calmar_P; Entropy_P; DR_P];
metrics_Q = [annRet_Q; annVol_Q; Sharpe_Q; MaxDD_Q; Calmar_Q; Entropy_Q; DR_Q];

metrics = ["Metrics", "AnnRet", " AnnVol", "Sharpe Ratio", "MaxDD", "Calmar Ratio", "Entropy", "Diversification Ratio"];
T = table(metrics_EW, metrics_A, metrics_B, metrics_C, metrics_D, metrics_E, metrics_F, metrics_G, ...
    metrics_H, metrics_I, metrics_L, metrics_M, metrics_N, metrics_P, metrics_Q, ...
    'VariableNames', ["EW", "A", "B", "C", "D", "E", "F", "G", "H", "I","L", ...
    "M", "N", "P", "Q"]);
Tab = rows2vars(T);
allVars = 1:width(Tab);
Tab = renamevars(Tab,allVars,metrics);

%writetable(Tab,'TABLE_B.xlsx');

% plot EX 1
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_A, 'LineWidth', 2);
plot(dates_test(2:end), evolution_B, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','A','B', 'Location','best');

% plot EX 2
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_C, 'LineWidth', 2);
plot(dates_test(2:end), evolution_D, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','C','D', 'Location','best');

% plot EX 3
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_E, 'LineWidth', 2);
plot(dates_test(2:end), evolution_F, 'LineWidth', 2);
plot(dates_test(2:end), evolution_G, 'LineWidth', 2);
plot(dates_test(2:end), evolution_H, 'LineWidth', 2);
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','E','F','G', 'H','Location','best');

% plot EX 4
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_I, 'LineWidth', 2);
plot(dates_test(2:end), evolution_L, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','I','L', 'Location','best');

% plot EX 5
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_M, 'LineWidth', 2);
plot(dates_test(2:end), evolution_N, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','M','N', 'Location','best');

% plot EX 6
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_P, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','P', 'Location','best');

% plot EX 7
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_Q, 'LineWidth', 2);
hold off;
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','Q', 'Location','best');

% PLOT
figure;
plot(dates_test(2:end), evolution_EW, 'LineWidth', 2);
hold on;
grid on;
plot(dates_test(2:end), evolution_A, 'LineWidth', 2);
plot(dates_test(2:end), evolution_B, 'LineWidth', 2);
plot(dates_test(2:end), evolution_C, 'LineWidth', 2);
plot(dates_test(2:end), evolution_D, 'LineWidth', 2);
plot(dates_test(2:end), evolution_E, 'LineWidth', 2);
plot(dates_test(2:end), evolution_F, 'LineWidth', 2);
plot(dates_test(2:end), evolution_G, 'LineWidth', 2);
plot(dates_test(2:end), evolution_H, 'LineWidth', 2);
plot(dates_test(2:end), evolution_I, 'LineWidth', 2);
plot(dates_test(2:end), evolution_L, 'LineWidth', 2);
plot(dates_test(2:end), evolution_M, 'LineWidth', 2);
plot(dates_test(2:end), evolution_N, 'LineWidth', 2);
plot(dates_test(2:end), evolution_P, 'LineWidth', 2);
plot(dates_test(2:end), evolution_Q, 'LineWidth', 2);
title('Portfolios Performance from 2022 to 2023');
ylabel('Portfolio Value %');
xlabel('Dates');
legend('EW','A','B','C','D','E','F','G','H','I','L','M','N','P','Q', 'Location','best');
