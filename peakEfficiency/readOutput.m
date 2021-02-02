function [spec,summary] = readOutput(fileName)
spec=[];
fidin = fopen(fileName);
while 1 % Ѱ������ͷ
    dataRow = fgetl(fidin);
    if strncmp(dataRow,' cell ',6)
        dataRow = fgetl(fidin);
        if strncmp(dataRow,'      energy',12)
            break;
        end
    end
end
while 1 % ��ȡ��������
    dataRow = fgetl(fidin);
    % disp(dataRow);
    if strncmp(dataRow,'      total',11)
        summary = str2double(regexp(dataRow,'\s+','split'));
        summary = summary(1,3:end);
        break;
    end
    spec = [spec;str2double(regexp(dataRow,'\s+','split'))];
end

fclose(fidin);
spec(:,1)=[];
end