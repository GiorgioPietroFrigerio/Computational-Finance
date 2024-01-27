function [evolution, annRet, annVol, Sharpe, MaxDD, Calmar, Entropy, DR] = get_metrics(weights, ret, log_ret)

    % Portfolio Evolution
    equity    = cumprod(ret*weights);
    evolution = 100.*equity/equity(1);

    % Annualized Return
    annRet = (evolution(end)/evolution(1)).^(1/(length(evolution)/252)) - 1;

    % Annualized Volatility
    annVol = std(tick2ret(evolution))*sqrt(252);

    % Sharpe Ratio
    Sharpe = annRet/annVol;

    % Max Drawdown
    dd = zeros(1, length(evolution));
    for i = 1 : length(evolution)
        dd(i) = (evolution(i)/max(evolution(1:i))) - 1;
    end
    MaxDD = min(dd);

    % Calmar
    Calmar = annRet/abs(MaxDD);

    % Entropy
    Entropy = - evolution'*log(evolution);

    % Diversification Ratio
    vola    = std(log_ret);
    V       = cov(log_ret);
    volaPtf = sqrt(weights'*V*weights);
    DR      = (weights'*vola')/volaPtf;

end
