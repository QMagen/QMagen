function [ beta, T ] = Tem_cal( Para )

beta = zeros(Para.N_max, 1);
T = zeros(Para.N_max, 1);
for i = 1:1:length(beta)
    beta(i) = 2 * Para.tau * i;
end
T = 1 ./ beta;

end

