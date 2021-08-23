function [ C ] = DircSumMPO( A, B, varargin )
% function [ C ] = DircSumMPO( A, B, varargin )
% The last two indices of A{i} & B{i} should be the physical indices.
% C = varargin{1}(1) * A + varargin{1}(2) * B
% Yuan Gao@buaa 2020.12.02
% mail: 17231064@buaa.edu.cn

if ~isempty(varargin)
    A{1} = A{1} * varargin{1}(1);
    B{1} = B{1} * varargin{1}(2);
end

if length(A) ~= length(B)
    warning('Inputs MPO have different size!');
end

C = A;
for i = 1:1:length(A)
    Asize = size(A{i});
    Bsize = size(B{i});

    if length(Asize) ~= length(Bsize) || Asize(end) ~= Bsize(end) || Asize(end-1) ~= Bsize(end-1)
        warning('Inputs tensors have different size!');
    end

    if length(Asize) == 3
        C{i} = zeros([Asize(1) + Bsize(1), Asize(2), Asize(3)]);
        C{i}(1:1:Asize(1),:,:) = A{i};
        C{i}((Asize(1)+1):1:end,:,:) = B{i};
    else
        C{i} = zeros([Asize(1) + Bsize(1), Asize(2) + Bsize(2), Asize(3), Asize(4)]);
        C{i}(1:1:Asize(1),1:1:Asize(2),:,:) = A{i};
        C{i}((Asize(1)+1):1:end,(Asize(2)+1):1:end,:,:)=B{i};
    end
end
end

