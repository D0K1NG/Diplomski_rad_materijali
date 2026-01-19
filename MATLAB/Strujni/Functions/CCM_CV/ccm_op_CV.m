function op = ccm_op_CV(boost, Bat, pv)
% calculate steady state param. for CCM CV mode with compensation ramp

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

    Im0 = Ir0-T/L*(Upv0+m0*L)/Ubat0*(Ubat0-Upv0);
    Lmin = T*(Upv0+m0*L)/(Ir0*Ubat0)*(Ubat0-Upv0);
    ro = 1/2*(1+L/T*(Im0-m0*L)/(Upv0+m0*L))+1/2*(-1/T*L/(Upv0+m0*L)*(Ir0-T/L*(Ubat0-Upv0)+(Ir0-Im0)/(Upv0+m0*L)*(Ubat0-Upv0-m0*L)))+1/2*Ubat0/(Upv0+m0*L)*(1-L/T*(Ir0-Im0)/(Upv0+m0*L));
    L_lim = -(T*Ubat0*Upv0)/(Im0*Ubat0 - Ir0*Ubat0 + Im0*Upv0 - Ir0*Upv0 + T*Ubat0*m0);
    D0 = L/T*(Ir0-Im0)/(Upv0+m0*L);

    % Incremental conductance at CV operating point:
    idx = find(pv.Upv >= Upv0, 1);
    G_incr_pv = (pv.Ipv(idx+1) - pv.Ipv(idx-1)) / (pv.Upv(idx+1) - pv.Upv(idx-1));

    % Limit CCM -> DCM:
    Ir_lim = T/L*((Upv0+m0*L)*(Ubat0-Upv0))/(Ubat0);


    E0 = Ebat_min + (Ubat0 - Ubat_cut_off)*1/nagib;
  
    op.Ipv0 = Ipv0;
    op.Upv0 = Upv0;
    op.Ubat0 = Ubat0;
    op.m0 = m0;
    op.Ir0 = Ir0;
    op.Im0 = Im0;
    op.Lmin = Lmin;
    op.ro = ro;
    op.L_lim = L_lim;
    op.G_incr_pv = G_incr_pv;
    op.D0 = D0;
    op.Ir_lim = Ir_lim;
    op.E0 = E0;
end