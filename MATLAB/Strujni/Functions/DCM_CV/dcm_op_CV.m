function op = dcm_op_CV(boost, Bat, pv)
% calculate steady state param. for DCM CV mode with compensation ramp

    arguments
        boost struct
        Bat struct
        pv struct
    end

    unpackStruct(boost);
    unpackStruct(Bat);
    
    Upv0 = pv.Umpp;
    [~, idx] = min(abs(pv.Upv - Upv0));
    Ipv0 = pv.Ipv(idx);
    Ir0 = Ipv0;
    Ubat0 = 12.4;

    Ubatmax = Ubat_charged;
    Upvmin = 0.77*pv.Uoc;
    m0 = (Ubatmax - 2*Upvmin)/(2*L);

    ro = L/T*(Ubat0*Upv0*Ir0)/((Ubat0-Upv0)*(Upv0+m0*L)^2);
    D0 = L/T*(Ir0)/(Upv0+m0*L);

    % Incremental conductance at CV operating point:
    idx = find(pv.Upv >= Upv0, 1);
    G_incr_pv = (pv.Ipv(idx+1) - pv.Ipv(idx-1)) / (pv.Upv(idx+1) - pv.Upv(idx-1));

    E0 = Ebat_min + (Ubat0 - Ubat_cut_off)*1/nagib;
    
    op.Ipv0 = Ipv0;
    op.Upv0 = Upv0;
    op.Ubat0 = Ubat0;
    op.m0 = m0;
    op.Ir0 = Ir0;
    op.ro = ro;
    op.D0 = D0;
    op.G_incr_pv = G_incr_pv;
    op.E0 = E0;
end