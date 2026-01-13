function ccm_m = ccm_m_param(boost, Bat, pv, Ir0)
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
    Ubat0 = Ubat_nom;
    
    Ubatmax = Ubat_charged;
    Upvmin = 0.77*pv.Uoc;
    % Upvmin = Upv0;
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
  
    ccm_m.Ipv0 = Ipv0;
    ccm_m.Upv0 = Upv0;
    ccm_m.Ubat0 = Ubat0;
    ccm_m.m0 = m0;
    ccm_m.Ir0 = Ir0;
    ccm_m.Im0 = Im0;
    ccm_m.Lmin = Lmin;
    ccm_m.ro = ro;
    ccm_m.L_lim = L_lim;
    ccm_m.G_incr_pv = G_incr_pv;
    ccm_m.D0 = D0;
    ccm_m.Ir_lim = Ir_lim;
end