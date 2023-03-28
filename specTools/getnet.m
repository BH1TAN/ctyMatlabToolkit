function netArea = getnet(s,pk,method)
% ��������s��pkָʾ�ķ�������
% INPUTS��
%    s�� ��������
%    pk�������ڵĵ�ַ
%
% OUTPUTS��
%    netArea:�徻����
switch method
    case 1 % ָ������λ��Ϊǰ��20��
        LL = pk-20;
        HH = pk+20;
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL-5:LL);s(HH:HH+5)]);
    case 2 % �ڷ�Χ��Ѱ����Сֵ��Ϊ����
        % Ѱ�ҹȵ�
        LL = pk-3;
        HH = pk+3;
        for i = 0:10
            if s(pk-i-1)>=s(pk-i)
                LL = pk-i;
                break;
            end
        end
        for i = 0:10
            if s(pk+i+1)>=s(pk+i)
                HH = pk+i;
                break;
            end
        end
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL),s(HH)]);
    case 3 % ָ��������˹���
        roi=[round(pk-0.01*pk):round(pk+0.01*pk)]; % 0.01�Ǹ�������������½�FWTM����
        [~,netArea,~,~,~,~] = fitPeak(roi,s(roi),0);
    otherwise
        
        
end

