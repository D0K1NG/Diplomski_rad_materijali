function U=mppt(ukm1,ukm2,ikm1,ikm2)

if abs(ukm1-ukm2)>0.01
    dPdU=ikm1+ukm1*(ikm1-ikm2)/(ukm1-ukm2);
else
    dPdU=ikm1-ikm2;
end

dU=50*dPdU;


if dU>2;
    dU=2;
end
if dU<-2
    dU=-2;
end

U=ukm1+dU;

if (ikm1<=1e-3)&(ikm2<=1e-3)
    U=0.9*U;
end
if U<100
    U=100;
end

    
Pkm1=ukm1*ikm1;
Pkm2=ukm2*ikm2;

if ((Pkm1>Pkm2)&(ukm1>ukm2))|((Pkm1<Pkm2)&(ukm1<ukm2))
    U=ukm1+0.5;
else
    U=ukm1-0.5;
end