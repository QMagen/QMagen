function [ T, M, chi ] = ED_chi( H, M, h, beta_list)
[U, ES] = eig(H);                   
ES = diag(ES);                   
ESF = ES - min(ES);

Mnn = diag(U' * M * U); 


beta = beta_list;
Nb = numel(beta);
T = zeros(Nb, 1);      
M = zeros(Nb, 1);
chi = zeros(Nb, 1);

for it = 1:1:Nb
    T(it) = 1/beta(it);
    Z = sum(exp(-beta(it) .* ESF));
    M(it) = sum(Mnn .* exp(-beta(it).*ESF))/Z;
    chi(it) = real(M(it)/h);
end

end