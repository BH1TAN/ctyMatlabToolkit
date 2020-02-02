function [FoM,stdFoM] = sbrs_netv2(spec,tpltSpec,roi)
% ����ʵ�� Heider �����SBRS���״�����
% ���ģ�Signature-based radiation scanning using radiation interrogation to detect explosives
% spec:N��ʵ�����ף���һ��Ϊair�ף�������Ϊ��Ʒ-air��
% tpltSpec��M��ģ���ף���һ��Ϊair�ף�Ҫ����specͳһ����
% roi�������׵���һ�µĵ�������
%
% FoM��M��N�����ƶ�ָ��,ÿ�д���ÿ���׺�1~M��ģ������ƶ�
% stdFoM:M��N�����ƶ�ָ��,ÿ�д���ÿ���׺�1~M��ģ������ƶȱ�׼��
% 
FoM = zeros(size(tpltSpec,2),size(spec,2));
stdFoM = zeros(size(tpltSpec,2),size(spec,2));
for n = 1:size(spec,2)
    for m = 1:size(tpltSpec,2)
        thisSpec = spec(:,n);
        thisTplt = tpltSpec(:,m);
        chFoM = (((thisSpec-spec(:,1)-thisTplt+tpltSpec(:,1)).^2)./ ...
            (thisSpec+spec(:,1)+thisTplt+tpltSpec(:,1))); % ÿһ����FoM
        chFoM(isnan(chFoM)) = 0; % ��ĸΪ0�ĵ���0
        FoM(m,n) = roi(:,1)'* chFoM;
        stdFoM(m,n) = 2*sqrt(roi(:,1)'* chFoM);
    end
end
end

