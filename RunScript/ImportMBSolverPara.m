function [ Para ] = ImportMBSolverPara( Para )
% function [ Para ] = ImportMBSolverPara( Para )
switch Para.ManyBodySolver
    case 'ED'
        % // beta list for ED
        beta_list = 0.0025.*2.^(0:1:15).*2^0.1;
        for int = 0.3:0.2:0.9
            beta_list = [beta_list, 0.0025.*2.^(0:1:15).*2^int];
        end
        beta_list = sort(beta_list);
        Para.beta_list = beta_list;
        
    case 'iLTRG'
        % // Trotter step
        Para.tau = 0.025;
        
        % Percentage change of field when calculate susceptibility
        % Recommended value
        %       Zero field     0.25
        %       Finite field   0.01
        Para.DeltaHRatio = 0.25;
        % // N_max: iLTRG iterations
        Para.N_max = floor(Para.beta_max / 2 / Para.tau) + 3;
        
        % // Trotter order
        Para.TroOrd = '1';      % '1' only
        % // D_max: bond dimension of rho(beta/2)
        Para.D_max = 40;
        
        % // Number of interp
        Para.InterNum = 20;
        
    case 'XTRG'
        % // SETTEN initial tau
        Para.tau = 0.00025;   
        
        % It: XTRG iterations
        Para.It = floor(log(Para.beta_max/Para.tau)/log(2));
        
        % //D: bond dimension of rho(beta)
        % D_list = [Di for i steps, Dj for j steps, etc .]
        % Recommended value 200
        % Bigger is more accurate
        Para.D_list = 1:1:Para.It;
        Para.D_list(:) = 50;
        Para.D_list(end:-1:end-4) = 50;
        
        % //MCrit: bond dimension compressing H^n
        % used in SETTN initialization of rho(tau)
        % Recommended value 200
        % Bigger is more accurate
        Para.MCrit = 50;
        
        % //XTRG runtime parameters
        % max iterations of MPO varitional product
        Para.VariProd_step_max = 10000;
        % max iterations of MPO varitional sum
        Para.VariSum_step_max = 10000;
        % max expensian order of SETTN
        Para.SETTN_init_step_max = 10000;

end

end

