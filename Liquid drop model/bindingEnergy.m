function binding = bindingEnergy(z,a)
% Caluculate binding energy from liquid drop model

%% Model parameters
av = 15.5; % MeV
as = 16.8;
ac = 0.72;
asym = 23;
ap = 34;
%% Volume term 
ev = av*a;

%% surface term
es = -as*a^(2/3);

%% Coulomb term
ec = -ac*z*(z-1)*a^(-1/3);

%% Asymmetry term
esym = -asym*(a-2*z)^2/a;

%% Pairing term
ep = 0.5*((-1)^z+(-1)^(a-z))*ap/sqrt(a);

%% Binding energy
binding = ev+es+ec+esym+ep;

end

