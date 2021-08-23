function [ H ] = AutomataInit( Para )
% function [ IntrMap ] = AutoMataInit( Para )
% Initialize the Hamiltonian by Automata picture.
% Yuan Gao@buaa 2021.04.06
% mail: 17231064@buaa.edu.cn
IntrMap = eval([Para.IntrcMap_Name, '(Para)']);
% IntrMap = SortIntrMap( IntrMap );
L = Para.L;
d = Para.d;
BondInfo = cell(L, 1);
Op = GetLocalSpace(d);
for i = 1:1:L
    if i == 1
        BondInfo{i} = [1,2];
    elseif i == L
        BondInfo{i} = [2,1];
    else
        BondInfo{i} = [2,2];
    end
end

% =========== Get Bond Dim Info ===========
for i = 1:1:length(IntrMap)
    if IntrMap(i).JmpOut>0
        BondInfo{IntrMap(i).JmpOut}(2) = BondInfo{IntrMap(i).JmpOut}(2) + 1;
        BondInfo{IntrMap(i).JmpIn}(1) = BondInfo{IntrMap(i).JmpIn}(1) + 1;
        if IntrMap(i).JmpIn > IntrMap(i).JmpOut+1
            for j = (IntrMap(i).JmpOut+1):1:(IntrMap(i).JmpIn-1)
                BondInfo{j} = BondInfo{j} + [1,1];
            end
        end
    end 
end

% =========== Get MPO  ===========
H.A = cell(L,1);
for i = 1:1:length(BondInfo)
    H.A{i} = zeros([BondInfo{i},d,d]);
    PseudoMPO(i).A = cell(BondInfo{i});
    if i ~= L
        H.A{i}(1,1,:,:) = reshape(Op.Id, [1,1,d,d]);
        PseudoMPO(i).A{1,1} = 'Id';
    end
    if i ~= 1
        H.A{i}(BondInfo{i}(1),BondInfo{i}(2),:,:) = reshape(Op.Id, [1,1,d,d]);
        PseudoMPO(i).A{BondInfo{i}(1),BondInfo{i}(2)} = 'Id';
    end
end
pos_list = zeros(L, 1);
pos_list(:) = 2;
for i = 1:1:length(IntrMap)
    JmpOut = IntrMap(i).JmpOut;
    JmpIn = IntrMap(i).JmpIn;
    JmpOut_type = IntrMap(i).JmpOut_type;
    JmpIn_type = IntrMap(i).JmpIn_type;
    CS = IntrMap(i).CS;
    if JmpOut == 0
    % on site ---------------------
        switch JmpIn_type
            case 'Sx'
                Si = Op.Sx;
            case 'Sy'
                Si = Op.Sy;
            case 'Sz'
                Si = Op.Sz;
        end
        H.A{JmpIn}(1,end,:,:) = CS * reshape(Si, [1,1,d,d]) + H.A{JmpIn}(1,end,:,:); 
        PseudoMPO(JmpIn).A{1,end} = JmpIn_type;
    else
    % two site --------------------
        switch JmpOut_type
            case 'Sx'
                So = Op.Sx;
            case 'Sy'
                So = Op.Sy;
            case 'Sz'
                So = Op.Sz;
        end
        
        switch JmpIn_type
            case 'Sx'
                Si = Op.Sx;
            case 'Sy'
                Si = Op.Sy;
            case 'Sz'
                Si = Op.Sz;
        end
        pos = pos_list(JmpOut);
        H.A{JmpOut}(1,pos,:,:) = reshape(So, [1,1,d,d]);
        PseudoMPO(JmpOut).A{1,pos} = JmpOut_type;
        pos_list(JmpOut) = pos_list(JmpOut) + 1;
        
        if JmpIn > JmpOut + 1
            for j = (JmpOut+1):1:(JmpIn-1)
                H.A{j}(pos, pos_list(j),:,:) = reshape(Op.Id, [1,1,d,d]);
                PseudoMPO(j).A{pos,pos_list(j)} = 'Id';
                pos = pos_list(j);
                pos_list(j) = pos_list(j) + 1;
            end
        end
        H.A{JmpIn}(pos,end,:,:) = CS * reshape(Si, [1,1,d,d]);
        PseudoMPO(JmpIn).A{pos,end} = JmpIn_type;
    end
end
H.A{1} = permute(H.A{1}, [2,3,4,1]);
H.A{end} = permute(H.A{end}, [1,3,4,2]);
H.lgnorm = 0;
end

