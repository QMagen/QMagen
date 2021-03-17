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
%       .Para_Range         % For 'OPT' & 'LOSS'
%       .[gFactor_Num]
%       .[gFactor_Type] 
%       .[gFactor_Name] 
%       .[gFactor_Vec]
%       .gFactor_Range      % For 'OPT' & 'LOSS'
%
% .Lattice
%       .[L]
%       .Lx
%       .Ly
%       .BCX
%       .BCY
%
% .Field
%       .B
%       .h
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
%       QMagenConf(Conf, ModelConf, Lattice, LossConf, Setting, 'Thermo data name', ThermoData)
%       QMagenConf(Conf, ModelConf, Lattice)
% -------------------------------------------------
% YG@BUAA, Mar16
  
properties
    Config
    ModelConf
    ModelParaValue
    Lattice
    Field
    LossConf
    Setting
    CmData
    ChiData
end
  
methods
    function obj = QMagen(Config, ModelConf, Lattice, varargin)
        if nargin == 7 || nargin == 9
            obj.Config = Config;
            obj.ModelConf = ModelConf;
            obj.Lattice = Lattice;
            obj.LossConf = varargin{1};
            obj.Setting = varargin{2};
            len = length(varargin);
            if len ~= 4 && len ~= 6
                error('Illegal thermodynamic data import format!\n')
            else
               for i = 1:1:(len-2)/2
                   switch varargin{2 * i + 1}
                       case {'C', 'c', 'Cm', 'cm'}
                           obj.CmData = varargin{2 * i + 2};
                       case {'Chi', 'chi'}
                           obj.ChiData = varargin{2 * i + 2};
                   end
               end
            end
        end
    end
    
end
  
methods (Access=protected)
    function displayScalarObject(obj)
        if isempty(obj.Config)
            fprintf('(empty ThermoData)\n');
        else
            fprintf('\nQMagen Configuration:\n');
            fprintf('-------------------------------------------------------------------------------------------\n')
            fprintf('\tModel Name         |  %s\n', obj.ModelConf.ModelName_Full);
            fprintf('\tMany-Body Solver   |  %s\n', obj.Config.ManyBodySolver);
            if strcmp(obj.Config.Mode, 'OPT')
                fprintf('\tOptimizer          |  %s\n', 'Bayesian Optimizer');
            end
            fprintf('-------------------------------------------------------------------------------------------\n')
            fprintf('Lattice Geometry:\n');
            if isfield(obj.Lattice, 'Lx')
                fprintf('\tLx                 |  %d\n', obj.Lattice.Lx);
            end
            if isfield(obj.Lattice, 'Ly')
                fprintf('\tLy                 |  %d\n', obj.Lattice.Ly);
            end
            if isfield(obj.Lattice, 'Lx')
                fprintf('\tBCX                |  %s\n', obj.Lattice.BCX);
            end
            if isfield(obj.Lattice, 'Lx')
                fprintf('\tBCY                |  %s\n', obj.Lattice.BCY);
            end
            fprintf('\tL                  |  %d\n', obj.Lattice.L);
            fprintf('-------------------------------------------------------------------------------------------\n')
            switch obj.Config.Mode
                case 'OPT'
                    fprintf('Parameters Optimization Range:\n');
                    for i = 1:1:length(obj.ModelConf.Para_Name)
                        fprintf('\t%-18s |  ', obj.ModelConf.Para_Name{i})
                        if ischar(obj.ModelConf.Para_Range{i})
                            fprintf('%s\n', obj.ModelConf.Para_Range{i})
                        elseif length(obj.ModelConf.Para_Range{i}) == 2
                            fprintf('[%.3f, %.3f]\n', obj.ModelConf.Para_Range{i})
                        elseif length(obj.ModelConf.Para_Range{i}) == 1
                            fprintf('%.3f\n', obj.ModelConf.Para_Range{i})
                        else
                            error('??????????\n')
                        end
                    end
                case {'LOSS', 'CALC-Cm', 'CALC-Chi'}
                    fprintf('Parameters Value:\n');
                    for i = 1:1:length(obj.ModelConf.Para_Name)
                        fprintf('\t%-18s |  %.3f', obj.ModelConf.Para_Name{i}, obj.ModelConf.Para_Value{i})
                    end
            end
            fprintf('-------------------------------------------------------------------------------------------\n')
%             fprintf('\tData    | %7s|  %8s\n','T',obj.Info.Name);
%             fprintf('\t%s\n',repmat('-',1,26));
%             n_ = size(obj.Data,1);
%             for i_=1:3
%                 fprintf('\t\t|%8g|  %8g\n',obj.Data(i_,:));
%             end
%             fprintf('\t\t|%8s|  %8s\n','...','...');
%             for i_=n_-2:n_
%                 fprintf('\t\t|%8g|  %8g\n',obj.Data(i_,:));
%             end
%             fprintf('\n')
        end
    end
    
    function displayNonScalarObject(objAry)
        for obj=objAry
            displayScalarObject(obj);
        end
    end
    
end
  
  
end
