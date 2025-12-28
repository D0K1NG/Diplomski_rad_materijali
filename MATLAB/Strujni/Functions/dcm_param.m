function dcm = dcm_param(boost, Bat, pv_data)
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
    Ubat0 = Ubat_charged;
    Upvmin = 0.3*Upv0;
    m0 = (Ubat_charged-2*Upvmin)/(2*L);
    Ir0 = Ipv0;
    ro = L/T*(Ubat0*Upv0*Ir0)/((Ubat0-Upv0)*(Upv0+m0*L)^2);
    
    dcm.Ipv0 = Ipv0;
    dcm.Upv0 = Upv0;
    dcm.Ubat0 = Ubat0;
    dcm.m0 = m0;
    dcm.Ir0 = Ir0;
    dcm.ro = ro;
end