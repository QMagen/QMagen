function [ res ] = OptFunc( TStr, QMagenConf )


% fprintf('Many-body solver: %s\n', QMagenConf.Config.ManyBodySolver)
% fprintf('Model Name: %s\n', QMagenConf.ModelConf.ModelName_Full)
% display(QMagenConf.Lattice)
% fprintf('Parameter:\n')

[ Para_input, vp, gFac_input, vg ] = GetOptVar( QMagenConf );

OptPara = QMagenConf.Config.BOPara;
for i = 1:1:OptPara.Group_Number
    if i == 1
        lf = @(x) loss_func( TStr, eval(gFac_input), eval(Para_input) );
        
        res = bayesopt(lf, [vp, vg], ...
                        'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
                        'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
                        'ExplorationRatio',OptPara.AcqFunc_ER(i));
        save(['../Tmp/tmp_', TStr, '/res', num2str(i), '.mat'],'res');
    else
        load(['../Tmp/tmp_', TStr, '/res' num2str(i-1), '.mat']);
        res = resume(res,'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
                         'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
                         'ExplorationRatio', OptPara.AcqFunc_ER(i));
        save(['../Tmp/tmp_', TStr, '/res' num2str(i),'.mat'],'res');
    end

end
end



