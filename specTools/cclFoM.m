function [FOM,err,centers,dis,sigma_bkgd,sigma_sigl]=cclFoM(bkgd,sigl)
% �����������Ƹ��Եı�׼���FOM����
% bkgd��sigÿһ����һ�����λ������
% FOM (factor of measurement) = d/2.355*(sigma1+sigma2)
% central_bkgd = �޶�Ʒ���Ƶ�����
% central_sigl = �ж�Ʒ���Ƶ�����
% dis = ���ľ�
% sigma_bkgd = ���׵���������ͶӰ�󣬺����ĵľ����׼��
% sigma_sigl = ��Ʒ����������ͶӰ�󣬺����ĵľ����׼��
% bkgd = ���׵㼯��ÿ��Ϊһ���������(x,y)������Ӧ>1
% sigl = ��Ʒ�㼯��ÿ��Ϊһ���������(x,y)������Ӧ>1
% err = ����ʱ�Ĵ����ʣ���һ����ֱ�Ϊ�����Ե�x�������֣�����y�������֣���������
central_bkgd = mean(bkgd,1);
central_sigl = mean(sigl,1);
centers = [central_bkgd;central_sigl];
% �����׼��
[~,set1,~,sigma_bkgd,~]=pointShadow(bkgd,central_bkgd,central_sigl);
[~,~,set2,~,sigma_sigl]=pointShadow(sigl,central_bkgd,central_sigl);
dis = abs(p2pdistance(central_bkgd,central_sigl,central_sigl));
FOM = dis/(2.355*(sigma_bkgd+sigma_sigl));
if isnan(FOM)
    err = nan;
    return;
else 
    [~,err,~,~] = cclGaussErr(set1,set2+dis);
    % ȡ��С��0ֵ
    err = min(err(err>0));
    if isempty(err)
        err = nan;
    end
end
end
