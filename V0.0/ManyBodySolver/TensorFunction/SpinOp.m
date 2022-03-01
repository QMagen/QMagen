function [Sx, Sy, Sz, Id] = SpinOp(d)
% //Init spin operators
% w.li@buaa.edu.cn, 2016/12/27.

% //spin operators
Sz = zeros(d,d);  Sup = zeros(d,d);  Sdn = zeros(d,d);    % spin operators             
Id = eye(d,d);                                            % identity matrix (d by d)
for n = 1:1:d
    mz = -(d-1)/2 + (n-1);                                % note mz should be determd by n
    for m=1:d
        if(m==n) 
            Sz(m,m) = mz;                                 % Sz operator
        end                               
        if(m==n+1) 
            Sup(m,n) = sqrt((d^2-1)/4.0-mz^2-mz);         % S+ operator
        end    
        if(m==n-1) 
            Sdn(m,n) = sqrt((d^2-1)/4.0-mz^2+mz);         % S- operator
        end     
    end
end
Sx = (Sup + Sdn)/2.0;  Sy = (Sup - Sdn)/(2.0i);           % Sx, Sy operator
  
end