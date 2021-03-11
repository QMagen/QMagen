function [ Rslt ] = XTRG_Main( Para, H, Id, Op, ST )
global EVO_check;
taup = Para.tau * 2 ^ (ST/4);
Para.tau = taup;
if EVO_check == 1
    fprintf('tau = %f \n', Para.tau);
    tic
end
[rho_init, Op] = SETTN(Para, H, Id, Op);
if EVO_check == 1
    toc
    fprintf('SETTN complete! \n')
end
[~, Rslt] = ExpEvo_conj(Para, rho_init, Op);
end

