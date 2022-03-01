function [T, En] = DMRGMain(Para, H)

T = InitMPS(Para);

Rslt.En = zeros(1, Para.DMRGStepMax);
Rslt.En(1) = inf;
Rslt.En(2) = Observe( T, H, Para );


[ EnV ] = Init_DMRG_EnV( H, T );
%keyboard;
for i = 1:1:Para.DMRGStepMax
    for j = 1:1:(Para.L-2)
        [T] = two_site_update_DMRG(EnV, T, j, '->-', Para);
        [ EnV ] = Update_DMRG_EnV(EnV, H, T, j, '->-');
    end
    for j = Para.L:-1:2
        [T] = two_site_update_DMRG(EnV, T, j, '-<-', Para);
        if j > 2
            [ EnV ] = Update_DMRG_EnV(EnV, H, T, j, '-<-');
        end
    end
    Rslt.En(i + 2) = Observe(T, H, Para);
    % fprintf('%d, En: %.16f\n', i, Rslt.En(i + 2));
    if abs(Rslt.En(i + 2) - Rslt.En(i + 1))/abs(Rslt.En(i+1)) < 1e-8 && i >= 2
        En = Rslt.En(i + 2);
        break;
    end
end
end

% ======================================== %
% Sub Function
% ======================================== %
function [ EnV ] = Init_DMRG_EnV(H, T)
EnV = H;
Vr = H.A{end};

for i = (length(H.A)-1):-1:2
    if i == (length(H.A)-1)
        Vr = contract(T.A{i+1}, 2, Vr, 3);
        Vr = contract(conj(T.A{i+1}), 2, Vr, 3);
        Vr = contract(Vr, 3, H.A{i},2);
        EnV.A{i} = Vr;
    else
        Vr = contract(T.A{i+1}, [2,3], Vr, [2,5]);
        Vr = contract(conj(T.A{i+1}), [2,3], Vr, [2,4]);
        Vr = contract(Vr, 3, H.A{i}, 2);
        EnV.A{i} = Vr;
    end
end
end

function [T] = two_site_update_DMRG(EnV, T, pos, dir, Para)

switch dir
    case '->-'
        Vl = EnV.A{pos};
        Vr = EnV.A{pos+1};
        
        if pos == 1
            TT = contract(T.A{pos}, 1, T.A{pos+1}, 1);
        else
            TT = contract(T.A{pos}, 2, T.A{pos+1}, 1);
        end
    case '-<-'
        Vl = EnV.A{pos-1};
        Vr = EnV.A{pos};
        
        if pos == 2
            TT = contract(T.A{pos-1}, 1, T.A{pos}, 1);
        else
            TT = contract(T.A{pos-1}, 2, T.A{pos}, 1);
        end
end
% =============================
% check ED
% =============================
% if length(size(Vl)) == 3
%     Hp = contract(Vl, 1, Vr, 3);
%     Hp = permute(Hp, [1,3,5,2,4,6]);
%     Hp = reshape(Hp, [numel(TT), numel(TT)]);
% elseif length(size(Vr)) == 3
%     Hp = contract(Vl, 3, Vr, 1);
%     Hp = permute(Hp, [1,3,5,2,4,6]);
%     Hp = reshape(Hp, [numel(TT), numel(TT)]);
% else
%     Hp = contract(Vl, 3, Vr, 3);
%     Hp = permute(Hp, [1,3,5,7,2,4,6,8]);
%     Hp = reshape(Hp, [numel(TT), numel(TT)]);
% end
% [Vp, Dp] = eigs(Hp, 1, 'smallestreal');
% TT = reshape(Vp, size(TT));

% TTp = reshape(TT, [numel(TT), 1]);
% =============================
% =============================
% while numel(En) <= 1 || (En(end - 1) - En(end))/abs(En(end))*Para.L > Para.tol/10

Ek = [];
q = cell(1, Para.DK + 1);
Ht = zeros(Para.DK + 1);
q{1} = TT/(norm(reshape(TT, [numel(TT), 1])));
%(norm(reshape(TT, [numel(TT), 1])))
for i = 1:1:Para.DK
    if length(size(Vl)) == 3
        q{i+1} = contract(q{i}, 1, Vl, 3);
    else
        q{i+1} = contract(q{i}, [1,2], Vl, [2,5]);
        if length(size(q{i+1})) == 5
            q{i+1} = permute(q{i+1}, [1,2,4,3,5]);
        else
            q{i+1} = permute(q{i+1}, [1,3,2,4]);
        end
    end
    
    if length(size(Vr)) == 3
        q{i+1} = contract(q{i+1}, [1,2], Vr, [3,1]);
    else
        q{i+1} = contract(q{i+1}, [1,2,3], Vr, [2,5,3]);
    end
    
    % TTpp = reshape(q{i+1}, [numel(TT), 1]);
    % TTpp - Hp * TTp
    Ht(i,i) = contract(conj(q{i}), 1:1:length(size(q{i})), q{i+1}, 1:1:length(size(q{i})));
    
    [V, E_gs] = Eigen_sm(Ht(1:i, 1:i));
    Ek = [Ek, E_gs];
    % check convergence of energy
    if i > 1 && (Ek(end - 1) - Ek(end))/abs(Ek(end))*Para.L < Para.tol/10
        break;
    end
    
    if i == 1 % main step of Lanczos, update next Lanczos base
        q{i+1} = q{i+1} - Ht(i,i) * q{i};
    else
        q{i+1} = q{i+1} - Ht(i,i) * q{i} - Ht(i-1,i) * q{i-1};
    end
    
    Ht(i,i+1) = norm(reshape(q{i+1}, [numel(q{i+1}), 1]));
    Ht(i+1,i) = Ht(i,i+1);
    % check if more dimension is needed
    if i > 1 && abs(Ht(i,i+1)/Ek(end)) < Para.tol/10
        break;
    end
    q{i+1} = q{i+1}/Ht(i,i+1); % normalize
    
end
% En = [En, Ek(end)];
% keyboard;
TT = V(1) * q{1};
for j = 2:1:length(V)
    TT = TT + V(j) * q{j};
end


% end

Tsize = size(TT);
if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    TT = reshape(TT, [Tsize(1), prod(Tsize(2:1:3))]);
elseif (pos == (Para.L-1) && strcmp(dir, '->-')) || pos == Para.L
    TT = reshape(TT, [prod(Tsize(1:1:2)), prod(Tsize(3))]);
else
    TT = reshape(TT, [prod(Tsize(1:1:2)), prod(Tsize(3:1:4))]);
end

[U, S, V, ~, ~] = svdT(TT, 'Nkeep', Para.MCrit, 'epsilon', 1e-8);
Usize = size(U);
Vsize = size(V);

if pos == 1 || (pos == 2 && strcmp(dir, '-<-'))
    U = permute(U, [2,1]);
    V = reshape(V, [Vsize(1), Tsize(2), Tsize(3)]);
elseif (pos == (Para.L-1) && strcmp(dir, '->-')) || pos == Para.L
    U = reshape(U, [Tsize(1), Tsize(2), Usize(2)]);
    U = permute(U, [1,3,2]);
else
    U = reshape(U, [Tsize(1), Tsize(2), Usize(2)]);
    U = permute(U, [1,3,2]);
    V = reshape(V, [Vsize(1), Tsize(3), Tsize(4)]);
end

Ns = norm(S);
S = diag(S)/Ns;

switch dir
    case '->-'
        T.A{pos} = U;
        T.A{pos+1} = contract(S, 2, V, 1);
    case '-<-'
        if pos-1 == 1
            T.A{pos-1} = contract(S, 1, U, 1);
        else
            T.A{pos-1} = contract(U, 2, S, 1, [1,3,2]);
        end
        T.A{pos} = V;
end
%keyboard;
end

function [V, D] = Eigen_sm(H)

% calculate smallest eigenstate and eigen value by eig
% assume H is hermite
[V, D] = eigs(H, 1, 'smallestreal');
%keyboard;
end

function [ EnV ] = Update_DMRG_EnV(EnV, H, T, pos, dir)
switch dir
    case '->-'
        if pos == 1
            EnV.A{pos+1} = contract(T.A{pos}, 2, EnV.A{pos}, 3);
            EnV.A{pos+1} = contract(conj(T.A{pos}), 2, EnV.A{pos+1}, 3);
            EnV.A{pos+1} = contract(EnV.A{pos+1}, 3, H.A{pos+1}, 1);
        else
            EnV.A{pos+1} = contract(T.A{pos}, [1,3], EnV.A{pos}, [2,5]);
            EnV.A{pos+1} = contract(conj(T.A{pos}), [1,3], EnV.A{pos+1}, [2,4]);
            EnV.A{pos+1} = contract(EnV.A{pos+1}, 3, H.A{pos+1}, 1);
        end
    case '-<-'
        if pos == length(H.A)
            EnV.A{pos-1} = contract(T.A{pos}, 2, EnV.A{pos}, 3);
            EnV.A{pos-1} = contract(conj(T.A{pos}), 2, EnV.A{pos-1}, 3);
            EnV.A{pos-1} = contract(EnV.A{pos-1}, 3, H.A{pos-1}, 2);
        else
            EnV.A{pos-1} = contract(T.A{pos}, [2,3], EnV.A{pos}, [2,5]);
            EnV.A{pos-1} = contract(conj(T.A{pos}), [2,3], EnV.A{pos-1}, [2,4]);
            EnV.A{pos-1} = contract(EnV.A{pos-1}, 3, H.A{pos-1}, 2);
        end
end
end
