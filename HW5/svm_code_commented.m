clc;
clear all;
close all;
%load('feature_apple.mat');
%image_a=imread('red.jpg');
load('feature_hand4.mat'); % image selection
image_a=imread('hand4.jpg');
x=feature_f;
y=feature_b;
m=5;N=size(x,2);M=size(y,2); % feature size
cvx_begin %cvx
variables a(m) b u(N) v(M)
minimize((ones(1,N)*u + ones(1,M)*v))
subject to
a'*x-b>=1-u';
a'*y-b<=-(1-v');
u>=0;
v>=0;
cvx_end;

figure
scatter3(x(3,:),x(4,:),x(5,:)) % foreground RGB 
hold on;
scatter3(y(3,:),y(4,:),y(5,:)) % background RGB
[X,Y]=meshgrid(0:255,0:255);
Z=(-b-a(3)*X-a(4)*Y)./a(5); %hyper plane plot
hold on;
surface(X,Y,Z)

figure,
imshow(image_a); %original image

figure,
im=double(image_a);
svmc=zeros(size(im,1),size(im,2));
for i=1:size(im,1)
    for j=1:size(im,2)
        svmc(i,j)=[i j im(i,j,1) im(i,j,2) im(i,j,3)]*a-b; % obtaining SVM decession 
    end
end

svmc=im2bw(svmc,0);%svm threshold
imshow(svmc);

level = graythresh(image_a);
seg_I = im2bw(image_a,level);
seg_I = -1*double(seg_I);
seg_I = seg_I + 1;
figure
imshow(seg_I) %normal matlab threshold