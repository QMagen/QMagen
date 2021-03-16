function [ loss ] = loss_func( TStr, g, ParaVal )
loss = 0;
load(['tmp_', TStr, '/configuration.mat'])

ModelConf = QMagenConf.ModelConf;
CmData = QMagenConf.CmData;
ChiData = QMagenConf.ChiData;
LossConf = QMagenConf.LossConf;

wl = LossConf.WeightList;
loss_type = LossConf.Type;
loss_design = LossConf.Design;

if isempty(wl)
    wl = zeros(length(CmData) + length(ChiData), 1);
    wl(:) = 1;
end

% // Cm =======================================

RsltCv = cell(length(CmData), 1);
for i = 1:1:length(CmData)
    clear Field
    Field.B = CmData(i).Info.Field;
    switch ModelConf.gFactor_Type
        case 'xyz'
            g_fec = [0, 0, 0];
            for j = 1:1:ModelConf.gFactor_Num
                g_fec = g_fec + g(j) * ModelConf.gFactor_Vec{j};
            end
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
        case 'dir'
            g_fec = g(CmData.Info.g_info{i}) * ModelConf.gFactor_Vec{CmData.Info.g_info{i}};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    Model = GetModel(TStr, g_fec, ParaVal);
    [lossp, RsltCv{i}] = loss_func_Cm(Model, Field, CmData(i).Info.TRange, CmData(i).Data, loss_type);
    loss = loss + lossp * wl(i);
end

% // chi ======================================

RsltChi = cell(length(ChiData), 1);
for i = 1:1:length(ChiData)
    Field.B = ChiData(i).Info.Field;
    switch ModelConf.gFactor_Type
        case 'xyz'
            g_fec = [0, 0, 0];
            for j = 1:1:ModelConf.gFactor_Num
                g_fec = g_fec + g(j) * ModelConf.gFactor_Vec{j};
            end
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
        case 'dir'
            g_fec = g(ChiData.Info.g_info{i}) * ModelConf.gFactor_Vec{Chidata.Info.g_info{i}};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    Model = GetModel(TStr, g_fec, ParaVal);
    [lossp, RsltChi{i}] = loss_func_chi(Model, Field, ChiData(i).Info.TRange, ChiData(i).Data, loss_type);
    loss = loss + lossp * wl(i + length(CmData));
end

switch loss_design
    case 'native'
    case 'log'
        loss = log(loss);
    otherwise
        keyboard;
end

global SAVEFLAG
global MIN_LOSS_VAL
global SAVENAME
global SAVE_COUNT

if SAVEFLAG == 1
    if loss < MIN_LOSS_VAL
        save(SAVENAME, 'best.mat', 'RsltCv', 'RsltChi');
        MIN_LOSS_VAL = loss;
    end
    
elseif SAVEFLAG == 2
    save([SAVENAME, num2str(SAVE_COUNT), '.mat'], 'RsltCv', 'RsltChi');
    SAVE_COUNT = SAVE_COUNT + 1;
end
end

