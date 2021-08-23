function [ H, Id, Ope ] = InitHam(Para)
% function[ H, Id, Ope ] = InitHam(Para)
% Get the MPO form of Hamiltonian and identity.
% H.A = cell(L, 1) is the tensors that make up the MPO of Hamiltonian.
% H.lgnorm is the log norm of H.A.
% Id.A = cell(L, 1) is the tensors that make up the MPO of identity.
% Id.lgnorm = 0;
% Yuan Gao@buaa 2020.12.07
% mail: 17231064@buaa.edu.cn

% Updata: Automata picture 
% Yuan Gao@buaa 2020.04.06
% mail: 17231064@buaa.edu.cn

% Initialize the Hamiltonian by direct sum ================================
% IntrMap = eval([Para.IntrcMap_Name, '(Para)']);
% Op = GetLocalSpace(Para.d);
% H.lgnorm = 0;
% H.A = cell(Para.L, 1);
% HA = H;
% Id.A = cell(Para.L, 1);
% for i = 1:1:length(IntrMap)
%     HA = AssignATensor(HA, Op, IntrMap(i), Para);
%     if i == 1
%         H = HA;
%     else
%         H.A = DircSumMPO(H.A, HA.A);
%     end
% end
% 
% for i = 2:1:(Para.L-1)
%     Id.A{i} = Op.Id4;
% end
% Id.A{1} = Op.Id3;
% Id.A{end} = Op.Id3;
% Id.lgnorm = 0;
% 
% Ope = AssignATensor1Site( Op, Id, Para );
% if norm(Para.Field.h) ~= 0
%     H.A = DircSumMPO(H.A, Ope.Hh.A);
% end
% [H.A, lgnorm] = CompressH(H.A);
% H.lgnorm = H.lgnorm + lgnorm;
% =========================================================================

% Initialize the Hamiltonian by automata picture ==========================
Op = GetLocalSpace(Para.d);
H = AutomataInit(Para);
[H, Ope] = AutomataInit1Site(H, Op, Para);
[H.A, lgnorm] = CompressH(H.A);
H.lgnorm = H.lgnorm + lgnorm;
% =========================================================================

cH = H;
cH.A{1} = conj(cH.A{1});
cH.A{1} = permute(cH.A{1}, [1,3,2]);
cH.A{end} = conj(cH.A{end});
cH.A{end} = permute(cH.A{end}, [1,3,2]);
for i = 2:1:length(cH.A)-1
    cH.A{i} = conj(cH.A{i});
    cH.A{i} = permute(cH.A{i}, [1,2,4,3]);
end
[Hs.A, nm] = VariProdMPO(Para, H.A, cH.A);
Hs.lgnorm = H.lgnorm + cH.lgnorm + log(nm);
Ope.Hs = Hs;
Ope.H = H;
Id.A = cell(Para.L, 1);
for i = 2:1:(Para.L-1)
    Id.A{i} = Op.Id4;
end
Id.A{1} = Op.Id3;
Id.A{end} = Op.Id3;
Id.lgnorm = 0;
Ope.Id = Op.Id;

end

