function [ M ] = M_cal( LnZ_l_u, LnZ_l_d, beta_l, hnorm, Para )
%M_CAL Summary of this function goes here
%   Detailed explanation goes here
M = zeros(Para.N_max, 1);
for i = 1:1:Para.N_max
    M(i) = 1/beta_l(i) * (LnZ_l_u(i) - LnZ_l_d(i))/(2 * hnorm);
end
end

