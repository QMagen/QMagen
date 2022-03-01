function [ U, S, V, t_error_relative, entropy ] = svdT( A, varargin )
% function [ U, S, V, truncation error, relative trunction error ] = svdT(A, varargin)
% U * diag(S) * V = A
% varargin = {'Nkeep', D_max, 'epsilon', epsilon}
% Yuan Gao@buaa 2020.12.02
% mail: 17231064@buaa.edu.cn
% SVDT for test
try
    [U, S, V] = svd(A, 'econ');
catch
    [U, S, V] = svd_lapack(A, 'econ', 'gesvd');
end
 
if isnan(norm(U))
    [U, S, V] = svd_lapack(A, 'econ', 'gesvd');
end 

S = diag(S);
ns = norm(S);
t_error_relative = 0;

if ~isempty(varargin)
    D_max = length(S);
    epsilon = 0;
    switch varargin{1}
        case 'Nkeep'
            D_max = min(D_max, varargin{2});
        case 'epsilon'
            epsilon = varargin{2};
    end
    if length(varargin) == 4
        switch varargin{3}
            case 'Nkeep'
                D_max = min(D_max, varargin{4});
            case 'epsilon'
                epsilon = varargin{4};
        end
    end
    if ~isempty(find(S<epsilon, 1))
        D_max = min(find(S/ns<epsilon)-1, D_max);
        % D_max = min(find(S<epsilon)-1, D_max);
    end
    Sp = S;
    Sp = Sp/norm(Sp);
    S = S(1:1:D_max);
    t_error_relative = sum(Sp((D_max+1):1:end).^2);
    entropy = -sum(Sp.^2 .* log(Sp.^2));
    U = U(:,1:1:D_max);
    V = V(:,1:1:D_max);
    % fprintf('%g\n', t_error_relative)
end
V = V';
end

