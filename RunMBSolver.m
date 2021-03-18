clear all
addpath('lossfunc')
addpath('ManyBodySolver')
addpath('UtilityFunc')
addpath (genpath('SpinModel'))
addpath ('Class')

% TStr = datestr(now,'YYYYmmDD_HHMMSS');

% =========================================================================
Config.ManyBodySolver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Config.ModelName = 'TLTI';
Config.Mode = 'CALC-Chi';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

Field.h = [0, 0, 0.1];

QMagenConf = QMagen(Config, ModelConf, Lattice, Field);

QMagenConf = GetModel(QMagenConf, 'J1', 1, ...
                                  'J2', 0.1, ...
                                  'Delta', 0.6);
                              
[Rslt] = QMagenMain(QMagenConf, 'Kmin', 1);