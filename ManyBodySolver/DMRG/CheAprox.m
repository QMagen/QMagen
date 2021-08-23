function [ y ] = CheAprox( x, mu, varargin )
N = length(mu);
n = (1:1:N)-1;
g = ((N-n+1) .* cos(pi * n/(N+1)) + sin(pi * n/(N+1)) .* cot(pi/(N+1)))/(N+1);
y = zeros(1, length(x));
y0 = ones(1, length(x));
y1 = x;
if isempty(varargin)
    for i = 3:1:N
        yp = 2 * x .* y1 - y0;
        y0 = y1;
        y1 = yp;
        y = y + 2 * g(i) * mu(i) * yp;
        
    end
    y = y + g(1) * mu(1);
    y = y + g(2) * 2 * mu(2) * x;
else
    y = zeros(length(mu), length(x));
    
    y(1,:) = g(1);
    
    y(2,:) = 2 * g(varargin{1}) * x;
    for i = 3:1:varargin{1}
        yp = 2 * x .* y1 - y0;
        y0 = y1;
        y1 = yp;
        y(i,:) = 2 * g(i) * mu(i) * yp;
        
    end

end
y = y ./(pi * sqrt(1-x.^2));
end

