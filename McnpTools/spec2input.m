function spec2input(spec,nnn,mmm)
% ������ת��Ϊmcnp�����ļ��еķֲ�
% spec:����
% nnn: �����xÿ���ж��ٸ�ֵ
% mmm: �����yÿ���ж��ٸ�ֵ
% REF:
%    si������ L��ɢֵ�ֲ� A�������ܶ�

disp('c *-1----*----2----*----3----*----4----*----5----*----6----*----7----*----8----*');
a = spec(:,1)';
% H �����ھ��ȷֲ���L��ɢֵ�ֲ���A�������ܶȺ���
disp(['si1 L ',num2str(a(1:nnn),'%g ')]);
i = nnn;
while i+nnn < length(spec)
    disp(['      ',num2str(a(i+1:i+nnn),'%g ')]);
    i=i+nnn;
end
disp(['      ',num2str(a(i+1:end),'%g ')]);

a = spec(:,2)';
disp(['sp1 ',num2str(a(1:mmm),'%g ')]);
i = mmm;
while i+mmm < length(spec)
    disp(['      ',num2str(a(i+1:i+mmm),'%g ')]);
    i=i+mmm;
end
disp(['      ',num2str(a(i+1:end),'%g ')]);
disp('c *-1----*----2----*----3----*----4----*----5----*----6----*----7----*----8----*');
end
