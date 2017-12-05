%{
 Function name @FindLeastCircle
 input points set
 output the centroid and radius of the circle
%}

function varargout = FindLeastCircle(varargin)

point_set = varargin{1};
x = point_set(:,1);
y = point_set(:,2);
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
    maxValue=max(r);    % or N=max(r(:))
    [mc]=find(maxValue==r);
    % iteration break when all points are inside the circle
    if maxValue <= R(3) || ~isempty( intersect(mc, [AI BI CI]) )
%         alpha=0:pi/20:2*pi;% angle [0,2*pi]
%         % plot the circle witch centroid is [R(1),R(2)], radius is R(3)
%         plot(cr(1)+R(3)*cos(alpha),cr(2)+R(3)*sin(alpha),'--r');
%         axis equal;
        break% all points inside
    else
        %the point farthest from the centroid is outside the circle
    end
    D=[x(mc),y(mc)];
    P=[A;B;C;D];% save the coordinate  for the four points
    DI=mc;
    set_3P=nchoosek([AI,BI,CI,DI],3);
    rSet=[];
    for i=1:length(set_3P)
        A=[x(set_3P(i,1)) y(set_3P(i,1))];
        B=[x(set_3P(i,2)) y(set_3P(i,2))];
        C=[x(set_3P(i,3)) y(set_3P(i,3))];
        R=minCirclePoints3(A,B,C);
        rSet=[rSet;[R,i]];%[centroid,radius,index]
    end
    rSet=sortrows(rSet,3);% sort by radius
    
    % find out the circle which radius is least and include the four points
    for i=1:size(rSet,1)
        flag = 1;
        for j=1:4
            if sqrt((rSet(i,1)-(P(j,1) ))^2+ ( rSet(i,2)-(P(j,2)))^2) >rSet(i,3)
                flag = 0; % this circle doesn't satisfy
                break;
            end
        end
        if flag == 1  % this circle satisfied
            break;
        end
    end
    mc=rSet(i,4);
    AI = set_3P(mc, 1);
    BI = set_3P(mc, 2);
    CI = set_3P(mc, 3);
    A=[x(set_3P(mc,1)) y(set_3P(mc,1))];
    B=[x(set_3P(mc,2)) y(set_3P(mc,2))];
    C=[x(set_3P(mc,3)) y(set_3P(mc,3))];
end
varargout{1} = R;

end


%minCirclePoints3.m
function R=minCirclePoints3(A,B,C)
X=[A(1) B(1) C(1)];
Y=[A(2) B(2) C(2)];

% calculates the lengths of AB BC CA
len=[sqrt((X(1)-X(2))^2+(Y(1)-Y(2))^2) sqrt((X(2)-X(3))^2+(Y(2)-Y(3))^2) sqrt((X(3)-X(1))^2+(Y(3)-Y(1))^2)];
% calculates cosA,cosB,cosC in a nor-special situation

if(sum(len>0)==3)
    abc=[cosABC(len(2),len(1),len(3)) cosABC(len(3),len(1),len(2)) cosABC(len(1),len(2),len(3))];
end

% Two points are the same
if(len(1)==len(2)+len(3))
    r=len(1)/2;
    a=(X(1)+X(2))/2;
    b=(Y(1)+Y(2))/2;
    R=[a b r];
    % Three points are the same
elseif(len(2)==len(1)+len(3))
    r=len(2)/2;
    a=(X(2)+X(3))/2;
    b=(Y(2)+Y(3))/2;
    R=[a b r];
    % Three points at one line
elseif(len(3)==len(1)+len(2))
    r=len(3)/2;
    a=(X(1)+X(3))/2;
    b=(Y(1)+Y(3))/2;
    R=[a b r];
    %--------------------------------------------------------------------------
    
else
    tmp=(abc<=0);
    if(tmp(1))
        r=len(2)/2;
        a=(X(2)+X(3))/2;
        b=(Y(2)+Y(3))/2;
        R=[a b r];
    elseif(tmp(2))
        r=len(3)/2;
        a=(X(1)+X(3))/2;
        b=(Y(1)+Y(3))/2;
        R=[a b r];
    elseif(tmp(3))
        r=len(1)/2;
        a=(X(1)+X(2))/2;
        b=(Y(1)+Y(2))/2;
        R=[a b r];
    elseif(sum(tmp)==0)
        a=(((X(1)^2-X(2)^2+Y(1)^2-Y(2)^2)*(Y(2)-Y(3)))-((X(2)^2-X(3)^2+Y(2)^2-Y(3)^2)*(Y(1)-Y(2))))/(2*(X(1)-X(2))*(Y(2)-Y(3))-2*(X(2)-X(3))*(Y(1)-Y(2)));
        b=(((X(1)^2-X(2)^2+Y(1)^2-Y(2)^2)*(X(2)-X(3)))-((X(2)^2-X(3)^2+Y(2)^2-Y(3)^2)*(X(1)-X(2))))/(2*(Y(1)-Y(2))*(X(2)-X(3))-2*(Y(2)-Y(3))*(X(1)-X(2)));
        r=sqrt((X(1)-a)^2+(Y(1)-b)^2);
        R=[a b r];
    end
end
end

function c=cosABC(x,y,z)

c=(z^2+y^2-x^2)/(2*z*y);
end
