function [dataout,HeadData]=readptrac( outputType,nps,maxEventsPerHistory,nHeadLine )
% Transform mcnp output file to matlab matrix (3D or 2D)
% 
% outputType:
%     1: cell, each page contains one history, each row contains all the
%        information of orginal 2 rows
%     2: 2D matrix, each row contains all the information of orginal 2 rows
% nps: Simulated particle number
% maxEventsPerHistory: use only for memory allocation
% nHeadLine: Count of lines before the particle data (like '1 3000' line).      

if(maxEventsPerHistory<=0)
    maxEventsPerHistory = 4000;
end
[filename,pathname]=uigetfile('*.*','Chose a ptrac');%ѡ��������Ҫ��ȡ���ļ�
if isequal(filename,0)
    disp('User Canceled');
    return;
else
    disp(['User selected--',fullfile(pathname,filename)]);
end
fp=fullfile(pathname,filename);
fidin=fopen(fp);
dataout = cell(nps,1);
HistoryBuffer = zeros(maxEventsPerHistory,10);
History = 1;
DataBufferLine = 1;
LastHistoryFlag = 0;
HeadData = zeros(9,[]);
strFlag = 0;
for i=1:nHeadLine %��ȡptrac�ļ�ͷ
    HeadLine = str2double(regexp(fgetl(fidin),'\s+','split'));
    HeadData(i,1:size(HeadLine,2)) = HeadLine;
end
while 1
    str = fgetl(fidin);
    if str~=-1
        DataRow = str2double(regexp(str,'\s+','split'));
    else
        strFlag = 1;
    end
    if((size(DataRow,2)==HeadData(7,2)+1)||strFlag==1) %NPS line���߶������� HeadData(7,2)ΪNPS line ���ݸ���
        if(LastHistoryFlag)%��Ҫ������һ��history������
            HistoryBuffer = HistoryBuffer(2:DataBufferLine-1,:);%ɾ��û�м�¼����
            % save('CrackedPtrac','-v7.3'); %�洢����ǰĿ¼
            FriendlyDataBuffer = [HistoryBuffer(1:2:end,:),HistoryBuffer(2:2:end,:)]; %����ƴ��
            FriendlyDataBuffer(:,2)=[FirstEventType;FriendlyDataBuffer(1:size(FriendlyDataBuffer,1)-1,2)];%�¼��������
            dataout(History,1) = {FriendlyDataBuffer};
            History = History + 1;
            
            HistoryBuffer = zeros(maxEventsPerHistory,10);
            DataBufferLine = 1;
            strFlag = 0;
            
        end
        if str == -1
            disp('Success! Finish reading!');
            break;
        end
        CurrentNPS = DataRow(1,2);
        if mod(CurrentNPS,100)==0
            disp(['TransFormat process: ',num2str(CurrentNPS/nps)]);
        end
        FirstEventType = DataRow(1,3);
    else %Event1/Event2 line
        LastHistoryFlag = 1;
        HistoryBuffer(DataBufferLine,1:size(DataRow,2)) = DataRow;
    end
    DataBufferLine = DataBufferLine + 1;
end
fclose(fidin);
if(History-nps==1)
    disp('Comment:�����nps��ptracǡ���Ǻ�');
elseif(History-nps<1)
    disp('Warning:�����nps�ϴ������������������ڴ�');
    dataout(History:end) = [];
end
FriendlyData = dataout;
if(outputType==1)
    save('CrackedPtrac','-v7.3','FriendlyData','HeadData'); %�洢��ǰ���󵽵�ǰĿ¼
elseif(outputType==2)
    %��FriendlyData�����ݺϲ���һ��������
    save('CrackedPtrac','-v7.3','FriendlyData','HeadData'); %�洢��ǰ���󵽵�ǰĿ¼
    FriendlyData = zeros(nps*maxEventsPerHistory,10);
    pp = 1;
    disp('Transforming cell data to 2D matrix ...');
    for i=1:(History-1)
        height = size(dataout{i,1},1);
        width = size(dataout{i,1},2);
        FriendlyData(pp:(pp+height-1),1:width) = dataout{i,1};
        pp = pp+height;
    end
    FriendlyData(pp:end,:) = [];
    dataout = FriendlyData;
    save('CrackedPtrac','-v7.3','FriendlyData','HeadData'); %�洢��ǰ���󵽵�ǰĿ¼
end
end