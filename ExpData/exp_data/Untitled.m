% Data = load('C_0.txt');
% Data(:,2) = Data(:,2) * 8.314;
% save('CuN_C_expdata_0T.mat', 'Data');
% 
% Data = load('C_28.2k.txt');
% Data(:,2) = Data(:,2) * 8.314;
% save('CuN_C_expdata_2.82T.mat', 'Data');
% 
% Data = load('C_35.7k.txt');
% Data(:,2) = Data(:,2) * 8.314;
% save('CuN_C_expdata_3.58T.mat', 'Data');
% 
% load('par.mat')
% 
% M = M * 4 * pi / 1e4 / 0.6;
% Data = zeros(length(M), 2);
% Data(:,1) = T;
% Data(:,2) = M;
% save('CuN_Chi_expdata_Sz.mat', 'Data');