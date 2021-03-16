clear all
addpath('lossfunc')
addpath('ManyBodySolver')
addpath('UtilityFunc')
addpath (genpath('SpinModel'))
addpath ('Class')
% =========================================================================
Conf.many_body_solver = 'XTRG'; % 'ED', 'iLTRG', 'XTRG'         
Conf.ModelName = 'TLARX';

% =========================================================================
% MODEL SPECIFICATION
% =========================================================================
[ GeomConf, ModelConf, Conf ] = GetSpinModel( Conf );
save('ModelConfig/TLARX_TMGO_XTRG_YC6x9.mat', 'Conf', 'GeomConf', 'ModelConf');
[ ModelConf ] = SetParaVal(ModelConf, 'J1xy', 1);