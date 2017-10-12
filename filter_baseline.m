function s_rec = filter_baseline(s_rec);
%%ϸ��ϵ��������ֵ����

%��PDF�ļ���Moving Average Filters���еĽ���

move_filter_width = 181; %�ƶ����Ŀ�� 

%%% y0����һ����������������

       y0=0;     
    for i = 1:move_filter_width
        y0= y0 + s_rec(i);
    end
    y1_1(1) = y0;
%%%%����Ĵ��룬�Ǽ���һ����ֵ������y1_1�ĵ�һ��λ�ã�

%%%%����Ĵ��룬���õ�������������ֵ��
for j = 2:length(s_rec)-move_filter_width    %���õ���������С�˼�������
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
















% move_filter_width = 181; %�ƶ����Ŀ��
% %%%  ǰ���˲������Ϊy1  %%%%%%%%%%%%
%   y1(1)=s_rec(1);
% for i = 1:move_filter_width-1
%     y1(i+1) = y1(i) + s_rec(i);
% end
% for i= move_filter_width:length(s_rec)
%      y1(i+1) = s_rec(i) + y1(i)- s_rec(i-move_filter_width+1);
% end
% %%%  �����˲������Ϊy2  %%%%%%%%%%%%
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
% %%%%��y1 �� y2 ���ȸ�ȡһ�룬����b�źż�����Ư���ź�%%%%%%%%%%
%   for k=1:length(s_rec)/2
%       b(k) =y2(length(s_rec)+1-k);
%   end
%   for k=length(s_rec)/2 + 1:length(s_rec)
%       b(k) =y1(k);
%   end
%   
%   %%%% �ź� = �ع��ź� - ����Ư���ź� %%% 
% s_rec = s_rec -(1/move_filter_width)*b';