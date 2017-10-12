%************************** ������ȡ����*****************************************%
%************************** R��������ȡ����**************************************%
function  Rwave_place= detection_Rwave(s_orign,sample_rate) %�������R����λ��
% 2017.9.25�޸��˲��ִ��룬ע�͵����õı������ӿ����

points=length(s_orign); 

% **************************************** % 
signal=reshape(s_orign,1,points);
% level=4;                                           %�ֽ����Ϊ4��_maxweller 
% signal=signal(1:1*points);         %��ecgdata������һ�������뵽���� signal��
%�Ĳ�ֽ�
                                      % ��һ��ֽ�� �ƽ�ϵ��a1��С��ϵ��w1
a1=zeros(1,points);
w1=zeros(1,points);
                                      % �ڶ���ֽ�� �ƽ�ϵ��a2��С��ϵ��w2
a2=zeros(1,points);
w2=zeros(1,points);
                                      % ������ֽ�� �ƽ�ϵ��a3��С��ϵ��w3
a3=zeros(1,points);
w3=zeros(1,points);
                                      % ���Ĳ�ֽ�� �ƽ�ϵ��a4��С��ϵ��w4
a4=zeros(1,points);
w4=zeros(1,points);

% *******************  С���ֽⲿ��  ********************** %
%��һ��ֽ⣬�Ǵӵ�4�㿪ʼ�ģ�ǰ�������ֵΪ��
%�����ֽ⣬�Ǵӵ�24�㿪ʼ�ģ�ǰ24�����ֵΪ�㣬2016.11.12���޸�Ϊ6,12,24
%ע�� 2^0 = 1
%�����õ���һ��������ۡ��� trous�� algorithm for WT�����ġ�A wavelet-based ECG delineator- evaluation on standard databases��
%ע�������2^(j-1)
% ******************************************************** %
for i=1:points-3           
  a1(i+3)= 1/4*signal(i+3- 2^0*0) + 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2)+ 1/4*signal(i+3- 2^0*3);
  w1(i+3)= -1/4*signal(i+3- 2^0*0) - 3/4*signal(i+3- 2^0*1) + 3/4*signal(i+3- 2^0*2) + 1/4*signal(i+3- 2^0*3);
end
                                  %�������C���Ե���ƣ����Բ��þ��󷨽������  
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


% *******************   �ҳ�ÿһ��ļ���ֵ��ͼ�Сֵ��  ********************%
%  ����C���Է������Բ��þ�������
%  ÿ�����Ѱ�ҷ�����һ���� 
%  ��ֵѰ�Һ�������� maximum_value_find
% m_w_1��m_w_2��m_w_3��m_w_4�Ⱦ��Ǹ���ļ�ֵ�㣬���Ǽ�ֵ���ֵ��Ϊ0��
% ************************************************************************%
%�ȷ�����һ���ռ�
m_w_1 = zeros(1,points);
% m_w_2 = zeros(1,points);
m_w_3 = zeros(1,points);
% m_w_4 = zeros(1,points);

m_w_1 = maximum_value_find(w1,points);      %%�ҳ�ÿ��ļ�ֵ���ҳ���������ʵ��ֵ��
% m_w_2 = maximum_value_find(w2,points);
m_w_3 = maximum_value_find(w3,points);
% m_w_4 = maximum_value_find(w4,points);
% 
% figure(3);
% subplot(4,1,1);plot(m_w_1,'LineWidth',2);ylabel('m_w_1');
% subplot(4,1,2);plot(m_w_2,'LineWidth',2);ylabel('m_w_2');
% subplot(4,1,3);plot(m_w_3,'LineWidth',2);ylabel('m_w_3');
% subplot(4,1,4);plot(m_w_4,'LineWidth',2);ylabel('m_w_4');
% ***************   ��ֵ����ֵ����    ******************* %
%  p_n_v_3 ��ֵ����ֵ���� �������-1,0��1��ֵ����Ϊ����һ���ļ�ֵ�Ե�Ѱ����׼��
p_n_v_3 = zeros(1,points);  
[p_n_v_3,~] = threshold_process(m_w_3,points,sample_rate);  %ֻ����������
% figure(4);
% plot(p_n_v_3);
% ***************                �ҳ���ֵ��           ****************** %
%%�ҵ� ����ȷ��ֵ��λ�ã�����λ������ ��-1,1��Գ���
%�����������ļ�ֵ��ʱ��������ǳ��ֵĶ���ļ�ֵ�ԣ���Ӧ����������ʵ�����йء�
% ************************************************************************%

position_3 = zeros(1,points);
position_3 = find_m_pair(p_n_v_3,points,sample_rate);  %2016.11.12 �����ڲ��������޸�


% ************ ��������ֵ�Թ��㣬��R����ֵ��������QRS����㼰�յ� ***** %
%������� �����������λ������
% ************************************************************************%

[R_1,~,count2,count3]= find_zeros (m_w_1,m_w_3,position_3,points,sample_rate);  %2016.11.12 �����ڲ��������޸�



%************************��ȷR���� �� QRS��λ��**************************%

% QRS���ĺ�����
Qstart=[];
for m=1:points    %  c2num=size(count2); for m=1:c2num(2)  
    if count2(m)==-1
        Qstart=[Qstart,m];  %��ʵ���﷨���⣬Ҳ���� Qstart=m,��������
    end
end
%QRS�յ�ĺ�����
Send=[];
for m=1:points      % c3num=size(count3); for m=1:c3num(2)  
    if count3(m)==-1
        Send=[Send,m];   %��ʵ���﷨���⣬Ҳ���� Send=m ��������
    end
end
%���R��
% QRSnum=size(R_1);
R=[];
for m=1:length(Qstart)  %QRSnum(2)
     a=Qstart(m);
     c=Send(m);
     [yR r0]=max(signal(1,a:c));
     r=a+r0-1;
     R=[R,r];  %��ʵ���﷨���⣬Ҳ���� R=r ��������
end
%���Q�㡢R���S��
% Q=[];
% S=[];
% for m=1:QRSnum(2)
%     a=Qstart(m);
%     b=R(m);
%     c=Send(m);
%     [yQ q0]=min(ecgdata(1,a:b));  %���������������͵�  yQ����ֵ��q0����Сֵ��λ�á�
%     [yS s0]=min(ecgdata(1,b:c));  %���������������͵�
%     q=a+q0-1;
%     Q=[Q,q];    %��ʵ���﷨���⣬Ҳ���� Q=q ��������
%     s=b+s0-1;
%     S=[S,s];    %��ʵ���﷨���⣬Ҳ���� S=s ��������
% end
% 
% 
% % ************************    ��ͼ    **************************%
% num=size(Qstart);
% Y=zeros(1,points );
% for i=1:num(2)
%     for j=Qstart(i):Send(i)
%         Y(j)= ref_value;
%     end
% end

Rwave_place =R';