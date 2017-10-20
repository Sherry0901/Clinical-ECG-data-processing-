% % % % % % % % % % % % % % % % % % % % %写入文件
function write2file(l2,all_data,R,pacdir,pac_num,resultdir,name)
figure(1);
plot(l2);
hold on
handle_r=plot(R,l2(R),'*','color','R');  %绘制R波位置
% figure 窗口最大化，坐标轴也随着窗口变大而相应变大
scrsz = get(0,'ScreenSize');  % 是为了获得屏幕大小，Screensize是一个4元素向量[left,bottom, width, height]
set(gcf,'Position',scrsz);    % 用获得的screensize向量设置figure的position属性，实现最大化的目的
axis([0, 7000,-0.5, 1.5 ]);   % 坐标轴的显示范围
for y=1:length(R)
    hnd_text_r(y)=text((R(y)-2),(l2(R(y))+0.1),num2str(y));  %标出R波的number
end
saveas(gcf,[resultdir,name,'.fig']);
iswrite=input('是否将R波信息写入文件，是请输入1，不是请输入0：'); %若数据太乱或者R波提取漏检严重，则暂时不要写进文件，待后续修改调试
if iswrite
    delete_R_num=input('请输入需要删除的R波的波段个数，若无请输入0:');
    if (delete_R_num~=0)
        for s=1:delete_R_num
            delete_R_begin=input('请输入需要删除的R波位置起始点，注意是text上显示的数值:');
            delete_R_end=input('请输入需要删除的R波位置终止点:');
            R(delete_R_begin:delete_R_end)=0;
            
        end
    end
    R(R==0)=[]; %%将0元素删除
    
    miss_R_num=input('请输入需要增加的R波的个数，若无请输入0:');
    if (miss_R_num~=0)
        
        for s=1:miss_R_num
            miss_R=input('请输入需要增加的R波位置:');
            for j=1:length(R)
                if miss_R>R(j) && miss_R<R(j+1)
                    R=[R(1:j);miss_R;R(j+1:end)];
                    
                end
            end
        end
    end
    
    % % % % % % % % % % % % %    重新绘R波位置
    delete(handle_r);
    delete(hnd_text_r);
    plot(R,l2(R),'*','color','R');     %绘制最大值点
   
    for y=1:length(R)
        hnd_text_r(y)=text((R(y)-2),(l2(R(y))+0.1),num2str(y));
    end
    fprintf('Program paused. Press enter to continue.\n');
    pause;
    lr=length(R);
     type=cell(lr,1);
    for k=int32(1):lr
        type{k,1}='N';      %默认为正常
    end

    R_type=[num2cell(R) type];
%     file_feature=[pacdir,name,num2str(pac_num),'_feature.csv'];   
    file_R=[pacdir,name,num2str(pac_num),'R.xlsx'];
    file_all_data=[pacdir,name,num2str(pac_num),'alldata.xlsx'];
%     QRSclinical(l2,R,samplerate,file_feature);
    xlswrite(file_R,R_type);     %将R波信息写入 .xls
    xlswrite(file_all_data,all_data); %将心电数据写入 .xls
end
    close all;
    pause(0.01);
end