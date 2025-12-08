function ccm_m = ccm_m_param(boost, Bat, pv_data)
% calculate steady state param. for CCM mode with compensation ramp

    arguments
        boost struct
        Bat struct
        pv_data struct
    end

    unpackStruct(boost);
    unpackStruct(Bat);
    unpackStruct(pv_data);
    
    Ipv0 = Impp;
    Upv0 = Vmpp;
    Ubat0 = Ubat_nom;
    Upvmin = 0.3*Upv0;
    m0 = (Ubat_charged-2*Upvmin)/(2*L);
    Ir0 = Ipv0;
    Im0 = Ir0-T/L*(Upv0+m0*L)/Ubat0*(Ubat0-Upv0);
    Lmin = T*(Upv0+m0*L)/(Ir0*Ubat0)*(Ubat0-Upv0);
    % ro = 1/2*(1+L/T*(Im0-m0*L)/(Upv0+m0*L))+1/2*((-1/T*L/(Upv0+m0*L))*(Ir0-T/L*(Ubat0-Upv0)+(Ir0-Im0)/(Upv0+m0*L)*(Ubat0-Upv0-m0*L)))+1/2*Ubat0/(Upv0+m0*L)*(1-L/T*(Ir0-Im0)/(Upv0+m0*L));
    ro = 1/2*(1+L/T*(Im0-m0*L)/(Upv0+m0*L))+1/2*(-1/T*L/(Upv0+m0*L)*(Ir0-T/L*(Ubat0-Upv0)+(Ir0-Im0)/(Upv0+m0*L)*(Ubat0-Upv0-m0*L)))+1/2*Ubat0/(Upv0+m0*L)*(1-L/T*(Ir0-Im0)/(Upv0+m0*L));
    
    ccm_m.Ipv0 = Ipv0;
    ccm_m.Upv0 = Upv0;
    ccm_m.Ubat0 = Ubat0;
    ccm_m.m0 = m0;
    ccm_m.Ir0 = Ir0;
    ccm_m.Im0 = Im0;
    ccm_m.Lmin = Lmin;
    ccm_m.ro = ro;
end