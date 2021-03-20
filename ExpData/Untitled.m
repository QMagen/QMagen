% load RsltCm.mat
% Data(:,1) = Rslt.T_l;
% for i = 1:1:length(Rslt.T_l)
%     Data(i,2) = Rslt.Cm_l(i) * (1 + 0.01 * normrnd(0,1));
% end
% save('ToyModel_C_expdata_0T.mat', 'Data')
% 
% load RsltChix.mat
% Data(:,1) = Rslt.T_l;
% for i = 1:1:length(Rslt.T_l)
%     Data(i,2) = Rslt.Chi_l(i) * (1 + 0.01 * normrnd(0,1));
% end
% save('ToyModel_Chi_expdata_Sx.mat', 'Data')
% semilogx(Data(:,1), Data(:,2), '-*', 'LineWidth', 2); hold on
% 
% load RsltChiz.mat
% Data(:,1) = Rslt.T_l;
% for i = 1:1:length(Rslt.T_l)
%     Data(i,2) = Rslt.Chi_l(i) * (1 + 0.01 * normrnd(0,1));
% end
% save('ToyModel_Chi_expdata_Sz.mat', 'Data')
% semilogx(Data(:,1), Data(:,2), '-*', 'LineWidth', 2); hold on