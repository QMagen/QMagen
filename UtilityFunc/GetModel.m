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
        if strcmp(QMagenConf.ModelConf.Para_Unit{i}, 'ES')
            QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, QMagenConf.ModelConf.Para_Name{i}, Para_List(i));
        else
            QMagenConf.ModelParaValue = setfield(QMagenConf.ModelParaValue, QMagenConf.ModelConf.Para_Name{i}, Para_List(i)/QMagenConf.ModelParaValue.ES);
        end
    end
else
    len = length(varargin);
    if mod(len , 2) == 1
        error('Illegal import format!')
    end
    lenp = 2 * length(QMagenConf.ModelConf.Para_Name);
    
    if isfield(QMagenConf.Field, 'B')
        lenp = lenp + 2;
    end
    
    if len ~= 2 * length(QMagenConf.ModelConf.Para_Name)
        error('Not enough input arguement!')
    else
        ES_pos = find(strcmp(varargin, QMagenConf.ModelConf.Para_EnScale), 1);
        QMagenConf.ModelParaValue.ES = abs(varargin{ES_pos + 1});
        if QMagenConf.ModelParaValue.ES ~= 1
            error('The energy scaling should be 1!')
        end
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

