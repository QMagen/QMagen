function [ Gtau ] = CorFunc( Para, MPS_e, Ham )
%COFUN Summary of this function goes here
%   Detailed explanation goes here
[Sx, Sy, Sz, ~] = SpinOp(Para.d);
lgnorm = MPS_e{1}.lgnorm;

switch Para.O1_type
    case 'Sx'
        O1 = Sx;
    case 'Sy'
        O1 = Sy;
    case 'Sz'
        O1 = Sz;
end

switch Para.O2_type
    case 'Sx'
        O2 = Sx;
    case 'Sy'
        O2 = Sy;
    case 'Sz'
        O2 = Sz;
end

% // method 1 =============================================================
% all to all correlation function Gtau
Gtau = zeros(Para.L, Para.L, length(Para.tau) + 1);
for O2_pos = 1:1:Para.L
    TSO = MPS_e{1};
    sizeTSO = size(TSO.A{O2_pos});
    TSO.A{O2_pos} = contract(TSO.A{O2_pos}, length(sizeTSO), O2, 2);
    [ Gtaui ] = EVOIm_betaL_IP( Para, TSO, Ham, MPS_e, O1 );
    Gtau(O2_pos, :, :) = Gtaui(:,:,1) .* exp(Gtaui(:,:,2) - 2 * lgnorm);
end
end

% function [ Gqtau ] = Ftran1D(Para, Grtau)
% n = 0:1:floor(Para.L/2);
% Gqtau = zeros(length(n), length(Para.tau) + 1);
% r = (1:1:Para.L) - Para.O2_pos;
% for j = 1:1:(length(Para.tau) + 1)
%     for i = 1:1:length(n)
%         Gqtau(i,j) = sum(transp(Grtau(:,j)) .* exp(1i * r * pi * 2 * n(i) / Para.L));
%     end
% end
% end
