function [ Rslt ] = XTRG_Main( Para, H, Id, Op, ST, i )
global EVOFLAG;
taup = Para.tau * 2 ^ (ST/4);
Para.tau = taup;
if i ~= 0
    Para.TStr_log = [num2str(i), Para.TStr];
else
    Para.TStr_log = Para.TStr_log;
end
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

