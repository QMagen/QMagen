function [ H ] = MPS2V( MPO )

len = length(MPO);
T = MPO{1};
for i = 2:1:len
    T = contract(MPO{i}, 1, T, 1);
end
T = permute(T, len:-1:1);
H = reshape(T, [2^len, 1]);
end

