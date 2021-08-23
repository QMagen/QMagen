% build hamiltonian matrix for General spin-1/2 models
% input:    
%           system size:    L
%           xxx.mat including:
%           2 site terms:   indeces:    [i,j] 
%                           coefficients:   [J+-, Jzz, J++, --, J+z, J-z]   //Note: the code will take care of terms J-+, Jz+, Jz-       
%           1 site terms:   indeces:    [i]
%                           coefficients:   [hz, h+, h-]
% cc@lzu, 20210715

close all
clear 
clc

format long

L=4;
Dim=power(2,L);

% initialization
aux = load('check_onsite.mat');
nt2 = length(aux.Bond_info);
nt1 = length(aux.OnSite_info);

% make sure input data for matlab mex c++ function has correct forms
twosite_index = zeros([nt2,2],'uint32');
twosite_coeff = zeros([nt2,6],'double');
twosite_coeff = complex(twosite_coeff,0);
onesite_index = zeros([nt1,1],'uint32');
onesite_coeff = zeros([nt1,3],'double');
onesite_coeff = complex(onesite_coeff,0);
% 
for i=1:nt2
    for j=1:2
        twosite_index(i,j) = aux.Bond_info(i,j)-1;
    end
    for j=1:6
        twosite_coeff(i,j) = aux.Intr_info(i,j);
    end
end

for i=1:nt1
    onesite_index(i) = aux.OnSite_info(i)-1;
    for j=1:3
        onesite_coeff(i,j) = aux.OnSite_S_info(i,j);
    end
end

tic
% Count No. of nonzero elements
nnz = GeneralSpinHalf_SparseMat_Count_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff);
toc

% Build Sparse matrix (rows, cols, vals)
rows = zeros([1,nnz],'uint32');
cols = zeros([1,nnz],'uint32'); 
vals = zeros([1,nnz],'double');
vals = complex(vals,0);
[rows, cols, vals] = GeneralSpinHalf_SparseMat_Build_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff, rows, cols, vals);
toc

% (rows, cols, vals) to sparse matrix
S = sparse(rows+1,cols+1,vals,Dim,Dim,nnz);
toc

% MATLAB diagonalization
[vs, ds] = eigs(S,1,'smallestreal');
diag(ds)
toc

% Check whether sparse matrix is in the compact form (no repeated index)
xxx = rows*Dim + cols;
bbb = unique(xxx);
size(xxx)
size(bbb)
plot(xxx,'.r')
hold on
plot(bbb,'ob')