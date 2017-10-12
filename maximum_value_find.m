
% 输入的小波系数w
%输出的是各个极值点的值，非极值点为零
function m_w_value= maximum_value_find(w,points)
%2017.9.25修改了代码，加快速度
% *********** 正极大值点检测  ******  % 
% p_w  是正的数值 w=w1;
% p_g_w 斜率的值，斜率为正时 p_g_w =1,；相反，p_g_w =0
% p_m_w 正极大值点，p_m_w =1时表示是正极大值点，否则为零。
% 如 0 0 1 0 0，表示 第三个位置是极大值位置点。
% m_w 极大值点和极小值点的位置
% m_w_value  得出极值
% ************************************************************************%
% p_w = zeros(1,points);
p_w= w;
% for i=1:points          %小波系数的大于0的点，大于零的值保留，小于领的值置零。
%   if w(i) >0
%       p_w(i) = w(i);
%   else
%       p_w(i) = 0;
%   end
% end
p_w(w<=0)=0;  %之前的for可以用这个语句代替，加快速度 
% 斜率运算  也就前一个数与后一个数比较。
p_g_w = zeros(1,points-1);  %个数少了一个
for i=1:points-1   %长度别弄错了
   if p_w(i) < p_w(i+1) 
      p_g_w(i) = 1;
  else
      p_g_w(i) = 0;
  end
end

%正极大值点  
p_m_w = zeros(1,points-1);  %个数与p_g_w的个数一样，第一个是零
for i=1:points-2 %长度别弄错了
   if p_g_w(i) > p_g_w(i+1) 
      p_m_w(i+1) = 1;
  else
      p_m_w(i+1) = 0;
  end
end

%负极大值点检测
% n_w = zeros(1,points);
% for i=1:points %小波系数的大于0的点，大于零的值保留，小于领的值置零。
%   if w(i) <0
%       n_w(i) = w(i);
%   else
%       n_w(i) = 0;
%   end
% end
n_w=w;
n_w(w>=0)=0;  %之前的for可以用这个语句代替，加快速度
% 斜率运算  也就前一个数与后一个数比较。
n_g_w = zeros(1,points-1);  %个数少了一个
for i=1:points-1   %长度别弄错了
   if n_w(i) > n_w(i+1) 
      n_g_w(i) = 1;
  else
      n_g_w(i) = 0;
  end
end

%负极大值点  
n_m_w = zeros(1,points-1);  %个数与p_g_w的个数一样，第一个是零
for i=1:points-2  %长度别弄错了
   if n_g_w(i) > n_g_w(i+1) 
      n_m_w(i+1) = 1;
  else
      n_m_w(i+1) = 0;
  end
end

%将极大值的位置放在一起
%在matlab中可以采用或运算  m_w =p_m_w|n_m_w; 

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



% 找出极值点的值
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





