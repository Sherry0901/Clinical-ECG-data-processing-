 % % % % % % % % % % % % % % ÖÐÖµÂË²¨
 function [l1,l2,v1]=medfilter(l1_origin,l2_origin,v1_origin)
        c=medfilt1(l1_origin,100);
        l1=l1_origin-c;
        l1=l1(100:end);
        c=medfilt1(l2_origin,100);
        l2=l2_origin-c;
        l2=l2(100:end);
        c=medfilt1(v1_origin,100);
        v1=v1_origin-c;
        v1=v1(100:end);
 end