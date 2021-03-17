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
Config.Mode = 'CALC-Cm';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ Lattice, ModelConf, Config ] = GetSpinModel( Config );

Field.h = [0, 0, 0];
QMagenConf = QMagen(Config, ModelConf, Lattice, Field);

QMagenConf = GetModel(QMagenConf, 'J1', 10, 'J2', 5, 'Delta', 5, 'g', [2, 2, 2]);
RunQMagen(QMagenConf)