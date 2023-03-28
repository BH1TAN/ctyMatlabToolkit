function [h,cfun,gof] = decaycurve(count,t)
% 计数的指数衰变拟合
% Inputs:
%    count:行向量，每个数为计数
%    t: 行向量，单位s，开始测量的时刻
% Outputs：
%    h：衰变图像的句柄
%    拟合结果，包括：
%        cfun.halflife = 半衰期，单位s
%        gof.rsquare = 拟合优度
%        cfun.a  = 无限长时间后的计数
%        cfun.b  = 指数项的系数

syms x;
f=fittype('a+b*0.5^(x/halflife)','independent','x','coefficients',{'a','b','halflife'});
options = fitoptions('Method','NonlinearLeastSquares');
options.StartPoint = [count(end),count(1), 0.5*(t(end)-t(1))];
options.Lower = [0,0,0];
[cfun,gof] = fit(t',count',f,options);

h = figure;
plot(t',count','bo');hold on;
plot(t',cfun(double(t)),'r-');
title({['T0.5=',num2str(cfun.halflife,'%.2f'),' s',' R^2= ',num2str(gof.rsquare,'%.2f')];
    ['a=',num2str(cfun.a,'%.2f'),' b=',num2str(cfun.b,'%.2f')]});
xlabel('Time(s)');ylabel('Count');

set(h,'visible','off');