function [ C, Ns2 ] = VariSumMPO( Para, MPOA, MPOB, varargin )
% function [ C, Ns ] = VariSumMPO( MPOA, MPOB, varargin )
% The last two indices of MPOA{i} & MPOB{i} should be the physical indices.
% C = varargin{1}(1) * MPOA + varargin{1}(2) * MPOB
% Yuan Gao@buaa 2021.1.1
% mail: 17231064@buaa.edu.cn

%============Parameter settings==============
max_step = Para.VariSum_step_max;
ep = 1e-8;
%============================================
if ~isempty(varargin)
    MPOA{1} = MPOA{1} * varargin{1}(1);
    MPOB{1} = MPOB{1} * varargin{1}(2);
end

if length(MPOA) ~= length(MPOB)
    warning('Inputs MPO have different size!');
end
len = length(MPOA);

C = cell(len, 1);
for i = 1:1:len
    C{i} = conj(MPOA{i});
end

[ EnVA ] = Init_VariSumMPO_EnV( MPOA, C );
[ EnVB ] = Init_VariSumMPO_EnV( MPOB, C );

for i = 1:1:max_step
    
    if i == 1
        D_max = ceil(Para.MCrit/2);
    else
        D_max = Para.MCrit;
    end
    
    for j = 1:1:(len-2)
        [C, Ns1] = two_site_update_VariSumMPO(EnVA, EnVB, C, j, '->-', D_max);
        [ EnVA ] = Update_VariSum_EnV(EnVA, MPOA, C, j, '->-');
        [ EnVB ] = Update_VariSum_EnV(EnVB, MPOB, C, j, '->-');
    end
    
    for j = len:-1:3
        [C, Ns2] = two_site_update_VariSumMPO(EnVA, EnVB, C, j, '-<-', D_max);
        [ EnVA ] = Update_VariSum_EnV(EnVA, MPOA, C, j, '-<-');
        [ EnVB ] = Update_VariSum_EnV(EnVB, MPOB, C, j, '-<-');
    end
    
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

function [ EnV ] = Init_VariSumMPO_EnV( MPO, C )
EnV = MPO;

len = length(EnV);

Vr = contract(EnV{end}, [2,3], C{end}, [2,3]);


for j = (len-1):-1:2
    Vr = contract(Vr, 1, MPO{j}, 2, [2,1,3,4]);
    EnV{j} = Vr;
    if j ~= 2
        Vr = contract(Vr, [2,3,4], C{j}, [2,3,4]);
    end
end
end

function [ C, Ns ] = two_site_update_VariSumMPO( EnVA, EnVB, C, pos, dir, D_max )
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

function [ EnV ] = Update_VariSum_EnV(EnV, MPO, C, pos, dir)
switch dir
    case '->-'
        if pos == 1
            Vl = contract(EnV{1}, [2,3], C{1}, [2,3]);
            Vl = contract(Vl, 1, MPO{2}, 1, [2,1,3,4]);
            EnV{2} = Vl;
        else
            Vl = contract(EnV{pos}, [2,3,4], C{pos}, [1,3,4]);
            Vl = contract(Vl, 1, MPO{pos+1}, 1, [2,1,3,4]);
            EnV{pos+1} = Vl;
        end
    case '-<-'
        if pos == length(EnV)
            Vr = contract(EnV{end}, [2,3], C{end}, [2,3]);
            Vr = contract(Vr, 1, MPO{end-1}, 2, [2,1,3,4]);
            EnV{end-1} = Vr;
        else
            Vr = contract(EnV{pos}, [2,3,4], C{pos}, [2,3,4]);
            Vr = contract(Vr, 1, MPO{pos-1}, 2, [2,1,3,4]);
            EnV{pos-1} = Vr;
        end
end
end