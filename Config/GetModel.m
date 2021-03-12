function [ Model ] = GetModel(TStr, g, varagin )
load(['tmp_', TStr, '/configuration.mat'])
Model.TStr = TStr;
Model.g = g;
Model.ES = abs(varagin(1));
Model.Name = 'TMGO';
for i = 1:1:length(varagin)
    Model = setfield(Model, ModelConf.Para{i}, varagin(i)/Model.ES);
end
end

