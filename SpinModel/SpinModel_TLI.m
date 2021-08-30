function [ Lattice, ModelConf ] = SpinModel_TLI( )
% -------------------------------------------------------------
% Triangular lattice
% Transverse field Ising ModelConf
% Parameter:
%           J1     Nearest neighbor term
%           J2     Next-nearest neighbor term
%           Delta  Transverse field term
%           gz     Lande factor of Sz direction
%
% Hamiltonian:
%   H = J1 \sum_<i,j> Sz_i Sz_j
%       + J2 \sum_<<i,j>> Sz_i Sz_j
%       - Delta\sum_i Sx_i
%       - hz\sum_i Sz_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
ModelConf.ModelName = 'TLI';      
ModelConf.ModelName_Full = 'Triangular-Lattice Transverse Field Ising Model';
ModelConf.IntrcMap = 'IntrcMap_TLI';
ModelConf.AvlbSolver = {'ED', 'XTRG'};    % can be solved by ED (high-T) and XTRG (low-T)
ModelConf.LocalSpin = '1/2';

% Parameters' name in Hamiltonian
ModelConf.Para_Name = {'J1'; 'J2'; 'Delta'};
% Parameters' unit
%  'K':   Set the unit as Kelvin.
%  'ES':  Set the unit as energy scale, i.e. the correspoding term
%         interaction strength is [*] times of energy scale.
ModelConf.Para_Unit = {'K'; 'K'; 'K'};
% Energy scale of this model, choose one from ModelConf.Para_Name
ModelConf.Para_EnScale = 'J1';
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
Lattice.Lx = 3;
Lattice.Ly = 3;
Lattice.BCX = 'PBC';
Lattice.BCY = 'PBC';
Lattice.L = Lattice.Lx * Lattice.Ly;

% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS
% =============================================================
% J1 range
ModelConf.Para_Range{1} = [5, 20];
% J2 range
ModelConf.Para_Range{2} = [0, 5];
% Delta range
ModelConf.Para_Range{3} = [0, 12];
% gz range
ModelConf.gFactor_Range{1} = [5, 20];


end

