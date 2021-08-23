function [ T, E, M ] = ED_M( H, M, h, beta_list)
[U, ES] = eig(H);  
ES = diag(ES);                   
ESF = ES - min(ES);
T = U(:,1);
E = min(ES);
M = T' * M * T;
save('benchmark.mat', 'T', 'E', 'M')
keyboard;
end