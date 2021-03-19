function [ Rslt ] = XTRG_Main( Para, H, Id, Op, ST )
global EVOFLAG;
taup = Para.tau * 2 ^ (ST/4);
Para.tau = taup;
if EVOFLAG == 1
    fprintf('tau = %f \n', Para.tau);
    tic
end
[rho_init, Op] = SETTN(Para, H, Id, Op);
if EVOFLAG == 1
    toc
    fprintf('SETTN complete! \n')
end
[~, Rslt] = ExpEvo_conj(Para, rho_init, Op);
end

