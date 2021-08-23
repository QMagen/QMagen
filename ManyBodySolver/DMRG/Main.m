addpath Tensor_Func/
addpath Model/
addpath('../TensorFunction')
[ Para ] = GetPara();
keyboard;
[ H, Id, Ope ] = InitHam(Para);
% Get ground state & ground state energy
[T, E0] = DMRGMain(Para, H);
keyboard;
% Get ground state energy of -H
Hp = H;
Hp.A{1} = Hp.A{1} * -1;
[~, E0p] = DMRGMain(Para, Hp);

% Rescale and shift Hamiltonian
Para.Wstar = -E0p-E0;
Para.a = Para.Wstar/(2 * Para.Wp);
Hrs = H;
Hrs.lgnorm = Hrs.lgnorm - log(Para.a);
[ Hrs.A, Ns] = VariSumMPO(Para, Hrs.A, Id.A, exp(Hrs.lgnorm), -E0/Para.a-Para.Wp);
Hrs.lgnorm = log(Ns);

Rslt.q = (1:1:Para.L) .* pi./(Para.L+1);
q_list = Rslt.q;
Rslt.omega = (Para.omegap + Para.Wp) * Para.a;
CoRslt = cell(Para.L, 1);
muRslt = cell(Para.L, 1);
tic
parfor(it = 1:Para.L, 4)  
    maxNumCompThreads(3);
    q = q_list(it);
    [Co, mu, ts1, ts0] = CheMain(Para, q, T, Ope, Hrs)
    CoRslt{it} = Co;
    muRslt{it} = mu;
end
toc
save('Rslt.mat', 'Rslt', 'CoRslt', 'muRslt');