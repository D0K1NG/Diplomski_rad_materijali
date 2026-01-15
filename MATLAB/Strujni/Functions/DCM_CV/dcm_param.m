function dcm = dcm_param(boost, Bat, pv, Ir0)
% calculate steady state param. for CCM mode with compensation ramp

    arguments
        boost struct
        Bat struct
        pv struct
        Ir0 (1,1) double
    end

    unpackStruct(boost);
    unpackStruct(Bat);
    
    Ipv0 = Ir0;
    [~, idx] = min(abs(pv.Ipv - Ipv0));
    Upv0 = pv.Upv(idx);
    Ubat0 = Ubat_charged - 0.6;

    Ubatmax = Ubat_charged;
    Upvmin = 0.77*pv.Uoc;
    % Upvmin = Upv0;
    m0 = (Ubatmax - 2*Upvmin)/(2*L);

    ro = L/T*(Ubat0*Upv0*Ir0)/((Ubat0-Upv0)*(Upv0+m0*L)^2);
    D0 = L/T*(Ir0)/(Upv0+m0*L);

    % Incremental conductance at CV operating point:
    idx = find(pv.Upv >= Upv0, 1);
    G_incr_pv = (pv.Ipv(idx+1) - pv.Ipv(idx-1)) / (pv.Upv(idx+1) - pv.Upv(idx-1));
    
    dcm.Ipv0 = Ipv0;
    dcm.Upv0 = Upv0;
    dcm.Ubat0 = Ubat0;
    dcm.m0 = m0;
    dcm.Ir0 = Ir0;
    dcm.ro = ro;
    dcm.D0 = D0;
    dcm.G_incr_pv = G_incr_pv;
end