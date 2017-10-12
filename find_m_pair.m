function position_6 = find_m_pair (p_n_v,points,sample_rate) 

%找出极值对 
%先找出非零点的位置，然后对这些点的位置距离进行判断
%position  的大小是由非零值得个数决定的 
%p_n_v=p_n_v_3;
% gate=ceil(sample_rate/10);  %360hz原先是50,100原先是11
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
  %然后对这些点的位置距离进行判断,并探测极值对
for i=1:length(position)-1   %diff的长度少了一个
    if abs(position(i)-position(i+1))<=gate  %原来是11,2017.9.23修改为80,原来是80,2016.11.12修改为11  %abs 绝对值  如果非零位置的距离小于80个采样点时，说明是靠在一起的极值对
       diff(i)=p_n_v(position(i)) - p_n_v(position(i+1));  %这两个位置的逻辑数相减 。这个运算很重要（包含1-1，-1-1,1-（-1））
    else
       diff(i)=0;  %如果非零位置的距离大于80个采样点时，则距离过大，默认为不是靠在一起的极值对。
    end
end
%将diff=-2的位置记录下来
position_2 = zeros(1,length(diff));   %随便先给一个长度
position_3 = zeros(1,length(diff)); 
j_b=1;
for i=1:length(diff)
    if diff(i) == -2
      position_2(j_b)= position(i);  %将极小值的位置记录下来
      position_3(j_b)= position(i+1);%将极大值的位置记录下来
      j_b = j_b + 1;
    end
end
      j_b = j_b - 1;
  position_21 = zeros(1,j_b);  
  position_31 = zeros(1,j_b); 
  position_21 = position_2(1:j_b);
  position_31= position_3(1:j_b);
% 这样就可以找所需要的负极大值点、正极大值点了

 position_4 = zeros(1,points); 
 position_5 = zeros(1,points); 
 
for i=1:points
    for j=1:length(position_21)
        if i == position_21(j)
             position_4(i) = i;   %将负极大值的位置提取出来
        else if i == position_31(j)
                  position_5(i) = i;   %将正极大值的位置提取出来
%             else                    %这儿的语法哪里有错误，如果不把下面注释掉，就会出错。
%                   position_5(i) =0; % 因为套了两层循环，所以这儿必须注释掉。
%                   position_4(i) =0;
            end
         end
    end  
end
% 将找到的负极大值点、正极大值点整合在一起。
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

 
 