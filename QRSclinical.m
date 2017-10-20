%�ٴ�ʵ��QRS������ȡ
function QRSclinical(l2,R,f,f3)
%f1����ѹ����
%f2:R����λ������������

%��ȡ����
% [D]=textread(f1,'%f%*[^\n]');
% [R]=textread(f2,'%d%*[^\n]');
%��ʼ��
% f=125;                  %����Ƶ��
D=l2;
lr=length(R);           
T(lr,1)=double(0);      %T��λ��
S(lr,1)=double(0);      %S��λ��    
P(lr,1)=double(0);      %P��λ��
Q(lr,1)=double(0);      %Q��λ��
Pamp(lr,1)=double(0);   %P����ѹֵ
Ramp(lr,1)=double(0);   %R����ѹֵ
Tamp(lr,1)=double(0);   %T����ѹֵ
RR(lr,1)=double(0);     %RR����
RRt(lr,1)=double(0);    %��һ��RR����
type(lr,1)=char('N');
%��ȡ
for i=int32(1):lr
%type
type(i,1)=char('N');
%S point
min=1000;minindex=0;
for j=int32(R(i)):int32(0.06*f+R(i))
if j<length(D)
    if D(j)<min       
        min=D(j);
        minindex=int32(j);
    end
end
S(i,1)=minindex;
end

%T point
max=-10;maxindex=0;
for j=int32(S(i)):int32(0.35*f+R(i))
if j<length(D)
    if D(j)>max       
        max=D(j);
        maxindex=int32(j);
    end
end
T(i,1)=maxindex;
end

%Q point
min = 1000;
minindex=0;
for j=int32(R(i)):-1:int32(R(i)-0.06*f)
if j>=1
    if D(j)<min       
        min=D(j);
        minindex=int32(j);
    end
end
Q(i,1)=minindex;
end

%P point
max = -10;
maxindex=0;
for j=int32(Q(i)):-1:int32(R(i)-0.2*f)
if j>=1
    if D(j)>max      
        max=D(j);
        maxindex=uint32(j);
    end
end
P(i,1)=maxindex;
end

end
close all;
pause(0.01);
plot(l2,'b');
hold on
plot(R,l2(R),'*','color','R');     %�������ֵ��
plot(Q,l2(Q),'o','color','R');     %�������ֵ��
plot(S,l2(S),'s','color','R');     %�������ֵ��
plot(P,l2(P),'d','color','R');     %�������ֵ��
plot(T,l2(T),'v','color','R');     %�������ֵ��
pause
%������д���ı�
fid=fopen(f3,'w+');
fprintf(fid,'%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t\t%s\t%s\r\n','Pamp','Ramp','Tamp','PR','QRS','QT','ST','RRI','RRI(t-1)','type');
ST=double((T-S)/f*1000);
QT=double((T-Q)/f*1000);
PR=double((Q-P)/f*1000);
QRS=double((S-Q)/f*1000);

for i=int32(5):lr-1
    Pamp(i,1)=D(P(i));
    Ramp(i,1)=D(R(i));
    Tamp(i,1)=D(T(i));
    RR(i,1)=double((R(i)-R(i-1))/f*1000);
    RRt(i,1)=double((R(i-1)-R(i-2))/f*1000);
    fprintf(fid,'%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%.3f\t\t%s\r\n',Pamp(i),Ramp(i),Tamp(i),PR(i),QRS(i),QT(i),ST(i),RR(i),RRt(i),type(i));
end
end