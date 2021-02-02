function [positions,distance,countresult]=Get_e_Positions(ptrac,remmiter,r0,rinsulator,rcollector)
% ���ٵõ�����λ��
% ע�⣺��Ҫ�ֹ�ȥ��ptrac���ļ�ͷ�����ļ���ptrac����MATLAB�������ſ�ʹ�ñ�����
% 
% ptrac���ļ�����    remmiter:������뾶��cm��
% r0:�ռ�糡�ٽ�뾶��cm����ֵΪ0ʱ�����ݾ��ȿռ��ɵ糡�����ٽ�뾶
% rinsulator:��Ե����뾶��cm��   rcollector:�ռ�����뾶��cm��
% 
% �ο���ƣ�remmiter=0.05 r0=0.068 rinsulator=0.087 rcollector=0.1015
% �汾������20171206 20171228
if(r0==0)
    ratio = remmiter/rinsulator;
    r0 = rinsulator*sqrt((ratio^2-1)/(2*log(ratio)));
end
lines = size(ptrac,1);
j=1;
positions = zeros(lines,4);
for i = 1:lines
    if isnan(ptrac(i,4))
        if ~isnan(ptrac(i,3))
            positions(j,1:3)=ptrac(i,1:3);
            disp(j);
            j = j+1;
        end
    end
end
positions(j:end,:)=[];
positions(:,4) = (positions(:,1).^2+positions(:,2).^2).^(1/2);
distance=positions(:,4);
countresult = zeros(1,5);
countresult(1,1) = sum(distance<remmiter);
countresult(1,2) = sum(distance<r0)-sum(distance<remmiter);
countresult(1,3) = sum(distance<rinsulator)-sum(distance<r0);
countresult(1,4) = sum(distance<rcollector)-sum(distance<rinsulator);
countresult(1,5) = sum(distance>=rcollector);
disp(num2str(countresult));
disp(['����������:',num2str(j-1)]);
disp(['��һ�е�����Ӧ�������¼���:',num2str(sum(countresult))]);
end
