function draw_pdf(pacdir,name,packagename,sample_rate,data,R,pacnum)

close all;
yunit=1;%等于1代表10mm/mv,等于2代表5mm/mv

time=packagename(5:14);
time_date=[time(1:2),'/',time(3:4)];
time_h=str2double(time(5:6));
time_m=str2double(time(7:8));
time_s=str2double(time(9:10));
new_folder = [pacdir,'PDF',num2str(pacnum)]; % new_folder 保存要创建的文件夹，是绝对路径+文件夹名称
mkdir(new_folder);  % mkdir()函数创建文件夹

grid_step=0.04*sample_rate;

% % % % % % % % % % % % 读取数据
l1=data(:,1);
l2=data(:,2);
l3=data(:,3);
avr=data(:,4);
avl=data(:,5);
avf=data(:,6);
v1=data(:,7);


% % % % % % % % % % % % % % % % % % % % % 每1121个点画一张图
leng=1120;
length_l1=length(l1);
num_pdf=ceil(length_l1/leng);

l3_position=1.3*yunit;
l2_position=3.2*yunit;
l1_position=5.5*yunit;
avr_position=0;
avl_position=-2*yunit;
avf_position=-4.2*yunit;
v1_position=-5.8*yunit;


% % % % % % % % % % % % % % % 画ECG格子 % % % % % % % % % % % % % % %
x=1:grid_step:leng+1;

lx=length(x);
ymax=8*yunit;
ymin=-7.5*yunit;
y=ymin:0.1*yunit:ymax;
ly=length(y);
hold on
for i=1:ly
    if mod(y(i),0.5)==0
        plot([1,leng],[y(i),y(i)],'b-','LineWidth',0.01);
    else
        plot(x,y(i),'r.','markersize',3.5)%默认为6
    end
end
for m=1:lx
    if mod((x(m)-1),(5*grid_step))==0
        plot([x(m),x(m)],[ymin,ymax],'b-','LineWidth',0.01);
    end
end

axis([1 (leng+1) ymin ymax]);
bigx=1:25*grid_step:leng+1;
set(gca,'xtick',bigx,'xticklabel',((bigx-1)/sample_rate));
set(gca,'ytick',[],'yticklabel',[]);

% text_l1=text(-15,(l1_position),'I');
% text_l2=text(-15,(l2_position),'II');
% text_l3=text(-17,(l3_position),'III');
% text_avr=text(-27,(avr_position),'aVR');
% text_avl=text(-27,(avl_position),'aVL');
% text_avf=text(-27,(avf_position),'aVF');
% text_v1=text(-22,(v1_position),'V1');
text(-15,(l1_position),'I');
text(-15,(l2_position),'II');
text(-17,(l3_position),'III');
text(-27,(avr_position),'aVR');
text(-27,(avl_position),'aVL');
text(-27,(avf_position),'aVF');
text(-22,(v1_position),'V1');
%%%%%%%%%%%%%%%%%%%% 保存为pdf %%%%%%%%%%%%%%
set(gcf,'PaperOrientation','landscape');
set(gcf,'PaperPositionMode', 'manual');
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperPosition',[-3.5 0.06 36.05 19.07]);
set(gcf, 'PaperSize', [29.7 21]);
k=1;

for j=1:num_pdf
    if j<num_pdf && j>1
        l1_part=l1(leng*(j-1)+1:leng*j);
        l2_part=l2(leng*(j-1)+1:leng*j);
        l3_part=l3(leng*(j-1)+1:leng*j);
        v1_part=v1(leng*(j-1)+1:leng*j);
        avr_part=avr(leng*(j-1)+1:leng*j);
        avl_part=avl(leng*(j-1)+1:leng*j);
        avf_part=avf(leng*(j-1)+1:leng*j);
    else
        l1_part=l1(leng*(j-1)+1:end);
        l2_part=l2(leng*(j-1)+1:end);
        l3_part=l3(leng*(j-1)+1:end);
        v1_part=v1(leng*(j-1)+1:end);
        avr_part=avr(leng*(j-1)+1:end);
        avl_part=avl(leng*(j-1)+1:end);
        avf_part=avf(leng*(j-1)+1:end);
    end
    % % % % % % % % % % % % % % % 画ECG % % % % % % % % % % % % % % %
    
    hold on
    hndl1=plot((l1_part+l1_position),'k','LineWidth',0.7);  %5.3
    hndl2=plot((l2_part+l2_position),'k','LineWidth',0.7);  %3.2
    hndl3=plot((l3_part+l3_position),'k','LineWidth',0.7);  %1.5
    hndavr=plot((avr_part+avr_position),'k','LineWidth',0.7);
    hndavl=plot((avl_part+avl_position),'k','LineWidth',0.7); %2
    hndavf=plot((avf_part+avf_position),'k','LineWidth',0.7);
    hndv1=plot((v1_part+v1_position),'k','LineWidth',0.7);
    %%%%%%%%
    
    title([name,num2str(j,'%02d')]);
    
    hndtime=text(0.1,ymax+0.5,[time_date,'  ',num2str(time_h,'%02d'),':',num2str(time_m,'%02d'),':',num2str(time_s,'%02d'),'   25mm/s   ',num2str((10/yunit)),'mm/mv']);
    
    time_s=time_s+floor(leng/sample_rate);
    if time_s>=60
        time_m=time_m+1;
        time_s=time_s-60;
    end
    if time_m>=60
        time_m=time_m-60;
        time_h=time_h+1;
    end
    
    % % % % % % % % % % % % % % % % % % % % % % % % % % % 画R波位置
    flag=0;
    while  (R(k)<=leng*j)
        flag=1;
        hndr(k)=text((R(k)-grid_step-leng*(j-1)),7.5,num2str(k));
        hndl2r(k)=plot(R(k)-leng*(j-1),(l2(R(k))+l2_position),'*','color','r');
        k=k+1;
        if k==length(R)
            break
        end
    end
%     Rx=R(1:(k-1));
%     hndl2r=plot(Rx,(l2_part(Rx)+l2_position),'*','color','r');
    pdfname=[new_folder,'\',name,num2str(j,'%02d'),'.pdf'];
    print(gcf, '-dpdf','-r600',pdfname);
    delete(hndl1);delete(hndl2);delete(hndl3);delete(hndavr);
    delete(hndavl);delete(hndavf);delete(hndv1);delete(hndtime);
    
    if (flag==1)
        delete(hndr);delete(hndl2r);
    end
    pause(1.1);
end
close(figure(gcf));
end



