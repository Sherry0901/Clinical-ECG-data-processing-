
% �����С��ϵ��w
%������Ǹ�����ֵ���ֵ���Ǽ�ֵ��Ϊ��
function m_w_value= maximum_value_find(w,points)
%2017.9.25�޸��˴��룬�ӿ��ٶ�
% *********** ������ֵ����  ******  % 
% p_w  ��������ֵ w=w1;
% p_g_w б�ʵ�ֵ��б��Ϊ��ʱ p_g_w =1,���෴��p_g_w =0
% p_m_w ������ֵ�㣬p_m_w =1ʱ��ʾ��������ֵ�㣬����Ϊ�㡣
% �� 0 0 1 0 0����ʾ ������λ���Ǽ���ֵλ�õ㡣
% m_w ����ֵ��ͼ�Сֵ���λ��
% m_w_value  �ó���ֵ
% ************************************************************************%
% p_w = zeros(1,points);
p_w= w;
% for i=1:points          %С��ϵ���Ĵ���0�ĵ㣬�������ֵ������С�����ֵ���㡣
%   if w(i) >0
%       p_w(i) = w(i);
%   else
%       p_w(i) = 0;
%   end
% end
p_w(w<=0)=0;  %֮ǰ��for��������������棬�ӿ��ٶ� 
% б������  Ҳ��ǰһ�������һ�����Ƚϡ�
p_g_w = zeros(1,points-1);  %��������һ��
for i=1:points-1   %���ȱ�Ū����
   if p_w(i) < p_w(i+1) 
      p_g_w(i) = 1;
  else
      p_g_w(i) = 0;
  end
end

%������ֵ��  
p_m_w = zeros(1,points-1);  %������p_g_w�ĸ���һ������һ������
for i=1:points-2 %���ȱ�Ū����
   if p_g_w(i) > p_g_w(i+1) 
      p_m_w(i+1) = 1;
  else
      p_m_w(i+1) = 0;
  end
end

%������ֵ����
% n_w = zeros(1,points);
% for i=1:points %С��ϵ���Ĵ���0�ĵ㣬�������ֵ������С�����ֵ���㡣
%   if w(i) <0
%       n_w(i) = w(i);
%   else
%       n_w(i) = 0;
%   end
% end
n_w=w;
n_w(w>=0)=0;  %֮ǰ��for��������������棬�ӿ��ٶ�
% б������  Ҳ��ǰһ�������һ�����Ƚϡ�
n_g_w = zeros(1,points-1);  %��������һ��
for i=1:points-1   %���ȱ�Ū����
   if n_w(i) > n_w(i+1) 
      n_g_w(i) = 1;
  else
      n_g_w(i) = 0;
  end
end

%������ֵ��  
n_m_w = zeros(1,points-1);  %������p_g_w�ĸ���һ������һ������
for i=1:points-2  %���ȱ�Ū����
   if n_g_w(i) > n_g_w(i+1) 
      n_m_w(i+1) = 1;
  else
      n_m_w(i+1) = 0;
  end
end

%������ֵ��λ�÷���һ��
%��matlab�п��Բ��û�����  m_w =p_m_w|n_m_w; 

% m_w = zeros(1,points);
% for i=1:points-1
%     if p_m_w(i) ~=0 
%         m_w(i) = p_m_w(i);
%     else if n_m_w(i) ~=0 
%          m_w(i) = n_m_w(i);
%         else
%           m_w(i) = 0;  
%         end
%     end
% end
m_w =p_m_w|n_m_w;  
m_w(1) =1;
m_w(points)=1;



% �ҳ���ֵ���ֵ
m_w_value = w;
% for i=1:points
%     if m_w(i) ~=0
%         m_w_value(i)=w(i);
%     else
%         m_w_value(i)=0;
%     end
% end
m_w_value(m_w==0)=0;
 m_w_value(1)=m_w_value(1) + 1e-10;  
 m_w_value(points)=m_w_value(points) + 1e-10; 





