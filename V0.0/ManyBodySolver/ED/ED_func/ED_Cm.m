function [ T, C, E ] = ED_Cm( H, beta_list )

ESpec = eig(H);                   % energy spectrum
ESpec = real(ESpec);                   % select diagnal part
% save('ESpec.mat', 'ESpec', 'H');
ESpecFix = ESpec - min(ESpec);

beta = beta_list;
Nb = numel(beta);
T = zeros(Nb, 1);        % T
E = zeros(Nb, 1);        % energy
C = zeros(Nb, 1);        % heat capacity
LnZ = zeros(Nb, 1);
F = zeros(Nb, 1);
% dC = zeros(Nb, 1);       % dC/dT
for it = 1:1:Nb
    T(it) = 1/beta(it);
    Z = sum(exp(-beta(it) .* ESpecFix));
    LnZ(it) = log(Z) - beta(it) * min(ESpec);
    F(it) = -1/beta(it) * LnZ(it);
    E(it) = sum(ESpecFix .* exp(-beta(it).*ESpecFix))/Z;
    C(it) = (sum(ESpecFix.^2 .* exp(-beta(it).*ESpecFix))/Z - E(it)^2) * beta(it)^2;
    % dC(it) = - beta(it)^2 * (2 * beta(it) * (1/Z * (sum(ESpecFix.^2 .* exp(-beta(it) .* ESpecFix))) - 1/Z^2 * (sum(ESpecFix .* exp(-beta(it).*ESpecFix)))^2) + beta(it)^2 * (1/Z^2 * sum(ESpecFix .* exp(-beta(it) .* ESpecFix)) * (sum(ESpecFix.^2 .* exp(-beta(it) .* ESpecFix))) + 1/Z * (sum(-ESpecFix.^3 .* exp(-beta(it) .* ESpecFix))) - 2/Z^3 * sum(ESpecFix .* exp(-beta(it) .* ESpecFix)) * (sum(ESpecFix .* exp(-beta(it).*ESpecFix)))^2 - 1/Z^2 * 2 * (sum(ESpecFix .* exp(-beta(it).*ESpecFix))) * (sum(-ESpecFix.^2 .* exp(-beta(it).*ESpecFix)))));
    E(it) = E(it) + min(ESpec);
end
end

