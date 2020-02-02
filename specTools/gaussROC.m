function ROC = gaussROC(index1,index2,nTh)
% index1��index2Ϊ����һά��˹�ֲ��ĳ��������������ƶ�����ֵ��Ӧ��ROC����
% ROC ����False positive rate��FPR�� ���� True positive rate��TPR��
% index1: ���и�˹�ֲ�1��������
% index2: ���и�˹�ֲ�2��������
% nTh: ROC���ߵ������
% ROC�� ��һ��FPR���ڶ���TPR

%% ���ݺ������ж�
u1 = mean(index1);sigma1 = std(index1,0);
u2 = mean(index2);sigma2 = std(index2,0);

if size(index1,1)<2||size(index2,1)<2
    disp('Error: Only one index');
    pause;
    return;
end
if u1>u2 %����ʹu2>u1
    disp('Warining: mean(index1)>mean(index2)');
    pause;
    u3=u1;u1=u2;u2=u3;
    sigma3=sigma1;sigma1=sigma2;sigma2=sigma3;
end

%% ����ֵ������
thDOWN = min([norminv(0.001,u1,sigma1);norminv(0.001,u2,sigma2)]);
thUP   = max([norminv(1-0.001,u1,sigma1);norminv(1-0.001,u2,sigma2)]);

%% ��ROC����
th = (thDOWN:(thUP-thDOWN)/(nTh+1):thUP)';
ROC = zeros(size(th,1),2);
for i=1:size(th,1)
    ROC(i,1) = normcdf(th(i),u1,sigma1);
    ROC(i,2) = normcdf(th(i),u2,sigma2);
end

%%

end