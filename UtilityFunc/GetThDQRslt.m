function [ RsltCvNU, RsltCv, RsltChiNU, RsltChi ] = GetThDQRslt( TStr, g, ParaVal )


len = length(datestr(now,'YYYYmmDD_HHMMSS'));

if len == length(TStr)
    load(['../Tmp/tmp_', TStr, '/configuration.mat'])
else
    load(['../Tmp/tmp_', TStr(2:1:end), '/configuration.mat'])
end

ModelConf = QMagenConf.ModelConf;
CmData = QMagenConf.CmData;
ChiData = QMagenConf.ChiData;


% // Cm =======================================
RsltCvNU = cell(length(CmData), 1);
RsltCv = cell(length(CmData), 1);
for i = 1:1:length(CmData)
    clear Field
    QMagenConf.Field.B = CmData(i).Info.Field;
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
    
    ThDQ = 'Cm';
    [RsltCvNU{i}, RsltCv{i}] = GetResult(QMagenConf, 0.9 * min(CmData(i).Info.TRange), ThDQ);

end

% // chi ======================================

RsltChiNU = cell(length(ChiData), 1);
RsltChi = cell(length(ChiData), 1);
% chivvopt = zeros(length(ChiData), 1);
for i = 1:1:length(ChiData)
    clear Field
    QMagenConf.Field.B = ChiData(i).Info.Field;
   
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
    
    ThDQ = 'Chi';

    [RsltChiNU{i}, RsltChi{i}] = GetResult(QMagenConf, 0.9 * min(ChiData(i).Info.TRange), ThDQ);

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
    
if SAVEFLAG ~= 0 && length(TStr) == length(TStrnow)
    save(['../Tmp/', SAVENAME, num2str(SAVE_COUNT), '.mat'], 'ModelVal', ...
          'RsltCvNU', 'RsltCv', 'RsltChiNU', 'RsltChi');
    SAVE_COUNT = SAVE_COUNT + 1;
elseif SAVEFLAG ~= 0 && length(TStr) ~= length(TStrnow)
    save(['../Tmp/', SAVENAME, [TStr(1), TStrnow], '.mat'], 'ModelVal', ...
          'RsltCvNU', 'RsltCv', 'RsltChiNU', 'RsltChi');
end

end

