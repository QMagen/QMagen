function [ H ] = AssignATensor( H, Op, IntrInfo, Para )
% function [ H ] = AssignATensor( H, Op, IntrInfo, Para)
% Assign A-tensors starting from all Identity MPO (input H)
% IntrInfo stores interaction-site info (IntrInfo.JmpOut, IntrInfo.JmpIn),
% interaction-type info (IntrInfo.JmpOut_type, IntrInfo.JmpIn_type) and
% coupling strength (IntrInfo.CS).
% Yuan Gao@buaa 2020.12.07
% mail: 17231064@buaa.edu.cn
L = Para.L;
H.lgnorm = 0;
I = IntrInfo.JmpOut;
J = IntrInfo.JmpIn;

if I >= J
    keyboard;
end

Id4 = Op.Id4; 
Id3 = Op.Id3;

if IntrInfo.JmpOut == 1
    switch IntrInfo.JmpOut_type
        case 'Sx'
            SL = Op.Sx3;
        case 'Sy'
            SL = Op.Sy3;
        case 'Sz'
            SL = Op.Sz3;
    end
else
    switch IntrInfo.JmpOut_type
        case 'Sx'
            SL = Op.Sx4;
        case 'Sy'
            SL = Op.Sy4;
        case 'Sz'
            SL = Op.Sz4;
    end
end

if IntrInfo.JmpIn == L || IntrInfo.JmpIn == 1
    switch IntrInfo.JmpIn_type
        case 'Sx'
            SR = Op.Sx3;
        case 'Sy'
            SR = Op.Sy3;
        case 'Sz'
            SR = Op.Sz3;
    end 
else
    switch IntrInfo.JmpIn_type
        case 'Sx'
            SR = Op.Sx4;
        case 'Sy'
            SR = Op.Sy4;
        case 'Sz'
            SR = Op.Sz4;
    end
end

if strcmp(IntrInfo.JmpOut_type, 'Sy') && strcmp(IntrInfo.JmpIn_type, 'Sy')
    SL = real(-1i * SL);
    SR = real(1i * SR);
end

for i = 1:1:L
    
    if i == IntrInfo.JmpOut
        H.A{i} = SL;
    elseif i == IntrInfo.JmpIn
        H.A{i} = IntrInfo.CS * SR;
    elseif i == 1
        H.A{i} = Id3;
    elseif  i == L
        H.A{i} = Id3;
    else
        H.A{i} = Id4;
    end   
    
end

end

