function [ H, lgnorm ] = CompressH( H )
len = length(H);
A = zeros(length(H), 1);
for i = 1:1:length(A)
    A(i) = max(size(H{i}));
end
D_max = max(A);

lgnorm = 0;
for i = 1:1:(len-1)
    if i == 1
        T = contract(H{i}, 1, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(2) * sizeA(3), sizeB(2) * sizeB(3) * sizeB(4)]);
        [U, S, V, ~, ~] = svdT(T, 'Nkeep', D_max, 'epsilon', 1e-16);
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U, [sizeA(2), sizeA(3), D]), [3,1,2]);
        H{i+1} = reshape(S * V, [D, sizeB(2), sizeB(3), sizeB(4)]);
    elseif i == len-1
        T = contract(H{i}, 2, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(1) * sizeA(3) * sizeA(4), sizeB(2) * sizeB(3)]);
        [U, S, V, ~, ~] = svdT(T, 'Nkeep', D_max, 'epsilon', 1e-16);
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U, [sizeA(1), sizeA(3), sizeA(4), D]), [1,4,2,3]);
        H{i+1} = reshape(S * V, [D, sizeB(2), sizeB(3)]);
    else
        T = contract(H{i}, 2, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(1) * sizeA(3) * sizeA(4), sizeB(2) * sizeB(3) * sizeB(4)]);
        %tic
        [U, S, V, ~, ~] = svdT(T, 'Nkeep', D_max, 'epsilon', 1e-16);
        %toc
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U, [sizeA(1), sizeA(3), sizeA(4), D]), [1,4,2,3]);
        H{i+1} = reshape(S * V, [D, sizeB(2), sizeB(3), sizeB(4)]);
        % fprintf('%d->-%d\n',i, D)
    end  
end

for i = (len-1):-1:1
    if i == 1
        T = contract(H{i}, 1, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(2) * sizeA(3), sizeB(2) * sizeB(3) * sizeB(4)]);
        [U, S, V, ~, ~] = svdT(T, 'epsilon', 1e-8);
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U * S, [sizeA(2), sizeA(3), D]), [3,1,2]);
        H{i+1} = reshape(V, [D, sizeB(2), sizeB(3), sizeB(4)]);
    elseif i == len-1
        T = contract(H{i}, 2, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(1) * sizeA(3) * sizeA(4), sizeB(2) * sizeB(3)]);
        [U, S, V, ~, ~] = svdT(T, 'epsilon', 1e-8);
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U * S, [sizeA(1), sizeA(3), sizeA(4), D]), [1,4,2,3]);
        H{i+1} = reshape(V, [D, sizeB(2), sizeB(3)]);
    else
        T = contract(H{i}, 2, H{i+1}, 1);
        sizeA = size(H{i});
        sizeB = size(H{i+1});
        T = reshape(T, [sizeA(1) * sizeA(3) * sizeA(4), sizeB(2) * sizeB(3) * sizeB(4)]);
        %tic
        [U, S, V, ~, ~] = svdT(T, 'epsilon', 1e-8);
        %toc
        D = length(S);
        ns = norm(S);
        S = S/ns;
        lgnorm = lgnorm + log(ns);
        S = diag(S);
        H{i} = permute(reshape(U * S, [sizeA(1), sizeA(3), sizeA(4), D]), [1,4,2,3]);
        H{i+1} = reshape(V, [D, sizeB(2), sizeB(3), sizeB(4)]);
        % fprintf('%d-<-%d\n',i, D)
    end 
end
% H{1} = H{1} * exp(lgnorm);
end

