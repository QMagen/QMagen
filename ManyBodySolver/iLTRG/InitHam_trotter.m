function [ Hab, Hba ] = InitHam_trotter( t_ab, t_ba, Para )
% function [ Hab, Hba ] = InitHam_tortter( Para )

[Sx, Sy, Sz, Id] = SpinOp(Para.d);

Hab = 0;
Hba = 0;

for i = 1:1:length(t_ab(:,1))
    switch t_ab{i, 1}
        case 'Sx'
            Sl = Sx;
        case 'Sy'
            Sl = Sy;
        case 'Sz'
            Sl = Sz;
    end
    
    switch t_ab{i, 2}
        case 'Sx'
            Sr = Sx;
        case 'Sy'
            Sr = Sy;
        case 'Sz'
            Sr = Sz;
    end
    
    if norm(Sl-Sr) < 1e-10
        hab = t_ab{i,3} * real(kron(Sl, Sr));
    else
        hab = t_ab{i,3} * kron(Sl, Sr);
    end
    Hab = Hab + hab;
end

for i = 1:1:length(t_ba(:,1))
    switch t_ba{i, 1}
        case 'Sx'
            Sl = Sx;
        case 'Sy'
            Sl = Sy;
        case 'Sz'
            Sl = Sz;
    end
    
    switch t_ba{i, 2}
        case 'Sx'
            Sr = Sx;
        case 'Sy'
            Sr = Sy;
        case 'Sz'
            Sr = Sz;
    end
    
    if norm(Sl-Sr) < 1e-10
        hba = t_ab{i,3} * real(kron(Sl, Sr));
    else
        hba = t_ab{i,3} * kron(Sl, Sr);
    end
    Hba = Hba + hba;
end

Hxa = kron(Sx, Id);
Hxb = kron(Id, Sx);
Hya = kron(Sy, Id);
Hyb = kron(Id, Sy);
Hza = kron(Sz, Id);
Hzb = kron(Id, Sz);


Hf = - 1/2 * Para.Field.h(1) * (Hxa + Hxb) - 1/2 * Para.Field.h(2) * (Hya + Hyb) - 1/2 * Para.Field.h(3) * (Hza + Hzb);
Hab = Hab + Hf;
Hba = Hba + Hf;

end

