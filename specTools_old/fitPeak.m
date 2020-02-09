function [area,amp,sigma,a,slope,xpeak,cfun] = fitPeak(x,y,plotOrNot)
% x ���׺����꣬��ַ
% y ���������꣬ÿ������
% area �������0����δ�����
% ��Ϲ�ʽ
% y=a+slope*x+area*1/sqrt(2*pi)/sigma*exp(-(x-peak)^2/2/sigma^2);
syms t;
f=fittype('(amp/(sigma*sqrt(2*pi)))*exp(-(t-xpeak)^2/(2*sigma^2))+a+slope*t', ...
    'independent','t','coefficients',{'amp','sigma','xpeak','a','slope'});
options = fitoptions('Method','NonlinearLeastSquares');
originalPeak = x(find(y==max(y))); originalPeak = originalPeak(1,1);
options.Lower = [3,0,originalPeak-2,0,-Inf];
options.Upper = [Inf,2,originalPeak+2,Inf,0];
options.StartPoint = [10,0.5,originalPeak,0.1,(y(end)-y(1))/(x(end)-x(1))];
cfun = fit(x,y,f,options);
if plotOrNot
    figure;
    plot(x,y,'.');hold on;grid on;
    plot(min(x):0.0001:max(x),cfun(min(x):0.0001:max(x)),'-');
    xlabel('Energy(MeV)');ylabel('Count rate(cps/ch)');
end
amp = cfun.amp;
sigma = cfun.sigma;
xpeak = cfun.xpeak;
a = cfun.a;
slope = cfun.slope;
area = amp/(sqrt(2)*sigma);
end