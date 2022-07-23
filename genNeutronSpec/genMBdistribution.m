%% 产生maxwellian-Boltzman分布的中子能谱
clear;close all;

e_bin = 10.^(-4:0.1:7)'; % eV
t = 293.5;
flux_tot = 4.3e12; % nv

k = 1.38e-23/1.6e-19; % eV/K
nnn = 2*pi.*exp(-e_bin./(k*t)).*sqrt(e_bin)./(pi*k*t)^-1.5;
nnn = nnn*flux_tot/sum(nnn);
spec_neutron = [e_bin,nnn];

figure;
semilogx(e_bin,nnn,'.-');
xlabel('eV');
ylabel('Count');

