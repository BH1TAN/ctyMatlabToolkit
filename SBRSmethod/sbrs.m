function [FoM,stdFoM] = sbrs(spec,tpltSpec,roi)
% ����ʵ�� Heider �����SBRS���״�����
% ���ģ�Signature-based radiation scanning using radiation interrogation to detect explosives
% spec:N��ʵ������
% tpltSpec��M��ģ���ף�Ҫ����specͳһ����
% roi��K��3�У�K��������Ȩ�أ���ʼ�����ͽ�������
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
        specSgnl = zeros(size(roi,1),1);
        tpltSgnl = zeros(size(roi,1),1);
        for k = 1:size(roi,1)
            specSgnl(k,1) = sum(thisSpec(roi(k,2):roi(k,3),1));
            tpltSgnl(k,1) = sum(thisTplt(roi(k,2):roi(k,3),1));
        end
        FoM(m,n) = roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnl+tpltSgnl));
        stdFoM(m,n) = 2*sqrt(roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnl+tpltSgnl)));
    end
end
end

