% % % % % % % % % % ������
%%Initialization
clear;close all;clc;

mydir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\�ٴ�ʵ��\9.11\'; %���õ����ĵ����ݵ��ļ���
resultdir='E:\����\�о���\����ʧ���б��ٴ�ʵ��\MATLAB����\������ȡ\�ٴ�R����ȡ���\';%����ECG������ݵ��ļ���
d = dir(mydir);
isub = [d(:).isdir]; %# returns logical vector
nameFolds = {d(isub).name}'; %�õ��ļ����������
nameFolds(ismember(nameFolds,{'.','..'})) = [];
samplerate=100; %����Ƶ��

for i=3:length(nameFolds)
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
        R=detection_Rwave(l2,samplerate);
        
        for t=1:2  %ѭ�����Σ����м�飬�Է�����©����һ������
            R_z=correction_R(l2,R,samplerate);
            R=R_z;
        end
        write2file(l2,all_data,R,pacdir,pac_num,resultdir,name);%���ĵ�������R�����ݱ���Ϊ.xlsx�ļ�
    end
end
% % % % % % % % ��ECG,����ΪPDF�ĵ�
for i=4:length(nameFolds)
    
    %     fid = fopen('test.csv');
    %     title = textscan(fid, '%s %s %s %s %s %s %s %s %s %s',1,'delimiter', ',');
    %     data = textscan(fid, ' %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %.3f %s','delimiter', ',');
    %     fclose(fid);
    %     dcells = textscan(fid, '%f, %f, %f, %s');
    %     fclose(fid);
    %     dcellneeds = dcells(1:3);
    %     Mat = cell2mat(dcellneeds);
    %     disp(Mat);    %���Դ��룬�ɺ���
    
    name=cell2mat(nameFolds(i));
    pacdir=[mydir,name,'\']; %package�ļ���λ��
    file_R=dir([pacdir,'*R.xlsx']);
    file_data=dir([pacdir,'*alldata.xlsx']);
    if   ~isempty(file_R)
        for j=1:length(file_R);
            r_packagename=file_R(j).name;
            data_packagename=file_data(j).name;
            data=xlsread([pacdir,data_packagename]);    %�����ĵ�����
            R_pdf=xlsread([pacdir,r_packagename]);  %����R��λ������
            temp=dir([pacdir,'*package.txt']);
            num=str2double(r_packagename(regexp(r_packagename,'\d')));
            packagename=temp(num).name;
            draw_pdf(pacdir,name,packagename,samplerate,data,R_pdf,num); %��ECGͼ
        end
    end
end