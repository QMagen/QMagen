function [ Para ] = GetPara()


% // ==================== Model ====================

Para.IntrcMap_Name = 'IntrcMap_XYChain';
Para.ModelName = 'Heisenberg_Chain';
Para.d = 2; % local spin; 2 -> spin-1/2, 3 -> spin-1
Para.Ver = 'Memory';
% Geometry
Para.L = 10;
Para.BCX = 'OBC';

% Interaction
Para.Model.J = 1;
Para.Model.D = -1;

% // ==================== DMRG =====================
Para.DK = 20;
Para.tol = 1e-8;

% // ============ Correlation functions ============
Para.Wp = 0.95;
Para.omegap = -Para.Wp:0.005:Para.Wp;
Para.CheMaxStep = 100;
Para.Furi_type = 'OBC';
Para.q = 1 .* pi./(Para.L+1);
Para.O1_type = 'Sz';
Para.O2_type = 'Sz';
% // ==================== Field ====================
Para.Field.h = [0,0,0];


% // ================= Statistics ==================
Para.Step_max = 1010; % Number of samples


% // ===================== RG ======================
Para.MCrit = 50; % Bond dimension
Para.DMRGStepMax = 100;
Para.VariProd_step_max = 10000; 
Para.VariSum_step_max = 10000;


% // ================ save path ====================
% if ~strcmp(TStr, 'Para')
%     fprintf('\n%s\n', TStr);
%     fprintf('beta = %.3f\n ', Para.beta);
%     fprintf('L = %d\n', Para.L)
%     oripath = ['/tmp/ygao/STRG_RSLT/', TStr];
%     mkdir('/tmp/ygao/STRG_RSLT', TStr);
%     
%     % save path of sample information
%     Para.SamPath = [oripath, '/SamRslt/', Para.ModelName, '_beta-', num2str(Para.beta), '_D-', num2str(Para.MCrit), '_L-', num2str(Para.L)];
%     % save path of correlation function information
%     Para.CoPath = [oripath, '/CoRslt/', Para.ModelName, '_beta-', num2str(Para.beta), '_D-', num2str(Para.MCrit), '_L-', num2str(Para.L)];
%     % save path of entanglement entropy information
%     Para.EEPath = [oripath, '/EERslt/', Para.ModelName, '_beta-', num2str(Para.beta), '_D-', num2str(Para.MCrit), '_L-', num2str(Para.L)];
%     
%     mkdir(Para.SamPath);
%     mkdir(Para.CoPath);
%     mkdir(Para.EEPath);
%     save([oripath, '/', 'Para.mat'], 'Para');
% end
end

