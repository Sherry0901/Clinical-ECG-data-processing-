% % % % % % % % % % % % % % % % % % % % %д���ļ�
function write2file(l2,all_data,R,pacdir,pac_num,resultdir,name)
figure(1);
plot(l2);
hold on
handle_r=plot(R,l2(R),'*','color','R');  %����R��λ��
% figure ������󻯣�������Ҳ���Ŵ��ڱ�����Ӧ���
scrsz = get(0,'ScreenSize');  % ��Ϊ�˻����Ļ��С��Screensize��һ��4Ԫ������[left,bottom, width, height]
set(gcf,'Position',scrsz);    % �û�õ�screensize��������figure��position���ԣ�ʵ����󻯵�Ŀ��
axis([0, 7000,-0.5, 1.5 ]);   % ���������ʾ��Χ
for y=1:length(R)
    hnd_text_r(y)=text((R(y)-2),(l2(R(y))+0.1),num2str(y));  %���R����number
end
saveas(gcf,[resultdir,name,'.fig']);
iswrite=input('�Ƿ�R����Ϣд���ļ�����������1������������0��'); %������̫�һ���R����ȡ©�����أ�����ʱ��Ҫд���ļ����������޸ĵ���
if iswrite
    delete_R_num=input('��������Ҫɾ����R���Ĳ��θ���������������0:');
    if (delete_R_num~=0)
        for s=1:delete_R_num
            delete_R_begin=input('��������Ҫɾ����R��λ����ʼ�㣬ע����text����ʾ����ֵ:');
            delete_R_end=input('��������Ҫɾ����R��λ����ֹ��:');
            R(delete_R_begin:delete_R_end)=0;
            
        end
    end
    R(R==0)=[]; %%��0Ԫ��ɾ��
    
    miss_R_num=input('��������Ҫ���ӵ�R���ĸ���������������0:');
    if (miss_R_num~=0)
        
        for s=1:miss_R_num
            miss_R=input('��������Ҫ���ӵ�R��λ��:');
            for j=1:length(R)
                if miss_R>R(j) && miss_R<R(j+1)
                    R=[R(1:j);miss_R;R(j+1:end)];
                    
                end
            end
        end
    end
    
    % % % % % % % % % % % % %    ���»�R��λ��
    delete(handle_r);
    delete(hnd_text_r);
    plot(R,l2(R),'*','color','R');     %�������ֵ��
   
    for y=1:length(R)
        hnd_text_r(y)=text((R(y)-2),(l2(R(y))+0.1),num2str(y));
    end
    fprintf('Program paused. Press enter to continue.\n');
    pause;
    lr=length(R);
     type=cell(lr,1);
    for k=int32(1):lr
        type{k,1}='N';      %Ĭ��Ϊ����
    end

    R_type=[num2cell(R) type];
%     file_feature=[pacdir,name,num2str(pac_num),'_feature.csv'];   
    file_R=[pacdir,name,num2str(pac_num),'R.xlsx'];
    file_all_data=[pacdir,name,num2str(pac_num),'alldata.xlsx'];
%     QRSclinical(l2,R,samplerate,file_feature);
    xlswrite(file_R,R_type);     %��R����Ϣд�� .xls
    xlswrite(file_all_data,all_data); %���ĵ�����д�� .xls
end
    close all;
    pause(0.01);
end