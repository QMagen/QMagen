function [ T ] = TransM( T, Ta, La )

T = contract(T, 1, La, 1);
T = contract(T, 1, conj(La), 1);
T = contract(T, 1, Ta, 1);
T = contract(T, [1,3,4], conj(Ta), [1,3,4]);

end

