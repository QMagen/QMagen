function [ T ] = InnerProdMPS(MPSA, MPSB)
% res = InnerProd(A, B)
% C = <B|A>;
T = contract(MPSA{1}, 2, conj(MPSB{1}), 2);
for i = 2:1:(length(MPSA)-1)
    T = contract(T, 1, MPSA{i}, 1);
    T = contract(T, [1,3], conj(MPSB{i}), [1,3]);
end
T = contract(T, 1, MPSA{end}, 1);
T = contract(T, [1,2], conj(MPSB{end}), [1,2]);

end
