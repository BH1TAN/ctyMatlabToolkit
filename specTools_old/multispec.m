function mat = multispec(oldmat,multi)
% ��ÿ��Ϊһ�����׵Ķ������ף�ÿmulti���Ӻ�
mat = [];
i = 1;
while 1
    mat = [mat,sum(oldmat(:,multi*i-multi+1:multi*i),2)];
    i = i + 1;
    if(multi*i>size(oldmat,2))
        break;
    end
end
end