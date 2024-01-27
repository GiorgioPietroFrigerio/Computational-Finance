function [c, ceq] = nonLinCon_PCA(x, factorLoading, covarFactor, D)

ceq = [];
c   = ((factorLoading'*x)'*covarFactor*(factorLoading'*x) + x'*D*x) - 0.007^2;

end