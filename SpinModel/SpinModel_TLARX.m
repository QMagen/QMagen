function [ GeomConf, ModelConf, Conf ] = SpinModel_TLARX( Conf )
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
Conf.IntrcMap_Name = 'IntrcMap_TLARX';
Conf.ModelName_all = 'Triangular lattice-ARX model';
Conf.d = 2;
ModelConf.Para_List = {'J1xy', 'J1z', 'Jpm', 'Jpmz', 'J2xy', 'J2z', 'Delta'};
ModelConf.Para_ES = 2;
ModelConf.Para_Range = cell(length(ModelConf.Para_List), 1);
ModelConf.Num_gFactor = 2;
ModelConf.Type_gFactor = 'xyz';
ModelConf.gFactor = cell(ModelConf.Num_gFactor, 1);
ModelConf.gFactor_Vec = cell(ModelConf.Num_gFactor, 1);
ModelConf.gFactor_Range = cell(ModelConf.Num_gFactor, 1);
ModelConf.gFactor{1} = 'gx';
ModelConf.gFactor_Vec{1} = [1,0,0];
ModelConf.gFactor{2} = 'gz';
ModelConf.gFactor_Vec{2} = [0,0,1];

% =============================================================
% GEOMETRY SETTINGS
% =============================================================
GeomConf.Lx = 3;
GeomConf.Ly = 3;
GeomConf.BCX = 'OBC';
GeomConf.BCY = 'PBC';
Conf.L = GeomConf.Lx * GeomConf.Ly;

% =============================================================
% PARAMETER SETTINGS
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

