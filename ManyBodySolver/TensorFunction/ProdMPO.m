function [ C ] = ProdMPO( MPOA, MPOB )
%PRODMPO Summary of this function goes here
%   Detailed explanation goes here

len = length(MPOA);
C = cell(len, 1);
C{1} = contract(MPOA{1}, 2, MPOB{1}, 3, [1,3,4,2]);
Csize = size(C{1});
C{1} = reshape(C{1}, [Csize(1) * Csize(2), Csize(3), Csize(4)]);
for i = 2:1:(len-1)
    C{i} = contract(MPOA{i}, 3, MPOB{i}, 4, [1,4,2,5,6,3]);
    Csize = size(C{i});
    C{i} = reshape(C{i}, [Csize(1) * Csize(2), Csize(3) * Csize(4), Csize(5), Csize(6)]);
end
C{len} = contract(MPOA{len}, 2, MPOB{len}, 3, [1,3,4,2]);
Csize = size(C{len});
C{len} = reshape(C{len}, [Csize(1) * Csize(2), Csize(3), Csize(4)]);
end

