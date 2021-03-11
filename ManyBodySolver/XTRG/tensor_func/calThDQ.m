function [ ThDQ ] = calThDQ( Para, rho, Op, beta )
% function [ ThDQ ] = calThDQ( Para, rho, H )

if norm(Para.Field.h) ~= 0
    ThDQ.M = -real(InnerProd(rho, Op.Sm));
else
    ThDQ.M = 0;
end

ThDQ.En = real(InnerProd(rho, Op.H));
% ThDQ.Cm = real(beta^2 * (InnerProd(rho, Op.Hs) - InnerProd(rho, Op.H)^2));
ThDQ.Cm = 0;

end

