function flag = geninput(templateFile,mcnpInputFile,variableList)
% �Ķ�ģ���ļ��е�[var...]ΪvariableList�����ݣ�����input�ļ�
% Inputs:
%     templateFile: ģ���ļ���
%     mcnpInputFile ������ļ���
%     variableList ����������ÿ��Ϊvar1,var2,...
%
% Outputs:
%     flag��1�ɹ�������ʧ��

flag = 1;
fid0 = fopen(templateFile,'r');
if ~fid0
    disp('Error: Cannot read template file');
    flag = 0;
    return;
end
varCount = size(variableList,2);
fid = fopen(mcnpInputFile,'w+');
while ~feof(fid0)
    lineData = fgets(fid0);
    %
    for varNo = 1:varCount
        lineData = strrep(lineData,['[var',num2str(varNo),']'],num2str(variableList(1,varNo)));
    end
    if(length(lineData)>80)
        flag = 101;
        lineData = strcat('ERROR:',lineData);
    end
    fprintf(fid,lineData);
end
fclose(fid);
fclose(fid0);
if flag==1
    % disp(['Success: Generated ',mcnpInputFile,' from: ',templateFile]);
elseif flag==101
    disp('Error: Some row exceeded 80 chars');
else
    disp('Error: If you see this, try again again again...');
end

end