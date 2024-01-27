function H = getEntropy(w, CovMatrix)
    % Calculates the Shannon entropy in asset volatility
  
    sigma       = sqrt(diag(CovMatrix));
    
    % Calculate the numerator and denominator using vectorized operations
    numerator   = w.^2 .* sigma.^2;
    denominator = sum(numerator);

    % Calculate H using vectorized operations
    H = - sum((numerator / denominator) .* log(numerator / denominator));
end