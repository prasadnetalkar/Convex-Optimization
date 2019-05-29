function Tdown = objTdown(Vmem,R,D,nj)
M=size(Vmem,2);%number of VMs
Tdown=posynomial;
Ttemp=posynomial;
for j=1:M
    if(nj>=2)
       Ttemp=(Vmem(j)*D^(nj-1))/R(j)^nj;
    else
       Ttemp=Vmem(j)/R(j);
    end
    Tdown=Tdown+Ttemp;
end
return
end