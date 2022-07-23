function fE1 = PhotonStrengthFunction(Z,A,Sn,Mexp,L,En,Eg)
%% 计算Kopecky-Uhl模型给出的Photon strength function
% 注意Kopecky1990年论文中E1的式子(2.4)存在量纲错误，所以其它公式也需要小心
% 经与作者确认，KU的PSF模型括号内第二项分母实为5次方。
% Kopecky原文的公式和TALYS手册中给出的公式单位有区别，所以psf结果有量级区别
% 
hbar = 1.05457e-34/(1.6e-19)/1e6; % MeV.s
c = 3e8; % m/s

N=A-Z;
% L=1;
% L 相邻的电多级辐射概率之比为2.5e-3，
% 然而此处单纯将L=1改为L=2，fE1仅降低不到一半，
% 所以本函数中的fE1的公式可能仅对L=1成立
if mod(Z,2)==0 && mod(N,2)==0 % 对能
    delta = -11/sqrt(A);
elseif mod(Z,2)==1 && mod(N,2)==1
    delta = 11/sqrt(A);
else
    delta = 0;
end

alpha = 0.0722396; % FGM中的BFM effective 
beta  = 0.195267;  % FGM中的BFM effective
gamma1 = 0.410289; % FGM中的BFM effective

gamma = gamma1/A^(1/3);
U = Sn-delta;
at = alpha*A+beta*A^(2/3);
Mldm = mldm(Z,N);
aSn=at*(1+(Mexp-Mldm)*(1-exp(-gamma*U))/U);

T2 = (En+Sn-delta-Eg)/(aSn); % MeV^2

EE1 = 31.2*A^(-1/3)+20.6*A^(-1/6); % MeV
GE1 = 0.026*EE1^1.91; % MeV
GtE1 = GE1*(Eg.^2+4*pi^2*T2)/(EE1.^2); % MeV


KE1 = 1/((2*L+1)*pi^2*hbar^2*c^2);
sigmaE1 = 1.2*(120*N*Z)/(A*pi*GE1); % mb

fE1 = KE1*sigmaE1*GE1* ...
    ((Eg.*GtE1)./((Eg.^2+EE1^2).^2)+ ...
    (0.7.*GE1.*4.*pi^2.*T2)/EE1^5); % 单位为mb.m^-2.MeV^-3
fE1 = fE1/1e31; % 单位为MeV^-3

% figure;
% semilogx(En,fE1);
% xlabel('Neutron energy (MeV)');
% ylabel('f_E_1');
% title('Ag110的退激');
end