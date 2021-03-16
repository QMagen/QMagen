classdef QMagen < matlab.mixin.CustomDisplay
% A data type for QMagen Optimaization with properties
% [.] has default values or can be computed from other variables.
% 
% .Config
%       .ManyBodySolver     
%       .ModelName          
%       .Mode   
% 
% .ModelConf
%       .[ModelName]
%       .[ModelName_Full]
%       .[IntrcMap]
%       .[LocalSpin]
%       .[Para_Name]
%       .[Para_EnScale]
%       .Para_Range  
%       .[gFactor_Num]
%       .[gFactor_Type] 
%       .[gFactor_Name] 
%       .[gFactor_Vec]
%       .gFactor_Range      
%       
% .Lattice
%       .[L]
%       .Lx
%       .Ly
%       .BCX
%       .BCY
%
% .LossConf
%       .WeightList
%       .Type
%       .Design
%
% .Setting
%       .PLOTFLAG            
%       .EVOFLAG           
%       .SAVEFLAG            
%       .SAVENAME        
% -------------------------------------------------
% Usage: 
%       QMagenConf(Conf, ModelConf, GeomConf, Setting)
%       QMagenConf(Conf, ModelConf, GeomConf, LossConf, Setting, 'Thermo data name', ThermoData)
% -------------------------------------------------
% YG@BUAA, Mar16
  
properties
    Config
    ModelConf
    Lattice
    LossConf
    Setting
    CmData
    ChiData
end
  
methods
    function obj = QMagen(Config, ModelConf, Lattice, LossConf, Setting, varargin)
        % Constructor
        if nargin > 0
            obj.Config = Config;
            obj.ModelConf = ModelConf;
            obj.Lattice = Lattice;
            obj.LossConf = LossConf;
            obj.Setting = Setting;
            len = length(varargin);
            if len ~= 2 && len ~= 4
                error('Illegal thermodynamic data import format!\n')
            else
               for i = 1:1:len/2
                   switch varargin{2 * i - 1}
                       case {'C', 'c', 'Cm', 'cm'}
                           obj.CmData = varargin{2 * i};
                       case {'Chi', 'chi'}
                           obj.ChiData = varargin{2 * i};
                   end
               end
            end
        end
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
