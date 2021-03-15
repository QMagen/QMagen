function [ Model ] = GetModel(TStr, g, varagin )
load(['tmp_', TStr, '/configuration.mat'])
Model.TStr = TStr;
Model.g = g;
Model.ES = abs(varagin(ModelConf.Para_ES));
Model.Name = 'TMGO';
for i = 1:1:length(varagin)
    Model = setfield(Model, ModelConf.Para_List{i}, varagin(i)/Model.ES);
end
end

