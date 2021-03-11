function [ data ] = InnerProd( rho, A )
% function [ data ] = InnerProd( rho, A )
% data = rho * A * rho^dagger / (rho * rho^dagger)
% Yuan Gao@buaa 2020.12.29
% mail: 17231064@buaa.edu.cn

T = contract(rho.A{1}, 2, A.A{1}, 3);
T = contract(T, [2,4], conj(rho.A{1}), [3,2]);

for i = 2:1:(length(rho.A)-1)
    T = contract(T, 1, rho.A{i}, 1);
    T = contract(T, [1,4], A.A{i}, [1,4]);
    T = contract(T, [1,5,3], conj(rho.A{i}), [1,3,4]);
end

T = contract(T, 1, rho.A{end}, 1);
T = contract(T, [1,3], A.A{end}, [1,3]);
T = contract(T, [1,2,3], conj(rho.A{end}), [1,3,2]);
data = T * exp(A.lgnorm);

end

