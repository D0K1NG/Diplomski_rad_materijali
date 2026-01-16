function [Upv_ref] = fcn(Ipv_1, Ipv_2, Upv_1, Upv_2)

e = 0.1; % osjetljivost
k = 2; % pojacanje greske (vece pojacanje, brzi odziv)

if abs(Upv_1 - Upv_2) > e

    dPdUpv = Ipv_1 + Upv_1 * (Ipv_1 - Ipv_2)/(Upv_1 - Upv_2); % derivacija odreduje predznak promjene napona

else
    
    dPdUpv = Ipv_1 - Ipv_2; % razlika napona moze biti premala blizu MPP-a

end
 
% Potrebno je ograniciti moguce prevelike promjene u naponu

incr = k * dPdUpv;

if incr > 1.5

    incr = 1.5;

elseif incr < -1.5

    incr = -1.5;

end

Upv_ref = Upv_1 + incr;

if (Upv_ref < 20)

    Upv_ref = 20;

elseif (Upv_ref > 22.98)
    
    Upv_ref = 22.98;

end


end

