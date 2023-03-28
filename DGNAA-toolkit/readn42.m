function s = readn42(fileName)
% s.spec 能谱原始数据，无刻度单列能谱，纵坐标计数count/ch
% s.specStartRow: 能谱起始行，$DATA:$行号，import要+1
% s.startTime: 测量起始时刻(matlab datevec格式)
% s.realtime: 测量时长(实时间，s)
% s.livetime：测量活时间(s)

str_specStart = '<ChannelData>';
str_specEnd = '</ChannelData>';
str_walltime = '<StartDateTime>'; % 采集起始时刻
str_walltime2 = '<StartTime>'; % 采集起始时刻
str_realtime = '<RealTimeDuration>'; % 实时间
str_realtime2 = '<RealTime>';
str_livetime = '<LiveTimeDuration>'; % 活时间
str_livetime2 = '<LiveTime>'; 
infoFlag = 4; % 读取信息指示器，每读到一个减1，=0则退出
s.startTime = [];
s.livetime = [];
s.realtime = [];
s.spec = [];

suffixs = {'.n42','.N42'};
if contains(fileName,suffixs)
    fid = fopen(fileName,'r');
else
    fid = fopen([fileName,'.n42'],'r');
end

while 1 && infoFlag
    dataRow = fgetl(fid);
    if contains(dataRow,str_walltime) || contains(dataRow,str_walltime2)
        % 采集起始时刻
        infoFlag = infoFlag - 1;
        win1 = find(dataRow=='>');win1 = win1(1);
        win2 = find(dataRow=='<');win2 = win2(2);
        str = dataRow(win1+1:win2-1);
        s.startTime = datevec(str(1:19),'yyyy-mm-ddTHH:MM:SS');
    elseif contains(dataRow,str_realtime) || contains(dataRow,str_realtime2)
        % 实时间
        infoFlag = infoFlag - 1;
        win1 = find(dataRow=='>');win1 = win1(1);
        win2 = find(dataRow=='<');win2 = win2(2);
        str = dataRow(win1+1:win2-1);
        s.realtime = str2num(str(3:end-1));
    elseif contains(dataRow,str_livetime) || contains(dataRow,str_livetime2)
        % 活时间
        infoFlag = infoFlag - 1;
        win1 = find(dataRow=='>');win1 = win1(1);
        win2 = find(dataRow=='<');win2 = win2(2);
        str = dataRow(win1+1:win2-1);
        s.livetime = str2num(str(3:end-1));
    elseif contains(dataRow,str_specStart)
        % 各道数据
        infoFlag = infoFlag - 1;
        win1 = find(dataRow=='>');
        win2 = find(dataRow=='<');
        if length(win1)==2
            % 所有道的数据在一行
            win1 = win1(1);win2 = win2(2);
            str = dataRow(win1+1:win2-1);
            s.spec = str2num(str)';
        else
            % 所有道的数据分多行
            str = fgetl(fid);
            while ~contains(str,str_specEnd)
                str = [str,' ',fgetl(fid)];
            end
            s.spec = str2num(str(1:find(str=='<')-1))';
        end
    end
    if ~infoFlag
        % 读完数据，退出循环
        break;
    end
end
fclose(fid);

end % of the function