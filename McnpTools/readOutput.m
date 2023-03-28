function [spec,summary] = readOutput(fileName)
% �ӵ�̽������Ӧ��MCNPģ�����õ���output�ļ��У���ȡ���ײ���

spec = [];
summary = [];
fidin = fopen(fileName);
if fidin == -1
    warning(['Error: Reading ',fileName]);
    return;
end
while 1 % Ѱ������ͷ
    dataRow = fgetl(fidin);
    if strncmp(dataRow,' cell ',6)
        dataRow = fgetl(fidin);
        if strncmp(dataRow,'      energy',12)
            break;
        end
    elseif dataRow == -1
        fclose(fidin);
        disp('ERROR: Did not see the sign of interested data');
        return;
    end
end
while 1 % ��ȡ��������
    dataRow = fgetl(fidin);
    % disp(dataRow);
    if strncmp(dataRow,'      total',11) % ����ܺ���
        summary = str2double(regexp(dataRow,'\s+','split'));
        summary = summary(1,3:end);
        break;
    end
    spec = [spec;str2double(regexp(dataRow,'\s+','split'))];
end

fclose(fidin);
spec(:,1)=[]; % ɾ������
end
