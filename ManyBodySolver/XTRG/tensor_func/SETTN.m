function [ rho, Op ] = SETTN( Para, H, Id, Op )
% function [ rho, Op ] = SETTN( Para, H, Id, Op )
% Series-Expansion Thermal Tensor Network algorithm to get 
% the density matrix rho at inverse temperature Para.tau.
% rho.A is the tensor that make up the MPO of density martrix.
% rho.lgnorm is the log norm of density martrix.
% Yuan Gao@buaa 2020.12.07
% mail: 17231064@buaa.edu.cn

tau = Para.tau;
step_max = Para.SETTN_init_step_max;

rho = Id;
Hn = H;
Para.MCrit = max(Para.D_list);
for i = 1:1:step_max
    % //rho = rho + (-tau)^i/i! H^i
    sig = sign((-1)^i);
    fec1 = rho.lgnorm;
    fec2 = Hn.lgnorm + i * log(tau) - sum(log(1:1:i));
    
    if fec1 > fec2
        [rho.A, nm] = VariSumMPO(Para, rho.A, Hn.A, [1, sig * exp(fec2-fec1)]);
        rho.lgnorm = fec1 + log(nm);
    else
        [rho.A, nm] = VariSumMPO(Para, rho.A, Hn.A, [exp(fec1-fec2), sig]);
        rho.lgnorm = fec2 + log(nm);
    end
    % fprintf('%d, %.5f, %.5f\n', i, fec1/log(10), fec2/log(10));
    if (fec2-fec1)/log(10) < -16
        break;
    end
    % //Hn = H * Hn (H^(i+1))
    [Hn.A, nm] = VariProdMPO(Para, Hn.A, H.A);
    Hn.lgnorm = H.lgnorm + Hn.lgnorm + log(nm);
end
end

