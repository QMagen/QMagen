function [ ModelConf ] = SetParaVal( ModelConf, varargin )
len = length(varargin);

if mod(len, 2) == 1
    error('Input error!\n')
end

for i = 1:1:length(varargin)/2
    logical_array = strcmp(ModelConf.Para_Name, varargin{2 * i - 1});
    loc = find(logical_array, 1);
    if isempty(loc)
        error('Undefined parameter name!\n')
    else
        ModelConf.Para_Range{loc} = varargin{2 * i};
    end
    
end

end

