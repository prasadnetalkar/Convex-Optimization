clc
clear
close all
em=imread('cguitar.tif');
figure;
imshow(em);

edm=double(em);
e=zeros(249,49);%given in Question 

for i=1:1:49
    for j=1:1:249
        e(j,i)=255;
    end
end

x = 1:249;
y = 1:49;
[X,Y] = meshgrid(x,y); % to create i and j matrix

cvx_begin
variables a b c
minimize(norm(e.*(a*X'+b*Y'+c) - edm(1:249,1:49)))
subject to
(a*X'+b*Y'+c)>=0 
(a*X'+b*Y'+c)<=1
cvx_end

for i=1:1:size(em,1)
    for j=1:1:size(em,2)
        e_new(i,j) = em(i,j)/(a*i+b*j+c);
    end
end

figure;
imshow(e_new);
