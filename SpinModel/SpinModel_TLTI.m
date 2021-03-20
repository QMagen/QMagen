function [ Lattice, ModelConf ] = SpinModel_TLTI( )
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
ModelConf.ModelName = 'TLTI';      
ModelConf.ModelName_Full = 'Triangular-Lattice Transverse Field Ising Model';
ModelConf.IntrcMap = 'IntrcMap_TLTI';
ModelConf.AvlbSolver = {'ED', 'XTRG'};    % can be solved by ED (high-T) and XTRG (low-T)
ModelConf.LocalSpin = '1/2';
ModelConf.Para_Name = {'J1'; 'J2'; 'Delta'};
ModelConf.Para_EnScale = 'J1';
ModelConf.Para_Range = cell(length(ModelConf.Para_Name), 1);
ModelConf.gFactor_Num = 1;
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
Lattice.BCX = 'OBC';
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

