%读取心电数据，并换算为电压值，byte代表字节数
function [l1_va, l2_va, v1_va]=ecgdataread(b,byte)
len=size(b);
num=len(1);
num=num/20;
b1=hex2dec(b);
if byte==3
    guo1=reshape(b1,[20,num]);
    guo2=guo1(3:20,:);
    guo3=reshape(guo2,[9,num*2]);
    l1_origin=guo3(1:1,:)*65536+guo3(2:2,:)*256+guo3(3:3,:);
    l2_origin=guo3(4:4,:)*65536+guo3(5:5,:)*256+guo3(6:6,:);
    v1_origin=guo3(7:7,:)*65536+guo3(8:8,:)*256+guo3(9:9,:);
end
if byte==2
    guo1=reshape(b1,[20,num]);
    guo2=guo1(3:20,:);
    guo3=reshape(guo2,[6,num*3]);
    l1_origin=guo3(1:1,:)*256+guo3(2:2,:);
    l2_origin=guo3(3:3,:)*256+guo3(4:4,:);
    v1_origin=guo3(5:5,:)*256+guo3(6:6,:);
    
    for i=1:num*3
        if(l1_origin(i)> 32767)
            l1_origin(i)=l1_origin(i)-65536;
        end
        if(l2_origin(i)> 32767)
            l2_origin(i)=l2_origin(i)-65536;
        end
        if(v1_origin(i)> 32767)
            v1_origin(i)=v1_origin(i)-65536;
        end
    end
end
    % % % % % % % % % % % % % % % % % % % % %换算电压
    l1_va=(l1_origin/8388608-0.5)*4.8/3.5*1000; %滤除基线的两字节：3.5c/4.8*0x800000=b,三导的，b是实际电压，c是采到的数值,单位毫伏
    l2_va=(l2_origin/8388608-0.5)*4.8/3.5*1000;
    v1_va=(v1_origin/8388608-0.5)*4.8/3.5*1000;
end