function m = mldm(z,n)
% Liquid drop model 得出的原子质量，单位MeV
% 基于TALYS_v1.96 P120
a = z+n;
if mod(z,2)==0 && mod(n,2)==0
    delta = -11/sqrt(a);
elseif mod(z,2)==1 && mod(n,2)==1
    delta = 11/sqrt(a);
else
    delta = 0;
end
c4 = 1.21129; % MeV
c3 = 0.717; % MeV
k = 1.79;
a2 = 18.56; % MeV
a1 = 15.677; % MeV
c2 = a2*(1-k*((n-z)/a)^2);
c1 = a1*(1-k*((n-z)/a)^2);
Ecoul = c3*(z^2)/a^(1/3)-c4*z^2/a;
Esur = c2*a^(2/3);
Evol = -c1*a;
m = 8.07144*n + 7.28899*z + Evol + Esur + Ecoul + delta;

end

