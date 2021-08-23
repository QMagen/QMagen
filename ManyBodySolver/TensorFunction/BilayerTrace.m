function [ LnZ ] = BilayerTrace( rho )
%BILAYERTRACE Summary of this function goes here
%   Detailed explanation goes here

crho = rho;
for i = 1:1:length(rho.A)
    crho.A{i} = conj(crho.A{i});
end
T = contract(rho.A{1}, [2,3], crho.A{1}, [2,3]);
for i = 2:1:(length(rho.A)-1)
    T = contract(T, 1, rho.A{i}, 1);
    T = contract(T, [1,3,4], crho.A{i}, [1,3,4]);
end
T = contract(T, 1, rho.A{end}, 1);
T = contract(T, [1,2,3], crho.A{end}, [1,2,3]);
LnZ = 2 * rho.lgnorm + log(T);
end

