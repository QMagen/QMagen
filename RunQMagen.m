addpath lossfunc
addpath ManyBodySolver
addpath Config
addpath tmp
TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
conf.many_body_solver = 'ED'; % 'ED', 'LTRG', 'XTRG'
conf.d = 2;
conf.L = 9;


% =========================================================================
Geo.Lx = 3;
Geo.Ly = 3;
Geo.BCX = 'OBC';
Geo.BCY = 'PBC';
ModelConf = {'J1', 'J2', 'Delta'};

% =========================================================================
Cmdata.len = 1;
Cmdata.Field = cell(Cmdata.len, 1);
Cmdata.Trange = cell(Cmdata.len, 1);
Cmdata.data = cell(Cmdata.len, 1);

Cmdata.Field{1} = [0,0,0];
Cmdata.data{1} = struct2array(load('C_expdata.mat', 'C_data'));
Cmdata.Trange{1} = [1, 40];

Chidata.len = 1;
Chidata.Field = cell(Chidata.len, 1);
Chidata.data = cell(Chidata.len, 1);

Chidata.Field{1} = [0,0,0.1];
Chidata.data{1} = struct2array(load('Chi_expdata.mat', 'Chi_data'));
Chidata.Trange{1} = [1, 40];

% =========================================================================
setting.plot_check = 0; % 0 -> off, 1 -> on

% Show information about evolution.
setting.EVO_check = 0;  % 0 -> off, 1 -> on

% Save intermediate results.
setting.res_save = 2;   % 0 -> off, 1 -> save the best, 2 -> save all

% The file name to save intermediate results.
setting.res_save_name = 'Save_folder/EDtest';


% =========================================================================
save(['tmp/', TStr, 'exp_data.mat'], 'Cmdata', 'Chidata');
save(['tmp/', TStr, 'configuration.mat'], 'Geo', 'conf', 'ModelConf', 'setting')
% =========================================================================


for i = 1:1:10
    if i == 1
        lf = @(x) loss_func( TStr, [2, 2, x.gz], [x.J1, x.J2, x.Delta] );

        v1 = optimizableVariable('J1',[5, 20]);
        v2 = optimizableVariable('J2', [0, 5]);
        v3 = optimizableVariable('Delta', [0, 12]);
        v4 = optimizableVariable('gz', [5, 20]);

        
        res = bayesopt(lf, [v1, v2, v3, v4], ...
                        'AcquisitionFunctionName', 'expected-improvement-plus', ...
                        'MaxObjectiveEvaluations', 50, 'IsObjectiveDeterministic', true, ...
                        'ExplorationRatio',0.5);
        save(['Opt_res/', TStr, 'res', num2str(i), '.mat'],'res');
    elseif i > 1 && i < 6
        load(['Opt_res/', TStr, 'res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'MaxObjectiveEvaluations', 100, 'IsObjectiveDeterministic', true, ...
                         'ExplorationRatio', 0.5);
        save(['Opt_res/', TStr, 'res' num2str(i),'.mat'],'res');
    else
        load(['Opt_res/', TStr, 'res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'MaxObjectiveEvaluations', 100, 'IsObjectiveDeterministic', true, ...
                         'ExplorationRatio', 0.05);
        save(['Opt_res/', TStr, 'res' num2str(i),'.mat'],'res');
    end

end