function [ t_ab, t_ba ] = Trotter_ToyAFHC( Para )

t_ab = cell(3,3);

t_ab{1,1} = 'Sx';
t_ab{1,2} = 'Sx';
t_ab{1,3} = Para.Model.J;

t_ab{2,1} = 'Sy';
t_ab{2,2} = 'Sy';
t_ab{2,3} = Para.Model.J;

t_ab{3,1} = 'Sz';
t_ab{3,2} = 'Sz';
t_ab{3,3} = Para.Model.Delta;

t_ba = t_ab;
end

