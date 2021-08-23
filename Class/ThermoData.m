classdef ThermoData < matlab.mixin.CustomDisplay
  % A data type for QMagen Optimaization
  % with properties
  % .Data: a two-column data
  %        .Data(:,1) for Temperature
  %        .Data(:,2) for the values
  % .Info.Name:     Name of the data
  % .Info.Field:    field
  % .Info.g_info:   gFactor
  % .Info.TRange:   temperature range for fitting
  % .Info.Storage:  where data is storage in hard drive
  % -------------------------------------------------
  % Usage: ThermoData(Name, Field, TRange, Storage)
  % -------------------------------------------------
  % BC@BUAA, Mar12
  
  properties
    Data
    Info
  end
  
  methods
    function obj = ThermoData(name, field, TRange, varargin)
      % Constructor
      if nargin>0
        if ischar(name)
          obj.Info.Name = name;
        else
          error('Name#1 not char?!');
        end
        
        if isnumeric(field) && numel(field)==3
          obj.Info.Field = field;
        else
          error('field#2 not numerics or not 3-d array?!');
        end
        
        if isnumeric(TRange) && numel(TRange)==2
          obj.Info.TRange = TRange;
        else
          error('TRange#3 not numerics or not 2-d array?!');
        end
        
        obj.Info.g_info = [];
        if ~isempty(varargin)
            storage = varargin{1};
            if ischar(storage)
                obj.Info.Storage = storage;
            else
                error('storage#4 not char?!');
            end
            obj = obj.loadStorage_();
        else
            obj.Data = [0,0];
        end
      end
    end
    
    
    function obj = loadStorage_(obj)
      % load data from disk
      obj.Data = struct2array(load(obj.Info.Storage));
    end
    
  end
  
  methods (Access=protected)
    function displayScalarObject(obj)
      if isempty(obj.Info)
        fprintf('(empty ThermoData)\n');
      else
        fprintf('\n(ThermoData):\n');
        fprintf('\tField   |  (%2g,%2g,%2g)\n',obj.Info.Field);
        fprintf('\tData    | %7s|  %8s\n','T',obj.Info.Name);
        fprintf('\t%s\n',repmat('-',1,26));
        n_ = size(obj.Data,1);
        for i_=1:3
          fprintf('\t\t|%8g|  %8g\n',obj.Data(i_,:));
        end
        fprintf('\t\t|%8s|  %8s\n','...','...');
        for i_=n_-2:n_
          fprintf('\t\t|%8g|  %8g\n',obj.Data(i_,:));
        end
        fprintf('\n')
      end
    end
    
    function displayNonScalarObject(objAry)
      for obj=objAry
        displayScalarObject(obj);
      end
    end
    
  end
  
  
end
