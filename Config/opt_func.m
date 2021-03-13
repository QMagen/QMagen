function [ res ] = opt_func( TStr )

load(['tmp_', TStr, '/exp_data.mat']);
load(['tmp_', TStr, '/configuration.mat'])

Para_input = ['['];
vp = [];
for i = 1:1:length(ModelConf.Para_List)
    if length(ModelConf.Para_Range{i}) == 1
        Para_input = [Para_input, num2str(ModelConf.Para_Range{i})];
        if i ~= length(ModelConf.Para)
            Para_input = [Para_input, ','];
        end
    else  
        Para_input = [Para_input, ['x.', ModelConf.Para_List{i}]];
        fprintf('%10s: [%d, %d]\n', ModelConf.Para_List{i}, ModelConf.Para_Range{i})
        if i ~= length(ModelConf.Para_List)
            Para_input = [Para_input, ','];
        end
        vp = [vp, optimizableVariable(ModelConf.Para_List{i}, ModelConf.Para_Range{i})];
    end
end
Para_input = [Para_input, ']'];

gFac_input = ['['];
vg = [];
for i = 1:1:ModelConf.Num_gFactor
    if length(ModelConf.gFacotr_Range{i}) == 1
        gFac_input = [gFac_input, num2str(ModelConf.gFacotr_Range{i})];
        if i ~= ModelConf.g_len
            gFac_input = [gFac_input, ','];
        end
    else
        gFac_input = [gFac_input, ['x.', ModelConf.gFactor{i}]];
        if i ~= ModelConf.Num_gFactor
            gFac_input = [gFac_input, ','];
        end
        vg = [vg, optimizableVariable(ModelConf.gFactor{i}, ModelConf.gFacotr_Range{i})];
    end
end
gFac_input = [gFac_input, ']'];


for i = 1:1:10
    if i == 1
        lf = @(x) loss_func( TStr, eval(gFac_input), eval(Para_input) );
        
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

