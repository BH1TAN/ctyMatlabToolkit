function [pks,area] = myfindpeak(yin,varargin)
% 3�ζ���ʽ5��⻬һ����ֵ΢���ҷ�

area = 0;

plotOrNot = sum(strcmp(varargin,'plot'));
% matlab ����Ѱ�庯�������Ⱥܸ��Ҳ��ɵ�
[~,pks] = findpeaks(yin);

% ���׵��������ع��㷨
yin_gra3 = gradient(gradient(gradient(yin)));
figure;
plot(yin_gra3);


if plotOrNot 
    figure
    semilogy(yin);
    hold on;
    semilogy(pks,spline((1:size(yin,1))',yin,pks),'v');
end
end
