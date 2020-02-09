function distance = p2pdistance(pos1,pos2,pos3)
% distanceΪpos1��pos2�ľ���
% ��pos1��pos2��pos3�࣬����Ϊ��+��������һ�����Ϊ��-��
distance = zeros(size(pos1,1),1);
for i = 1:size(pos1,1)
    distance(i,1) = sqrt((pos1(i,1)-pos2(1,1))^2+(pos1(i,2)-pos2(1,2))^2);
    if distance(i,1)==0
        continue;
    end
    vec2 = pos1(i,1:2)-pos2(1,1:2);k2=vec2(1,2)/vec2(1,1);
    vec3 = pos1(i,1:2)-pos3(1,1:2);k3=vec3(1,2)/vec3(1,1);
    if ~isequal(pos2,pos3) % pos2��pos3��һ��
        flag1 = vec2*vec3';flag2=vec2*vec2';flag3=vec3*vec3';
        if flag1>0 && flag2<flag3 %ͬ����pos1��pos3��pos2����
            distance(i,1) = -distance(i,1);
        end
        clear flag1 flag2 flag3;
    else % pos2��pos3һ��
        %vec2��(��2����3]����ʱdistance����Ϊ'-'
        if vec2(1,1)<0
            distance(i,1) = -distance(i,1);
        end
        if vec2(1,2)<0
            distance(i,1) = -distance(i,1);
        end
    end
end
end
