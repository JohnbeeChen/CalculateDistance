clear all;
close all;
clc;
x=[22 8 4 51 38 17 81 18 62 15 11 3 75 67];
y=[38 13 81 32 11 12 63 45 12 72 11 85 5 9];
point = [x', y'];
R = FindLeastCircle(point);
circle(R(1:2),R(3));
hold on;
plot(x,y,'*');
grid minor
