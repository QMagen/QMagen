function [ C_l ] = Cm_cal( LnZ_l, beta_l, Para )

C_l = zeros(Para.N_max, 1);
C_l(1) = 0;
C_l(Para.N_max) = 0;

for i = 2:Para.N_max-1
    C_l(i) = beta_l(i) ^ 2 * (LnZ_l(i-1) + LnZ_l(i+1) - 2 * LnZ_l(i))/(4 * (Para.tau ^ 2));
end

end

