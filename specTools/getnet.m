function netArea = getnet(s,ch,method)
% ��������s��pkָʾ�ķ�������
% INPUTS��
%    s�� ��������
%    pk�������ڵĵ�ַ
%
% OUTPUTS��
%    netArea:�徻����

switch method
    case 1
        LL = ch-10;
        HH = ch+10;
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL),s(HH)]);
    case 2
        % Ѱ�ҹȵ�
        LL = ch-3;
        HH = ch+3;
        for i = 0:10
            if s(ch-i-1)>=s(ch-i)
                LL = ch-i;
                break;
            end
        end
        for i = 0:10
            if s(ch+i+1)>=s(ch+i)
                HH = ch+i;
                break;
            end
        end
        netArea = sum(s(LL:HH,1))-(HH-LL+1)*mean([s(LL),s(HH)]);
    otherwise
        
        
end

