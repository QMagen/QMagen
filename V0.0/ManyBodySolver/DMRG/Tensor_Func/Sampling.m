function [ str ] = Sampling( MPS , dir )

str = zeros(1,length(MPS));
str = string(str);
p = 1;
% '1'   spin up
% '-1'  spin down
% EnV = Init_Sampling_EnV(MPS);

EnV = 0;

for pos = 1:1:length(MPS)
    rho = getLocRho(EnV, MPS, pos, p);
    switch dir
        case 'x'
            rho = RepC(rho);
    end
    ran = rand();
    p1 = rho(1,1);
    p2 = rho(2,2);
%     check1 = p1+p2;
%     check2 = abs(p1-p2);
%     fprintf('c1:%f, c2:%f \n', check1, check2);
    if ran < real(p1)
        str(pos) = string(1);
        p = p * p1;
    else
        str(pos) = string(-1);
        p = p * p2;
    end
    
    if pos ~= length(MPS)
        EnV = Update_EnV(EnV, MPS, str, pos, dir);
    end
end


end

% ||======================================||
% ||=============subfunction==============||
% ||======================================||

function [ rho ] = getLocRho(EnV, MPS, pos, p)

len = length(MPS);

switch pos
    case 1
        rho = contract(MPS{1}, 1, conj(MPS{1}), 1);
        rho = rho/p;
    case len
        rho = contract(EnV, 1, MPS{end}, 1);
        rho = contract(rho, 1, conj(MPS{end}), 1);
        rho = rho/p;
    otherwise
        rho = contract(EnV, 1, MPS{pos}, 1);
        rho = contract(rho, [1,2], conj(MPS{pos}), [1,2]);
        rho = rho/p;
end
end

function [ EnV ] = Update_EnV(EnV, MPS, str, pos, dir)
rho = LocalSpin(str(pos), dir);
switch pos
    case 1
        EnV = MPS{1};
        EnV = contract(EnV, 2, rho, 1);
        EnV = contract(EnV, 2, conj(MPS{1}), 2);
    otherwise
        EnV = contract(EnV, 1, MPS{pos}, 1);
        EnV = contract(EnV, 3, rho, 1);
        EnV = contract(EnV, [1,3], conj(MPS{pos}), [1,3]);
end
end

function [ Id ] = LocalSpin(str, dir)
switch dir
    case 'z'
        switch str
            case '1'
                Id = [1,0;0,0];
            case '-1'
                Id = [0,0;0,1];
        end
    case 'x'
        switch str
            case '1'
                Id = 1/2 * [1,1;1,1];
            case '-1'
                Id = 1/2 * [1,-1;-1,1];
        end
end
end

function rho = RepC(rho)
T = 1/sqrt(2) * [1,1;1,-1];
rho = T * rho * T;
end