function [ C, Ns2, ana ] = VariSumMPS( Para, MPSA, MPSB, varargin )

%============Parameter settings==============
max_step = Para.VariSum_step_max;
ep = 1e-8;
%============================================
if ~isempty(varargin)
    MPSA{1} = MPSA{1} * varargin{1};
    MPSB{1} = MPSB{1} * varargin{2};
end

if length(MPSA) ~= length(MPSB)
    warning('Chain length mismatch! \n');
end
len = length(MPSA);

C = cell(len, 1);
for i = 1:1:len
    C{i} = conj(MPSA{i});
end

ana.err = zeros(Para.L-1,1);
ana.entropy = zeros(Para.L-1,1);

[ EnVA ] = Init_VariSumMPS_EnV( MPSA, C );
[ EnVB ] = Init_VariSumMPS_EnV( MPSB, C );

for i = 1:1:max_step
    
    if i == 1
        D_max = ceil(Para.MCrit/2);
        % D_max = Para.MCrit;
    else
        D_max = Para.MCrit;
    end
    
    for j = 1:1:(len-2)
        [C, ~, ~] = two_site_update_VariSumMPS(EnVA, EnVB, C, j, '->-', D_max);
        [ EnVA ] = Update_VariSum_EnV(EnVA, MPSA, C, j, '->-');
        [ EnVB ] = Update_VariSum_EnV(EnVB, MPSB, C, j, '->-');
    end
    
    for j = len:-1:2
        [C, Ns2, ana_local] = two_site_update_VariSumMPS(EnVA, EnVB, C, j, '-<-', D_max);
        ana.err(j-1) = ana_local.err;
        ana.entropy(j-1) = ana_local.entropy;
        if j == len
            Ns1 = Ns2;
        end
        if j > 2
            [ EnVA ] = Update_VariSum_EnV(EnVA, MPSA, C, j, '-<-');
            [ EnVB ] = Update_VariSum_EnV(EnVB, MPSB, C, j, '-<-');
        end
    end
    % fprintf('%d, Ns1: %.8f, Ns2: %.8f\n', i, log10(Ns1), log10(Ns2));
    if abs(Ns1 - Ns2) < ep && i >= 2
        C{1} = C{1}/Ns2;
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

function [ EnV ] = Init_VariSumMPS_EnV( MPS, C )
EnV = MPS;

len = length(EnV);

Vr = contract(EnV{end}, 2, C{end}, 2);


for j = (len-1):-1:2
    Vr = contract(Vr, 1, MPS{j}, 2, [2,1,3]);
    EnV{j} = Vr;
    if j ~= 2
        Vr = contract(Vr, [2,3], C{j}, [2,3]);
    end
end
end

function [ C, Ns, ana ] = two_site_update_VariSumMPS( EnVA, EnVB, C, pos, dir, D_max )
switch dir
    case '->-'
        Vl1 = EnVA{pos};
        Vl2 = EnVB{pos};
        Vr1 = EnVA{pos+1};
        Vr2 = EnVB{pos+1};
    case '-<-'
        Vl1 = EnVA{pos-1};
        Vl2 = EnVB{pos-1};
        Vr1 = EnVA{pos};
        Vr2 = EnVB{pos};
end
len = length(EnVA);
T1 = contract(Vl1, 1, Vr1, 1); 
T2 = contract(Vl2, 1, Vr2, 1);
T = T1 + T2;
Tsize = size(T);

if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    T = reshape(T, [Tsize(1), prod(Tsize(2:1:3))]);
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

function [ EnV ] = Update_VariSum_EnV(EnV, MPS, C, pos, dir)
switch dir
    case '->-'
        if pos == 1
            Vl = contract(EnV{1}, 2, C{1}, 2);
            Vl = contract(Vl, 1, MPS{2}, 1, [2,1,3]);
            EnV{2} = Vl;
        else
            Vl = contract(EnV{pos}, [2,3], C{pos}, [1,3]);
            Vl = contract(Vl, 1, MPS{pos+1}, 1, [2,1,3]);
            EnV{pos+1} = Vl;
        end
    case '-<-'
        if pos == length(EnV)
            Vr = contract(EnV{end}, 2, C{end}, 2);
            Vr = contract(Vr, 1, MPS{end-1}, 2, [2,1,3]);
            EnV{end-1} = Vr;
        else
            Vr = contract(EnV{pos}, [2,3], C{pos}, [2,3]);
            Vr = contract(Vr, 1, MPS{pos-1}, 2, [2,1,3]);
            EnV{pos-1} = Vr;
        end
end
end
