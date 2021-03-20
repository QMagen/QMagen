function [ Ta, Lb, Tb, Ns ] = EvoRG( La, Ta, Lb, Tb, Uab, Para )
% function [ La, Ta, Lb, Tb ] = EvoRG( La, Ta, Lb, Tb, Uab, Para )
D = length(La(:,1));

T = contract(La, 2, Ta, 1);
T = contract(T, 2, Lb, 1, [1,4,2,3]);
T = contract(T, 2, Tb, 1);
T = contract(T, 4, La, 1, [1,2,3,6,4,5]);
Uab = reshape(Uab, [Para.d,Para.d,Para.d,Para.d]);
T = contract(Uab, [3,4], T, [2,5], [3,1,4,5,2,6]);
T = reshape(T, [D * Para.d^2, D * Para.d^2]);
[U, S, V, ~, ~] = svdT(T, 'Nkeep', Para.D_max, 'epsilon', 1e-8);
Dp = length(S);
Ns = norm(diag(S));
Lb = diag(S) / Ns;
U = reshape(U, [D,Para.d,Para.d,Dp]);
U = permute(U, [1,4,2,3]);
V = reshape(V, [Dp,D,Para.d,Para.d]);
Ta = contract(La^(-1), 2, U, 1);
Tb = contract(V, 2, La^(-1), 1, [1,4,2,3]);

end

