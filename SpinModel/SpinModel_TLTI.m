function [ Lattice, Model, Conf ] = SpinModel_TLTI( Conf )
% -------------------------------------------------------------
% Triangular lattice
% Transverse field Ising model
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
Model.ModelName = 'TLTI';
Model.ModelName_Full = 'Triangular lattice-Transverse field Ising model';
Model.IntrcMap = 'IntrcMap_TLTI';
Model.LocalSpin = '1/2';
Model.Para_Name = {'J1'; 'J2'; 'Delta'};
Model.Para_EnScale = 'J1';
Model.Para_Range = cell(length(Model.Para_Name), 1);
Model.gFactor_Num = 1;
Model.gFactor_Type = 'xyz';
Model.gFactor_Name = cell(Model.gFactor_Num, 1);
Model.gFactor_Vec = cell(Model.gFactor_Num, 1);
Model.gFactor_Range = cell(Model.gFactor_Num, 1);
Model.gFactor_Name{1} = 'gz';
Model.gFactor_Vec{1} = [0,0,1];


% =============================================================
% GEOMETRY SETTINGS
% =============================================================
Lattice.Lx = 3;
Lattice.Ly = 3;
Lattice.BCX = 'OBC';
Lattice.BCY = 'PBC';
Lattice.L = Lattice.Lx * Lattice.Ly;

% =============================================================
% PARAMETER SETTINGS
% =============================================================
% J1 range
Model.Para_Range{1} = [5, 20];
% J2 range
Model.Para_Range{2} = [0, 5];
% Delta range
Model.Para_Range{3} = [0, 12];
% gz range
Model.gFactor_Range{1} = [5, 20];


end

