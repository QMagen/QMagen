
% // ========================== TmMgGaO4 ==================================
% ref: Li, et al. Nat. Commun. 11, 1111 (2020).
%
% Spin model [../SpinModel/SpinModel_TLI]
% Bayesian optimization parameters [ImportBOPara.m]
% Many-body solver parameters [ImportMBSolverPara.m]
% =========================================================================
% QMagen Collaboration: YG.BUAA & WL.ITP, 2021-08-30

clear all

addpath('../Class')
addpath('../Expdata')
addpath('../LossFunc')
addpath('../ManyBodySolver')
addpath('../svd_lapack_interface')
addpath('../Tmp')
addpath('../UtilityFunc')

addpath(genpath('../SpinModel'))

% // ==================== User Input: Parameters ==========================
Para.ManyBodySolver = 'ED'; % 'ED', 'iLTRG', 'XTRG'
Para.ModelName = 'TLI';
Para.Mode = 'OPT';

% // import specific heat data --------------------------------------------
% CmDataFile: experimental data file name include Data
%             Data(:,1) -> temperarture   Unit: K
%             Data(:,2) -> specifit heat  Unit: J/(mol K)
% CmDataFile = {'FileName1'; 'FileName2'; ...};
CmDataFile = {'../ExpData/TMGO_C_expdata_0T.mat'};

% CmDataTRange: the temperature range to be fitted (Unit: K)
% CmDataTRange = {[T1l, T1u]; [T2l, T2u]; ...};
CmDataTRange = {[4,40]};

% CmDataField: the magnetic filed of experimantal data (Unit: Tesla)
% CmDataField = {[B1x, B1y, B1z]; [B2x, B2y, B2z]; ...};
CmDataField = {[0,0,0]};

% CmDatagInfo: the No. of g factor used for the conversion
% Only require when MoldeConf.gFactor_Type = 'dir';
% CmDatagInfo = {gNum1, gNum2, ...};
CmDatagInfo = {};
%--------------------------------------------------------------------------

% // import susceptibility data -------------------------------------------
% CmDataFile: experimental data file name include Data
%             Data(:,1) -> temperarture   Unit: K
%             Data(:,2) -> susceptibility Unit: cm^3/mol (1/4pi * emu/mol)
% ChiDataFile = {'FileName1'; 'FileName2'; ...};
ChiDataFile = {'../ExpData/TMGO_Chi_expdata_Sz.mat'};

% ChiDataTRange: the temperature range to be fitted (Unit: K)
% ChiDataTRange = {[T1l, T1u]; [T2l, T2u]; ...};
ChiDataTRange = {[4, 40]};

% CmDataField: the magnetic filed of experimantal data (Unit: Tesla)
% CmDataField = {[B1x, B1y, B1z]; [B2x, B2y, B2z]; ...};
ChiDataField = {[0,0,0.1]};

% ChiDatagInfo: the No. of g factor used for the conversion
% Only require when MoldeConf.gFactor_Type = 'dir';
% ChiDatagInfo = {gNum1, gNum2, ...};
ChiDatagInfo = {};
%--------------------------------------------------------------------------

% // loss function --------------------------------------------------------
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
%--------------------------------------------------------------------------

% // settings -------------------------------------------------------------
% plot result in each iteration
Setting.PLOTFLAG = 0; % 0 -> off, 1 -> on

% save intermediate results
Setting.SAVEFLAG = 2;   % 0 -> off, 1 -> save the best, 2 -> save all

% the file name to save intermediate results.
Setting.SAVENAME = 'TMGO';
%--------------------------------------------------------------------------

% // restart --------------------------------------------------------------
Restart.XTrace = [];
Restart.ObjTrace = [];
Restart.Resume = [];
%--------------------------------------------------------------------------
% =========================================================================


% // ====================== Package input data ============================
[ Lattice, ModelConf, Para ] = GetSpinModel( Para );

for i = 1:1:length(CmDataFile)
    CmData(i) = ThermoData('Cm', CmDataField{i}, CmDataTRange{i}, CmDataFile{i});
    
    if strcmp(ModelConf.gFactor_Type, 'dir')
        CmData(i).Info.g_info = CmDatagInfo{i};
    end
end

for i = 1:1:length(ChiDataFile)
    ChiData(i) = ThermoData('Chi', ChiDataField{i}, ChiDataTRange{i}, ChiDataFile{i});
    
    if strcmp(ModelConf.gFactor_Type, 'dir')
        ChiData(i).Info.g_info = ChiDatagInfo{i};
    end
end

Para.BOPara = ImportBOPara(Para.ManyBodySolver);
QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting, 'Restart', Restart, 'Cm', CmData, 'Chi', ChiData);
% =========================================================================

% // main function of QMagen
QMagenMain(QMagenConf)