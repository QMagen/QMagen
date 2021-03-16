function [ res ] = opt_func( TStr )

load(['tmp_', TStr, '/configuration.mat'])

fprintf('Many-body solver: %s\n', QMagenConf.Config.ManyBodySolver)
fprintf('Model Name: %s\n', QMagenConf.ModelConf.ModelName_Full)
display(QMagenConf.Lattice)
fprintf('Parameter:\n')

Para_input = ['['];
vp = [];
for i = 1:1:length(QMagenConf.ModelConf.Para_Name)
    if isstr(QMagenConf.ModelConf.Para_Range{i})
        Para_input = [Para_input, ['x.', QMagenConf.ModelConf.Para_Range{i}]];
        fprintf('%10s: %s\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
    elseif length(QMagenConf.ModelConf.Para_Range{i}) == 1
        Para_input = [Para_input, num2str(QMagenConf.ModelConf.Para_Range{i})];
        fprintf('%10s: %d\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
    else  
        Para_input = [Para_input, ['x.', QMagenConf.ModelConf.Para_Name{i}]];
        fprintf('%10s: [%d, %d]\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
        vp = [vp, optimizableVariable(QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})];
    end
end
Para_input = [Para_input, ']'];

gFac_input = ['['];
vg = [];
for i = 1:1:QMagenConf.ModelConf.gFactor_Num
    if isstr(QMagenConf.ModelConf.gFactor_Range{i})
        gFac_input = [gFac_input, ['x.', QMagenConf.ModelConf.gFactor_Range{i}]];
        fprintf('%10s: %s\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
    elseif length(QMagenConf.ModelConf.gFactor_Range{i}) == 1
        gFac_input = [gFac_input, num2str(QMagenConf.ModelConf.gFactor_Range{i})];
        fprintf('%10s: %d\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
    else
        gFac_input = [gFac_input, ['x.', QMagenConf.ModelConf.gFactor_Name{i}]];
        fprintf('%10s: [%d, %d]\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
        vg = [vg, optimizableVariable(QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})];
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
        load(['tmp_', TStr, '/res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', 'expected-improvement-plus', ...
                         'MaxObjectiveEvaluations', 100, 'IsObjectiveDeterministic', true, ...
                         'ExplorationRatio', 0.05);
        save(['tmp_', TStr, '/res' num2str(i),'.mat'],'res');
    end

end
end

