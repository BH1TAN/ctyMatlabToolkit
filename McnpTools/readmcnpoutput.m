%% ��ȡFS��C��ɵ�output file�е�ע���ʷֲ�ͼ
close all;clear;
%% �ֶ��������
outputFileName = '9';
param.TIMEAXIS = [1]; % ��λ��s   total�����������ּ���
param.withTotalCol = 0; % ��û��total��
% param.HRZAXIS = 0:10:100;    
% param.VERAXIS = -130:10:100; 
param.HRZAXIS = 0:19;    
param.VERAXIS = 0:19;  

%% ���ɲ���
fileName = [outputFileName,'.o'];
param.TIMESLICE = size(param.TIMEAXIS,2);%ʱ������Ƭ��,����total��
param.COLCNT = size(param.HRZAXIS,2);
param.ROWCNT = size(param.VERAXIS,2);
if param.TIMESLICE>1
    nPart1ExtraLine = 6;
elseif param.TIMESLICE==1
    nPart1ExtraLine = 5;
end
nPart2ExtraLine = nPart1ExtraLine - 2;

%% ����.o�ļ�
fid = fopen(fileName,'r');
i = 0;
DATASTART = 0;
param.ENERGYCNT = 0; %�ܵ���
while ~feof(fid)
    i = i+1;
    dataRow = fgetl(fid);
    if strncmp(dataRow,' s axis',7) && DATASTART==0
        DATASTART = i;
    elseif strncmp(dataRow,'      total',11) && param.ENERGYCNT==0
        param.ENERGYCNT = i - DATASTART - nPart2ExtraLine;
        break;
    end
end
disp(['Notice: data start at line: ',num2str(DATASTART)]);
disp(['Notice: Energy point number: ',num2str(param.ENERGYCNT)]);
fclose(fid);

%% ���ʹ��importdata����������
orgnCell = cell(param.ROWCNT,param.COLCNT); % ���ԭʼ����
tofspecCell = cell(param.ROWCNT,param.COLCNT);
specCell = cell(param.ROWCNT,param.COLCNT);
nPartInFilm = ceil(param.TIMESLICE/5); % һ��film��������80�����Ʊ���Ϊ����part
nPart1Loop = param.ENERGYCNT + nPart1ExtraLine;
nPart2Loop = param.ENERGYCNT + nPart2ExtraLine;
nFilmLoop = nPart1Loop + (nPartInFilm-1)*nPart2Loop;

iFilm = 0;
for iCol = 1:param.COLCNT
    for iRow = 1:param.ROWCNT
        disp(['Row:',num2str(iRow),'/',num2str(param.ROWCNT),' Col:',num2str(iCol),'/',num2str(param.COLCNT),' ',datestr(now)]);
        filmStartLine = DATASTART + iFilm*nFilmLoop; % ��film��ʼ��
        iFilm = iFilm + 1;
        matPart = importdata(fileName,' ',filmStartLine+nPart1ExtraLine-3);
        matPart = matPart.data;
        for i = 1:nPartInFilm-1
            thisLine = filmStartLine+i*nPart2Loop+nPart2ExtraLine-1;
            matPart2 = importdata(fileName,' ',thisLine);
            matPart2 = matPart2.data;
            matPart = [matPart,matPart2(:,2:end)];
        end
        orgnCell{iRow,iCol} = matPart;
        if param.withTotalCol
            tofspecCell{iRow,iCol} = matPart(:,1:end-2);
            specCell{iRow,iCol} = matPart(:,[1,end-1,end]);
        else
            tofspecCell{iRow,iCol} = matPart;
            specCell{iRow,iCol} = matPart; % д����ô��total ???
        end
    end
end

save(['orgnCell-',outputFileName],'outputFileName','specCell','tofspecCell','param');
