function  [R_1,count,count2,count3]= find_zeros (m_w_1,m_w_3,position,points,sample_rate) 
%��������ֵ�Թ��㣬��R����ֵ��������QRS����㼰�յ�************%
 % ����û����
Rnum =0;  % ����û����
count = zeros(1,points);
count2 = zeros(1,points);
count3 = zeros(1,points);
R0 = zeros(1,points);
%  step=floor(sample_rate/9);  %9.28��Ϊ����7
% step=60;
if sample_rate==100
    step=11;
elseif sample_rate==360
    step=25;
else
    step=floor(sample_rate/9);
end
%position=position_3;
% stamp_1 = 0;
% stamp_2 = 0;
%  stamp_3 = 0;
   i=1;
   j=1;
while i< points
    if position(i) == -1
     stamp_1 = i;   %�ҵ�ǰһ�������
     i=i+1;         %��һ������
      while(i<points & position(i)==0)   %һֱ��������һ�������
          i=i+1;  
       end
    stamp_2 = i;     %%�ҵ���һ�������
 %�󼫴�ֵ�ԵĹ����      
    stamp_3= round((abs(m_w_3(stamp_2))*stamp_1 + stamp_2*abs(m_w_3(stamp_1)))/(abs(m_w_3(stamp_2))+abs(m_w_3(stamp_1))));
%R������ֵ��
    R0(j)=stamp_3 - 10;   %����ƫ���������� 
    count(stamp_3-10)=1;  
%���QRS�����
 kqs=stamp_3-10;      
 markq=0; 
     while (kqs>1)&&( markq< 3) %  kqs>1   markq<3 �Ǹ���ʲô��ȷ�����أ� 
         if  m_w_1(kqs) ~= 0     %��һ��ļ�ֵ��,�ǣ�������δ����ֵ����ļ�ֵ��    
            markq=markq+1;  % ��������ʱ�ͼ�һ��������ʱ�Ͳ��ӣ�
         end
         kqs= kqs -1; %��ǰ���������û��Q����ô��????????????
     end
  count2(kqs)=-1;
%���QRS���յ�  
  kqs=stamp_3-10;
  marks=0;
  while (kqs<points)&&( marks<4)   %% kqs<points ע��һ��
      if m_w_1(kqs)~= 0
         marks=marks+1;
      end
      kqs= kqs+1;
  end
      count3(kqs)=-1;
  
  i=i+step;      %���һ�¾ͼ���60, Ӧ�������������˲�Ӧ�ڰ�    %ԭ����60��2016.11.12�޸�Ϊ25
  j=j+1;
  Rnum=Rnum+1;
    end     % if position(i) == -1 �Ľ�ֹλ��
i=i+1;   % ���interva2(i)��Ϊ-1ʱ��ֱ��������һ����
end   % while�Ľ�ֹλ��

R_1 = zeros(1,j-1);
for i=1:j-1
 R_1(i) = R0(i);
end


