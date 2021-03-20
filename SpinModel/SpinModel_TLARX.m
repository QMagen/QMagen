function [ Lattice, ModelConf, Conf ] = SpinModel_TLARX( Conf )
% -------------------------------------------------------------
% Triangular lattice
% ARX model
% Parameter:
%           J1xy        Nearest neighbor SxSx+SySy term
%           J1z         Nearest neighbor SzSz term
%           Jpm         Nearest neighbor gamma_ij S+S+ + h.c.
%           Jpmz        Nearest neighbor gamma_ij* S+Sz - gamma_ij S-Sz + <i<->j>
%           J2xy        Next-nearest neighbor SxSx+SySy term
%           J2z         Next-nearest neighbor SzSz term
%           Delta       Transverse field term
% Hamiltonian:
%   H = \sum_<i,j> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%                  +Jpm (gamma_ij S+_i S+_j + h.c.)
%                  -Jpmz 1i/2 (gamma_ij* S+_i Sz_j - gamma_ij S-_i Sz_j + <i<->j>)
%       + \sum_<<i,j>> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%       - Delta\sum_i Sx_i
%       - h\sum_i Sh_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
ModelConf.ModelName = 'TLARX';
ModelConf.ModelName_Full = 'Triangular-Lattice ARX model';
ModelConf.IntrcMap = 'IntrcMap_TLARX';
ModelConf.LocalSpin = '1/2';
ModelConf.Para_Name = {'J1xy'; 'J1z'; 'Jpm'; 'Jpmz'; 'J2xy'; 'J2z'; 'Delta'};
ModelConf.Para_Unit = {'K'; 'K'; 'K'; 'K'; 'K'; 'K'; 'K'};
ModelConf.Para_EnScale = 'J1z';
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
Lattice.Lx = 3;
Lattice.Ly = 3;
Lattice.BCX = 'OBC';
Lattice.BCY = 'PBC';
Lattice.L = Lattice.Lx * Lattice.Ly;

% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS 
% =============================================================
% J1xy range
ModelConf.Para_Range{1} = [-10, 10];
% J1z range
ModelConf.Para_Range{2} = [5 10];
% Jpm range
ModelConf.Para_Range{3} = [-10, 10];
% Jpmz range
ModelConf.Para_Range{4} = [-10, 10];
% J2xy range
ModelConf.Para_Range{5} = [-10, 10];
% J2z range
ModelConf.Para_Range{6} = [0, 5];
% Delta range
ModelConf.Para_Range{7} = [0, 10];
% gx range
ModelConf.gFactor_Range{1} = 'gz';
% gz range
ModelConf.gFactor_Range{2} = [4, 20];
end

