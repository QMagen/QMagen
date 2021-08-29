function [ Para ] = ImportBOPara( MBSolver )

% Parallel Bayesian optimization for matlab 2018b +
switch MBSolver
    case {'ED', 'ED_C'}
        % Parallel
        Para.Parallel = 'on';
        Para.MinWorkerUtilization = 4;
        Para.ParpoolNum = 4;
        Para.Parallel_maxNumCompThreads = 1;
        % number of optimized groups
        Para.Group_Number = 5;
        % is Objective Deterministic
        %        true or false
        Para.IsObjDet = true;
        
        Para.Group_MaxEval = zeros(Para.Group_Number, 1);
        Para.AcqFunc_Name = cell(Para.Group_Number, 1);
        Para.AcqFunc_ER = zeros(Para.Group_Number, 1);
        
        % max evaluations of corresponding group
        Para.Group_MaxEval(:) = 400;
        
        % acquisition function name of corresponding group
        %       'expected-improvement'
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second'
        %       'expected-improvement-per-second-plus'
        %       'lower-confidence-bound'
        %       'probability-of-improvement'
        Para.AcqFunc_Name(:) = {'expected-improvement-plus'};
        % exploration ratio of corresponding group
        % AcqFunc_Name(i) =
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second-plus'
        Para.AcqFunc_ER = [0.5, 0.4, 0.3, 0.2, 0.1];
        
    case 'iLTRG'
        % Parallel
        Para.Parallel = 'off';
        Para.MinWorkerUtilization = 5;
        Para.ParpoolNum = 9;
        Para.Parallel_maxNumCompThreads = 4;
        % number of optimized groups
        Para.Group_Number = 10;
        % is Objective Deterministic
        %        true of false
        Para.IsObjDet = true;
        
        Para.Group_MaxEval = zeros(Para.Group_Number, 1);
        Para.AcqFunc_Name = cell(Para.Group_Number, 1);
        Para.AcqFunc_ER = zeros(Para.Group_Number, 1);
        
        % max evaluations of corresponding group
        Para.Group_MaxEval(:) = 50;
        
        % acquisition function name of corresponding group
        %       'expected-improvement'
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second'
        %       'expected-improvement-per-second-plus'
        %       'lower-confidence-bound'
        %       'probability-of-improvement'
        Para.AcqFunc_Name(:) = {'expected-improvement-plus'};
        % exploration ratio of corresponding group
        % AcqFunc_Name(i) =
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second-plus'
        Para.AcqFunc_ER = [0.5, 0.4, 0.3, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
        
    case 'XTRG'
        % Parallel
        Para.Parallel = 'off';
        Para.MinWorkerUtilization = 5;
        Para.ParpoolNum = 9;
        Para.Parallel_maxNumCompThreads = 5;
        % number of optimized groups
        Para.Group_Number = 10;
        % is Objective Deterministic
        %        true of false
        Para.IsObjDet = true;
        
        Para.Group_MaxEval = zeros(Para.Group_Number, 1);
        Para.AcqFunc_Name = cell(Para.Group_Number, 1);
        Para.AcqFunc_ER = zeros(Para.Group_Number, 1);
        
        % max evaluations of corresponding group
        Para.Group_MaxEval(:) = 50;
        
        % acquisition function name of corresponding group
        %       'expected-improvement'
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second'
        %       'expected-improvement-per-second-plus'
        %       'lower-confidence-bound'
        %       'probability-of-improvement'
        Para.AcqFunc_Name(:) = {'expected-improvement-plus'};
        % exploration ratio of corresponding group
        % AcqFunc_Name(i) =
        %       'expected-improvement-plus'
        %       'expected-improvement-per-second-plus'
        Para.AcqFunc_ER = [0.5, 0.4, 0.3, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
        
    case 'DMRG'
        Para=struct();
end


end

