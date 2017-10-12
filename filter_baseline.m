function s_rec = filter_baseline(s_rec);
%%细节系数进行阈值量化

%见PDF文件《Moving Average Filters》中的介绍

move_filter_width = 181; %移动窗的宽度 

%%% y0就是一个变量，不是数组

       y0=0;     
    for i = 1:move_filter_width
        y0= y0 + s_rec(i);
    end
    y1_1(1) = y0;
%%%%上面的代码，是计算一个数值给数组y1_1的第一个位置；

%%%%下面的代码，是用迭代法，依次求值，
for j = 2:length(s_rec)-move_filter_width    %运用迭代法，减小了计算量。
    y1_1(j) = y1_1(j-1)- s_rec(j-1)+s_rec(move_filter_width+j-1);
end

    y1=0;
    for i = 1:move_filter_width
        y1= y1 + s_rec(length(s_rec)-move_filter_width+2-i);
    end 
       
    y1_1(length(s_rec)-move_filter_width+1) = y1;

for j= length(s_rec)-move_filter_width+2:length(s_rec)
    y1_1(j) = y1_1(j-1)+ s_rec(j)-s_rec(j-move_filter_width+1);
end
s_rec = s_rec -(1/move_filter_width)*y1_1';
















% move_filter_width = 181; %移动窗的宽度
% %%%  前向滤波，结果为y1  %%%%%%%%%%%%
%   y1(1)=s_rec(1);
% for i = 1:move_filter_width-1
%     y1(i+1) = y1(i) + s_rec(i);
% end
% for i= move_filter_width:length(s_rec)
%      y1(i+1) = s_rec(i) + y1(i)- s_rec(i-move_filter_width+1);
% end
% %%%  反向滤波，结果为y2  %%%%%%%%%%%%
% for k=1:length(s_rec)
%       s_rec_1(k) = s_rec(length(s_rec)+1-k);
% end 
%     y2(1)=s_rec_1(1);
% for i = 1:move_filter_width-1
%     y2(i+1) = y2(i) + s_rec_1(i);
% end
% for i= move_filter_width:length(s_rec)
%      y2(i+1) = s_rec_1(i) + y2(i)- s_rec_1(i-move_filter_width+1);
% end
% %%%%将y1 和 y2 长度各取一半，构成b信号即基线漂移信号%%%%%%%%%%
%   for k=1:length(s_rec)/2
%       b(k) =y2(length(s_rec)+1-k);
%   end
%   for k=length(s_rec)/2 + 1:length(s_rec)
%       b(k) =y1(k);
%   end
%   
%   %%%% 信号 = 重构信号 - 基线漂移信号 %%% 
% s_rec = s_rec -(1/move_filter_width)*b';