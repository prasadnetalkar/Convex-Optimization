function Tmig = objTmig(Vmem,R,D,nj)
M=size(Vmem,2);
Tmig=posynomial;
for j=1:M
    Ttemp1=posynomial;
    Ttemp2=posynomial;
    Tmigtemp=posynomial;
    for i=1:nj-1
        Ttemp1=(D/R(j))^i;
        Ttemp2=Ttemp2+Ttemp1;
    end
    Tmigtemp=(Vmem(j)/R(j))*(1+Ttemp2);
    Tmig=Tmig+Tmigtemp;
end
return
end