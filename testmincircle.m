clear all;close all;clc;
x=[22 8 4 51 38 17 81 18 62 15 11 3 75 67];

y=[38 13 81 32 11 12 63 45 12 72 11 85 5 9];

plot(x,y,'*');hold on;

grid on%

set_3P=nchoosek(1:length(x),3);

AI=set_3P(1,1);

BI=set_3P(1,2);

CI=set_3P(1,3);

A=[x(AI) y(AI)];

B=[x(BI) y(BI)];

C=[x(CI) y(CI)];

while 1

    R=minCirclePoints3(A,B,C);

    cr=[R(1),R(2)];

    r=zeros(1,length(x));

    for i=1:length(x)

       r(i)=sqrt((x(i)-cr(1))^2+(y(i)-cr(2))^2);

    end

    maxValue=max(r);    %??N=max(r(:))

    [mc]=find(maxValue==r);

    

    %???????????????A?B?C???????????????

    if maxValue <= R(3) || ~isempty( intersect(mc, [AI BI CI]) )

        alpha=0:pi/20:2*pi;%??[0,2*pi]

        plot(cr(1)+R(3)*cos(alpha),cr(2)+R(3)*sin(alpha),'--r');%?????R(1),R(2)????R(3)??

        axis equal;

        break;%????????       

    else

       %???????????       

    end

    D=[x(mc),y(mc)];

    P=[A;B;C;D];%?????????

     

    DI=mc;

    set_3P=nchoosek([AI,BI,CI,DI],3);

    rSet=[];

    for i=1:length(set_3P)

        A=[x(set_3P(i,1)) y(set_3P(i,1))];

        B=[x(set_3P(i,2)) y(set_3P(i,2))];

        C=[x(set_3P(i,3)) y(set_3P(i,3))];

        

        R=minCirclePoints3(A,B,C);

        rSet=[rSet;[R,i]];%???????,??,???(??????????)

    end;

    rSet=sortrows(rSet,3);%??????

    

%   ???????????????????

    for i=1:size(rSet,1)

        flag = 1;

        for j=1:4

          if sqrt((rSet(i,1)-(P(j,1) ))^2+ ( rSet(i,2)-(P(j,2)))^2) >rSet(i,3)%?????

            flag = 0; 

            break;

          end

        end;

        if flag == 1     %?i??????????--????????

            break;

        end;

    end;

    

    mc=rSet(i,4);

    AI = set_3P(mc, 1);

    BI = set_3P(mc, 2);

    CI = set_3P(mc, 3);

    A=[x(set_3P(mc,1)) y(set_3P(mc,1))];

    B=[x(set_3P(mc,2)) y(set_3P(mc,2))];

    C=[x(set_3P(mc,3)) y(set_3P(mc,3))];

end;