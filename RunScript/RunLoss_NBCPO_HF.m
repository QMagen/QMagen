
ParaData = [
1.1044  1.4887 -0.93995  -0.025366  4.1731 4.8316 
0.80316 1.6585 -0.083204 -0.11698   4.3291 4.8918
0.35958 1.5096 0.67115   -0.30525   4.1466 4.866];
J1xy = ParaData(:,1);
J1z = ParaData(:,2);
JPD = ParaData(:,3);
JGamma = ParaData(:,4);
J2xy = zeros(length(ParaData(:,1)),1);
J2z = J2xy;
gx = ParaData(:,5);
gz = ParaData(:,6);

addpath('../Class/');
addpath('../ExpData/');
addpath('../LossFunc/');
addpath('../ManyBodySolver/');
addpath(genpath('../SpinModel'));
addpath(genpath('../svd_lapack_interface'));
addpath('../UtilityFunc/');
% maxNumCompThreads(16);

% // ==================== User Input: Parameters ==========================
Para.ManyBodySolver = 'ED_C'; % 'ED', 'iLTRG', 'XTRG'
Para.ModelName = 'NBCPO';
% Para.Mode = 'LOSS';
Para.Mode = 'ThDQ';
% // import specific heat data --------------------------------------------


% CmDataTRange: the temperature range to be fitted (Unit: K)
% CmDataTRange = {[T1l, T1u]; [T2l, T2u]; ...};
CmDataTRange = {[0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]; [0.1, 10]};
%CmDataTRange = {[0.5, 4];[1, 4];[1.5, 4]
%;[1.5,4];...
 %               [1.5,4];[1,4];[1,4    };
% CmDataTRange = {};

% CmDataField: the magnetic filed of experimantal data (Unit: Tesla)
% CmDataField = {[B1x, B1y, B1z]; [B2x, B2y, B2z]; ...};
%CmDataField = {[0, 0, 0];[0, 0, 0.5];[0, 0, 1]
%;[0, 0, 1.5];
%              [0, 0, 2];[0, 0, 3];[0, 0, 4]};

CmDataField = {[0,0,0]; [0,0,1]; [0,0,2]; [0,0,3]; [0,0,4]; [0,0,5]};

% CmDatagInfo: the No. of g factor used for the conversion
% Only require when MoldeConf.gFactor_Type = 'dir';
% CmDatagInfo = {gNum1, gNum2, ...};
CmDatagInfo = {};
%--------------------------------------------------------------------------

% // import susceptibility data -------------------------------------------
% Bx = 0.1:0.1:8;
% Bz = 0.1:0.1:8;
% len = length(Bx) + length(Bz);
% % ChiDataTRange: the temperature range to be fitted (Unit: K)
% % ChiDataTRange = {[T1l, T1u]; [T2l, T2u]; ...};
% ChiDataTRange = cell(len, 1);
% ChiDataTRange(:) = {[1, 90]};
% 
% % CmDataField: the magnetic filed of experimantal data (Unit: Tesla)
% % CmDataField = {[B1x, B1y, B1z]; [B2x, B2y, B2z]; ...};
% ChiDataField = cell(len, 1);
% for i = 1:1:length(Bx)
%     ChiDataField(i) = {[Bx(i), 0, 0]};
% end
% 
% for j = 1:1:length(Bz)
%     ChiDataField(i+j) = {[0, 0, Bz(j)]};
% end
ChiDataTRange = {[0.1,90]; [0.1,90]};
ChiDataField = {[0.1,0,0]; [0,0,0.1]};
% ChiDatagInfo: the No. of g factor used for the conversion
% Only require when MoldeConf.gFactor_Type = 'dir';
% ChiDatagInfo = {gNum1, gNum2, ...};
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
Setting.SAVENAME = 'XTRGYC46HF';


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
%only fit Cm
%QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting, 'Restart', Restart, 'Cm',  CmData);
%only fit Chi
%QMagenConf = QMagen(Para, ModelConf, Lattice, LossConf, Setting, 'Chi', ChiData);

% =========================================================================
% // main function of QMagen

[RsltCvNU, RsltCv, RsltChiNU, RsltChi] = QMagenMain(QMagenConf, 'J1xy', J1xy, 'J1z', J1z , 'J2xy', J2xy, ...
                  'JPD', JPD, 'JGamma', JGamma, 'J2z', J2z, 'gx', gx, 'gz', gz);

