function [ Para ] = ImportBOPara( MBSolver )

switch MBSolver
    case 'ED'
        % number of optimized groups
        Para.Group_Number = 5;
        % is Objective Deterministic
        %        true of false
        Para.IsObjDet = true;
        
        Para.Group_MaxEval = zeros(Para.Group_Number, 1);
        Para.AcqFunc_Name = cell(Para.Group_Number, 1);
        Para.AcqFunc_ER = zeros(Para.Group_Number, 1);
        
        % max evaluations of corresponding group
        Para.Group_MaxEval(:) = 100;
        
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
        % number of optimized groups
        Para.Group_Number = 10;
        % is Objective Deterministic
        %        true of false
        Para.IsObjDet = true;
        
        Para.Group_MaxEval = zeros(Para.Group_Number, 1);
        Para.AcqFunc_Name = cell(Para.Group_Number, 1);
        Para.AcqFunc_ER = zeros(Para.Group_Number, 1);
        
        % max evaluations of corresponding group
        Para.Group_MaxEval(:) = 25;
        
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
end


end

