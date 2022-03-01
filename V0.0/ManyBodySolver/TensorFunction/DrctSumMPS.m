function [ C ] = DrctSumMPS(MPSA, MPSB, varargin)
% function [X] = DrctSumMPS(X, Y)
% Add MPS X & Y, return it as X
% No varargin: X = X + Y
% With vararg: X = varargin{1} .* X + varargin{2} .* Y
% YGao@buaa, 2020-10-29.

L = numel(MPSA);  
  
% //add coefficients to X & Y
if ~isempty(varargin)
    MPSA{1} = MPSA{1} * varargin{1};
    MPSB{1} = MPSB{1} * varargin{2};
end

if L ~= numel(MPSB) 
    warning('Chain length mismatch! \n'); 
end
C = MPSA;
for i = 1:1:length(MPSA)
    Asize = size(MPSA{i});
    Bsize = size(MPSB{i});

    if length(Asize) ~= length(Bsize) || Asize(end) ~= Bsize(end) || Asize(end-1) ~= Bsize(end-1)
        warning('Inputs tensors have different size!');
    end

    if length(Asize) == 2
        C{i} = zeros([Asize(1) + Bsize(1), Asize(2)]);
        C{i}(1:1:Asize(1),:) = MPSA{i};
        C{i}((Asize(1)+1):1:end,:) = MPSB{i};
    else
        C{i} = zeros([Asize(1) + Bsize(1), Asize(2) + Bsize(2), Asize(3)]);
        C{i}(1:1:Asize(1),1:1:Asize(2),:) = MPSA{i};
        C{i}((Asize(1)+1):1:end,(Asize(2)+1):1:end,:)=MPSB{i};
    end
end

end