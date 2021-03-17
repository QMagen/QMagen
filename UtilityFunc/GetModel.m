function [ QMagenConf ] = GetModel(QMagenConf, varargin )

if nargin == 3
    QMagenConf.ModelParaValue.g = varargin{1};
    Para_List = varargin{2};
end

ES_pos = find(strcmp(QMagenConf.ModelConf.Para_Name, QMagenConf.ModelConf.Para_EnScale), 1);
QMagenConf.ModelParaValue.ES = abs(Para_List(ES_pos));

if QMagenConf.ModelParaValue.ES == 0
    error('Energy should not be zero! \n')
end

for i = 1:1:length(Para_List)
    QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, QMagenConf.ModelConf.Para_Name{i}, Para_List(i)/QMagenConf.ModelParaValue.ES);
end

end

