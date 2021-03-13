function [ Hab, Hba ] = InitHam_trotter( Para )
% function [ Hab, Hba ] = InitHam_tortter( Para )

[Sx, Sy, Sz, Id] = SpinOp(Para.S);

Hxx = kron(Sx, Sx);
Hyy = real(kron(Sy, Sy));
Hzz = kron(Sz, Sz);

Hxa = kron(Sx, Id);
Hxb = kron(Id, Sx);
Hza = kron(Sz, Id);
Hzb = kron(Id, Sz);

Hnn = Hxx + Hyy + Para.Model.Delta * Hzz;
Hf = - 1/2 * Para.Field.h(1) * (Hxa + Hxb) - 1/2 * Para.Field.h(3) * (Hza + Hzb);
Hab = Hnn + Hf;
Hba = Para.Model.alpha * Hnn + Hf;

end

