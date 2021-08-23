function [ MPS ] = InitMPS( Para, varargin )
% Initialize the MPS
%   |     |     |     |
%   ^     ^     ^     ^
%   |     |     |     |
%   o--<--o--<--o--<--o

if ~isempty(varargin)
    str = varargin{1};
    dir = varargin{2};
else
    str = zeros(1, Para.L);
    for i = 1:1:Para.L
        if rand() > 0.5
            str(i) = 1;
        else
            str(i) = -1;
        end
        %str(i) = -1;
    end
    str = string(str);
    dir = 'i';
end

MPS.A = cell(Para.L, 1);
MPS.lgnorm = 0;
for i = 1:1:Para.L
    switch i
        case {1, Para.L}
            MPS.A{i} = LocS(str(i), dir);
            MPS.A{i} = reshape(MPS.A{i}, [1,2]);
        otherwise
            MPS.A{i} = LocS(str(i), dir);
            MPS.A{i} = reshape(MPS.A{i}, [1,1,2]);
    end
end

end

function vec = LocS(str, dir)
% switch str
%     case '1'
%         vec = [1;0];
%     case '-1'
%         vec = [0;1];
% end
a = rand();
vec = [a; sqrt(1-a^2)];
if strcmp(dir, 'x')
    vec = 1/sqrt(2) * [1,1;1, -1] * vec;
end
end