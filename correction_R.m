% % % % % % % % % 对R波提取的位置进行修正，包括漏检和误检检查，修正% % % % % % % % %
function Rlast=correction_R(s_orign,Rwave_place,sample_rate)
% s_orign=l2_f;
% Rwave_place=R;
% for t=1:2
    flag=0;
    R_p=Rwave_place;
    step=floor(sample_rate/10);
    
    for i =5:length(Rwave_place)-1
        peak = s_orign(Rwave_place(i-4))+s_orign(Rwave_place(i-1))+s_orign(Rwave_place(i-2))+s_orign(Rwave_place(i-3));
        Rpeak=peak/4;
        
        R_R1 = (Rwave_place(i)-Rwave_place(i-1))+(Rwave_place(i-1)-Rwave_place(i-2))+(Rwave_place(i-2)-Rwave_place(i-3));
        
        % +(Rwave_place(i-3)-Rwave_place(i-4))+(Rwave_place(i-4)-Rwave_place(i-5));
        R_Rav=R_R1/3;
        
        if (Rwave_place(i)-Rwave_place(i-1))>R_Rav*1.2 % 当R波位置间期过大时，判断为漏检
            x=s_orign((Rwave_place(i-1)+step):(Rwave_place(i)-step));
            if max(x)>=Rpeak*0.6
                flag=1;
                posi=find(x==max(x))+Rwave_place(i-1)+step-1;
                R_p=[R_p;posi];
            end
        end
        %            i=i+1;
        if (s_orign(Rwave_place(i))< Rpeak*0.6)  % 当R波幅度较小时，判断为误检
            if(Rwave_place(i)-Rwave_place(i-1))<R_Rav*0.98 || (Rwave_place(i+1)-Rwave_place(i))<R_Rav*0.98
                R_p(i)=0;
                %               Rwave_place(find(Rwave_place==0))=[]; %%将0元素删除
                %              i=i-1;
            end
        end
    end
    R_p(R_p==0)=[]; %%将0元素删除
    if flag
        R_p=sort(R_p);
    end
    Rwave_place=R_p;
    
    flag=0;
    for i =1:length(Rwave_place)-4
        peak = s_orign(Rwave_place(i+4))+s_orign(Rwave_place(i+1))+s_orign(Rwave_place(i+2))+s_orign(Rwave_place(i+3));
        Rpeak=peak/4;
        
        R_R1 = (Rwave_place(i+1)-Rwave_place(i))+(Rwave_place(i+2)-Rwave_place(i+1))+(Rwave_place(i+3)-Rwave_place(i+2));
        R_Rav=R_R1/3;
        
        if (Rwave_place(i+1)-Rwave_place(i))>R_Rav*1.2 % 当R波位置间期过大时，判断为漏检
            x=s_orign((Rwave_place(i)+step):(Rwave_place(i+1)-step));
            if max(x)>=Rpeak*0.6
                flag=1;
                posi=find(x==max(x))+Rwave_place(i)+step-1;
                R_p=[R_p;posi];
            end
        end
        if i==1
            if (s_orign(Rwave_place(i))< Rpeak*0.6)  % 当R波幅度较小时，判断为误检
                if(Rwave_place(i+1)-Rwave_place(i))<R_Rav*0.98
                    R_p(i)=0;
                end
            end
  
        else if (s_orign(Rwave_place(i))< Rpeak*0.6)  % 当R波幅度较小时，判断为误检
                if(Rwave_place(i)-Rwave_place(i-1))<R_Rav*0.98 || (Rwave_place(i+1)-Rwave_place(i))<R_Rav*0.98
                    R_p(i)=0;
                end
            end
        end
    end
    R_p(R_p==0)=[]; %%将0元素删除
    if flag
        R_p=sort(R_p);
    end    

Rlast=R_p;
end





