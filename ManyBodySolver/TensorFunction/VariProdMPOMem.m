function [ C, Ns2 ] = VariProdMPOMem( Para, MPOA, MPOB )
% function [ C, Ns ] = VariProdMPOMem( MPOA, MPOB )
% The last two indices of MPOA{i} & MPOB{i} should be the physical indices. 
% C{i} = MPOA{i} * MPOB{i} 
% Yuan Gao@buaa 2021.1.1
% mail: 17231064@buaa.edu.cn
% updated 2021.6.6

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

[EnV, T] = Init_VariProdMPO_EnV(MPOA, MPOB, C);

for i = 1:1:max_step
    
    if i == 1
        D_max = ceil(Para.MCrit/2);
    else
        D_max = Para.MCrit;
    end
    
    for j = 1:1:(len-2)
        [C{j}, C{j+1}, Ns1] = two_site_update_VariProdMPO(T, len, j, '->-', D_max);
        [ EnV{j+1}, T ] = Update_VairProd_EnV(EnV(j:1:(j+2)), MPOA(j:1:(j+2)), ...
                                              MPOB(j:1:(j+2)), C{j}, len, j, '->-');
    end
    
    for j = len:-1:2
        [C{j-1}, C{j}, Ns2] = two_site_update_VariProdMPO(T, len, j, '-<-', D_max);
        if j ~= 2
            [ EnV{j-1}, T ] = Update_VairProd_EnV(EnV((j-2):1:j), MPOA((j-2):1:j), ...
                                                  MPOB((j-2):1:j), C{j}, len, j, '-<-');
        end
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

function [ EnV, T ] = Init_VariProdMPO_EnV( MPOA, MPOB, C )
EnV = MPOA;
EnV{1} = contract(MPOA{1}, 2, MPOB{1}, 3, [1,3,4,2]);
Vr = contract(MPOA{end}, 2, MPOB{end}, 3, [1,3,4,2]);
EnV{end} = Vr;

len = length(EnV);

Vr = contract(Vr, [3,4], C{end}, [2,3]);

for j = (len-1):-1:2
    EnV{j} = Vr;
    if j ~= 2
        Vr = contract(Vr, 1, MPOA{j}, 2);
        Vr = contract(Vr, [1,4], MPOB{j}, [2,4], [2,4,1,5,3]);
        Vr = contract(Vr, [3,4,5], C{j}, [2,3,4]);
    end
end

Vr = contract(Vr, 1, MPOA{2}, 2);
Vr = contract(Vr, [1,4], MPOB{2}, [2,4], [2,4,1,5,3]);
T = contract(EnV{1}, [1,2], Vr, [1,2]);
end

function [ C1, C2, Ns ] = two_site_update_VariProdMPO(T, len, pos, dir, D_max )

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
        C1 = conj(U);
        C2 = conj(contract(S, 2, V, 1));
    case '-<-'
        if pos-1 == 1
            C1 = conj(contract(U, 1, S, 1, [3,1,2]));
        else
            C1 = conj(contract(U, 2, S, 1, [1,4,2,3]));
        end
        C2 = conj(V);
end

end

function [ EnVO, T ] = Update_VairProd_EnV(EnV, MPOA, MPOB, C, len, pos, dir)
switch dir
    case '->-'
        % EnV{pos} EnV{pos+1} EnV{pos+2}
        % MPOA{pos} MPOA{pos+1} MPOA{pos+2}
        % MPOB{pos} MPOB{pos+1} MPOB{pos+2}
        % C{pos}
        if pos == 1
            Vl = contract(EnV{1}, [3,4], C, [2,3]);
            EnVO = Vl;
            Vl = contract(Vl, 1, MPOA{2}, 1);
            Vl = contract(Vl, [1,4], MPOB{2}, [1,4], [2,4,1,5,3]);
        else
            Vl = contract(EnV{1}, 1, MPOA{1}, 1);
            Vl = contract(Vl, [1,4], MPOB{1}, [1,4], [2,4,1,5,3]);
            Vl = contract(Vl, [3,4,5], C, [1,3,4]);
            EnVO = Vl;
            Vl = contract(Vl, 1, MPOA{2}, 1);
            Vl = contract(Vl, [1,4], MPOB{2}, [1,4], [2,4,1,5,3]);
        end
        
        if pos == len-2
            Vr = EnV{end};
        else
            Vr = contract(EnV{3}, 1, MPOA{3}, 2);
            Vr = contract(Vr, [1,4], MPOB{3}, [2,4], [2,4,1,5,3]);
        end
    case '-<-'
        % EnV{pos-2} EnV{pos-1} EnV{pos}
        % MPOA{pos-2} MPOA{pos-1} MPOA{pos}
        % MPOB{pos-2} MPOB{pos-1} MPOB{pos}
        % C{pos}
        if pos == len
            Vr = contract(EnV{3}, [3,4], C, [2,3]);
            EnVO = Vr;
            Vr = contract(Vr, 1, MPOA{2}, 2);
            Vr = contract(Vr, [1,4], MPOB{2}, [2,4], [2,4,1,5,3]);
        else
            Vr = contract(EnV{3}, 1, MPOA{3}, 2);
            Vr = contract(Vr, [1,4], MPOB{3}, [2,4], [2,4,1,5,3]);
            Vr = contract(Vr, [3,4,5], C, [2,3,4]);
            EnVO = Vr;
            Vr = contract(Vr, 1, MPOA{2}, 2);
            Vr = contract(Vr, [1,4], MPOB{2}, [2,4], [2,4,1,5,3]);
        end
        
        if pos == 3
            Vl = EnV{1};
        else
            Vl = contract(EnV{1}, 1, MPOA{1}, 1);
            Vl = contract(Vl, [1,4], MPOB{1}, [1,4], [2,4,1,5,3]);
        end
end
T = contract(Vl, [1,2], Vr, [1,2]);
end