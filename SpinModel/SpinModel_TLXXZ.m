function [ GeomConf, ModelConf, Conf ] = SpinModel_TLXXZ( Conf )
% -------------------------------------------------------------
% Triangular lattice
% XXZ model
% Parameter:
%           J1xy        Nearest neighbor SxSx+SySy term
%           J1z         Nearest neighbor SzSz term
%           J2xy        Next-nearest neighbor SxSx+SySy term
%           J2z         Next-nearest neighbor SzSz term
%           gx          Lande factor of Sx direction
%           gz          Lande factor of Sz direction
%
% Hamiltonian:
%   H = \sum_<i,j> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J1z Sz_i Sz_j
%       + \sum_<<i,j>> J1xy (Sx_i Sx_j + Sy_i Sy_j) + J2z Sz_i Sz_j
%       - h\sum_i Sh_i
% -------------------------------------------------------------

% =============================================================
% DEFAULT SETTINGS
% =============================================================
Conf.IntrcMap_Name = 'IntrcMap_TLXXZ';
Conf.ModelName_all = 'Triangular lattice-XXZ model';
Conf.d = 2;
ModelConf.Para_List = {'J1xy', 'J1z', 'J2xy', 'J2z'};
ModelConf.Para_ES = 1;
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
ModelConf.Para_Range{1} = [5, 20];
% J1z range
ModelConf.Para_Range{2} = 'J1xy';
% J2xy range
ModelConf.Para_Range{3} = [0, 20];
% J2z range
ModelConf.Para_Range{4} = 'J2xy';
% gx range
ModelConf.gFactor_Range{1} = 'gz';
% gz range
ModelConf.gFactor_Range{2} = [1.5, 3];
end

