function [c, ceq] = nonLinCon(p)
%
% function which takes as input the model parameters p and gives as output
% the non linear constraints, according to the fmincon syntax
% INPUT:
% p:   model parameters, according to the convention below 
%
%  OUTPUT:
% c:   quantity considered by fmincon as c(p) <= 0
% ceq: quantity considered by fmincon as c(p) = 0

ceq = [];

% Conventions:
% sigma  = p(1);
% theta  = p(2);
% k      = p(3);
% Y      = p(4);

% Constraint: Y^2*sigma^2*k + 2*Y*theta*k - 1 <= 0
c = p(4)^2*p(1)^2*p(3) + 2*p(4)*p(2)*p(3) - 1;

end
