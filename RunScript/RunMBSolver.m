clear all
addpath(genpath('../'))

% =========================================================================
Config.ManyBodySolver = 'iLTRG'; % 'ED', 'iLTRG', 'XTRG'
Config.ModelName = 'XYZC';
Config.Mode = 'CALC-Cm';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

% // set the field to calculate
Field.h = [0, 0, 0];

QMagenConf = QMagen(Config, ModelConf, Lattice, Field);



% // set the parameter value to calculate
QMagenConf = GetModel(QMagenConf, 'Jx', 1, ...
                                  'Jy', 1, ...
                                  'Jz', 1.5);
                              
[Rslt] = QMagenMain(QMagenConf, 'Kmin', 2);
