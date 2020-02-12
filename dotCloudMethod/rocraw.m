function rocCurve = rocraw(index1,index2,nSeg)
% ��������index1��index2��ROC����
% index1��index2��Ϊ������
% nSeg Ϊ��index��С�����ֵ���Ϊ�������
%
% rocCurve ��ÿһ�зֱ�����
% TPR: ture positive rate
% FPR: false positive rate
% TNR: ture negative rate
% FNR: false negative rate

if length(index1)<2||length(index2)<2
    error('Error: Only one index');
end
range = [min([index1,index2]),max([index1,index2])];
if mean(index1)>mean(index2) % ȷ��index1����index2���
    index0=index1;
    index1=index2;
    index2=index0;
end
rocCurve=zeros(nSeg,4);
for i = 1:nSeg
    thresh = range(1)+i*(range(2)-range(1))/nSeg;
    rocCurve(i,1) = sum(index2>thresh)/length(index2);
    rocCurve(i,2) = sum(index1>thresh)/length(index1);
    rocCurve(i,3) = sum(index1<=thresh)/length(index1);
    rocCurve(i,4) = sum(index2<=thresh)/length(index2);

end
rocCurve = [1,1,0,0;rocCurve];
