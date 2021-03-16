function [ Model ] = GetModel(TStr, g, Para_List )
load(['tmp_', TStr, '/configuration.mat'])
Model.TStr = TStr;
Model.g = g;

ES_pos = find(strcmp(QMagenConf.Model.Para_Name, QMagenConf.Model.Para_EnScale), 1);
Model.ES = abs(Para_List(ES_pos));

if Model.ES == 0
    error('Energy should not be zero! \n')
end

for i = 1:1:length(Para_List)
    Model = setfield(Model, QMagenConf.Model.Para_Name{i}, Para_List(i)/Model.ES);
end

end

