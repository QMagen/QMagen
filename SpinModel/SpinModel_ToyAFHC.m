function [ Lattice, ModelConf ] = SpinModel_ToyAFHC( )
% -------------------------------------------------------------
% Spin Chain
% XXZ model
% Parameter:
%           J      Nearest neighbor SxSx + SySy term
%           Delta  Nearest neighbor SzSz term
%           gz     Lande factor of Sz direction
%
% Hamiltonian:
%   H = J[\sum_i  (Sx_{2i-1} Sx_{2i} + Sy_{2i-1} Sy_{2i})
%                 + Delta Sz_{2i-1} Sz_{2i}
%        + alpha(Sx_{2i} Sx_{2i+1} + Sy_{2i} Sy_{2i+1} 
%                 + Delta Sz_{2i} Sz_{2i+1})]
%       - gx mu_B Bx \sum_i Sx_i
%       - gz mu_B Bz \sum_i Sz_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
ModelConf.ModelName = 'ToyAFHC';
ModelConf.ModelName_Full = 'Antiferromagnetic Heisenberg Chain';
ModelConf.Trotter = 'Trotter_ToyAFHC';
ModelConf.AvlbSolver = {'iLTRG'};    % available solvers: iLTRG (full-T)
ModelConf.LocalSpin = '1/2';
ModelConf.Para_Name = {'J'; 'Delta'};
ModelConf.Para_Unit = {'K'; 'K'};
ModelConf.Para_EnScale = 'J';
ModelConf.Para_Range = cell(length(ModelConf.Para_Name), 1);
ModelConf.gFactor_Num = 2;
ModelConf.gFactor_Type = 'xyz';
ModelConf.gFactor_Name = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Vec = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Range = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Name{1} = 'gx';
ModelConf.gFactor_Vec{1} = [1,0,0];
ModelConf.gFactor_Name{2} = 'gz';
ModelConf.gFactor_Vec{2} = [0,0,1];

% =============================================================
% LATTICE GEOMETRY SETTINGS
% =============================================================
Lattice.L = Inf;

% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS
% =============================================================
% J range
ModelConf.Para_Range{1} = [-10, 10];
% Delta range
ModelConf.Para_Range{2} = [-10, 10];
% gx range
ModelConf.gFactor_Range{1} = 2;
% gz range
ModelConf.gFactor_Range{2} = 2;
end

