function [T] = contract(A,I1,B,I2,varargin)
% Input tensors A & B, input contraction index I1 & I2
% I1,2 could be array of equal size
% if I1 & I2 are both empty, it means a full contraction
% Returning T with prescibed index ordering in A & B
% varargin = [I1, I2, I3,..., In], permute the resulting tensor in that order.
 
% YLD 2016/07/24
% Modified by w.li@buaa.edu.cn, 2016/07/24, 08/01.
 
% I1 = [] & I2 = [] means a full contraction
if isempty(I1) && isempty(I2)
    I1 = 1:numel(size(A));
    I2 = 1:numel(size(B));
end
 
if numel(I1) ~= numel(I2)
    warning('Inputs I1, I2 have different length!');   % sizes of I1 & I2 must equal
end
 
DimA=size(A);   % tensor A`s dimension
DimB=size(B);   % tensor B`s dimension 

if eq(DimA(I1),DimB(I2))
    Ia=1:length(DimA);
    Ib=1:length(DimB);
    
    [RstIndA, tIaR, tI1R]=setxor(Ia,I1);    % tIaR, tI1R for temp usage
    if ~isempty(tI1R) || ~isempty(setxor(RstIndA, tIaR))
        warning('I1 indices (partially) not in Ia!');
    end
    Ia=Ia(sort(RstIndA, 'ascend'));         % sort the rest indices of A 
    
    [RstIndB, tIbR, tI2R]=setxor(Ib,I2);    % tIbR, tI2R for temp usage
    if ~isempty(tI2R) || ~isempty(setxor(RstIndB, tIbR))
        warning('I2 indices (partially) not in Ib!');
    end
    Ib=Ib(sort(RstIndB, 'ascend'));         % sort the rest indices of B
    
    A=permute(A,[Ia, I1]);
    B=permute(B,[I2, Ib]);            % permute A & B tensors
    A=reshape(A,[],prod(DimA(I1)));
    B=reshape(B,prod(DimB(I2)),[]);   % reshape two tensors into two matrix
    t=A * B;                          % matrix mutiplication (contraction)
    
    DimAR = DimA(Ia);                % sorted dimensions
    DimBR = DimB(Ib);
    if ~isempty([DimAR, DimBR])
        T = reshape(t, [DimAR, DimBR]);  % reshape T back to a tensor
    else
        T = t;                           % T is just a number
    end
    
    % //permute the order of resulting tensor
    if ~isempty(varargin)
        T = permute(T, varargin{1});
    end
    
else pause
    warning('Indices to be contracted do not match!')
end
end
