function DR = getDR(w, CovMatrix)

    % Calculates the diversification rate to be maximised
    sigma_p = sqrt((w'*CovMatrix*w)); 
    sigma   = sqrt(diag(CovMatrix));
    DR      = (w'*sigma)/sigma_p;
    
end