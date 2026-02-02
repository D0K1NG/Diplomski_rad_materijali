function D = calc_duty_cycle_CV(boost, Bat,pv, Upv0, Ir0, Ubat0)
% calculate steady state param. for CCM CV mode with compensation ramp

    unpackStruct(boost);
    unpackStruct(Bat);
    
    
    Ubatmax = Ubat_charged;
    Upvmin = 0.77*pv.Uoc;
    m0 = (Ubatmax - 2*Upvmin)/(2*L);

    Im0 = Ir0-T/L*(Upv0+m0*L)/Ubat0*(Ubat0-Upv0);

    D = L/T*(Ir0-Im0)/(Upv0+m0*L);
end