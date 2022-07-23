%% 针对特定核素计算不同中子入射能量和伽马出射能量的PSF

clear;close all;
amu = 931.4941024; % MeV
isotope = 'Ag110';
if strcmp(isotope,'Ag110')
    A = 110; Z=49;
    Sn = 6.8092; % MeV
    Mexp = - 87.457306; % MeV 质量过剩，来自AME2020
    Mexp = (109.906111-110) * amu;% 来自n+Ag110的talys output 
elseif strcmp(isotope,'Y89')
    A = 89;Z = 39;
    Sn = 11.4835;
    Mexp = -87.711;
elseif strcmp(isotope,'Nb93')
    A=93;Z=41;
    Sn=8.8309;
    Mexp = -87.2128;
else
    error('Invalid parameter: isotope');
end
L = 1; % 修改PhotonStrengthFunction以加入L=2等的公式之前，不要改动L=1
En0 = -9:0.1:2;
En = 10.^En0; % MeV incident neutron energy
Eg = 0.001:0.001:15; % 勿调整，否则计算isomer会出错，MeV emission gamma energy

%% PSF
psf = zeros(length(En),length(Eg));
for i = 1:length(En)
    for j = 1:length(Eg)
        psf(i,j) = PhotonStrengthFunction(Z,A,Sn,Mexp,L,En(i),Eg(j));
    end
    disp([num2str(i),'/',num2str(length(En))]);
end
%psf = psf / 1e14;
[Enn,Egg]=meshgrid(En0,Eg);Enn = Enn'; Egg=Egg';
figure;
h = pcolor(Enn,Egg,psf); shading interp;hold on;axis equal;set(gca,'FontSize',15);
h.ZData = h.CData; % 强行赋值后可以使用cursor,但等高线不再显示
[C,h] = contour(Enn,Egg,psf, 0:1,'Color', 'k', 'LineWidth', 0.1);
clabel(C,h,'FontSize',12);
% caxis([5 10]);
xlabel('Neutron energy (10^x MeV)','FontSize',15);
ylabel('Photon energy (MeV)','FontSize',15);
cb = colorbar;
%cb.FontSize = 15;cb.Title.String = '10^{14}';
title('Photon Strength Function for E1');

figure;
semilogx(En,psf(:,[1,100,1000,5000,1e4],:),'-');
legend({'Gamma energy = 1 keV','100','1000','5000','10 MeV'},'Location','best');
xlabel('Neutron energy (MeV)');
ylabel('psf (*10^{14})');
xlim([1e-4,100]);

%% 计算IR
% 这里本应输入伽马能量在Eg变量中的编号，但Eg的编号恰好为keV为单位的能量
if strcmp(isotope,'Ag110')
    EMstate = [1659,910.9,893,854.4,789.7,759.6];
    EGstate = [1377,1013,953.2,905,881.5];
%     EMstate = 1659;
%     EGstate = 1377;
    EtoMstate = [round(Sn*1e3-EMstate)]; % keV, 释放哪些伽马会到isomer
    EtoGstate = [round(Sn*1e3-EGstate)];
elseif strcmp(isotope,'Y89')
    EtoMstate = [round(Sn*1e3-908.97)]; % keV, 释放哪些伽马会到isomer
    EtoGstate = [round(Sn*1e3)];
elseif strcmp(isotope,'Nb93')
    EtoMstate = [round(Sn*1e3-30.77)]; % keV, 释放哪些伽马会到isomer
    EtoGstate = [round(Sn*1e3)];
end

psf_sum_meta = sum(psf(:,EtoMstate),2);
psf_sum_ground = sum(psf(:,EtoGstate),2);
ir = psf_sum_meta./(psf_sum_meta+psf_sum_ground);
ir = psf_sum_meta./psf_sum_ground;
figure;
semilogx(En,ir,'k-');
%ylim([0,1]);
xlabel('Neutron energy (MeV)');
ylabel('Isomeric ratio');
