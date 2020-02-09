function [t,dis,errorcode] = FindT(sig,bkgd,err,tprecision)
% Ϊʹt*n1��t*n2�������ɷֲ��Ľ�����Ϊ�б�δ֪�������ĸ��ֲ�ʱ��
% ���ʺ�©���ʾ�С��err����Ҫ��ĵ���Сt��ʹ�ö��ַ�Ѱ�ң�
% Ҫ��n1>n2
% errorcode=0�������� errorcode=1�������� errorcode=2�޷��ں���ʱ�������� 
% �ο���err=0.05,tprecision=0.00001

errorcode = 0;
if sig==0 || bkgd==0 
    t=0;dis=0;
    disp('Error:Ѱ�ұ�����������0');
    errorcode = 1;
    return;
end
if sig<=bkgd
    t=0;dis=0;
    disp('Error:�ź�С�ڱ���');
    errorcode = 2;
    return;
end
t1 = 1e-10;t2 = 1e12;
[flagflag,~]=fun1(sig*t2,bkgd*t2,err);
if flagflag == 0 %�������ʱҲ�޷��ֿ�
    t=0;dis=0;
    disp('Warning�������ű����޷��ں���ʱ��������');
    errorcode = 3;
    return;
end
while 1
    t3=0.5*t1+0.5*t2;
    % disp(['try multi-times t=',num2str(t3)]);
    [flag,disc]=fun1(sig*t3,bkgd*t3,err);
    if flag
        %t3����
        t2=t3;
    else
        %t3С��
        t1=t3;
    end
    if abs(t1-t2)<tprecision
        t=0.5*t1+0.5*t2;
        dis=disc;
        disp('Success:�ѵõ���С���ֱ���');
        break;
    end
end
end


function [flag,dis] = fun1(n1,n2,err)
% �õ�n1>n2���������ͼ�񽻵�������Լ��Ƿ����������Ҫ��
%
dis1=n1;dis2=n2;
while 1 
    dis3 = 0.5*dis1+0.5*dis2;
    if poisspdf(dis3,n1)-poisspdf(dis3,n2)<0
        dis2=dis3;
    elseif poisspdf(dis3,n1)-poisspdf(dis3,n2)>0
        dis1=dis3;
    end
    if abs(dis1-dis2)<0.1 || poisspdf(dis3,n1)-poisspdf(dis3,n2)==0
        dis3=0.5*dis1+0.5*dis2;
        if poisscdf(dis3,n1)<=err && poisscdf(dis3,n2,'upper')<=err
            flag = 1;dis = dis3;
            break;
        else
            flag = 0;dis = 0;
            break;
        end
    end
end
end