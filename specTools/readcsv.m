function s = readcsv(filename,specStartRow)
% ��ȡAPG7400����ĵ���.csv�е�������Ϣ
% ��ʹ����specStartRow�������벻��֤���Ƿ�Ϊ�������
%
% INPUTS��
% filename:�ļ���
% specStartRow: ����ѡ��������ʼ�к�-1��һ����$DATA���кţ�
%
% OUTPUTS��
% s.spec ����ԭʼ���ݣ��޿̶ȵ������ף����������count/ch
% s.specStartRow: ������ʼ�У�[Data]�кţ�importҪ+1
% s.startTime: ������ʼʱ��(matlab datevec��ʽ)
% s.realtime: ����ʱ��(ʵʱ�䣬s)
% s.livetime��������ʱ��(s)
%
str_specStart = '[Data]';
str_walltime = 'Start Time'; % �ɼ���ʼʱ��
str_realtime = 'Real time'; % ����ʵʱ��
str_livetime = 'Live time'; % ���л�ʱ��
infoFlag = 4; % ��ȡ��Ϣָʾ����ÿ����һ����1��=0���˳�
s.startTime = [];
s.livetime = [];
s.realtime = [];
s.spec = [];
fid = fopen(filename,'r');
i = 0;

while 1 && infoFlag
    dataRow = fgetl(fid);i = i+1;
    if strncmp(dataRow,str_walltime,length(str_walltime))
        % �ɼ���ʼʱ��
        nownow = datevec(now);
        s.startTime = datevec(dataRow(length(str_walltime)+1:end));
        %s.startTime(1,1) = nownow(1); % ����λ����ݸ�Ϊ4λ��
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_realtime,length(str_realtime))
        % ��ʱ���ʵʱ��
        s.realtime = str2num(dataRow(length(str_realtime)+1:end));
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_livetime,length(str_livetime))
        s.livetime = str2num(dataRow(length(str_livetime)+1:end));
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_specStart,length(str_specStart))
        specStartRow = i;
        infoFlag = infoFlag - 1;
    end
    if (nargin == 2 && infoFlag ==1) || ~infoFlag
        % ��ָ��������ʼ�л�������ݣ��˳�ѭ��
        break;
    end
end
s.specStartRow = specStartRow; 
s.realtime = repmat(s.realtime,1,size(s.livetime,2));
fclose(fid);
fileData = importdata(filename,',',specStartRow+1); % ��������
s.spec = fileData.data(:,2:end);% �޿̶ȵ������ף����������count/ch����ȥ��һ�е�ַ
end

