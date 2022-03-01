function [ Ta, Tb, La, Lb ] = InitId( Para )
% function [ Ta, Tb, La, Lb ] = InitId( Para )
% Initialize the unit tensor.
La = 1;
Lb = 1;
Ta = eye(Para.d);
Ta = reshape(Ta, [1,1,Para.d,Para.d]);
Tb = eye(Para.d);
Tb = reshape(Tb, [1,1,Para.d,Para.d]);
end

