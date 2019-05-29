addpath C:\Rutgers-GA\CONVEX\ggplab;
%close all
clear all
global QUIET;
QUIET =1;

trails=10;  
rounds=10;  % rounds= Vmem+dirty pages+stop phase=nj

plotta =1;
Cmig =1; %indicator variables
Cdown =1;%indicator variables

M = 3;% number of VMs                
avg = 1000;%Vmem mean 

Z = [125/2,125,125*2];% 1 Gbps = 125 Mbytes/s - standard-BW
D = 10.24; %2500 pps = 81.92 Mbps = 10.24 MBytes/s -standard

for a=3 %1=0.5Gbps,2=1Gbps,3=2Gbps
    Rmax=Z(a);
    for t = 1:trails
        p = ['Trail Number = ', num2str(t)];
        disp(p);
        for j = 1:M
            Vmem(j) = avg*rand(1); %uniform distribution
            Vmatrix(j,t,a)=Vmem(j);
        end
        for nj=1:rounds %number of rounds
            gpvar r(M);  %gp variables - optimal rate allocation to minimize total migration time

            %objective 1- down time
            Tdown = posynomial;
            Tdown = objTdown(Vmem,r,D,nj);

            %objective 2- migration time
            Tmig = posynomial;
            Tmig = objTmig(Vmem,r,D,nj);

            % objective 1 + objective 2 = Total time
            objective = posynomial;
            objective =  Cmig*Tmig + Cdown*Tdown;

            con1=D<=r(1); %constraint 1
            con2=0.00001<=r(1);%contraint 2
            for j=2:M
                con1=[con1;D<=r(j)];
                con2=[con2;0.00001<=r(j)];
            end
            rtemp=0;
            for j=1:M
                rtemp=rtemp+r(j);
            end
            con3=rtemp<=Rmax;  %contraint 3
            constraint = [con1;con2;con3];

            % solver
            [tottime,solution,status] = gpsolve(objective, constraint,'min');
            assign(solution)

            % Store input
            for k=1:size(r)
                Rmatrix(k,nj,a)=r(k);
            end
            TotTime(nj,t,a) = tottime;
        end
    end
end


% %%%%%%%%%%%%%%%%PLOTTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% width = 3;     % Width in inches
% height = 3;    % Height in inches
% alw = 0.75;    % AxesLineWidth
% fsz = 11;      % Fontsize
% lw = 1.5;      % LineWidth
% msz = 8;       % MarkerSize
% 
% figure;
% pos = get(gcf, 'Position');
% set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
% set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
% plot(mean(TotTime(:,:,3),2),'LineWidth',lw,'MarkerSize',msz); %<- Specify plot properites
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
