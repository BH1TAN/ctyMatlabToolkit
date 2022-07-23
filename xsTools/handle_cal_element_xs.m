%% 计算元素的截面曲线
clear;close all;
% xs_cd复制自origin book: Cd，各列分别为能量(eV)，某同位素n,tot截面(b)
% xs_gd复制自origin book: Gd
% abu_cd复制自origin book: Cdabundance：第一列为原子量，第二列为丰度
% abu_gd复制自origin book: Gdabundance
load('cdgd.mat');
tmp = xs_cd(:,1:2:end);tmp=tmp(:);
xs_cd2 = sortrows(unique(tmp(:)));% 储存统一横轴后的截面
xs_cd2(1,:)=[]; % 删除能量为0的行
tmp = xs_gd(:,1:2:end);tmp=tmp(:);
xs_gd2 = sortrows(unique(tmp(:)));
xs_gd2(1,:)=[]; % 删除能量为0的行

xs_cd2 = xsmat_interp(xs_cd,xs_cd2);
xs_gd2 = xsmat_interp(xs_gd,xs_gd2);

xs_cd_ele = xsele(xs_cd2,abu_cd);
xs_gd_ele = xsele(xs_gd2,abu_gd);
