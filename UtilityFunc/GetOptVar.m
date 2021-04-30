function [ Para_input, vp, gFac_input, vg ] = GetOptVar( QMagenConf )
Para_input = ['['];
vp = [];
for i = 1:1:length(QMagenConf.ModelConf.Para_Name)
    if isstr(QMagenConf.ModelConf.Para_Range{i})
        Para_input = [Para_input, ['x.', QMagenConf.ModelConf.Para_Range{i}]];
        % fprintf('%10s: %s\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
    elseif length(QMagenConf.ModelConf.Para_Range{i}) == 1
        Para_input = [Para_input, num2str(QMagenConf.ModelConf.Para_Range{i})];
        % fprintf('%10s: %d\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
    else  
        Para_input = [Para_input, ['x.', QMagenConf.ModelConf.Para_Name{i}]];
        % fprintf('%10s: [%d, %d]\n', QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})
        if i ~= length(QMagenConf.ModelConf.Para_Name)
            Para_input = [Para_input, ','];
        end
        vp = [vp, optimizableVariable(QMagenConf.ModelConf.Para_Name{i}, QMagenConf.ModelConf.Para_Range{i})];
    end
end
Para_input = [Para_input, ']'];

gFac_input = ['['];
vg = [];
for i = 1:1:QMagenConf.ModelConf.gFactor_Num
    if isstr(QMagenConf.ModelConf.gFactor_Range{i})
        gFac_input = [gFac_input, ['x.', QMagenConf.ModelConf.gFactor_Range{i}]];
        % fprintf('%10s: %s\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
    elseif length(QMagenConf.ModelConf.gFactor_Range{i}) == 1
        gFac_input = [gFac_input, num2str(QMagenConf.ModelConf.gFactor_Range{i})];
        % fprintf('%10s: %d\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
    else
        gFac_input = [gFac_input, ['x.', QMagenConf.ModelConf.gFactor_Name{i}]];
        % fprintf('%10s: [%d, %d]\n', QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})
        if i ~= QMagenConf.ModelConf.gFactor_Num
            gFac_input = [gFac_input, ','];
        end
        vg = [vg, optimizableVariable(QMagenConf.ModelConf.gFactor_Name{i}, QMagenConf.ModelConf.gFactor_Range{i})];
    end
end
gFac_input = [gFac_input, ']'];
end

