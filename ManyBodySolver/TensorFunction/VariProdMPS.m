function [ C, Ns2, ana ] = VariProdMPS( Para, MPSA, MPOB )
%============Parameter settings==============
max_step = Para.VariProd_step_max;
ep = 1e-8;
%============================================

if length(MPSA) ~= length(MPOB)
    warning('Chain length mismatch! \n');
end
len = length(MPSA);

C = cell(len, 1);
for i = 1:1:len
    C{i} = conj(MPSA{i});
end

EnV = Init_VariProdMPS_EnV(MPSA, MPOB, C);

ana.err = zeros(Para.L-1,1);
ana.entropy = zeros(Para.L-1,1);

for i = 1:1:max_step
    
    if i == 1
        D_max = ceil(Para.MCrit/2);
        % D_max = Para.MCrit;
    else
        D_max = Para.MCrit;
    end
    
    for j = 1:1:(len-2)
        [C, ~, ~] = two_site_update_VariProdMPS(EnV, C, j, '->-', D_max);
        [ EnV ] = Update_VairProd_EnV(EnV, MPSA, MPOB, C, j, '->-');
    end
    
    for j = len:-1:2
        [C, Ns2, ana_local] = two_site_update_VariProdMPS(EnV, C, j, '-<-', D_max);
        ana.err(j-1) = ana_local.err;
        ana.entropy(j-1) = ana_local.entropy;
        if j == len
            Ns1 = Ns2;
        end
        if j > 2
            [ EnV ] = Update_VairProd_EnV(EnV, MPSA, MPOB, C, j, '-<-');
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

function [ EnV ] = Init_VariProdMPS_EnV( MPSA, MPOB, C )
EnV = MPSA;
EnV{1} = contract(MPSA{1}, 2, MPOB{1}, 3);
Vr = contract(MPSA{end}, 2, MPOB{end}, 3);
EnV{end} = Vr;

len = length(EnV);

Vr = contract(Vr, 3, C{end}, 2, [1,3,2]);

for j = (len-1):-1:2
    Vr = contract(Vr, 1, MPSA{j}, 2);
    Vr = contract(Vr, [2,4], MPOB{j}, [2,4], [2,3,1,4]);
    EnV{j} = Vr;
    if j ~= 2
        Vr = contract(Vr, [3,4], C{j}, [2,3], [1,3,2]);
    end
end
end

function [ C, Ns, ana ] = two_site_update_VariProdMPS(EnV, C, pos, dir, D_max )
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
    T = reshape(T, [prod(Tsize(1)), prod(Tsize(2:1:3))]);
elseif (pos == (len-1) && strcmp(dir, '->-')) || pos == len
    T = reshape(T, [prod(Tsize(1:1:2)), prod(Tsize(3))]);
else
    T = reshape(T, [prod(Tsize(1:1:2)), prod(Tsize(3:1:4))]);
end

[U, S, V, ana.err, ana.entropy] = svdT(T, 'Nkeep', D_max);
Usize = size(U);
Vsize = size(V);

if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    U = permute(U, [2,1]);
    V = reshape(V, [Vsize(1), Tsize(2), Tsize(3)]);
elseif (pos == (len-1) && strcmp(dir, '->-')) || pos == len
    U = reshape(U, [Tsize(1), Tsize(2), Usize(2)]);
    U = permute(U, [1,3,2]);
else
    U = reshape(U, [Tsize(1), Tsize(2), Usize(2)]);
    U = permute(U, [1,3,2]);
    V = reshape(V, [Vsize(1), Tsize(3), Tsize(4)]);
end

Ns = norm(S);
S = diag(S);

switch dir
    case '->-'
        C{pos} = conj(U);
        C{pos+1} = conj(contract(S, 2, V, 1));
    case '-<-'
        if pos-1 == 1
            C{pos-1} = conj(contract(S, 1, U, 1));
        else
            C{pos-1} = conj(contract(U, 2, S, 1, [1,3,2]));
        end
        C{pos} = conj(V);
end

end

function [ EnV ] = Update_VairProd_EnV(EnV, MPSA, MPOB, C, pos, dir)
switch dir
    case '->-'
        if pos == 1
            Vl = contract(EnV{1}, 3, C{1}, 2, [1,3,2]);
            Vl = contract(Vl, 1, MPSA{2}, 1);
            Vl = contract(Vl, [2,4], MPOB{2}, [1,4], [2,3,1,4]);
            EnV{2} = Vl;
        else
            Vl = contract(EnV{pos}, [3,4], C{pos}, [1,3], [1,3,2]);
            Vl = contract(Vl, 1, MPSA{pos+1}, 1);
            Vl = contract(Vl, [2,4], MPOB{pos+1}, [1,4], [2,3,1,4]);
            EnV{pos+1} = Vl;
        end
    case '-<-'
        if pos == length(EnV)
            Vr = contract(EnV{end}, 3, C{end}, 2, [1,3,2]);
            Vr = contract(Vr, 1, MPSA{end-1}, 2);
            Vr = contract(Vr, [2,4], MPOB{end-1}, [2,4], [2,3,1,4]);
            EnV{end-1} = Vr;
        else
            Vr = contract(EnV{pos}, [3,4], C{pos}, [2,3], [1,3,2]);
            Vr = contract(Vr, 1, MPSA{pos-1}, 2);
            Vr = contract(Vr, [2,4], MPOB{pos-1}, [2,4], [2,3,1,4]);
            EnV{pos-1} = Vr;
        end
end
end
