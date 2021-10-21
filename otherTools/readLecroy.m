function [waves,tAxis]=readLecroy(maindir,nameForm,prefix,maxWavNo)
% ��ȡLecroyʾ��������Ķ��.trc�������ļ�����
% INPUT:
%     maindir: �ļ�������
%     nameForm: ��ȡ���ļ�������ʽ����"C2*.trc"
%     prefix: ��������
%     maxWavNo: ����ȡ���ٸ�����
% OUTPUT:
%     waves: ÿһ��Ϊһ�����Σ���λV
%     tAxis: ʱ����
    t1=cputime;
    path = pwd;
    addpath(pwd);
    cd (maindir);
    subdir = dir(nameForm);
    %dT=subdir(end).date-subdir(1).date;
    %samTime=dT(end)+dT(end-1)*10+dT(end-3)*60+dT(end-4)*600+dT(end-6)*3600+dT(end-7)*36000;
    wave = ReadLeCroyBinaryWaveform(subdir(1).name);
    tAxis = wave.x;
    waves=zeros(length(wave.y),min([length(subdir),maxWavNo]));
    for i=1:min([length(subdir),maxWavNo])
        disp([num2str(i),'/',num2str(maxWavNo),'/total:',num2str(length(subdir))])
        thisName=subdir(i).name;
        wave=ReadLeCroyBinaryWaveform(thisName);
        data=wave.y;
        %data=data-mean(data(1:50));
        waves(:,i)=data;
    end
    cd (path);
    fprintf('-------Saving data-------\n');
    save(['wave_',prefix,'_',maindir,'.mat'],'waves','tAxis','-v7.3');
    fprintf('**** finish all after %.3f s ****\n',cputime-t1);
end