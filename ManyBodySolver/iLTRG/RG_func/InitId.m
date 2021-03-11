function [ Ta, Tb, La, Lb ] = InitId( Para )
% function [ Ta, Tb, La, Lb ] = InitId( Para )
% Initialize the unit tensor.
La = 1;
Lb = 1;
Ta = eye(Para.S);
Ta = reshape(Ta, [1,1,Para.S,Para.S]);
Tb = eye(Para.S);
Tb = reshape(Tb, [1,1,Para.S,Para.S]);
end

