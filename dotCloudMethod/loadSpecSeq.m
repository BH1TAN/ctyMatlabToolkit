function [bkgd,smpl] = loadSpecSeq(bkgdFileName,smplFileName)
% ���뱾�׻���Ʒnml�ļ������ļ�����������bkgd,smpl����ÿһ��Ϊһ��׼������
% 

load([bkgdFileName,'.mat']);
bkgd = sgnl;
load([smplFileName,'.mat']);
smpl = sgnl;
end
