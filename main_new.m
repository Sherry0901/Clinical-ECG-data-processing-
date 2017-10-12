% % % % % % % % % % ������
%%Initialization
clear;close all;clc;

mydir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\�ٴ�ʵ��\9.11\'; %���õ����ĵ����ݵ��ļ���
resultdir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\MATLAB����\������ȡ\�ٴ�R����ȡ���\';%����ECG������ݵ��ļ���
d = dir(mydir);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}'; %�õ��ļ����������
nameFolds(ismember(nameFolds,{'.','..'})) = [];
sample_rate=100; %����Ƶ��%3�ֽ�

for i=1:length(nameFolds)
    name=cell2mat(nameFolds(i));
    pacdir=[mydir,name,'\']; %package�ļ���λ��
    temp1=dir([pacdir,'*package.txt']);
    for pac_num=1:length(temp1)
        type=[];
        R_type=[];
        packagename=temp1(pac_num).name;
        filepath=[pacdir,packagename];
        b=textread(filepath,'%s');  %��ȡ�ļ�����
        
        [l1_va, l2_va, v1_va]=ecgdataread(b,3); %��ȡ�ĵ����ݣ�������Ϊ��ѹֵ�����ֽڵ���3
        [l1,l2,v1]=medfilter(l1_va,l2_va,v1_va);%��ֵ�˲�
        l3=l2-l1;
        avr=-0.5*(l1+l2);
        avl=l1-0.5*l2;
        avf=l2-0.5*l1;
        all_data=[l1',l2',l3',avr',avl',avf',v1'];
        R=detection_Rwave(l2,sample_rate);
        
        for t=1:2  %ѭ�����Σ����м�飬�Է�����©����һ������
            R_z=correction_R(l2,R,sample_rate);
            R=R_z;
        end
        write2file(l2,all_data,R,mydir,pac_num,resultdir,name);%���ĵ�������R�����ݱ���Ϊ.xlsx�ļ�
    end
end
% % % % % % % % ��ECG,����ΪPDF�ĵ�
for i=1:length(nameFolds)
    name=cell2mat(nameFolds(i));
    pacdir=[mydir,name,'\']; %package�ļ���λ��
    pacR=[pacdir,name,'1R.xlsx'];
    if exist (pacR,'file')
        file_R=dir([pacdir,'*R.xlsx']);
        for pacnum=1:length(file_R);
            r_packagename=[pacdir,name,num2str(pacnum),'R.xlsx'];
            data_packagename=[pacdir,name,num2str(pacnum),'alldata.xlsx'];
            data=xlsread(data_packagename);    %�����ĵ�����
            R_pdf=xlsread(r_packagename);  %����R��λ������
            temp=dir([pacdir,'*package.txt']);
            packagename=temp(pacnum).name;
            draw_pdf(pacdir,name,packagename,sample_rate,data,R_pdf,pacnum); %��ECGͼ
        end
    end
end