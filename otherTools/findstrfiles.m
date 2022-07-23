function filenames = findstrfiles(foldername,str0)
% 在文件夹的所有文件中寻找存在特定字符串的文件
filenames = cell(0,1);
dir1 = dir(foldername);
for i = 3:length(dir1)
    disp([num2str(i),'/',num2str(length(dir1))]);
    fid = fopen(fullfile(dir1(i).folder,dir1(i).name));
    while ~feof(fid)
        str = fgetl(fid);
        if contains(str,str0)
            filenames = [filenames;dir1(i).name];
            break;
        end
    end
    fclose(fid);
end
end

