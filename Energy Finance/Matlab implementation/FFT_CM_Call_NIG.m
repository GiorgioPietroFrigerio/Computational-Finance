function Price = FFT_CM_Call_NIG(Strike, T, F0, B, params, Npow, A)

% Price of a Plain Vanilla Call exploiting the Carr-Madan algorithm
% Model: NIG
% 
% INPUT:
% Strike:  Strike price (possibly a vector)
% T:       Time to maturity
% F0:      Initial underlying price 
% B:       Discount factor 
% params:  Model Parameters
% Npow:    Discretization Parameter
% A:       Discretization Parameter
% 
% OUTPUT: 
% Price:   Model Price

% Characteristic function 
sigma  = params(1);
theta  = params(2);
k_IG   = params(3);
Y      = params(4);

% Characteristic Function 
V        = @(v) T*(1/k_IG) * (1 - sqrt(1 + v.^2*sigma^2*k_IG*Y^2 - 2*1i*theta*v*k_IG*Y));
CharFunc = @(v) exp(V(v) - 1i*v*V(-1i));

% discretization parameter
N = 2^Npow;

% v -> compute integral as a summation
eta  = A/N; 
v    = 0:eta:A*(N-1)/N; 
v(1) = 1e-22;

% lambda -> compute summation via FFT
lambda = 2*pi/(N*eta); 
k      = -lambda*N/2+lambda*(0:N-1);
Z_k    = (CharFunc(v-1i)-1)./(1i*v.*(1i*v+1));

% Option Price
w = ones(1,N); w(1)=0.5; w(end)=0.5;
x = w.*eta.*Z_k.*exp(1i*pi*(0:N-1));

z_k = real(fft(x)/pi);
C   = B*F0*( z_k + max(1 - exp(k), 0) );
K   = F0*exp(k);

% Output
index = find( K>0.1*F0 & K<3*F0 );
C     = C(index); 
K     = K(index);
Price = interp1(K, C, Strike, 'spline');

end








