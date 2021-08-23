function [ Lattice, ModelConf ] = SpinModel_XXZtest( )
% -------------------------------------------------------------
% Spin Chain
% XXZ model
% Parameter:
%           J                   2i-1 <-> 2i SxSx+SySy term
%           J * Delta           2i-1 <-> 2i SzSz term
%           alpha * J           2i <-> 2i+1 SxSx+SySy term
%           alpha * J * Delta   2i <-> 2i+1 SzSz term
%           gz                  Lande factor of Sz direction
%
% Hamiltonian:
%   H = J[\sum_i  (Sx_{2i-1} Sx_{2i} + Sy_{2i-1} Sy_{2i})
%                 + Delta Sz_{2i-1} Sz_{2i}
%        + alpha(Sx_{2i} Sx_{2i+1} + Sy_{2i} Sy_{2i+1} 
%                 + Delta Sz_{2i} Sz_{2i+1})]
%       - gz mu_B \sum_i Sz_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
ModelConf.ModelName = 'XXZtest';
ModelConf.ModelName_Full = 'Heisenberg Antiferromagnetic Chain (XXZ test)';
ModelConf.IntrcMap = 'IntrcMap_XXZtest';
ModelConf.Trotter = 'Trotter_XXZtest';
ModelConf.AvlbSolver = {'ED', 'ED_C', 'iLTRG', 'XTRG'};    % available solvers: iLTRG (full-T)
ModelConf.LocalSpin = '1/2';

% Parameters' name in Hamiltonian
ModelConf.Para_Name = {'Jxy'; 'Jz'};
% Parameters' unit
%  'K':   Set the unit as Kelvin.
%  'ES':  Set the unit as energy scale, i.e. the correspoding term
%         interaction strength is [*] times of energy scale.
ModelConf.Para_Unit = {'K'; 'K'};
% Energy scale of this model, choose one from ModelConf.Para_Name
ModelConf.Para_EnScale = 'Jxy';
ModelConf.Para_Range = cell(length(ModelConf.Para_Name), 1);

ModelConf.gFactor_Num = 1;
% Choose the type of Lande g factor
%  'xyz': The direction of g factor is given along Sx, Sy, or Sz as [1,0,0], [0,1,0], [0,0,1] respectively.
%  'dir': The direction of g factor is given along a chosen direction as [x, y, z] where x^2+y^+z^2 = 1;
%         under this setting, the CmDatagInfo and ChiDatagInfo is required
%         when importing the data to decide use which g factor for conversion.
ModelConf.gFactor_Type = 'xyz';
ModelConf.gFactor_Name = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Vec = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Range = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Name{1} = 'gz';
ModelConf.gFactor_Vec{1} = [0,0,1];

% =============================================================
% LATTICE GEOMETRY SETTINGS
% =============================================================
% Lattice.L = Inf;
Lattice.L = 8;
Lattice.BC = 'PBC';
% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS
% =============================================================
% J range
ModelConf.Para_Range{1} = [0.5, 5];
% Delta range
ModelConf.Para_Range{2} = [0.5, 5];
% gz range
ModelConf.gFactor_Range{1} = [1.5, 3];
end

