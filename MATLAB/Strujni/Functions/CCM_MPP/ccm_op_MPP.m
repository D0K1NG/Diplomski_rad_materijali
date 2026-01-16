function op = ccm_op_MPP(boost, Bat, pv, Ir0)
% calculate steady state param. for CCM MPP mode with compensation ramp

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
    Upvmin = 0.74*pv.Uoc;
    m0 = (Ubatmax - 2*Upvmin)/(2*L);

    Im0 = Ir0-T/L*(Upv0+m0*L)/Ubat0*(Ubat0-Upv0);
    Lmin = T*(Upv0+m0*L)/(Ir0*Ubat0)*(Ubat0-Upv0);
    ro = 1/2*(1+L/T*(Im0-m0*L)/(Upv0+m0*L))+1/2*(-1/T*L/(Upv0+m0*L)*(Ir0-T/L*(Ubat0-Upv0)+(Ir0-Im0)/(Upv0+m0*L)*(Ubat0-Upv0-m0*L)))+1/2*Ubat0/(Upv0+m0*L)*(1-L/T*(Ir0-Im0)/(Upv0+m0*L));
    L_lim = -(T*Ubat0*Upv0)/(Im0*Ubat0 - Ir0*Ubat0 + Im0*Upv0 - Ir0*Upv0 + T*Ubat0*m0);
    D0 = L/T*(Ir0-Im0)/(Upv0+m0*L);

    % Limit CCM -> DCM:
    Ir_lim = T/L*((Upv0+m0*L)*(Ubat0-Upv0))/(Ubat0);
  
    op.Ipv0 = Ipv0;
    op.Upv0 = Upv0;
    op.Ubat0 = Ubat0;
    op.m0 = m0;
    op.Ir0 = Ir0;
    op.Im0 = Im0;
    op.Lmin = Lmin;
    op.ro = ro;
    op.L_lim = L_lim;
    op.D0 = D0;
    op.Ir_lim = Ir_lim;
end