clc;
clear all;
close all;
load('points_new2.mat');
%p=point;
m=50; %number of segments
n=3; %number of points in each segment
t=linspace(0,1,n);
T_temp=[t.^3 ;t.^2; t ;ones(1,length(t))];
T=repmat(T_temp,1,m); %generate copies of t matrix for each segment

cvx_begin
variables a3(m) a2(m) a1(m) a0(m) b3(m) b2(m) b1(m) b0(m)

for i=1:1:m 
    coeff_x_temp(i,:)=[a3(i) a2(i) a1(i) a0(i)];
    coeff_y_temp(i,:)=[b3(i) b2(i) b1(i) b0(i)];
end
        
coeff_x=repelem(coeff_x_temp,n,1);
coeff_y=repelem(coeff_y_temp,n,1);

for i=1:1:size(p,1)
    Dx(i,1) = coeff_x(i,:)*T(:,i);
    Dy(i,1) = coeff_y(i,:)*T(:,i);
end

minimize(norm(Dx - p(:,1))+norm(Dy - p(:,2)))
subject to
for i=1:1:m-1
   temp1=n*i+1;
   temp2=temp1-1;
   3*coeff_x(temp2,1)+2*coeff_x(temp2,2)+coeff_x(temp2,3)==3*coeff_x(temp1,1)+2*coeff_x(temp1,2)+coeff_x(temp1,3);
   3*coeff_y(temp2,1)+2*coeff_y(temp2,2)+coeff_y(temp2,3)==3*coeff_y(temp1,1)+2*coeff_y(temp1,2)+coeff_y(temp1,3);
   6*coeff_x(temp2,1)+2*coeff_x(temp2,2)==6*coeff_x(temp1,1)+2*coeff_x(temp1,2);
   6*coeff_y(temp2,1)+2*coeff_y(temp2,2)==6*coeff_y(temp1,1)+2*coeff_y(temp1,2);
end
cvx_end

%%%%%%%%%%%%%%plotting%%%%%%%%%%%%%%%%%%

figure,
plot(Dx(:,1),Dy(:,1))
hold on;
plot(p(:,1),p(:,2));
legend('Fitted Curve','Original Curve');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%