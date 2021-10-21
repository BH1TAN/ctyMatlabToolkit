function nLine = howmanylines(fileName)
% return number of lines in a file
% 
% Inputs:
% fileName
%
% Outputs:
% nLines: number of lines
% 
% 
if ispc
    [~,cmdout] = system(['find /v /c "" ',fileName]);
    pos_digit = isstrprop(cmdout,'digit'); % ��������Щλ
    for i = length(pos_digit)-1:-1:1
        if pos_digit(i)==0 && pos_digit(i+1)==1
            pos_digit(1:i)=0; % �����ַ����ֵ�λ�����ȫ��������Ҫ������
            break;
        end
    end
else
    [~,cmdout] = system(['wc -l ',fileName]);
    pos_digit = isstrprop(cmdout,'digit');
    flag = 0;
    for i = 2:size(cmdout)
        if pos_digit(i-1)==1 && pos_digit(i)==0
            flag = 1;
        end
        if flag 
            pos_digit(i) = 0;
        end
    end
end
% ms = isstrprop(cmdout,'digit');
% ms = regexp(cmdout,'(?<=\w+)\d+','match');
nLine = str2num(cmdout(pos_digit));
end

