function nd = findcurrie_n(nb,FPR,FNR)
% ���׼���nb��ʵ������FPR��©����FNR�������С��Ʒ������nd
% �������·������nd
%     Lc = a1*sqrt(2*nb)       % a1��Ӧ����Ҫ����ֵ�ﵽLc
%     nd=Lc+a2*sigma(nd)       % a2 ��Ӧ©����Ҫ��nd��Lc�߶���
%     sigma(nd)=sqrt(nd+2*nb)  % nd�����
% 
% Reference:
%    Knoll.P97-98


% syms x b a1 a2
% eq = x == a2*sqrt(2*b)+a1*sqrt(x+2*b); % �����������ʽ�����ֱ���ù�ʽ
% s = solve(eq,x);

a1 = norminv(1-FNR,0,1);
a2 = norminv(1-FPR,0,1);
nd1 = a1^2/2 - (a1*(8*nb + a1^2 + 4*2^(1/2)*a2*nb^(1/2))^(1/2))/2 + 2^(1/2)*a2*nb^(1/2);
nd2 = a1^2/2 + (a1*(8*nb + a1^2 + 4*2^(1/2)*a2*nb^(1/2))^(1/2))/2 + 2^(1/2)*a2*nb^(1/2);
nd = nd2;

end

