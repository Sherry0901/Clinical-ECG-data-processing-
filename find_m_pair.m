function position_6 = find_m_pair (p_n_v,points,sample_rate) 

%�ҳ���ֵ�� 
%���ҳ�������λ�ã�Ȼ�����Щ���λ�þ�������ж�
%position  �Ĵ�С���ɷ���ֵ�ø��������� 
%p_n_v=p_n_v_3;
% gate=ceil(sample_rate/10);  %360hzԭ����50,100ԭ����11
if sample_rate==100
    gate=9;
elseif sample_rate==360
    gate=80;
else
    gate=ceil(sample_rate/10);
end
j_a=1;
position_1 = zeros(1,points);
for i=1:points
    if p_n_v(i) ~=0
      position_1(j_a) = i;
      j_a = j_a + 1;
    end
end
      j_a = j_a - 1;
  position = zeros(1,j_a);    
  position = position_1(1:j_a);
  %Ȼ�����Щ���λ�þ�������ж�,��̽�⼫ֵ��
for i=1:length(position)-1   %diff�ĳ�������һ��
    if abs(position(i)-position(i+1))<=gate  %ԭ����11,2017.9.23�޸�Ϊ80,ԭ����80,2016.11.12�޸�Ϊ11  %abs ����ֵ  �������λ�õľ���С��80��������ʱ��˵���ǿ���һ��ļ�ֵ��
       diff(i)=p_n_v(position(i)) - p_n_v(position(i+1));  %������λ�õ��߼������ ������������Ҫ������1-1��-1-1,1-��-1����
    else
       diff(i)=0;  %�������λ�õľ������80��������ʱ����������Ĭ��Ϊ���ǿ���һ��ļ�ֵ�ԡ�
    end
end
%��diff=-2��λ�ü�¼����
position_2 = zeros(1,length(diff));   %����ȸ�һ������
position_3 = zeros(1,length(diff)); 
j_b=1;
for i=1:length(diff)
    if diff(i) == -2
      position_2(j_b)= position(i);  %����Сֵ��λ�ü�¼����
      position_3(j_b)= position(i+1);%������ֵ��λ�ü�¼����
      j_b = j_b + 1;
    end
end
      j_b = j_b - 1;
  position_21 = zeros(1,j_b);  
  position_31 = zeros(1,j_b); 
  position_21 = position_2(1:j_b);
  position_31= position_3(1:j_b);
% �����Ϳ���������Ҫ�ĸ�����ֵ�㡢������ֵ����

 position_4 = zeros(1,points); 
 position_5 = zeros(1,points); 
 
for i=1:points
    for j=1:length(position_21)
        if i == position_21(j)
             position_4(i) = i;   %��������ֵ��λ����ȡ����
        else if i == position_31(j)
                  position_5(i) = i;   %��������ֵ��λ����ȡ����
%             else                    %������﷨�����д��������������ע�͵����ͻ����
%                   position_5(i) =0; % ��Ϊ��������ѭ���������������ע�͵���
%                   position_4(i) =0;
            end
         end
    end  
end
% ���ҵ��ĸ�����ֵ�㡢������ֵ��������һ��
 position_6 = zeros(1,points); 
 for i=1:points
     if position_4(i) ~=0
         %position_6(i) = position_4(i);
          position_6(i) = -1;
     else if  position_5(i) ~=0 
         %position_6(i) = position_5(i);
         position_6(i) = 1;
         else
          position_6(i)=0; 
         end
     end
 end
position_out = zeros(1,points);
position_out = position_6;

 
 