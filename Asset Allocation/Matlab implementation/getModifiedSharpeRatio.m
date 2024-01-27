function Mod_Sharpe = getModifiedSharpeRatio(x, LogRet, alpha)

    % Ann Ret
    ExpRet = mean(LogRet);
    annRet = ExpRet*x;
    
    % VaR 
    pLoss = - LogRet*x;
    VaR  = quantile(pLoss, alpha);
    
    % ES 
    ES = mean(pLoss(pLoss > VaR));
    
    % Sharpe
    Mod_Sharpe = annRet/ES;

end