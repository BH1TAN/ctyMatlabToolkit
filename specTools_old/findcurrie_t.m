function t = findcurrie_t(nb,nd,FPR,FNR)
% ���׼�����nb,��Ʒ��������nd��ʵ������FPR��©����FNR�������С����ʱ��t
% �������·������t
%     Lc = a1*sqrt(2*nb*t)           % a1��Ӧ����Ҫ����ֵ�ﵽLc
%     nd*t=Lc+a2*sigma(nd*t)         % a2��Ӧ©����Ҫ��nd*t��Lc�߶���
%     sigma(nd*t)=sqrt(nd*t+2*nb*t)  % nd*t�����
% �����
%     nd*t = a2*sqrt(2*nb*t)+a1*sqrt(nd*t+2*nb*t)
% Reference:
%    Knoll.P97-98

if nb<0 || nd<0 || FPR<0 || FNR<0
    t = -1; % ��������
    return;
end

a1 = norminv(1-FNR,0,1);
a2 = norminv(1-FPR,0,1);
t = (a2*sqrt(2*nb)+a1*sqrt(nd+2*nb))^2/nd^2;

end

