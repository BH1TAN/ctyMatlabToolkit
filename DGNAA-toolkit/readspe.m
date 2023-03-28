function s = readspe(fileName,specStartRow)
% ��ȡ����.spe�е�������Ϣ,��ȡ���ļ�����handle_getspe
% ��ʹ����specStartRow�������벻��֤���Ƿ�Ϊ�������
% ��specStartRow=21����ʱ0.701617->0.671748s�������Ҳ����
%
% INPUTS��
% fileName:�ļ���
% specStartRow: ����ѡ��������ʼ�к�-1��һ����$DATA���кţ�
%
% OUTPUTS��
% s.spec ����ԭʼ���ݣ��޿̶ȵ������ף����������count/ch
% s.specStartRow: ������ʼ�У�$DATA:$�кţ�importҪ+1
% s.startTime: ������ʼʱ��(matlab datevec��ʽ)
% s.realtime: ����ʱ��(ʵʱ�䣬s)
% s.livetime��������ʱ��(s)
%
str_specStart = '$DATA:';
str_walltime = '$DATE_MEA:'; % �ɼ���ʼʱ��
str_measuretime = '$MEAS_TIM:'; % ��ʱ���ʵʱ��
infoFlag = 3; % ��ȡ��Ϣָʾ����ÿ����һ����1��=0���˳�
s.startTime = [];
s.livetime = [];
s.realtime = [];
s.spec = [];
suffixs = {'.spe','.Spe','.SPE'};
if contains(fileName,suffixs)
    fid = fopen(fileName,'r');
else
    fid = fopen([fileName,'.spe'],'r');
end

i = 0;
while 1 && infoFlag
    dataRow = fgetl(fid);i = i+1;
    if strncmp(dataRow,str_walltime,10)
        % �ɼ���ʼʱ��
        s.startTime = datevec(fgetl(fid));i=i+1;
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_measuretime,10)
        % ��ʱ���ʵʱ��
        tt = str2num(fgetl(fid));i=i+1;
        s.livetime = min(tt);
        s.realtime = max(tt);
        infoFlag = infoFlag - 1;
    elseif strncmp(dataRow,str_specStart,6)
        specStartRow = i;
        infoFlag = infoFlag - 1;
    end
    if (nargin == 2 && infoFlag ==1) || ~infoFlag
        % ��ָ��������ʼ�л�������ݣ��˳�ѭ��
        break; 
    end
end
s.specStartRow = specStartRow;
fclose(fid);
fileData = importdata(fileName,'',specStartRow+1); % ��������
s.spec = fileData.data;% �޿̶ȵ������ף����������count/ch
end

