function [ C ] = ProdMPS( MPSA, MPOB )
%PRODMPO Summary of this function goes here
%   Detailed explanation goes here

len = length(MPSA);
C = cell(len, 1);
C{1} = contract(MPSA{1}, 2, MPOB{1}, 3);
Csize = size(C{1});
C{1} = reshape(C{1}, [Csize(1) * Csize(2), Csize(3)]);
for i = 2:1:(len-1)
    C{i} = contract(MPSA{i}, 3, MPOB{i}, 4, [1,3,2,4,5]);
    Csize = size(C{i});
    C{i} = reshape(C{i}, [Csize(1) * Csize(2), Csize(3) * Csize(4), Csize(5)]);
end
C{len} = contract(MPSA{len}, 2, MPOB{len}, 3);
Csize = size(C{len});
C{len} = reshape(C{len}, [Csize(1) * Csize(2), Csize(3)]);
end

