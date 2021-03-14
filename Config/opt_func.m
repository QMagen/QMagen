function [ res ] = opt_func( TStr )

load(['tmp_', TStr, '/exp_data.mat']);
load(['tmp_', TStr, '/configuration.mat'])

fprintf('Many-body solver: %s\n', Conf.many_body_solver)
fprintf('Model Name: %s\n', Conf.ModelName_all)
display(GeomConf)
fprintf('Parameter:\n')

Para_input = ['['];
vp = [];
for i = 1:1:length(ModelConf.Para_List)
    if isstr(ModelConf.Para_Range{i})
        Para_input = [Para_input, ['x.', ModelConf.Para_Range{i}]];
        fprintf('%10s: %s\n', ModelConf.Para_List{i}, ModelConf.Para_Range{i})
        if i ~= length(ModelConf.Para_List)
            Para_input = [Para_input, ','];
        end
    elseif length(ModelConf.Para_Range{i}) == 1
        Para_input = [Para_input, num2str(ModelConf.Para_Range{i})];
        fprintf('%10s: %d\n', ModelConf.Para_List{i}, ModelConf.Para_Range{i})
        if i ~= length(ModelConf.Para_List)
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
    if isstr(ModelConf.gFactor)
        gFac_input = [Para_input, ['x.', ModelConf.gFactor_Range{i}]];
        fprintf('%10s: %s\n', ModelConf.gFactor{i}, ModelConf.gFactor_Range{i})
        if i ~= length(ModelConf.Para_List)
            Para_input = [Para_input, ','];
        end
    elseif length(ModelConf.gFactor_Range{i}) == 1
        gFac_input = [gFac_input, num2str(ModelConf.gFactor_Range{i})];
        fprintf('%10s: %d\n', ModelConf.gFactor{i}, ModelConf.gFactor_Range{i})
        if i ~= ModelConf.Num_gFactor
            gFac_input = [gFac_input, ','];
        end
    else
        gFac_input = [gFac_input, ['x.', ModelConf.gFactor{i}]];
        fprintf('%10s: [%d, %d]\n', ModelConf.gFactor{i}, ModelConf.gFactor_Range{i})
        if i ~= ModelConf.Num_gFactor
            gFac_input = [gFac_input, ','];
        end
        vg = [vg, optimizableVariable(ModelConf.gFactor{i}, ModelConf.gFactor_Range{i})];
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
        save(['tmp_', TStr, '/res', num2str(i), '.mat'],'res');
    elseif i > 1 && i < 6
        load(['tmp_', TStr, '/res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'MaxObjectiveEvaluations', 100, 'IsObjectiveDeterministic', true, ...
                         'ExplorationRatio', 0.5);
        save(['tmp_', TStr, '/res' num2str(i),'.mat'],'res');
    else
        load(['tmp_', TStr, 'res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'MaxObjectiveEvaluations', 100, 'IsObjectiveDeterministic', true, ...
                         'ExplorationRatio', 0.05);
        save(['tmp_', TStr, '/res' num2str(i),'.mat'],'res');
    end

end
end

