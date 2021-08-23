function [Rslt, Info] = DMRG_lqy(Para)

% main function of DMRG

% initial MPS
T = IniMPS(Para);

% MPO of hamiltonian
Rslt.H = Get_MPO(Para);

Rslt.En = inf;
Rslt.En(2, 1) = calEn(T, Rslt.H);

% truncation information
Info.Ent = zeros(1, numel(Rslt.H) - 1);
Info.D = zeros(1, numel(Rslt.H) - 1);
Info.Err = zeros(1, numel(Rslt.H) - 1);

t = 1;

% main loops
while (Rslt.En(end - 1) - Rslt.En(end))/abs(Rslt.En(end)) > Para.tol
    
    tic;
    % sweep from left to right
    for i = 1: numel(Rslt.H) - 1

        % contrace TN to get local effect hamiltonian
        [H_local, v_l, v_r] = H_eff(T, Rslt.H, i);
        
        TT = contract(T(i), 3, T(i + 1), 2, [2, 1, 3, 4]);
        % GS tensor of H_eff
        TT = TT_update(TT, H_local, v_l, v_r, Para);
        
        % svd and output truncation information
        [T(i), T(i + 1), info] = Trun_qr(TT, [3, 4], '>>', Para.D, Para.err);
        T(i) = permute(T(i), [2, 1, 3]);
        T(i + 1) = permute(T(i + 1), [2, 1, 3])/norm(T(i + 1));
        tmp = getDimQS(T(i));
        [Info.Ent(t, i), Info.D(t, i), Info.Err(t, i)]...
            = Info_svd(info.svd, tmp(3));
            
    end
    
    % update energy
    Rslt.En(end + 1) = calEn(T, Rslt.H);
    fprintf(['\n Loops: ', num2str(t), ', En: ', num2str(Rslt.En(end), 16),...
        ', maxD: ', num2str(max(Info.D(end, :))),...
        ', maxErr: ', num2str(max(Info.Err(end, :))),...
        ', time: ', num2str(toc), '\n']);    
    t = t + 1;
    % GSMPS
    if Rslt.En(end) == min(Rslt.En)
        Rslt.GSMPS = T;
    end
    
    tic;
    % sweep from right to left
    for i = 1: numel(Rslt.H) - 1
        % contrace TN to get local effect hamiltonian
        [H_local, v_l, v_r] = H_eff(T, Rslt.H, numel(Rslt.H) - i);
        
        TT = contract(T(end - i), 3, T(end - i + 1), 2, [2, 1, 3, 4]);
        % GS tensor of H_eff
        TT = TT_update(TT, H_local, v_l, v_r, Para);
        
        % svd and output truncation information
        [T(end - i), T(end - i + 1), info]...
            = Trun_qr(TT, [3, 4], '<<', Para.D, Para.err);
        T(end - i) = permute(T(end - i), [2, 1, 3])/norm(T(end - i));
        T(end - i + 1) = permute(T(end - i + 1), [2, 1, 3]);
        tmp = getDimQS(T(end - i));
        [Info.Ent(t, numel(Rslt.H) - i), Info.D(t, numel(Rslt.H) - i), Info.Err(t, numel(Rslt.H) - i)]...
            = Info_svd(info.svd, tmp(3));
    
    end
    
    % update energy
    Rslt.En(end + 1) = calEn(T, Rslt.H);
    
    fprintf(['\n Loops: ', num2str(t), ', En: ', num2str(Rslt.En(end), 16),...
        ', maxD: ', num2str(max(Info.D(end, :))),...
        ', maxErr: ', num2str(max(Info.Err(end, :))),...
        ', time: ', num2str(toc), '\n']);
    t = t + 1;
    
    % GSMPS
    if Rslt.En(end) == min(Rslt.En)
        Rslt.GSMPS = T;
    end
    
end

fprintf(['\n Done! GS energy is ', num2str(min(Rslt.En), 16), ' \n']);

Rslt.En(1) = [];

end

function [En] = calEn(T, H)

% calculate energy form MPS and MPO
% T must be normalized

Ob = contract(H(1), 2, T(1), 1);
Ob = contract(Ob, [1, 4], conj(T(1)), [1, 2],  [1, 3, 2, 4]);

for i = 2:numel(T)
    Ob = contract(Ob, 2, T(i), 2);
    Ob = contract(Ob, [2, 4], H(i), [3, 2]);
    Ob = contract(Ob, [2, 4], conj(T(i)), [2, 1]);
end

En = real(Ob.data{1});

end

function [Ob] = calOb(T, Op)

% calculate one site observables of every site
% T must be normalized and canonical center must on first site

Ob = zeros(1, numel(T));

% first site
T_E = contract(T(1), [2, 3], conj(T(1)), [2, 3]);
T_E = contract(T_E, [1, 2], Op, [2, 1]);
if ~isempty(T_E)
    Ob(1) = T_E.data{1};
end

for i = 1: numel(T) - 1
    % move canonical center
    TT = contract(T(i), 3, T(i + 1), 2);
    [T(i), T(i + 1)] = qr_noreshape(TT, [3, 4], '>>');
    T(i + 1) = permute(T(i + 1), [2, 1, 3])/norm(T(i + 1));
    
    % i + 1 site
    T_E = contract(T(i + 1), [2, 3], conj(T(i + 1)), [2, 3]);
    T_E = contract(T_E, [1, 2], Op, [2, 1]);
    if ~isempty(T_E)
        Ob(i + 1) = T_E.data{1};
    end
end

end

function [H_local, v_l, v_r] = H_eff(T, H, i)

% calculate local effect hamiltonian of the i and i + 1 sites
% {1, 2, 3, 4, 5*, 6*, 7*, 8*}
%   --1              1--
%  |       1   4        |
%  |       |   |        |
% v_l-2  3-  H  - 6  2-v_r
%  |       |   |        |
%  |       2   5        |
%   --3              3--

% environment (left)
v_l = getIdentity(T(1), 2);
v_l = addvac(v_l, 1, 1);
for j = 1: i - 1
    v_l = contract(v_l, 3, T(j), 2); % T
    v_l = contract(v_l, [2, 3], H(j), [3, 2]); % H
    v_l = contract(v_l, [1, 3], conj(T(j)), [2, 1], [3, 2, 1]); % T*
end

% environment (right)
v_r = getIdentity(T(end), 3);
v_r = addvac(v_r, 1, 1);
for j = 1: numel(H) - i - 1
    v_r = contract(v_r, 3, T(end - j + 1), 3); % T
    v_r = contract(v_r, [2, 3], H(end - j + 1), [4, 2]); % H
    v_r = contract(v_r, [1, 3], conj(T(end - j + 1)), [3, 1], [3, 2, 1]);
end


% effect hamiltonian
H_local = contract(H(i), 4, H(i + 1), 3);

end

function [TT] = TT_update(TT, H_local, v_l, v_r, Para)

% update 2-sites local tensor by GS of H_eff

switch Para.eig
    case 'Eigs' % use function eigs of MATLAB
        % size of tensor
        D = getDimQS(TT);
        N = prod(D);
        
        X0 = reshape(TT.data{1}, [N, 1]);
        
        % use eigs to calculate GS
        [V, ~] = eigs(@(X) H_eff_multiply(X, H_local, v_l, v_r, TT, D), N, 1, 'smallestreal',...
            'IsFunctionSymmetric', 1,...
            'StartVector', X0,...
            'SubspaceDimension', min(Para.DK, N),...
            'Tolerance', Para.tol,...
            'Display', 0);
        TT.data{1} = reshape(V, D);
        
        
    case 'Lanczos'
        En = [];
        
        % iterative Lanczos
        while numel(En) <= 1 || (En(end - 1) - En(end))/abs(En(end))*Para.L > Para.tol/10
            
            % Lanczos base
            q = QSpace(1, Para.DK + 1);
            % tridiagonal form of H on Lanczos base
            H_T = zeros(Para.DK + 1);
            
            % main loops, see Page 549 of "Matrix Computations" by Gene H. Golub
            q(1) = TT/norm(TT); % initial vector
            Ek = []; % energy series with dimension of Krylov space
            
            for k = 1: Para.DK
                
                q(k + 1) = contract(v_l, 3, q(k), 1);
                q(k + 1) = contract(q(k + 1), [2, 3, 4], H_local, [3, 2, 5]);
                q(k + 1) = contract(q(k + 1), [2, 5], v_r, [3, 2]);
                H_T(k, k) = getscalar(contract(conj(q(k)), [1, 2, 3, 4], q(k + 1), [1, 2, 3, 4]));
                
                % calculate smallest eigenvalue
                [V, E_gs] = Eigen_sm(H_T(1:k, 1:k));
                Ek = [Ek, E_gs];
                
                % check convergence of energy
                if k > 1 && (Ek(end - 1) - Ek(end))/abs(Ek(end))*Para.L < Para.tol/10
                    break;
                end
                
                if k == 1 % main step of Lanczos, update next Lanczos base
                    q(k + 1) = q(k + 1) - H_T(k, k)*q(k);
                else
                    q(k + 1) = q(k + 1) - H_T(k, k)*q(k) - H_T(k - 1, k)*q(k - 1);
                end
                
                H_T(k, k + 1) = norm(q(k + 1));
                H_T(k + 1, k) = H_T(k, k + 1);
                % check if more dimension is needed
                if abs(H_T(k, k + 1)/Ek(end)) < Para.tol/10
                    break;
                end
                q(k + 1) = q(k + 1)/H_T(k, k + 1); % normalize
                
            end
            
            En = [En, Ek(end)];
            TT = V(1)*q(1);
            for i = 2: numel(V)
                TT = TT + V(i)*q(i);
            end
            

        end
        

        
    case 'JD'
        
        
        
        
        
        
        
        
        
        
        
end


end

function [Y] = H_eff_multiply(X, H_local, v_l, v_r, TT, D)

% output local 2-sites tensor Y = H_eff * X

X = reshape(X, D(1:4));

TT.data{1} = X;

% tensor contraction
TT = contract(v_l, 3, TT, 1);
TT = contract(TT, [2, 3, 4], H_local, [3, 2, 5]);
TT = contract(TT, [2, 5], v_r, [3, 2]);
Y = reshape(TT.data{1}, [prod(D), 1]);

end

function [V, D] = Eigen_sm(H)

% calculate smallest eigenstate and eigen value by eig
% assume H is hermite

[V, D] = eig(H, 'vector');
[D, order] = min(real(D));
V = V(:, order);


end


