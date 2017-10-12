%************************** 特征提取进入*****************************************%
%************************** R波初步提取程序**************************************%
function  Rwave_place= detection_Rwave(s_orign,sample_rate) %输出的是R波的位置
% 2017.9.25修改了部分代码，注释掉无用的变量，加快程序

points=length(s_orign); 

% **************************************** % 
signal=reshape(s_orign,1,points);
% level=4;                                           %分解层数为4层_maxweller 
% signal=signal(1:1*points);         %将ecgdata的数据一个个导入到数组 signal中
%四层分解
                                      % 第一层分解的 逼近系数a1和小波系数w1
a1=zeros(1,points);
w1=zeros(1,points);
                                      % 第二层分解的 逼近系数a2和小波系数w2
a2=zeros(1,points);
w2=zeros(1,points);
                                      % 第三层分解的 逼近系数a3和小波系数w3
a3=zeros(1,points);
w3=zeros(1,points);
                                      % 第四层分解的 逼近系数a4和小波系数w4
a4=zeros(1,points);
w4=zeros(1,points);

% *******************  小波分解部分  ********************** %
%第一层分解，是从第4点开始的，前三个点的值为零
%其余层分解，是从第24点开始的，前24个点的值为零，2016.11.12，修改为6,12,24
%注意 2^0 = 1
%这里用到了一个多孔理论“à trous” algorithm for WT。论文《A wavelet-based ECG delineator- evaluation on standard databases》
%注意这里的2^(j-1)
% ******************************************************** %
for i=1:points-3           
  a1(i+3)= 1/4*signal(i+3- 2^0*0) + 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2)+ 1/4*signal(i+3- 2^0*3);
  w1(i+3)= -1/4*signal(i+3- 2^0*0) - 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2) + 1/4*signal(i+3- 2^0*3);
end
                                  %这儿对于C语言的设计，可以采用矩阵法进行设计  
j=2;
for i=1:points-6
a2(i+6)=1/4*a1(i+6-2^(j-1)*0)+3/4*a1(i+6-2^(j-1)*1)+3/4*a1(i+6-2^(j-1)*2)+1/4*a1(i+6-2^(j-1)*3);
w2(i+6)=-1/4*a1(i+6-2^(j-1)*0)-3/4*a1(i+6-2^(j-1)*1)+3/4*a1(i+6-2^(j-1)*2)+1/4*a1(i+6-2^(j-1)*3);
end

j=3;
for i=1:points-12
a3(i+12)=1/4*a2(i+12-2^(j-1)*0)+3/4*a2(i+12-2^(j-1)*1)+3/4*a2(i+12-2^(j-1)*2)+1/4*a2(i+12-2^(j-1)*3);
w3(i+12)=-1/4*a2(i+12-2^(j-1)*0)-3/4*a2(i+12-2^(j-1)*1)+3/4*a2(i+12-2^(j-1)*2)+1/4*a2(i+12-2^(j-1)*3);
end

j=4;
for i=1:points-24
a4(i+24)=1/4*a3(i+24-2^(j-1)*0)+3/4*a3(i+24-2^(j-1)*1)+3/4*a3(i+24-2^(j-1)*2)+1/4*a3(i+24-2^(j-1)*3);
w4(i+24)=-1/4*a3(i+24-2^(j-1)*0)-3/4*a3(i+24-2^(j-1)*1)+3/4*a3(i+24-2^(j-1)*2)+1/4*a3(i+24-2^(j-1)*3);
end

% figure(1);
% subplot(4,1,1);plot(w1,'LineWidth',2);ylabel('w1');
% subplot(4,1,2);plot(w2,'LineWidth',2);ylabel('w2');
% subplot(4,1,3);plot(w3,'LineWidth',2);ylabel('w3');
% subplot(4,1,4);plot(w4,'LineWidth',2);ylabel('w4');


% *******************   找出每一层的极大值点和极小值点  ********************%
%  对于C语言法，可以采用矩阵来做
%  每个层的寻找方法是一样的 
%  极值寻找函数的设计 maximum_value_find
% m_w_1，m_w_2，m_w_3，m_w_4等就是各层的极值点，不是极值点的值变为0。
% ************************************************************************%
%先分配了一个空间
m_w_1 = zeros(1,points);
% m_w_2 = zeros(1,points);
m_w_3 = zeros(1,points);
% m_w_4 = zeros(1,points);

m_w_1 = maximum_value_find(w1,points);      %%找出每层的极值点找出来：（真实数值）
% m_w_2 = maximum_value_find(w2,points);
m_w_3 = maximum_value_find(w3,points);
% m_w_4 = maximum_value_find(w4,points);
% 
% figure(3);
% subplot(4,1,1);plot(m_w_1,'LineWidth',2);ylabel('m_w_1');
% subplot(4,1,2);plot(m_w_2,'LineWidth',2);ylabel('m_w_2');
% subplot(4,1,3);plot(m_w_3,'LineWidth',2);ylabel('m_w_3');
% subplot(4,1,4);plot(m_w_4,'LineWidth',2);ylabel('m_w_4');
% ***************   极值的阈值处理    ******************* %
%  p_n_v_3 极值点阈值处理 输出的是-1,0，1的值，是为了下一步的极值对的寻找做准备
p_n_v_3 = zeros(1,points);  
[p_n_v_3,~] = threshold_process(m_w_3,points,sample_rate);  %只计算第三层的
% figure(4);
% plot(p_n_v_3);
% ***************                找出极值对           ****************** %
%%找到 更精确极值对位置，其它位置置零 让-1,1配对出现
%再设计找所需的极值对时，这儿还是出现的多余的极值对，这应该是与采样率的设计有关。
% ************************************************************************%

position_3 = zeros(1,points);
position_3 = find_m_pair(p_n_v_3,points,sample_rate);  %2016.11.12 函数内部进行了修改


% ************ 求正负极值对过零，即R波峰值，并检测出QRS波起点及终点 ***** %
%输出的是 各个特征点的位置坐标
% ************************************************************************%

[R_1,~,count2,count3]= find_zeros (m_w_1,m_w_3,position_3,points,sample_rate);  %2016.11.12 函数内部进行了修改



%************************精确R波峰 和 QRS波位置**************************%

% QRS起点的横坐标
Qstart=[];
for m=1:points    %  c2num=size(count2); for m=1:c2num(2)  
    if count2(m)==-1
        Qstart=[Qstart,m];  %其实是语法问题，也就是 Qstart=m,生成数组
    end
end
%QRS终点的横坐标
Send=[];
for m=1:points      % c3num=size(count3); for m=1:c3num(2)  
    if count3(m)==-1
        Send=[Send,m];   %其实是语法问题，也就是 Send=m 生成数组
    end
end
%检测R点
% QRSnum=size(R_1);
R=[];
for m=1:length(Qstart)  %QRSnum(2)
     a=Qstart(m);
     c=Send(m);
     [yR r0]=max(signal(1,a:c));
     r=a+r0-1;
     R=[R,r];  %其实是语法问题，也就是 R=r 生成数组
end
%检测Q点、R点和S点
% Q=[];
% S=[];
% for m=1:QRSnum(2)
%     a=Qstart(m);
%     b=R(m);
%     c=Send(m);
%     [yQ q0]=min(ecgdata(1,a:b));  %这儿又是在搜索最低点  yQ是数值，q0是最小值的位置。
%     [yS s0]=min(ecgdata(1,b:c));  %这儿又是在搜索最低点
%     q=a+q0-1;
%     Q=[Q,q];    %其实是语法问题，也就是 Q=q 生成数组
%     s=b+s0-1;
%     S=[S,s];    %其实是语法问题，也就是 S=s 生成数组
% end
% 
% 
% % ************************    画图    **************************%
% num=size(Qstart);
% Y=zeros(1,points );
% for i=1:num(2)
%     for j=Qstart(i):Send(i)
%         Y(j)= ref_value;
%     end
% end

Rwave_place =R';