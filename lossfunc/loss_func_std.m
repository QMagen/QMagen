function [ loss ] = loss_func( TStr, g, ParaVal )
loss = 0;
len = length(datestr(now,'YYYYmmDD_HHMMSS'));

if len == length(TStr)
    load(['../Tmp/tmp_', TStr, '/configuration.mat'])
else
    load(['../Tmp/tmp_', TStr(2:1:end), '/configuration.mat'])
end

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

global FIGCOUNT
FIGCOUNT = 1;
global FIGTITLE
% // Cm =======================================
RsltCv = cell(length(CmData), 1);
for i = 1:1:length(CmData)
    clear Field
    QMagenConf.Field.B = CmData(i).Info.Field;
    FIGTITLE = CmData(i).Info.Storage(1:1:end-4);
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
            g_fec = g(CmData(i).Info.g_info) * ModelConf.gFactor_Vec{CmData(i).Info.g_info};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    QMagenConf = GetModel(QMagenConf, g_fec, ParaVal);
    %try
        [lossp, RsltCv{i}] = loss_func_Cm(QMagenConf, CmData(i).Info.TRange, CmData(i).Data, loss_type);
    %catch
    %   loss = NaN;
    %   break;
    %end
    loss = loss + lossp * wl(i);
end

% // chi ======================================

RsltChi = cell(length(ChiData), 1);
for i = 1:1:length(ChiData)
    clear Field
    QMagenConf.Field.B = ChiData(i).Info.Field;
    FIGTITLE = ChiData(i).Info.Storage(1:1:end-4);
    if isnan(loss)
        break;
    end
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
            g_fec = g(ChiData(i).Info.g_info) * ModelConf.gFactor_Vec{ChiData(i).Info.g_info};
            for j = 1:1:3
                if g_fec(j) == 0
                    g_fec(j) = 2;
                end
            end
    end
    QMagenConf = GetModel(QMagenConf, g_fec, ParaVal);
    %try
        [lossp, RsltChi{i}] = loss_func_chi(QMagenConf, ChiData(i).Info.TRange, ChiData(i).Data, loss_type);
    %catch
    %   loss = NaN;
    %   break;
    %end
    loss = loss + lossp * wl(i + length(CmData));
end

switch loss_design
    case 'native'
    case 'log'
        loss = log10(loss);
    otherwise
        keyboard;
end

global SAVEFLAG
global MIN_LOSS_VAL
global SAVENAME
global SAVE_COUNT
% keyboard;
ModelVal = struct();

TStrnow = datestr(now,'YYYYmmDD_HHMMSS');

for i = 1:1:length(ParaVal)
    ModelVal = setfield(ModelVal, QMagenConf.ModelConf.Para_Name{i}, ParaVal(i));
end
for i = 1:1:length(g)
    ModelVal = setfield(ModelVal, QMagenConf.ModelConf.gFactor_Name{i}, g(i));
end

if SAVEFLAG == 1 && length(TStr) == length(TStrnow)
    if loss < MIN_LOSS_VAL
        save(['../Tmp/', SAVENAME, 'best.mat'], 'ModelVal', 'RsltCv', 'RsltChi');
        MIN_LOSS_VAL = loss;
    end
    
elseif SAVEFLAG == 2 && length(TStr) == length(TStrnow)
    save(['../Tmp/', SAVENAME, num2str(SAVE_COUNT), '.mat'], 'ModelVal', 'RsltCv', 'RsltChi');
    SAVE_COUNT = SAVE_COUNT + 1;
elseif SAVEFLAG == 2 && length(TStr) ~= length(TStrnow)
    save(['../Tmp/', SAVENAME, [TStr(1), TStrnow], '.mat'], 'ModelVal', 'RsltCv', 'RsltChi');
end

end

