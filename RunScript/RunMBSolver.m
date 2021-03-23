clear all
addpath(genpath('../'))

% =========================================================================
Config.ManyBodySolver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Config.ModelName = 'TLI';
Config.Mode = 'CALC-Chi';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

% // set the field to calculate
Field.h = [0, 0, 0.1];

QMagenConf = QMagen(Config, ModelConf, Lattice, Field);

% // set the parameter value to calculate
QMagenConf = GetModel(QMagenConf, 'J1', 1, ...
                                  'J2', 0.1, ...
                                  'Delta', 0.6);
                              
[Rslt] = QMagenMain(QMagenConf, 'Kmin', 1);