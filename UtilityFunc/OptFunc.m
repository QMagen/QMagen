function [ res ] = OptFunc( TStr, QMagenConf )



[ Para_input, vp, gFac_input, vg ] = GetOptVar( QMagenConf );

OptPara = QMagenConf.Config.BOPara;
Restart = QMagenConf.Restart;

judge = 0;
if ~isempty(Restart)
    if ~isempty(Restart.XTrace)
        XTrace = Restart.XTrace;
    else
        XTrace = [];
    end
    
    if ~isempty(Restart.ObjTrace)
        ObjTrace = Restart.ObjTrace;
    else
        ObjTrace = [];
    end
    
    if ~isempty(Restart.Resume)
        res = Restart.Resume;
        warning('There might be a mistake!\n')
        keyboard;
        judge = 1;
    end
end



for i = 1:1:OptPara.Group_Number
    if i == 1 && judge == 0
        
        switch OptPara.Parallel
      
            case 'on'
                
                parpool(OptPara.ParpoolNum)
                spmd
                    maxNumCompThreads(OptPara.Parallel_maxNumCompThreads);
                    fun = makeFun(labindex, TStr, gFac_input, Para_input);
                end
                
                plf = parallel.pool.Constant(fun);
                try
                    res = bayesopt(plf, [vp, vg], ...
                        'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
                        'InitialX', XTrace, 'InitialObjective', ObjTrace, ...
                        'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
                        'ExplorationRatio',OptPara.AcqFunc_ER(i), ...
                        'UseParallel', true, 'MinWorkerUtilization', OptPara.MinWorkerUtilization);
                catch
                    error('Matlab version is insufficient, please turn off parallel!\n')
                end
                
            case 'off'
                
                lf = @(x) loss_func( TStr, eval(gFac_input), eval(Para_input) );
                res = bayesopt(lf, [vp, vg], ...
                    'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
                    'InitialX', XTrace, 'InitialObjective', ObjTrace, ...
                    'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
                    'ExplorationRatio',OptPara.AcqFunc_ER(i));
            otherwise 
                
                error('Undefined parallel parameter!\n')
        end
        save(['../Tmp/tmp_', TStr, '/res', num2str(i), '.mat'],'res');
    elseif i == 1 && judge == 1
        res = resume(res,'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
            'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
            'ExplorationRatio', OptPara.AcqFunc_ER(i));
        save(['../Tmp/tmp_', TStr, '/res' num2str(i),'.mat'],'res');
        
    else
        res = resume(res,'AcquisitionFunctionName', OptPara.AcqFunc_Name{i}, ...
            'MaxObjectiveEvaluations', OptPara.Group_MaxEval(i), 'IsObjectiveDeterministic', OptPara.IsObjDet, ...
            'ExplorationRatio', OptPara.AcqFunc_ER(i));
        save(['../Tmp/tmp_', TStr, '/res' num2str(i),'.mat'],'res');
    end
    
end
end



function f = makeFun(labindex, TStr, gFac_input, Para_input)
f = @fun;
TStr = [num2str(labindex), TStr];
    function lf = fun(x)
        lf = loss_func( TStr, eval(gFac_input), eval(Para_input) );
    end
end

