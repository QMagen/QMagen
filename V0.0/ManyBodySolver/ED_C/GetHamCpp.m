function [H, M] = GetHamCpp(Para, IntrMap)
L = Para.L;
d = Para.d;

if d ~= 2
    error(['The Model is not spin-1/2! Please use', char(39), 'ED', char(39), 'instead of ', char(39), 'ED_C', char(39), '!']);
end
% =========================================================================
% from 'Sx Sy Sz' to 'S+ S- Sz'
Bond_info = zeros(length(IntrMap), 2);
Intr_info = zeros(length(IntrMap), 6);
Change_Matrix = [1/2, -1i/2, 0; 1/2, 1i/2, 0; 0, 0, 1];
for i = 1:1:length(IntrMap)
    Bond_info(i, 1) = IntrMap(i).JmpOut;
    Bond_info(i, 2) = IntrMap(i).JmpIn;
    
    switch IntrMap(i).JmpOut_type
        case 'Sx'
            m_l = [1;0;0];
            m = 1;
        case 'Sy'
            m_l = [0;1;0];
            m = 2;
        case 'Sz'
            m_l = [0;0;1];
            m = 3;
    end
    
    switch IntrMap(i).JmpIn_type
        case 'Sx'
            n_l = [1;0;0];
            n = 1;
        case 'Sy'
            n_l = [0;1;0];
            n = 2;
        case 'Sz'
            n_l = [0;0;1];
            n = 3;
    end
    %     MXp = zeros(3);
    %     MXp(m,n) = IntrMap(i).CS;
    %     MXp = Change_Matrix * MXp * transpose(Change_Matrix);
    %     if i > 47
    %         keyboard;
    %     end
    Mx = IntrMap(i).CS * kron(Change_Matrix * m_l, transpose(Change_Matrix * n_l));
    Intr_info(i,:) = [Mx(1,2), Mx(3,3), Mx(1,1), Mx(2,2), Mx(1,3), Mx(2,3)];
    %     Intr_info(i,:) = reshape(Mx, [9, 1]);
    %     Intr_info(i,:) = [1/2, 1, 0, 0, 0, 0];
    %     norm(Mx'-Mx)
end

inputdata.Bond_info = Bond_info;
inputdata.Intr_info = Intr_info;
clear Bond_info
clear Intr_info

% =========================================================================
% simplify
count = 0;
for i = 1:1:length(inputdata.Bond_info(:,1))
    check = 0;
    if i == 1
        count = count + 1;
        Bond_info(count,:) = inputdata.Bond_info(1,:);
        Intr_info(count,:) = inputdata.Intr_info(1,:);
        
    else
        for j = 1:count
            if norm(Bond_info(j,:)-inputdata.Bond_info(i,:)) == 0
                Intr_info(j,:) = Intr_info(j,:) + inputdata.Intr_info(i,:);
                check = 1;
                break
            end
        end
        if check ~= 1
            count = count + 1;
            Bond_info(count,:) = inputdata.Bond_info(i,:);
            Intr_info(count,:) = inputdata.Intr_info(i,:);
        end
    end
end

aux.Bond_info = Bond_info;
aux.Intr_info = Intr_info;

% =========================================================================
h = Para.Field.h;
% Change_Matrix = [1, -1i, 0; 1, 1i, 0; 0, 0, 1];
Change_Matrix = [1/2, -1i/2, 0; 1/2, 1i/2, 0; 0, 0, 1];
if norm(Para.Field.h) ~= 0
    OnSite_info = 1:L;
    for i = 1:1:L
        Mx = Change_Matrix * transpose(h);
        OnSite_S_info(i,:) = [Mx(3), Mx(1), Mx(2)];
    end
else
    OnSite_info = [];
    OnSite_S_info = [];
end
aux.OnSite_info = OnSite_info;
aux.OnSite_S_info = OnSite_S_info;
% =========================================================================

% keyboard;
Dim=power(2,L);

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

% make sure input data for matlab mex c++ function has correct forms:
% convert possible "double" to "complex"
if isreal(twosite_coeff)
    twosite_coeff = complex(twosite_coeff,0);
end
if isreal(onesite_coeff)
    onesite_coeff = complex(onesite_coeff,0);
end


% Count No. of nonzero elements
nnz = GeneralSpinHalf_SparseMat_Count_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff);


% Build Sparse matrix (rows, cols, vals)
rows = zeros([1,nnz],'uint32');
cols = zeros([1,nnz],'uint32');
vals = zeros([1,nnz],'double');
vals = complex(vals,0);
[rows, cols, vals] = GeneralSpinHalf_SparseMat_Build_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff, rows, cols, vals);


% (rows, cols, vals) to sparse matrix
H = sparse(rows+1,cols+1,vals,Dim,Dim,nnz);
%keyboard;
%save('S_Ham.mat', 'H')
H = full(H);

% =========================================================================
clear aux
if norm(Para.Field.h) ~= 0
    h = Para.Field.h + 1e-16;
    h = h/norm(h);
    Change_Matrix = [1/2, -1i/2, 0; 1/2, 1i/2, 0; 0, 0, 1];
    if norm(Para.Field.h) ~= 0
        OnSite_info = 1:L;
        for i = 1:1:L
            Mx = Change_Matrix * transpose(h);
            OnSite_S_info(i,:) = [Mx(3), Mx(1), Mx(2)];
        end
    else
        OnSite_info = [];
        OnSite_S_info = [];
    end
    aux.OnSite_info = OnSite_info;
    aux.OnSite_S_info = OnSite_S_info;
    aux.Bond_info = [];
    aux.Intr_info = [];
    % keyboard;
    Dim=power(2,L);
    
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
    
    % make sure input data for matlab mex c++ function has correct forms:
    % convert possible "double" to "complex"
    if isreal(twosite_coeff)
        twosite_coeff = complex(twosite_coeff,0);
    end
    if isreal(onesite_coeff)
        onesite_coeff = complex(onesite_coeff,0);
    end
    

    % Count No. of nonzero elements
    nnz = GeneralSpinHalf_SparseMat_Count_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff);
   
    
    % Build Sparse matrix (rows, cols, vals)
    rows = zeros([1,nnz],'uint32');
    cols = zeros([1,nnz],'uint32');
    vals = zeros([1,nnz],'double');
    vals = complex(vals,0);
    [rows, cols, vals] = GeneralSpinHalf_SparseMat_Build_Complex(L, nt2, nt1,twosite_index,twosite_coeff,onesite_index,onesite_coeff, rows, cols, vals);

    
    % (rows, cols, vals) to sparse matrix
    M = sparse(rows+1,cols+1,vals,Dim,Dim,nnz);
    
    M = full(M);
else
    M = 0;
end
end

