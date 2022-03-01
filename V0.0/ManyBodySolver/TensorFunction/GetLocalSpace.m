function [ Op ] = GetLocalSpace( d )
% function [ Op ] = GetLocalSpace( d )
% Get the local d-dimensinal spin operator
% Yuan Gao@buaa 2020.12.07
% mail: 17231064@buaa.edu.cn
[Op.Sx, Op.Sy, Op.Sz, Op.Id] = SpinOp(d);

Op.Sx4 = reshape(Op.Sx, [1,1,d,d]);
Op.Sy4 = reshape(Op.Sy, [1,1,d,d]);
Op.Sz4 = reshape(Op.Sz, [1,1,d,d]);
Op.Id4 = reshape(Op.Id, [1,1,d,d]);

Op.Sx3 = reshape(Op.Sx, [1,d,d]);
Op.Sy3 = reshape(Op.Sy, [1,d,d]);
Op.Sz3 = reshape(Op.Sz, [1,d,d]);
Op.Id3 = reshape(Op.Id, [1,d,d]);
end

