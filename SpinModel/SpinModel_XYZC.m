function [ Lattice, ModelConf ] = SpinModel_XYZC( )
% -------------------------------------------------------------
% Spin Chain
% XYZC model [WL]
% Parameter:
%           Jx     Nearest neighbor SxSx term
%           Jy     Nearest neighbor SySy term
%           Jz     Nearest neighbor SzSz term
%           gx     Lande factor of Sx direction
%           gy     Lande factor of Sy direction
%           gz     Lande factor of Sz direction
%
% Hamiltonian:
%   H = \sum_i  Jx Sx_{i} Sx_{i+1} 
%             + Jy Sy_{i} Sy_{i+1})
%             + Jz Sz_{i} Sz_{i+1}
%       - gx mu_B Bx \sum_i Sx_i
%       - gy mu_B By \sum_i Sy_i
%       - gz mu_B Bz \sum_i Sz_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
ModelConf.ModelName = 'XYZC';
ModelConf.ModelName_Full = 'Antiferromagnetic Heisenberg Chain';
ModelConf.Trotter = 'Trotter_XYZC';
ModelConf.AvlbSolver = {'iLTRG'};    % available solvers: iLTRG (full-T)
ModelConf.LocalSpin = '1/2';

% Parameters' name in Hamiltonian
ModelConf.Para_Name = {'Jx'; 'Jy'; 'Jz'};
% Parameters' unit
%   'K'  to set the unit as Kelvin
%   'ES' to set the unit as energy scale, i.e. the correspoding term
%   interaction strength is [*] times of energy scale.
ModelConf.Para_Unit = {'K'; 'K'; 'K'};
% Energy scale of this model, choose one from ModelConf.Para_Name
ModelConf.Para_EnScale = 'Jx';
ModelConf.Para_Range = cell(length(ModelConf.Para_Name), 1);

ModelConf.gFactor_Num = 3;
% Choose the type of Lande g factor
%  'xyz': The direction of g factor is given along Sx, Sy, or Sz as [1,0,0], [0,1,0], [0,0,1] respectively.
%  'dir': The direction of g factor is given along a chosen direction as [x, y, z] where x^2+y^+z^2 = 1;
%         under this setting, the CmDatagInfo and ChiDatagInfo is required
%         when importing the data to decide use which g factor for conversion.
ModelConf.gFactor_Type = 'xyz';
ModelConf.gFactor_Name = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Vec = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Range = cell(ModelConf.gFactor_Num, 1);
ModelConf.gFactor_Name{1} = 'gx';
ModelConf.gFactor_Vec{1} = [1,0,0];
ModelConf.gFactor_Name{2} = 'gy';
ModelConf.gFactor_Vec{2} = [0,1,0];
ModelConf.gFactor_Name{3} = 'gz';
ModelConf.gFactor_Vec{3} = [0,0,1];

% =============================================================
% LATTICE GEOMETRY SETTINGS
% =============================================================
Lattice.L = Inf;

% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS
% =============================================================
% Jx range
ModelConf.Para_Range{1} = [-5, 5];
% Jy range
ModelConf.Para_Range{2} = [0.1, 5]; %'Jx';
% Jz range
ModelConf.Para_Range{3} = [-5, 5];
% gx range
ModelConf.gFactor_Range{1} = 2;
% gy range
ModelConf.gFactor_Range{2} = 2;
% gz range
ModelConf.gFactor_Range{3} = 2;
end

