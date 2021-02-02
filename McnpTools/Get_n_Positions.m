function [deadinV,targetEvents]=Get_n_Positions(ptrac,z,radius)
% �Ͽ��ٶȵõ�V�������Ӹ���
% ע�⣺��Ҫ�ֹ�ȥ��ptrac���ļ�ͷ������MATLAB�������ſ�ʹ�ñ�����
% deadinVΪλ��>z�����������<radius
lines = size(ptrac,1);
j=1;
new=zeros(lines,4);
for i = 1:lines 
    if ~isnan(ptrac(i,8))
        if ~isnan(ptrac(i,9))
            new(j,1:3)=ptrac(i,1:3);
            j = j+1;
        end
    end
end
new(j:end,:)=[];
new(:,4) = (new(:,1).^2+new(:,2).^2).^(1/2);
new2 = new(find(new(:,4)<=radius),:);
targetEvents = new2(find(new2(:,3)>=z),:);
deadinV = size(targetEvents,1);
end
