function [ C, Ns2 ] = VariProdMPO( Para, MPOA, MPOB )
% function [ C, Ns ] = VariProdMPO( MPOA, MPOB )
% The last two indices of MPOA{i} & MPOB{i} should be the physical indices. 
% C{i} = MPOA{i} * MPOB{i} 
% Yuan Gao@buaa 2021.1.1
% mail: 17231064@buaa.edu.cn

%============Parameter settings==============
max_step = Para.VariProd_step_max;
ep = 1e-8;
%============================================

if length(MPOA) ~= length(MPOB)
    warning('Inputs MPO have different size!');
end
len = length(MPOA);

C = cell(len, 1);
for i = 1:1:len
    C{i} = conj(MPOA{i});
end

EnV = Init_VariProdMPO_EnV(MPOA, MPOB, C);

for i = 1:1:max_step
    
    if i == 1
        D_max = ceil(Para.MCrit/2);
    else
        D_max = Para.MCrit;
    end
    
    for j = 1:1:(len-2)
        [C, Ns1] = two_site_update_VariProdMPO(EnV, C, j, '->-', D_max);
        [ EnV ] = Update_VairProd_EnV(EnV, MPOA, MPOB, C, j, '->-');
    end
    
    for j = len:-1:3
        [C, Ns2] = two_site_update_VariProdMPO(EnV, C, j, '-<-', D_max);
        [ EnV ] = Update_VairProd_EnV(EnV, MPOA, MPOB, C, j, '-<-');
    end
    % fprintf('%d, Ns1: %.8f, Ns2: %.8f\n', i, log10(Ns1), log10(Ns2));
    if abs(Ns1 - Ns2) < ep && i >= 2
        C{1} = C{1}/Ns2;
        % fprintf('%d, Ns:%.8f', i, Ns2);
        break;
    end
end

for i = 1:1:len
    C{i} = conj(C{i});
end

end

% ||======================================||
% ||=============subfunction==============||
% ||======================================||

function [ EnV ] = Init_VariProdMPO_EnV( MPOA, MPOB, C )
EnV = MPOA;
EnV{1} = contract(MPOA{1}, 2, MPOB{1}, 3, [1,3,4,2]);
Vr = contract(MPOA{end}, 2, MPOB{end}, 3, [1,3,4,2]);
EnV{end} = Vr;

len = length(EnV);

Vr = contract(Vr, [3,4], C{end}, [2,3]);

for j = (len-1):-1:2
    Vr = contract(Vr, 1, MPOA{j}, 2);
    Vr = contract(Vr, [1,4], MPOB{j}, [2,4], [2,4,1,5,3]);
    EnV{j} = Vr;
    if j ~= 2
        Vr = contract(Vr, [3,4,5], C{j}, [2,3,4]);
    end
end
end

function [ C, Ns ] = two_site_update_VariProdMPO(EnV, C, pos, dir, D_max )
switch dir
    case '->-'
        Vl = EnV{pos};
        Vr = EnV{pos+1};
    case '-<-'
        Vl = EnV{pos-1};
        Vr = EnV{pos};
end

len = length(EnV);
T = contract(Vl, [1,2], Vr, [1,2]);
Tsize = size(T);

if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    T = reshape(T, [prod(Tsize(1:1:2)), prod(Tsize(3:1:5))]);
elseif (pos == (len-1) && strcmp(dir, '->-')) || pos == len
    T = reshape(T, [prod(Tsize(1:1:3)), prod(Tsize(4:1:5))]);
else
    T = reshape(T, [prod(Tsize(1:1:3)), prod(Tsize(4:1:6))]);
end

[U, S, V, ~, ~] = svdT(T, 'Nkeep', D_max);
Usize = size(U);
Vsize = size(V);
if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    U = reshape(U, [Tsize(1), Tsize(2), Usize(2)]);
    U = permute(U, [3,1,2]);
    V = reshape(V, [Vsize(1), Tsize(3), Tsize(4), Tsize(5)]);
elseif (pos == (len-1) && strcmp(dir, '->-')) || pos == len
    U = reshape(U, [Tsize(1), Tsize(2), Tsize(3), Usize(2)]);
    U = permute(U, [1,4,2,3]);
    V = reshape(V, [Vsize(1), Tsize(4), Tsize(5)]);
else
    U = reshape(U, [Tsize(1), Tsize(2), Tsize(3), Usize(2)]);
    U = permute(U, [1,4,2,3]);
    V = reshape(V, [Vsize(1), Tsize(4), Tsize(5), Tsize(6)]);
end
Ns = norm(S);
S = diag(S);
switch dir
    case '->-'
        C{pos} = conj(U);
        C{pos+1} = conj(contract(S, 2, V, 1));
    case '-<-'
        if pos-1 == 1
            C{pos-1} = conj(contract(U, 1, S, 1, [3,1,2]));
        else
            C{pos-1} = conj(contract(U, 2, S, 1, [1,4,2,3]));
        end
        C{pos} = conj(V);
end

end

function [ EnV ] = Update_VairProd_EnV(EnV, MPOA, MPOB, C, pos, dir)
switch dir
    case '->-'
        if pos == 1
            Vl = contract(EnV{1}, [3,4], C{1}, [2,3]);
            Vl = contract(Vl, 1, MPOA{2}, 1);
            Vl = contract(Vl, [1,4], MPOB{2}, [1,4], [2,4,1,5,3]);
            EnV{2} = Vl;
        else
            Vl = contract(EnV{pos}, [3,4,5], C{pos}, [1,3,4]);
            Vl = contract(Vl, 1, MPOA{pos+1}, 1);
            Vl = contract(Vl, [1,4], MPOB{pos+1}, [1,4], [2,4,1,5,3]);
            EnV{pos+1} = Vl;
        end
    case '-<-'
        if pos == length(EnV)
            Vr = contract(EnV{end}, [3,4], C{end}, [2,3]);
            Vr = contract(Vr, 1, MPOA{end-1}, 2);
            Vr = contract(Vr, [1,4], MPOB{end-1}, [2,4], [2,4,1,5,3]);
            EnV{end-1} = Vr;
        else
            Vr = contract(EnV{pos}, [3,4,5], C{pos}, [2,3,4]);
            Vr = contract(Vr, 1, MPOA{pos-1}, 2);
            Vr = contract(Vr, [1,4], MPOB{pos-1}, [2,4], [2,4,1,5,3]);
            EnV{pos-1} = Vr;
        end
end
end