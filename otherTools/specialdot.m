function [intint,speWithXs] = specialdot(spe,xs,plotOrNot)
% ����ע����ֱ��ͼ��������ߵĳ˻�
% spe ��������,��һ���������ڶ���ͨ��
% xs  ���棬��һ�еĵ�λ���spe��һ��һ��
% �������ܵ����ܴ�ʹ��specialdot2���ܸ���

if max(spe(:,1))<min(xs(:,1)) ||min(spe(:,1))>max(xs(:,1))
    % ��������Χ��������ֱ�ӷ���0
    intint = 0;speWithXs=0;
    return
end
xs = [0,0;xs];[~,dd]=unique(xs(:,1));xs = xs(dd,:); % ɾ��xs�ظ���
spe(:,3) = interp1(xs(:,1),xs(:,2),spe(:,1)); % �����׵��ڲ��������
spe(:,4) = spe(:,2).*spe(:,3);
speWithXs = spe; 
intint = spe(:,2)'*spe(:,3);
if plotOrNot
    figure;
    yyaxis left
    semilogx(spe(:,1),spe(:,2),'b.-');hold on;
    xlabel('Energy');
    ylabel('Ray intensity');
    yyaxis right
    loglog(xs(:,1),xs(:,2),'r.-');
    ylabel('Cross section (b)');
    title(['Integration:',num2str(intint)]);
end
end
