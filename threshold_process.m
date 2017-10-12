function [p_n_v,threshold] = threshold_process(maximum_value,points,sample_rate)
% 找出能用的极值对
%  求正极大值的平均
%公式  maximum_value=m_w_3;
%找到maximum_value中大于零的值
% p_v = zeros(1,points);
p_v= maximum_value;
% for i=1:points
%     if maximum_value(i)>0
%         p_v(i) = maximum_value(i);
%     else
%         p_v(i) = 0;
%     end
% end
p_v(maximum_value<=0)=0;
duration=ceil(sample_rate*2.844);  %原先是1024
st=ceil(sample_rate*0.708);%原先是255
%将小波系数分成4段，找出每段的最大值，然后相加求出平均值
%关于找最大值的算法，去找一个最优的算法可以用于FPGA的已有的算法直接使用即可
%for i=1:round(points/4)  %关于这个四舍五入的运算，可通过对点数的控制，省去round函数的使用
for point_n =1:fix(points/duration)%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1=1+(point_n-1)*duration;
    x2= x1+st;
    a_1 = max(p_v(x1:x2));
    x3=x2+1;
    x4=x3+st;
    a_2 = max(p_v(x3:x4));
    x5=x4+1;
    x6=x5+st;
    a_3 = max(p_v(x5:x6));
    x7=x6+1;
    x8=x7+st;
    a_4 = max(p_v(x7:x8));
    
    p_thre = ( a_1 + a_2 + a_3 + a_4)/4;
    % 记录位置
    for i=x1:x8
        if  p_v(i)>(p_thre/3)     %这儿是1/3
            p_v(i)= 1;
        else
            p_v(i)=0;
        end
    end
end

if(rem(points,duration) ~=0)
    for i=fix(points/duration)*duration+1:points
        if  p_v(i)>(p_thre/3)     %这儿是1/3
            p_v(i)= 1;
        else
            p_v(i)=0;
        end
    end
end


%求负极大值的平均
% n_v = zeros(1,points);
n_v=maximum_value;
% for i=1:points
%     if maximum_value(i)<0
%         n_v(i) = maximum_value(i);
%     else
%         n_v(i) = 0;
%     end
% end
n_v(maximum_value>=0)=0;
for point_n =1:fix(points/duration)%%%%%%%%%%%%%%%%%%%%%%%%%%
    x1=1+(point_n-1)*duration;
    x2= x1+st;
    b_1 = min(n_v(x1:x2));
    x3=x2+1;
    x4=x3+st;
    b_2 = min(n_v(x3:x4));
    x5=x4+1;
    x6=x5+st;
    b_3 = min(n_v(x5:x6));
    x7=x6+1;
    x8=x7+st;
    b_4 = min(n_v(x7:x8));
    
    n_thre = ( b_1 + b_2 + b_3 + b_4)/4;
    
    % 记录位置
    for i=x1:x8
        if  n_v(i)<(n_thre/4)      %这儿是1/4
            n_v(i)= -1;
        else
            n_v(i)=0;
        end
    end
end

if(rem(points,duration) ~=0)
    for i=fix(points/duration)*duration+1:points
        if  n_v(i)<(n_thre/3)     %这儿是1/3
            n_v(i)= -1;
        else
            n_v(i)=0;
        end
    end
end

%将 p_v 和 n_v 合在一起
p_n_v = zeros(1,points);
for i=1:points
    if p_v(i) ~=0
        p_n_v(i) = p_v(i);
    else if n_v(i) ~=0
         p_n_v(i) = n_v(i);
        else
          p_n_v(i) = 0;
        end
    end
end
% p_n_v=p_v|n_v;
threshold = [p_thre,n_thre];
