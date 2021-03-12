function [ res ] = opt_func( TStr )

load(['tmp_', TStr, '/exp_data.mat']);
load(['tmp_', TStr, '/configuration.mat'])

g_input = ['['];
vg = [];
for i = 1:1:ModelConf.g_len
    g_input = [g_input, ['x.', ModelConf.g{i}]];
    if i ~= ModelConf.g_len
        g_input = [g_input, ','];
    end
    vg = [vg, optimizableVariable(ModelConf.g{i}, ModelConf.g_opt_range{i})];
end
g_input = [g_input, ']'];

Para_input = ['['];
vp = [];
for i = 1:1:length(ModelConf.Para)
    Para_input = [Para_input, ['x.', ModelConf.Para{i}]];
    if i ~= length(ModelConf.Para)
        Para_input = [Para_input, ','];
    end
    vp = [vp, optimizableVariable(ModelConf.Para{i}, ModelConf.Para_opt_range{i})];
end
Para_input = [Para_input, ']'];

keyboard;
for i = 1:1:10
    if i == 1
        lf = @(x) loss_func( TStr, eval(g_input), eval(Para_input) );
        
        res = bayesopt(lf, [vp, vg], ...
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
end

