function [ QMagenConf ] = GetModel(QMagenConf, varargin )

if nargin == 3
    QMagenConf.ModelParaValue.g = varargin{1};
    Para_List = varargin{2};
    
    ES_pos = find(strcmp(QMagenConf.ModelConf.Para_Name, QMagenConf.ModelConf.Para_EnScale), 1);
    QMagenConf.ModelParaValue.ES = abs(Para_List(ES_pos));
    
    if QMagenConf.ModelParaValue.ES == 0
        error('Energy should not be zero! \n')
    end
    
    for i = 1:1:length(Para_List)
        QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, QMagenConf.ModelConf.Para_Name{i}, Para_List(i)/QMagenConf.ModelParaValue.ES);
    end
else
    len = length(varargin);
    if mod(len , 2) == 1
        error('Illegal import format!\n')
    end
    lenp = 2 * length(QMagenConf.ModelConf.Para_Name);
    
    if isfield(QMagenConf.Field, 'B')
        lenp = lenp + 2;
    end
    
    if len ~= 2 * length(QMagenConf.ModelConf.Para_Name) + 2
        error('Not enough input arguement!\n')
    else
        ES_pos = find(strcmp(varargin, QMagenConf.ModelConf.Para_EnScale), 1);
        QMagenConf.ModelParaValue.ES = abs(varargin{ES_pos + 1});
        QMagenConf.ModelConf.Para_Value = cell(length(QMagenConf.ModelConf.Para_Name), 1);
        for i = 1:1:len/2
            if ~strcmp(varargin{2 * i - 1}(1), 'g')
                QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, varargin{2 * i - 1}, varargin{2 * i}/QMagenConf.ModelParaValue.ES);
                pos = find(strcmp(QMagenConf.ModelConf.Para_Name, varargin{2 * i - 1}), 1);
                QMagenConf.ModelConf.Para_Value{pos} = varargin{2 * i};
            else
                QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, varargin{2 * i - 1}, varargin{2 * i});
            end
        end
    end
end
end

