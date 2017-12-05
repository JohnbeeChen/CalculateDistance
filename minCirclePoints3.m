%minCirclePoints3.m
function R=minCirclePoints3(A,B,C)

X=[A(1) B(1) C(1)];

Y=[A(2) B(2) C(2)];

%???????AB BC CA

len=[sqrt((X(1)-X(2))^2+(Y(1)-Y(2))^2) sqrt((X(2)-X(3))^2+(Y(2)-Y(3))^2) sqrt((X(3)-X(1))^2+(Y(3)-Y(1))^2)];

%?????????????????? cosA,cosB,cosC

if(sum(len>0)==3)

abc=[cosABC(len(2),len(1),len(3)) cosABC(len(3),len(1),len(2)) cosABC(len(1),len(2),len(3))];

end

%??????????????

if(len(1)==len(2)+len(3))

    r=len(1)/2;

    a=(X(1)+X(2))/2;

    b=(Y(1)+Y(2))/2;

    R=[a b r];

elseif(len(2)==len(1)+len(3))

    r=len(2)/2;

    a=(X(2)+X(3))/2;

    b=(Y(2)+Y(3))/2;

    R=[a b r];

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

        b=(((X(1)^2-X(2)^2+Y(1)^2-Y(2)^2)*(X(2)-X(3)))-((X(2)^2-X(3)^2+Y(2)^2-Y(3)^2)*(X(1)-X(2))))/(2*(Y(1)-Y(2))*(X(2)-X(3))-2*(Y(2)-Y(3))*(X(1)-X(2)))  ;

        r=sqrt((X(1)-a)^2+(Y(1)-b)^2);

        R=[a b r];

    end

end

%d=linspace(0,2*pi,100);

%plot(a+r*sin(d),b+r*cos(d),'-',X(1),Y(1),'ro',X(2),Y(2),'bo',X(3),Y(3),'ko',a,b,'.')

%axis([0 10 0 10])

function c=cosABC(x,y,z)

c=(z^2+y^2-x^2)/(2*z*y);

end

end
