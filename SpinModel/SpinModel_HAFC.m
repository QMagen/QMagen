function [ Lattice, ModelConf ] = SpinModel_HAFC( )
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
ModelConf.ModelName = 'HAFC';
ModelConf.ModelName_Full = 'Heisenberg Antiferromagnetic Chain';
ModelConf.Trotter = 'Trotter_HAFC';
ModelConf.AvlbSolver = {'iLTRG'};    % available solvers: iLTRG (full-T)
ModelConf.LocalSpin = '1/2';

% //Some comments are needed [WL]
ModelConf.Para_Name = {'J'; 'Delta'; 'alpha'};
ModelConf.Para_Unit = {'K'; 'ES'; 'ES'};
ModelConf.Para_EnScale = 'J';

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
Lattice.L = Inf;

% =============================================================
% PARAMETERS OPTIMIZATION RANGE SETTINGS
% =============================================================
% J range
ModelConf.Para_Range{1} = [2, 8];
% Delta range
ModelConf.Para_Range{2} = [0, 2];
% alpha range
ModelConf.Para_Range{3} = [0, 1];
% gz range
ModelConf.gFactor_Range{1} = [1.5, 3];
end

