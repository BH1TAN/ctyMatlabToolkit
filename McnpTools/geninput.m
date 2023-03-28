function flag = geninput(templateFile,mcnpInputFile,variableList)
% 改动模板文件中的[var...]为variableList的内容，生成input文件
% Inputs:
%     templateFile: 模板文件名
%     mcnpInputFile ：输出文件名
%     variableList ：行向量，每列为var1,var2,...
%
% Outputs:
%     flag：1成功，其它失败

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