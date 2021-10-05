addpath('../Class/');
addpath('../ExpData/');
addpath('../LossFunc/');
addpath('../ManyBodySolver/');
addpath(genpath('../SpinModel'));
addpath(genpath('../svd_lapack_interface'));
addpath('../UtilityFunc/');
% maxNumCompThreads(16);

% // ==================== User Input: Parameters ==========================
Para.ManyBodySolver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Para.ModelName = 'TLI';
Para.Mode = 'ThDQ';
% // import specific heat data --------------------------------------------


% CmDataTRange: the temperature range to be fitted (Unit: K)
% CmDataTRange = {[T1l, T1u]; [T2l, T2u]; ...};
CmDataTRange = {[0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]};


% CmDataField: the magnetic filed of experimantal data (Unit: Tesla)
% CmDataField = {[B1x, B1y, B1z]; [B2x, B2y, B2z]; ...};
CmDataField = {[0,0,0]; [0,0,1]; [0,0,2]; [0,0,3]; [0,0,4]; [0,0,5]};

% CmDatagInfo: the No. of g factor used for the conversion
% Only require when MoldeConf.gFactor_Type = 'dir';
% CmDatagInfo = {gNum1, gNum2, ...};
CmDatagInfo = {};
%--------------------------------------------------------------------------

% // import susceptibility data -------------------------------------------
ChiDataTRange = {[0.1,90]};
ChiDataField = {[0,0,0.1]};
ChiDatagInfo = {};

% ============================ %
% Loss function customization
% ============================ %
% the weights between different data
% LossConf.WeightList = [], equal weight
% LossConf.WeightList = [w1, w2, ...];
LossConf.WeightList = [];

% type of loss function 
%       'abs-err' absolute error, normalized by maximum value
%       'rel-err' relative error
LossConf.Type = 'abs-err'; % 'abs-err', 'rel-err'

% design of loss function
%       'log'     L = log10(L)
%       'native'  L = L
LossConf.Design = 'log'; % 'native', 'log'

% Interpolation options when fitting
%       'Int2Exp' Interpolation to experimental data
%       'Int2Sim' Interpolation to simulation data
LossConf.IntSet = 'Int2Exp';
% ====================== %
% Save & Plot Settings
% ====================== %
% plot result in each iteration
Setting.PLOTFLAG = 0; % 0 -> off, n -> plot the graph every n iterations

% save intermediate results.
Setting.SAVEFLAG = 1;   % 0 -> off, 1 -> save the best, 2 -> save all

% the file name to save intermediate results.
Setting.SAVENAME = 'TMGO';


% // restart --------------------------------------------------------------

% load('../Tmp/edtest/tmp_20210604_194838/res5.mat')
Restart.XTrace = [];
Restart.ObjTrace = [];
Restart.Resume = [];

% // ====================== Package input data ============================
[ Lattice, ModelConf, Para ] = GetSpinModel( Para );

for i = 1:1:length(CmDataField)
    CmData(i) = ThermoData('Cm', CmDataField{i}, CmDataTRange{i});
    
    if strcmp(ModelConf.gFactor_Type, 'dir')
        CmData(i).Info.g_info = CmDatagInfo{i};
    end
end

for i = 1:1:length(ChiDataField)
    ChiData(i) = ThermoData('Chi', ChiDataField{i}, ChiDataTRange{i});
    
    if strcmp(ModelConf.gFactor_Type, 'dir')
        ChiData(i).Info.g_info = ChiDatagInfo{i};
    end
end

Para.BOPara = ImportBOPara(Para.ManyBodySolver);
QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting,'Restart',Restart, 'Cm', CmData, 'Chi', ChiData);
%only calculate Cm
%QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting, 'Restart', Restart, 'Cm',  CmData);
%only calculate Chi
%QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting, 'Chi', ChiData);

% =========================================================================
% // main function of QMagen

[RsltCvNU, RsltCv, RsltChiNU, RsltChi] = QMagenMain(QMagenConf, 'J1', 10.4, 'J2', 0.58, 'Delta', 6, 'gz', 13);

