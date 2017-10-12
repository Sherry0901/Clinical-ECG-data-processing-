function  [R_1,count,count2,count3]= find_zeros (m_w_1,m_w_3,position,points,sample_rate) 
%求正负极值对过零，即R波峰值，并检测出QRS波起点及终点************%
 % 好像没有用
Rnum =0;  % 好像没有用
count = zeros(1,points);
count2 = zeros(1,points);
count3 = zeros(1,points);
R0 = zeros(1,points);
%  step=floor(sample_rate/9);  %9.28改为除以7
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
     stamp_1 = i;   %找到前一个非零点
     i=i+1;         %下一个点了
      while(i<points & position(i)==0)   %一直搜索到下一个非零点
          i=i+1;  
       end
    stamp_2 = i;     %%找到后一个非零点
 %求极大值对的过零点      
    stamp_3= round((abs(m_w_3(stamp_2))*stamp_1 + stamp_2*abs(m_w_3(stamp_1)))/(abs(m_w_3(stamp_2))+abs(m_w_3(stamp_1))));
%R波极大值点
    R0(j)=stamp_3 - 10;   %就是偏移量的修正 
    count(stamp_3-10)=1;  
%求出QRS波起点
 kqs=stamp_3-10;      
 markq=0; 
     while (kqs>1)&&( markq< 3) %  kqs>1   markq<3 是根据什么区确定的呢？ 
         if  m_w_1(kqs) ~= 0     %第一层的极值点,是！！！！未经阈值处理的极值点    
            markq=markq+1;  % 不等于零时就加一，等于零时就不加；
         end
         kqs= kqs -1; %向前搜索，如果没有Q波怎么办????????????
     end
  count2(kqs)=-1;
%求出QRS波终点  
  kqs=stamp_3-10;
  marks=0;
  while (kqs<points)&&( marks<4)   %% kqs<points 注意一下
      if m_w_1(kqs)~= 0
         marks=marks+1;
      end
      kqs= kqs+1;
  end
      count3(kqs)=-1;
  
  i=i+step;      %这儿一下就加了60, 应该用他来忽略了不应期吧    %原来是60，2016.11.12修改为25
  j=j+1;
  Rnum=Rnum+1;
    end     % if position(i) == -1 的截止位置
i=i+1;   % 如果interva2(i)不为-1时，直接搜索下一个点
end   % while的截止位置

R_1 = zeros(1,j-1);
for i=1:j-1
 R_1(i) = R0(i);
end


