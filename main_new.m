% % % % % % % % % % 主程序
%%Initialization
clear;close all;clc;

mydir='E:\素雅\研究生\心律失常判别及临床实验\临床实验\9.11\'; %放置当日心电数据的文件夹
resultdir='E:\素雅\研究生\心律失常判别及临床实验\MATLAB代码\特征提取\临床R波提取结果\';%放置ECG结果数据的文件夹
d = dir(mydir);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}'; %得到文件夹里的姓名
nameFolds(ismember(nameFolds,{'.','..'})) = [];
sample_rate=100; %采样频率%3字节

for i=1:length(nameFolds)
    name=cell2mat(nameFolds(i));
    pacdir=[mydir,name,'\']; %package文件的位置
    temp1=dir([pacdir,'*package.txt']);
    for pac_num=1:length(temp1)
        type=[];
        R_type=[];
        packagename=temp1(pac_num).name;
        filepath=[pacdir,packagename];
        b=textread(filepath,'%s');  %读取文件数据
        
        [l1_va, l2_va, v1_va]=ecgdataread(b,3); %读取心电数据，并换算为电压值，三字节的是3
        [l1,l2,v1]=medfilter(l1_va,l2_va,v1_va);%中值滤波
        l3=l2-l1;
        avr=-0.5*(l1+l2);
        avl=l1-0.5*l2;
        avf=l2-0.5*l1;
        all_data=[l1',l2',l3',avr',avl',avf',v1'];
        R=detection_Rwave(l2,sample_rate);
        
        for t=1:2  %循环两次，进行检查，以防误检和漏检在一个波中
            R_z=correction_R(l2,R,sample_rate);
            R=R_z;
        end
        write2file(l2,all_data,R,mydir,pac_num,resultdir,name);%将心电数据与R波数据保存为.xlsx文件
    end
end
% % % % % % % % 画ECG,保存为PDF文档
for i=1:length(nameFolds)
    name=cell2mat(nameFolds(i));
    pacdir=[mydir,name,'\']; %package文件的位置
    pacR=[pacdir,name,'1R.xlsx'];
    if exist (pacR,'file')
        file_R=dir([pacdir,'*R.xlsx']);
        for pacnum=1:length(file_R);
            r_packagename=[pacdir,name,num2str(pacnum),'R.xlsx'];
            data_packagename=[pacdir,name,num2str(pacnum),'alldata.xlsx'];
            data=xlsread(data_packagename);    %读入心电数据
            R_pdf=xlsread(r_packagename);  %读入R波位置数据
            temp=dir([pacdir,'*package.txt']);
            packagename=temp(pacnum).name;
            draw_pdf(pacdir,name,packagename,sample_rate,data,R_pdf,pacnum); %画ECG图
        end
    end
end